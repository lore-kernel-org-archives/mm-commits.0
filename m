Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EEB3438BB
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 18:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788893965; cv=none; b=XOzpv4c3Xo/3Qzh01r0OLC40/MRDRc7u+thjIl9HV93jYWOyTlxMwZXcUyBH0bJ6YWmrqBsqm/f99Ci3gYjZXNJfgd0Yy7/Ixdobwd2ZVvFC+loEx2ADgzLNRwL/vsqJsRKkmWICK06/fXOOLYzAasOzZpCmZunJ1tJ99ii30DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788893965; c=relaxed/simple;
	bh=naxmTwA8AwBVLqBOl11WlN6bi+qUefERkNWyCpuP2PM=;
	h=Date:To:From:Subject:Message-Id; b=n6H9B5ih0vUDuKsRyk+W1BNrDVSfwE0qGbPzoypkpHyQ3NV/k1BghAe55Rv6pawWKwrQQhSl+iR7FObuudBQaMQVDnnHyop5G+pA37t+sCN5gk8/slTWlkWu7nYplBG+FuUTheu6JpAAUZ5jucYw8c9efVcfW4tFq57uPGTXLmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=poTBrwsj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="poTBrwsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BAF61F00A3D;
	Tue,  8 Sep 2026 18:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788893963;
	bh=PJkZCJBOiyw75Kr+roeraP7fFQ5Z8ViwgO4fYmhlZ7g=;
	h=Date:To:From:Subject;
	b=poTBrwsjfCByf38XKTstnWDWK40Bfe4sqWey5Hc/S2b1WkRl9U3odaYPkgzv2T7zD
	 mdKhtA4rjkephctxSWgy+Z9XkXPLFgmejTAUCTWD9ae5AeEdodmOTow1OLnyizWWI4
	 paAH8m/JLy8Oesgu/saq5PpH2pJDfpfYeZ/ia0sY=
Date: Tue, 08 Sep 2026 11:59:23 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,kiyer@crusoe.ai,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-support-hugetlb-folios-in-access-monitoring.patch added to mm-new branch
Message-Id: <20260908185923.8BAF61F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: support hugetlb folios in access monitoring
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-paddr-support-hugetlb-folios-in-access-monitoring.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-support-hugetlb-folios-in-access-monitoring.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Assisted-by: Claude:claude-fable-5
Signed-off-by: Krishna Iyer <kiyer@crusoe.ai>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-damon-move-damon_hugetlb_mkold-from-vaddr-to-ops-common.patch
mm-damon-ops-common-handle-hugetlb-folios-in-folio-mkold-young-rmap-walkers.patch
mm-damon-paddr-support-hugetlb-folios-in-access-monitoring.patch

