Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E02402B8A
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525448; cv=none; b=MYppdyTM5NCd5QGT+7HF2Z92Qs8HfMwc1Onxsxpc/akvxSjFsg1hmqYaYPHKTP3aMG1we2Ll3H+gECMx7QLwcT/DMBIFkCiij2QviGVCrUMpRqmXwGjO6fMUc743DAxlVV5GE5/jEUrCt7aFX6JossyUx0V+keJM9Q7Qp9UUUDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525448; c=relaxed/simple;
	bh=bUXzxqTSdFE4vI1gaLCjcHxwUUs08c5OnHgK1ExwSTk=;
	h=Date:To:From:Subject:Message-Id; b=OcPgn8meX9sHdakNuwbdaW+hXGTCNpT+ilSLCg1y1uCM0WPYfP5L+tScjVM3rwzSaeBnkmKHG3vLX+fv+1hTMnmw8DmHGW7E4/LQPGdTWG21qBu+kZCKmPfAtqlvJgfWHf5JitauR0Nr7SyYyo24BD/3uo7tmHv7xkbPRBy48lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ikxotfxc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ikxotfxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1267A1F00893;
	Fri,  9 Oct 2026 05:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525447;
	bh=XGAdCvcU9mH1uhtNDBgDdpOdkyAtev3v4fcSNufE4LU=;
	h=Date:To:From:Subject;
	b=ikxotfxcYJbjqKKCbpeEVDmlY26mOgBUDkewwDRHTCVxDYbXnNLtDiTwa1rYHpqOB
	 KWlpjltNP+C5Quu/nwUDK0vb179MtTIH09U/VG9aSNIp5DSkyRJHljZSmNo65CK1Th
	 8xWGgmkci9kiJboMZ1F0ci2PYfubcMH3Wso39ozg=
Date: Thu, 08 Oct 2026 22:57:26 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,kiyer@crusoe.ai,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-support-hugetlb-folios-in-access-monitoring.patch removed from -mm tree
Message-Id: <20261009055727.1267A1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: support hugetlb folios in access monitoring
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-support-hugetlb-folios-in-access-monitoring.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Krishna Iyer <kiyer@crusoe.ai>
Subject: mm/damon/paddr: support hugetlb folios in access monitoring
Date: Tue, 8 Sep 2026 06:51:55 -0700

DAMON's physical address space monitoring is blind to hugetlb-backed
memory.  Every access check starts at damon_get_folio(), which rejects
folios that are not on the LRU lists.  Hugetlb folios are managed outside
of the LRU by design, so every sampling attempt on hugetlb-backed memory
silently fails and the pages are reported as never accessed.

This is a significant blind spot on virtualization hosts.  Cloud
hypervisor hosts commonly back guest memory with 1 GiB hugetlbfs pages,
covering the vast majority of the machine's memory.  On such hosts,
modules like DAMON_STAT observe only the host-side remainder (page cache,
daemons) and report all guest working sets as permanently idle, defeating
the purpose of host-level access monitoring.  In testing on a 1 TiB host,
an hour of 4-thread random access over 842 GiB inside a guest was
statistically indistinguishable from an idle host, while a 40x smaller
host-side workload produced a quantitatively correct response.

Add damon_get_monitor_folio(), which additionally accepts hugetlb folios,
and use it in the two paddr access monitoring primitives, damon_pa_mkold()
and damon_pa_young().  With the previous commit teaching the
folio-granular rmap walkers to age huge PTEs and to call the mmu notifiers
spanning the whole huge page, this makes guest accesses visible through
secondary MMU (e.g.  KVM/EPT) young bits.

Free hugetlb pool folios have a zero refcount, so folio_try_get()
naturally keeps rejecting them.

The DAMOS action appliers (damon_pa_pageout(),
damon_pa_mark_accessed_or_deactivate(), damon_pa_migrate(),
damon_pa_stat()) keep using damon_get_folio(): reclaim, LRU manipulation
and migration cannot act on hugetlb folios, so their behavior is
unchanged.

