From: akpm@linux-foundation.org
Subject: + mm-hugetlb-dont-call-region_abort-if-region_chg-fails.patch
 added to -mm tree
Date: Wed, 29 Mar 2017 14:17:16 -0700
Message-ID: <58dc245c.4j2kczr3PjT7rkJn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57850 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932731AbdC2VRR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Mar 2017 17:17:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dvyukov@google.com, hillf.zj@alibaba-inc.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: don't call region_abort if region_chg fails
has been added to the -mm tree.  Its filename is
     mm-hugetlb-dont-call-region_abort-if-region_chg-fails.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-dont-call-region_abort-if-region_chg-fails.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-dont-call-region_abort-if-region_chg-fails.patch

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
Subject: mm/hugetlb.c: don't call region_abort if region_chg fails

Changes to hugetlbfs reservation maps is a two step process.  The first
step is a call to region_chg to determine what needs to be changed, and
prepare that change.  This should be followed by a call to call to
region_add to commit the change, or region_abort to abort the change.

The error path in hugetlb_reserve_pages called region_abort after a
failed call to region_chg.  As a result, the adds_in_progress counter
in the reservation map is off by 1.  This is caught by a VM_BUG_ON
in resv_map_release when the reservation map is freed.

syzkaller fuzzer (when using an injected kmalloc failure) found this bug,
that resulted in the following:

 kernel BUG at mm/hugetlb.c:742!
 Call Trace:
  hugetlbfs_evict_inode+0x7b/0xa0 fs/hugetlbfs/inode.c:493
  evict+0x481/0x920 fs/inode.c:553
  iput_final fs/inode.c:1515 [inline]
  iput+0x62b/0xa20 fs/inode.c:1542
  hugetlb_file_setup+0x593/0x9f0 fs/hugetlbfs/inode.c:1306
  newseg+0x422/0xd30 ipc/shm.c:575
  ipcget_new ipc/util.c:285 [inline]
  ipcget+0x21e/0x580 ipc/util.c:639
  SYSC_shmget ipc/shm.c:673 [inline]
  SyS_shmget+0x158/0x230 ipc/shm.c:657
  entry_SYSCALL_64_fastpath+0x1f/0xc2
 RIP: resv_map_release+0x265/0x330 mm/hugetlb.c:742

Link: http://lkml.kernel.org/r/1490821682-23228-1-git-send-email-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-dont-call-region_abort-if-region_chg-fails mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-dont-call-region_abort-if-region_chg-fails
+++ a/mm/hugetlb.c
@@ -4403,7 +4403,9 @@ int hugetlb_reserve_pages(struct inode *
 	return 0;
 out_err:
 	if (!vma || vma->vm_flags & VM_MAYSHARE)
-		region_abort(resv_map, from, to);
+		/* Don't call region_abort if region_chg failed */
+		if (chg >= 0)
+			region_abort(resv_map, from, to);
 	if (vma && is_vma_resv_set(vma, HPAGE_RESV_OWNER))
 		kref_put(&resv_map->refs, resv_map_release);
 	return ret;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlbfs-initialize-shared-policy-as-part-of-inode-allocation.patch
mm-hugetlb-dont-call-region_abort-if-region_chg-fails.patch

