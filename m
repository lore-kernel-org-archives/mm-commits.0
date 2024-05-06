Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDEA376EC
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957129; cv=none; b=fKm4yeOUOvJCyR405/wgoGu76WHkraSH6vTPtV5FGsgbQX5WOYTSRwiLqRQgOiLXjuRyFHAbU3g7DD5wPN1SZ4a2y1bvdl+lCloC2+MNhClza0w6GIOSuRO0xCd/xi0uuRv3sCm0zGmbm/GdIGQxWQQd42t/Yulc2pFQulVqFk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957129; c=relaxed/simple;
	bh=LPyNqMg5z9xyxbln4Mcy1hyXzxrnYhgm3r0nG7p0VIc=;
	h=Date:To:From:Subject:Message-Id; b=QMkpR+MGUTTXf0zj7TVpEedB0yhFNFGZUuYiq9d+XmMd90Exuig/Bkqm/XhTGx5jFq+uI3W13bkU9AUuHcrscFLqNhaxcG43F38e9rsXExsqVDRVblJucTpdRGYfLCpQ8uZOvqZ07F/DwAXI0ODW2aJrCvkstK+MmnrNV2uA6Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MYKco2fJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MYKco2fJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831D8C116B1;
	Mon,  6 May 2024 00:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957129;
	bh=LPyNqMg5z9xyxbln4Mcy1hyXzxrnYhgm3r0nG7p0VIc=;
	h=Date:To:From:Subject:From;
	b=MYKco2fJv37l1UN8DeuDDELwM7hKRcvQ4B0zuidUl0X5QGn768eRD6NMLikbaQ6E1
	 bDzqNM97kKGKokxnE6xGmehqI27uvPIwvF/PhmCPATPlIzBOw5T6q5OKXIo6l6LDWk
	 t477Nk2jFQPyHSGX5nMdneZ8jb9SUp+5bktAooyk=
Date: Sun, 05 May 2024 17:58:49 -0700
To: mm-commits@vger.kernel.org,honggyu.kim@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-implement-damon_folio_young.patch removed from -mm tree
Message-Id: <20240506005849.831D8C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: implement damon_folio_young()
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-implement-damon_folio_young.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: implement damon_folio_young()
Date: Fri, 26 Apr 2024 12:52:40 -0700

Patch series "mm/damon: add a DAMOS filter type for page granularity
access recheck".

DAMON provides its best-effort accuracy-overhead tradeoff under the
user-defined ranges of acceptable level of the monitoring accuracy and
overhead.  A recent discussion for tiered memory management support from
DAMON[1] concluded that finding memory regions of specific access pattern
with low overhead despite of low accuracy via DAMON first, and then double
checking the access of the region again in a finer (e.g., page)
granularity could be a useful strategy for some DAMOS schemes.

Add a new type of DAMOS filter, namely 'young' for such a case.  It checks
each page of DAMOS target region is accessed since the last check, and
filters it out or in if 'matching' parameter is 'true' or 'false',
respectively.

Because this is a filter type that applied in page granularity, the
support depends on DAMON operations set, similar to 'anon' and 'memcg'
DAMOS filter types.  Implement the support on the DAMON operations set for
the physical address space, 'paddr', since one of the expected usages[1]
is based on the physical address space.

[1] https://lore.kernel.org/r/20240227235121.153277-1-sj@kernel.org


This patch (of 7):

damon_pa_young() receives physical address, get the folio covering the
address, and show if the folio is accessed since the last check.  A
following commit will reuse the internal logic for checking access to a
given folio.  To avoid duplication of the code, split the internal logic. 
Also, change the rmap walker function's name from __damon_pa_young() to
damon_folio_young_one(), following the change of the caller's name and the
naming rule that more commonly used by other rmap walkers.

Link: https://lkml.kernel.org/r/20240426195247.100306-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240426195247.100306-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Tested-by: Honggyu Kim <honggyu.kim@sk.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-implement-damon_folio_young
+++ a/mm/damon/paddr.c
@@ -79,8 +79,8 @@ static void damon_pa_prepare_access_chec
 	}
 }
 
-static bool __damon_pa_young(struct folio *folio, struct vm_area_struct *vma,
-		unsigned long addr, void *arg)
+static bool damon_folio_young_one(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long addr, void *arg)
 {
 	bool *accessed = arg;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, addr, 0);
@@ -111,38 +111,44 @@ static bool __damon_pa_young(struct foli
 	return *accessed == false;
 }
 
-static bool damon_pa_young(unsigned long paddr, unsigned long *folio_sz)
+static bool damon_folio_young(struct folio *folio)
 {
-	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
 	bool accessed = false;
 	struct rmap_walk_control rwc = {
 		.arg = &accessed,
-		.rmap_one = __damon_pa_young,
+		.rmap_one = damon_folio_young_one,
 		.anon_lock = folio_lock_anon_vma_read,
 	};
 	bool need_lock;
 
-	if (!folio)
-		return false;
-
 	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
 		if (folio_test_idle(folio))
-			accessed = false;
+			return false;
 		else
-			accessed = true;
-		goto out;
+			return true;
 	}
 
 	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
 	if (need_lock && !folio_trylock(folio))
-		goto out;
+		return false;
 
 	rmap_walk(folio, &rwc);
 
 	if (need_lock)
 		folio_unlock(folio);
 
-out:
+	return accessed;
+}
+
+static bool damon_pa_young(unsigned long paddr, unsigned long *folio_sz)
+{
+	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
+	bool accessed;
+
+	if (!folio)
+		return false;
+
+	accessed = damon_folio_young(folio);
 	*folio_sz = folio_size(folio);
 	folio_put(folio);
 	return accessed;
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-_damon_sysfs-support-quota-goals.patch
selftests-damon-add-a-test-for-damos-quota-goal.patch
mm-damon-core-initialize-esz_bp-from-damos_quota_init_priv.patch
selftests-damon-_damon_sysfs-check-errors-from-nr_schemes-file-reads.patch
selftests-damon-_damon_sysfs-find-sysfs-mount-point-from-proc-mounts.patch
selftests-damon-_damon_sysfs-use-is-instead-of-==-for-none.patch
selftests-damon-classify-tests-for-functionalities-and-regressions.patch
docs-admin-guide-mm-damon-usage-fix-wrong-example-of-damos-filter-matching-sysfs-file.patch
docs-admin-guide-mm-damon-usage-fix-wrong-schemes-effective-quota-update-command.patch
docs-mm-damon-design-use-a-list-for-supported-filters.patch
docs-mm-damon-maintainer-profile-change-the-maintainers-timezone-from-pst-to-pt.patch
docs-mm-damon-maintainer-profile-allow-posting-patches-based-on-damon-next-tree.patch

