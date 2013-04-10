From: akpm@linux-foundation.org
Subject: + hugetlbfs-stop-setting-vm_dontdump-in-initializing-vmavm_hugetlb.patch added to -mm tree
Date: Wed, 10 Apr 2013 14:55:37 -0700
Message-ID: <20130410215538.003E65A42B4__38154.2556490332$1365630947$gmane$org@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:55643 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab3DJVzk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Apr 2013 17:55:40 -0400
Received: by mail-oa0-f74.google.com with SMTP id k14so231915oag.3
        for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2013 14:55:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, khlebnikov@openvz.org, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, riel@redhat.com, rientjes@google.com, stable@vger.kernel.org


The patch titled
     Subject: hugetlbfs: stop setting VM_DONTDUMP in initializing vma(VM_HUGETLB)
has been added to the -mm tree.  Its filename is
     hugetlbfs-stop-setting-vm_dontdump-in-initializing-vmavm_hugetlb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

hugetlbfs-stop-setting-vm_dontdump-in-initializing-vmavm_hugetlb.patch
fix-hugetlb-memory-check-in-vma_dump_size.patch
hugetlbfs-add-swap-entry-check-in-follow_hugetlb_page.patch
hwpoison-check-dirty-flag-to-match-against-clean-page.patch

