Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6382C3002DD
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 01:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788225278; cv=none; b=VeCwlZ0vU0HBF4Q5zJgJVcZ+oL8pr4F0hLLy8nEJJ86k6XDCpzpEn469nQpbwwdulAFZKXie9omIHF7kHzrpUlzY1LlteTbSQKNZgK14ZaXnFPxTFb5UKo9xCplEs5+fMlW7tCn1mubvcZHhyyw/vebqdhXA1CowNIKsjPuZ00I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788225278; c=relaxed/simple;
	bh=uO/rRQ82J16noc8hoctyuwAXmHqVcvpFNQD5OQ8W6MM=;
	h=Date:To:From:Subject:Message-Id; b=eG7Zc7Qk4w85g6IFerxkYomxUAPKcrdddyEYh7BFVdS/ck2C2fDMfFyEGYUuhbVgVWkdfihzxXoq/m25umr4LPbxgc6cqCufz7fPNJ8j0ut43T8bfEKbPl2A6zOTs8PvlzT49FzOeLhKDxtWer755IjgCrfQJnliavFBEUMtkeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rDPt9AY+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rDPt9AY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB051F000E9;
	Tue,  1 Sep 2026 01:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788225275;
	bh=3j2tJ1ZlNevEjs5lU4vPghrQhznjg1ZH/MJ3RZlPNWI=;
	h=Date:To:From:Subject;
	b=rDPt9AY+kd1z8+M/zTxv7qxRrElrnE28+JuT0ROiLpAcV85YBNSv/XaEtghXFNknu
	 koTTrYH/wg6nxr9EuRTVV1KwLJ8I89nCcB57Zf53E28kuSSQWQBE72D47z3XodIrwI
	 gxQu2pV8gPlP3GNu12onJzxqVmvQsOqye99eAxcg=
Date: Mon, 31 Aug 2026 18:14:35 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-preserve-source-surplus-accounting-during-demotion.patch added to mm-new branch
Message-Id: <20260901011435.ACB051F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: preserve source surplus accounting during demotion
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-preserve-source-surplus-accounting-during-demotion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-preserve-source-surplus-accounting-during-demotion.patch

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
Cc: David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yu Zhao <yuzhao@google.com>
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-preserve-source-surplus-accounting-during-demotion
+++ a/mm/hugetlb.c
@@ -3999,6 +3999,7 @@ long demote_pool_huge_page(struct hstate
 	struct hstate *dst;
 	long rc = 0;
 	long nr_demoted = 0;
+	long nr_persistent = 0;
 
 	lockdep_assert_held(&hugetlb_lock);
 
@@ -4011,22 +4012,40 @@ long demote_pool_huge_page(struct hstate
 
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
 
@@ -4035,6 +4054,14 @@ long demote_pool_huge_page(struct hstate
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
@@ -4045,7 +4072,7 @@ long demote_pool_huge_page(struct hstate
 	 * Not absolutely necessary, but for consistency update max_huge_pages
 	 * based on pool changes for the demoted page.
 	 */
-	src->max_huge_pages -= nr_demoted;
+	src->max_huge_pages -= nr_persistent;
 	dst->max_huge_pages += nr_demoted << (huge_page_order(src) - huge_page_order(dst));
 
 	if (rc < 0)
_

Patches currently in -mm which might be from xialonglong@kylinos.cn are

mm-hugetlb-do-not-dissolve-gigantic-pages-without-runtime-support.patch
mm-hugetlb-warn-instead-of-silently-bailing-gigantic-pages-without-runtime-support.patch
mm-hugetlb-preserve-source-surplus-accounting-during-demotion.patch
mm-hugetlb-cap-demotion-at-currently-available-free-pages.patch

