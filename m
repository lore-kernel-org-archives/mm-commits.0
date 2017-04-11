From: akpm@linux-foundation.org
Subject: + hugetlbfs-fix-offset-overflow-in-huegtlbfs-mmap.patch added to
 -mm tree
Date: Tue, 11 Apr 2017 15:57:41 -0700
Message-ID: <58ed5f65.q5jG4qeJw5aPy15/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41426 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752489AbdDKW5m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2017 18:57:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, aryabinin@virtuozzo.com, dvyukov@google.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, n-horiguchi@ah.jp.nec.com, vegard.nossum@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: fix offset overflow in huegtlbfs mmap
has been added to the -mm tree.  Its filename is
     hugetlbfs-fix-offset-overflow-in-huegtlbfs-mmap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-fix-offset-overflow-in-huegtlbfs-mmap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-fix-offset-overflow-in-huegtlbfs-mmap.patch

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
Subject: hugetlbfs: fix offset overflow in huegtlbfs mmap

If mmap() maps a file, it can be passed an offset into the file at
which the mapping is to start.  Offset could be a negative value when
represented as a loff_t.  The offset plus length will be used to
update the file size (i_size) which is also a loff_t.  Validate the
value of offset and offset + length to make sure they do not overflow
and appear as negative.

Found by syzcaller with commit ff8c0c53c475 ("mm/hugetlb.c: don't call
region_abort if region_chg fails") applied.  Prior to this commit, the
overflow would still occur but we would luckily return ENOMEM.
To reproduce:
mmap(0, 0x2000, 0, 0x40021, 0xffffffffffffffffULL, 0x8000000000000000ULL);

Resulted in,
kernel BUG at mm/hugetlb.c:742!
Call Trace:
 hugetlbfs_evict_inode+0x80/0xa0
 ? hugetlbfs_setattr+0x3c0/0x3c0
 evict+0x24a/0x620
 iput+0x48f/0x8c0
 dentry_unlink_inode+0x31f/0x4d0
 __dentry_kill+0x292/0x5e0
 dput+0x730/0x830
 __fput+0x438/0x720
 ____fput+0x1a/0x20
 task_work_run+0xfe/0x180
 exit_to_usermode_loop+0x133/0x150
 syscall_return_slowpath+0x184/0x1c0
 entry_SYSCALL_64_fastpath+0xab/0xad

Fixes: ff8c0c53c475 ("mm/hugetlb.c: don't call region_abort if region_chg fails")
Link: http://lkml.kernel.org/r/1491951118-30678-1-git-send-email-mike.kravetz@oracle.com
Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-fix-offset-overflow-in-huegtlbfs-mmap fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-fix-offset-overflow-in-huegtlbfs-mmap
+++ a/fs/hugetlbfs/inode.c
@@ -136,17 +136,26 @@ static int hugetlbfs_file_mmap(struct fi
 	vma->vm_flags |= VM_HUGETLB | VM_DONTEXPAND;
 	vma->vm_ops = &hugetlb_vm_ops;
 
+	/*
+	 * Offset passed to mmap (before page shift) could have been
+	 * negative when represented as a (l)off_t.
+	 */
+	if (((loff_t)vma->vm_pgoff << PAGE_SHIFT) < 0)
+		return -EINVAL;
+
 	if (vma->vm_pgoff & (~huge_page_mask(h) >> PAGE_SHIFT))
 		return -EINVAL;
 
 	vma_len = (loff_t)(vma->vm_end - vma->vm_start);
+	len = vma_len + ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
+	/* check for overflow */
+	if (len < vma_len)
+		return -EINVAL;
 
 	inode_lock(inode);
 	file_accessed(file);
 
 	ret = -ENOMEM;
-	len = vma_len + ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
