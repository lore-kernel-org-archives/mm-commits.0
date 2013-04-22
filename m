From: akpm@linux-foundation.org
Subject: [merged] hugetlbfs-stop-setting-vm_dontdump-in-initializing-vmavm_hugetlb.patch removed from -mm tree
Date: Mon, 22 Apr 2013 13:06:43 -0700
Message-ID: <20130422200643.8A59931C082@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:45570 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab3DVUGo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 16:06:44 -0400
Received: by mail-gh0-f202.google.com with SMTP id z10so624455ghb.3
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 13:06:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, khlebnikov@openvz.org, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, riel@redhat.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: stop setting VM_DONTDUMP in initializing vma(VM_HUGETLB)
has been removed from the -mm tree.  Its filename was
     hugetlbfs-stop-setting-vm_dontdump-in-initializing-vmavm_hugetlb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: hugetlbfs: stop setting VM_DONTDUMP in initializing vma(VM_HUGETLB)

Currently we fail to include any data on hugepages into coredump, because
VM_DONTDUMP is set on hugetlbfs's vma.  This behavior was recently
introduced by commit 314e51b98 "mm: kill vma flag VM_RESERVED and
mm->reserved_vm counter".  This looks to me a serious regression, so let's
fix it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>	[3.7+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-stop-setting-vm_dontdump-in-initializing-vmavm_hugetlb fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-stop-setting-vm_dontdump-in-initializing-vmavm_hugetlb
+++ a/fs/hugetlbfs/inode.c
@@ -110,7 +110,7 @@ static int hugetlbfs_file_mmap(struct fi
 	 * way when do_mmap_pgoff unwinds (may be important on powerpc
 	 * and ia64).
 	 */
-	vma->vm_flags |= VM_HUGETLB | VM_DONTEXPAND | VM_DONTDUMP;
+	vma->vm_flags |= VM_HUGETLB | VM_DONTEXPAND;
 	vma->vm_ops = &hugetlb_vm_ops;
 
 	if (vma->vm_pgoff & (~huge_page_mask(h) >> PAGE_SHIFT))
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

hwpoison-check-dirty-flag-to-match-against-clean-page.patch

