Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5560B3115B8
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334306; cv=none; b=CWPy5ZKhkZQbRZ+MoBzC+l5W93ELfbgvtv2TQHcSGqyryJkLJb2ApOunKlXgH9bcXga/stWAn+Wf6psln79Hgo7bfwnIq3bKm09wakuHdEHD+v9YnwEbJep8Ihvle4o2t+AubXbRinBnFCXaxsyZHw1LxpJZ8MJ9YomSV+aNc+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334306; c=relaxed/simple;
	bh=SEcIfCC1WAKV5mo1XHL8nFmy9/zgcuxMoDJGsuNxXMw=;
	h=Date:To:From:Subject:Message-Id; b=DyI50ZFOGzjMsx/pdg5zqvZbVT6WpWIi8BGGVglVjQL+5AI9itllFtnnsobRmVN2Yj1fHU6hkjUtcKsU/MOjDFC3pHUartMAgI7aMLBYKyEK9sTQvzRWCIE0L7GBNIC5vQO1u5OPMJoTZJXxwTZUkT9TFZHvGvCq6HAxiOc7/Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CjEmtcno; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CjEmtcno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA0B1F0089B;
	Wed,  7 Oct 2026 00:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334305;
	bh=TLSwCSnYii+D41fLgP6sN8jcbmnxPMC+moKVsEVprpc=;
	h=Date:To:From:Subject;
	b=CjEmtcnokW3L2vBV3MCfioA9rJXcltOq+a9QNjQqQlOBz+Tj0iCnhAjQDlcMVfTbl
	 idjBmKW9FuPyemi+qeSDQCJNAzsYHxD1cBSAefnZBbV5o4/T8adPrOmixQ5Pf1WuJM
	 bgnSoBqkOHhKoSaufUFNV+GVR7BQ5iCWeZHxHZIM=
Date: Tue, 06 Oct 2026 17:51:44 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-preserve-source-surplus-accounting-during-demotion.patch removed from -mm tree
Message-Id: <20261007005145.2CA0B1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: preserve source surplus accounting during demotion
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-preserve-source-surplus-accounting-during-demotion.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Longlong Xia <xialonglong@kylinos.cn>
Subject: mm/hugetlb: preserve source surplus accounting during demotion
Date: Mon, 31 Aug 2026 21:35:18 +0800

Patch series "mm/hugetlb: fix surplus accounting and availability checks
during demotion", v2.

Fix surplus accounting and availability checks in the hugetlb demote path.

Patch 1 fixes source hstate accounting when the free folio selected for
demotion accounts for a surplus page.  Patch 2 prevents demotion from
removing free huge pages that back reservations.

Both fixes were tested with x86_64 QEMU guests. The commands below use:

  hstate=/sys/kernel/mm/hugepages/hugepages-1048576kB

Patch 1: surplus accounting

A vmemmap restoration failure is difficult to trigger deterministically. 
For this test only, add a one-shot fault injection that makes the first
attempt to restore the vmemmap of an optimized 1 GiB folio fail:

  /* TEST ONLY: fail the first optimized 1G folio restore. */
  static atomic_t fail_next_1g_restore = ATOMIC_INIT(1);

  /* In __hugetlb_vmemmap_restore_folio(). */
  if (huge_page_size(h) == SZ_1G &&
      atomic_cmpxchg(&fail_next_1g_restore, 1, 0) == 1) {
          pr_info("TEST ONLY: forcing one 1G vmemmap "
                  "restore failure\n");
          return -ENOMEM;
  }

The injection does not modify the demotion or accounting code. It is
one-shot so that the later restore performed during demotion can succeed.

1. Boot QEMU with:

     hugepagesz=1G hugepages=0 hugetlb_cma=1G
     hugetlb_free_vmemmap=on

2. Enable overcommit:

     echo 1 > "$hstate/nr_overcommit_hugepages"

3. Allocate one 1 GiB huge page:

     nr=1 surplus=1 free=0 resv=0

4. Unmap it. The forced restoration failure leaves the folio on the
   freelist while it is still accounted as surplus:

     nr=1 surplus=1 free=1 resv=0

5. Demote one page:

     echo 1 > "$hstate/demote"

   Before this fix:

     nr=0 surplus=1 free=0 resv=0
     surplus > nr

   After this fix:

     nr=0 surplus=0 free=0 resv=0

Patch 2: cap demotion

This reproducer requires no kernel instrumentation.

1. Boot QEMU with:

     hugepagesz=1G hugepages=2
     nr=2 surplus=0 free=2 resv=0

2. Reserve one 1 GiB huge page with an untouched hugetlbfs mapping:

     nr=2 surplus=0 free=2 resv=1

3. Request demotion of two pages:

     echo 2 > "$hstate/demote"

   Before this fix:

     nr=0 surplus=0 free=0 resv=1
     resv > free

   After this fix:

     nr=1 surplus=0 free=1 resv=1
     resv == free

4. Touch the reserved page and let the process exit.

   Before this fix, the access fails with SIGBUS and leaves:

     nr=0 surplus=0 free=0 resv=0

   After this fix, the access succeeds and leaves:

     nr=1 surplus=0 free=1 resv=0


