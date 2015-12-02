From: akpm@linux-foundation.org
Subject: + mm-hugetlb-resv-map-memory-leak-for-placeholder-entries.patch
 added to -mm tree
Date: Wed, 02 Dec 2015 13:29:28 -0800
Message-ID: <565f62b8.MjJuF+bDwE35QL1j%akpm__18369.6824512028$1449091878$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192AbbLBV33 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 16:29:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dvyukov@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: fix resv map memory leak for placeholder entries
has been added to the -mm tree.  Its filename is
     mm-hugetlb-resv-map-memory-leak-for-placeholder-entries.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-resv-map-memory-leak-for-placeholder-entries.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-resv-map-memory-leak-for-placeholder-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlb.c: fix resv map memory leak for placeholder entries

Dmitry Vyukov reported the following memory leak

unreferenced object 0xffff88002eaafd88 (size 32):
  comm "a.out", pid 5063, jiffies 4295774645 (age 15.810s)
  hex dump (first 32 bytes):
    28 e9 4e 63 00 88 ff ff 28 e9 4e 63 00 88 ff ff  (.Nc....(.Nc....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<     inline     >] kmalloc include/linux/slab.h:458
    [<ffffffff815efa64>] region_chg+0x2d4/0x6b0 mm/hugetlb.c:398
    [<ffffffff815f0c63>] __vma_reservation_common+0x2c3/0x390 mm/hugetlb.c:1791
    [<     inline     >] vma_needs_reservation mm/hugetlb.c:1813
    [<ffffffff815f658e>] alloc_huge_page+0x19e/0xc70 mm/hugetlb.c:1845
    [<     inline     >] hugetlb_no_page mm/hugetlb.c:3543
    [<ffffffff815fc561>] hugetlb_fault+0x7a1/0x1250 mm/hugetlb.c:3717
    [<ffffffff815fd349>] follow_hugetlb_page+0x339/0xc70 mm/hugetlb.c:3880
    [<ffffffff815a2bb2>] __get_user_pages+0x542/0xf30 mm/gup.c:497
    [<ffffffff815a400e>] populate_vma_page_range+0xde/0x110 mm/gup.c:919
    [<ffffffff815a4207>] __mm_populate+0x1c7/0x310 mm/gup.c:969
    [<ffffffff815b74f1>] do_mlock+0x291/0x360 mm/mlock.c:637
    [<     inline     >] SYSC_mlock2 mm/mlock.c:658
    [<ffffffff815b7a4b>] SyS_mlock2+0x4b/0x70 mm/mlock.c:648

Dmitry identified a potential memory leak in the routine region_chg, where
a region descriptor is not free'ed on an error path.

However, the root cause for the above memory leak resides in region_del. 
In this specific case, a "placeholder" entry is created in region_chg. 
The associated page allocation fails, and the placeholder entry is left in
the reserve map.  This is "by design" as the entry should be deleted when
the map is released.  The bug is in the region_del routine which is used
to delete entries within a specific range (and when the map is released). 
region_del did not handle the case where a placeholder entry exactly
matched the start of the range range to be deleted.  In this case, the
entry would not be deleted and leaked.  The fix is to take these special
placeholder entries into account in region_del.

The region_chg error path leak is also fixed.

Fixes: feba16e25a57 ("mm/hugetlb: add region_del() to delete a specific range of entries")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Cc: <stable@vger.kernel.org>	[4.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-resv-map-memory-leak-for-placeholder-entries mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-resv-map-memory-leak-for-placeholder-entries
+++ a/mm/hugetlb.c
@@ -372,8 +372,10 @@ retry_locked:
 		spin_unlock(&resv->lock);
 
 		trg = kmalloc(sizeof(*trg), GFP_KERNEL);
-		if (!trg)
+		if (!trg) {
+			kfree(nrg);
 			return -ENOMEM;
+		}
 
 		spin_lock(&resv->lock);
 		list_add(&trg->link, &resv->region_cache);
@@ -483,7 +485,13 @@ static long region_del(struct resv_map *
 retry:
 	spin_lock(&resv->lock);
 	list_for_each_entry_safe(rg, trg, head, link) {
-		if (rg->to <= f)
+		/*
+		 * file_region ranges are normally of the form [from, to).
+		 * However, there may be a "placeholder" entry in the map
+		 * which is of the form (from, to) with from == to.  Check
+		 * for placeholder entries as well.
+		 */
+		if (rg->to <= f && rg->to != rg->from)
 			continue;
 		if (rg->from >= t)
 			break;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

mm-hugetlb-resv-map-memory-leak-for-placeholder-entries.patch