Note that the access check granularity for hugetlb-backed memory is the
huge page size: one touched byte reports the whole (up to 1 GiB) page as
accessed.  Also, DAMON now consumes secondary MMU young bits that KVM's
own aging uses; at DAMON's sampling rate (one page per region per sampling
interval) the interference is negligible.

Link: https://lore.kernel.org/20260902025700.17975-4-kiyer@crusoe.ai
Link: https://lore.kernel.org/20260908135156.97481-4-sj@kernel.org
Signed-off-by: Krishna Iyer <kiyer@crusoe.ai>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Claude:claude-fable-5
---

 mm/damon/ops-common.c |   25 +++++++++++++++++++++----
 mm/damon/ops-common.h |    1 +
 mm/damon/paddr.c      |    4 ++--
 3 files changed, 24 insertions(+), 6 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-paddr-support-hugetlb-folios-in-access-monitoring
+++ a/mm/damon/ops-common.c
@@ -15,14 +15,20 @@
 #include "../internal.h"
 #include "ops-common.h"
 
+static bool damon_folio_acceptable(struct folio *folio, bool monitor)
+{
+	return folio_test_lru(folio) ||
+		(monitor && folio_test_hugetlb(folio));
+}
+
 /*
- * Get an online page for a pfn if it's in the LRU list.  Otherwise, returns
- * NULL.
+ * Get an online page for a pfn if it's in the LRU list, or a hugetlb folio if
+ * @monitor is set.  Otherwise, returns NULL.
  *
  * The body of this function is stolen from the 'page_idle_get_folio()'.  We
  * steal rather than reuse it because the code is quite simple.
  */
-struct folio *damon_get_folio(unsigned long pfn)
+static struct folio *__damon_get_folio(unsigned long pfn, bool monitor)
 {
 	struct page *page = pfn_to_online_page(pfn);
 	struct folio *folio;
@@ -33,13 +39,24 @@ struct folio *damon_get_folio(unsigned l
 	folio = page_folio(page);
 	if (!folio_try_get(folio))
 		return NULL;
-	if (unlikely(page_folio(page) != folio) || !folio_test_lru(folio)) {
+	if (unlikely(page_folio(page) != folio) ||
+			!damon_folio_acceptable(folio, monitor)) {
 		folio_put(folio);
 		folio = NULL;
 	}
 	return folio;
 }
 
+struct folio *damon_get_folio(unsigned long pfn)
+{
+	return __damon_get_folio(pfn, false);
+}
+
+struct folio *damon_get_monitor_folio(unsigned long pfn)
+{
+	return __damon_get_folio(pfn, true);
+}
+
 void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr)
 {
 	pte_t pteval = ptep_get(pte);
--- a/mm/damon/ops-common.h~mm-damon-paddr-support-hugetlb-folios-in-access-monitoring
+++ a/mm/damon/ops-common.h
@@ -6,6 +6,7 @@
 #include <linux/damon.h>
 
 struct folio *damon_get_folio(unsigned long pfn);
+struct folio *damon_get_monitor_folio(unsigned long pfn);
 
 void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr);
 void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr);
--- a/mm/damon/paddr.c~mm-damon-paddr-support-hugetlb-folios-in-access-monitoring
+++ a/mm/damon/paddr.c
@@ -37,7 +37,7 @@ static unsigned long damon_pa_core_addr(
 
 static void damon_pa_mkold(phys_addr_t paddr)
 {
-	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
+	struct folio *folio = damon_get_monitor_folio(PHYS_PFN(paddr));
 
 	if (!folio)
 		return;
@@ -67,7 +67,7 @@ static void damon_pa_prepare_access_chec
 
 static bool damon_pa_young(phys_addr_t paddr)
 {
-	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
+	struct folio *folio = damon_get_monitor_folio(PHYS_PFN(paddr));
 	bool accessed;
 
 	if (!folio)
_

Patches currently in -mm which might be from kiyer@crusoe.ai are