This patch (of 2):

demote_pool_huge_page() currently removes every source folio as a
persistent folio.  A free folio can instead account for one of the source
hstate's surplus pages, for example after a vmemmap restoration failure. 
Removing such a folio without adjusting surplus_huge_pages makes the
persistent count underflow, and later subtracting it from max_huge_pages
can underflow that counter as well.

Classify selected folios against the node's surplus count while holding
hugetlb_lock, and preserve that classification on rollback.  Track the
number of successfully demoted persistent folios separately so only those
folios reduce the source max_huge_pages target.  All successfully demoted
folios still increase the destination target because the new destination
folios are added as persistent pages.

Testing:
Tested on an x86_64 QEMU guest booted with:

  hugepagesz=1G hugepages=0 hugetlb_cma=1G
  hugetlb_free_vmemmap=on

For testing only, add a one-shot fault injection that makes the first call
to __hugetlb_vmemmap_restore_folio() for an optimized 1 GiB folio return
-ENOMEM.  Set nr_overcommit_hugepages to 1, then allocate one 1 GiB huge
page:

  nr=1 surplus=1 free=0 resv=0

Unmap it. The failed restoration leaves the folio on the freelist while it
is still accounted as surplus:

  nr=1 surplus=1 free=1 resv=0

Demote one page. Before this fix, the result is:

  nr=0 surplus=1 free=0 resv=0

After this fix, the result is:

  nr=0 surplus=0 free=0 resv=0

The fault injection is one-shot, so the restore performed during demotion
can succeed.

Link: https://lore.kernel.org/20260831133519.2505020-2-xialonglong2025@163.com
Fixes: 8531fc6f52f5 ("hugetlb: add hugetlb demote page support")
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Codex:gpt-5.6-sol
Cc: David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yu Zhao <yuzhao@google.com>
---

 mm/hugetlb.c |   35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-preserve-source-surplus-accounting-during-demotion
+++ a/mm/hugetlb.c
@@ -4000,6 +4000,7 @@ long demote_pool_huge_page(struct hstate
 	struct hstate *dst;
 	long rc = 0;
 	long nr_demoted = 0;
+	long nr_persistent = 0;
 
 	lockdep_assert_held(&hugetlb_lock);
 
@@ -4012,22 +4013,40 @@ long demote_pool_huge_page(struct hstate
 
 	for_each_node_mask_to_free(src, nr_nodes, node, nodes_allowed) {
 		LIST_HEAD(list);
+		LIST_HEAD(surplus_list);
 		struct folio *folio, *next;
 
 		list_for_each_entry_safe(folio, next, &src->hugepage_freelists[node], lru) {
+			bool adjust_surplus;
+
 			if (folio_test_hwpoison(folio))
 				continue;
 
-			remove_hugetlb_folio(src, folio, false);
-			list_add(&folio->lru, &list);
+			/* Surplus accounting is maintained per node, not per folio. */
+			adjust_surplus = src->surplus_huge_pages_node[node] > 0;
+			remove_hugetlb_folio(src, folio, adjust_surplus);
+			list_add(&folio->lru, adjust_surplus ? &surplus_list : &list);
+			if (!adjust_surplus)
+				nr_persistent++;
 
 			if (++nr_demoted == nr_to_demote)
 				break;
 		}
 
+		if (list_empty(&list) && list_empty(&surplus_list))
+			continue;
+
 		spin_unlock_irq(&hugetlb_lock);
 
-		rc = demote_free_hugetlb_folios(src, dst, &list);
+		if (!list_empty(&list))
+			rc = demote_free_hugetlb_folios(src, dst, &list);
+		if (!list_empty(&surplus_list)) {
+			long tmp_rc;
+
+			tmp_rc = demote_free_hugetlb_folios(src, dst, &surplus_list);
+			if (rc >= 0)
+				rc = tmp_rc;
+		}
 
 		spin_lock_irq(&hugetlb_lock);
 
@@ -4036,6 +4055,14 @@ long demote_pool_huge_page(struct hstate
 			add_hugetlb_folio(src, folio, false);
 
 			nr_demoted--;
+			nr_persistent--;
+		}
+
+		list_for_each_entry_safe(folio, next, &surplus_list, lru) {
+			list_del(&folio->lru);
+			add_hugetlb_folio(src, folio, true);
+
+			nr_demoted--;
 		}
 
 		if (rc < 0 || nr_demoted == nr_to_demote)
@@ -4046,7 +4073,7 @@ long demote_pool_huge_page(struct hstate
 	 * Not absolutely necessary, but for consistency update max_huge_pages
 	 * based on pool changes for the demoted page.
 	 */
-	src->max_huge_pages -= nr_demoted;
+	src->max_huge_pages -= nr_persistent;
 	dst->max_huge_pages += nr_demoted << (huge_page_order(src) - huge_page_order(dst));
 
 	if (rc < 0)
_

Patches currently in -mm which might be from xialonglong@kylinos.cn are

mm-zswap-publish-the-initial-pool-with-list_add_rcu.patch
mm-zswap-enable-zswap_ever_enabled-in-zswap_pool_create.patch

