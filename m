From: akpm@linux-foundation.org
Subject: + mm-memblockc-use-pfn_phys.patch added to -mm tree
Date: Wed, 26 Mar 2014 15:50:31 -0700
Message-ID: <533359b7.XZLj+TPlre9BRzfA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbaCZWub (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Mar 2014 18:50:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + mm-memblockc-use-pfn_phys.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Wed, 26 Mar 2014 15:50:31 -0700


The patch titled
     Subject: mm/memblock.c: use PFN_PHYS()
has been added to the -mm tree.  Its filename is
     mm-memblockc-use-pfn_phys.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblockc-use-pfn_phys.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblockc-use-pfn_phys.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: mm/memblock.c: use PFN_PHYS()

Replace ((phys_addr_t)(x) << PAGE_SHIFT) by pfn macro.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memblock.c~mm-memblockc-use-pfn_phys mm/memblock.c
--- a/mm/memblock.c~mm-memblockc-use-pfn_phys
+++ a/mm/memblock.c
@@ -1253,7 +1253,7 @@ phys_addr_t __init memblock_mem_size(uns
 		pages += end_pfn - start_pfn;
 	}
 
-	return (phys_addr_t)pages << PAGE_SHIFT;
+	return PFN_PHYS(pages);
 }
 
 /* lowest address */
@@ -1324,7 +1324,7 @@ int __init_memblock memblock_search_pfn_
 			 unsigned long *start_pfn, unsigned long *end_pfn)
 {
 	struct memblock_type *type = &memblock.memory;
-	int mid = memblock_search(type, (phys_addr_t)pfn << PAGE_SHIFT);
+	int mid = memblock_search(type, PFN_PHYS(pfn));
 
 	if (mid == -1)
 		return -1;
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch
fs-freevxfs-vxfs_lookupc-update-function-comment.patch
ntfs-logging-clean-up.patch
mm-memblockc-use-pfn_phys.patch
sys_sysfs-add-config_sysfs_syscall.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
fs-efs-superc-add-__init-to-init_inodecache.patch
fs-minix-inodec-add-__init-to-init_inodecache.patch
befs-replace-kmalloc-memset-0-by-kzalloc.patch
fs-befs-linuxvfsc-add-__init-to-befs_init_inodecache.patch
befs-logging-clean-up.patch
befs-logging-clean-up-fix.patch
coda-add-__init-to-init_inodecache.patch
hfsplus-add-__init-to-hfsplus_create_attr_tree_cache.patch
fs-reiserfs-superc-add-__init-to-init_inodecache.patch
documentation-filesystems-ntfstxt-remove-changelog-reference.patch
fs-adfs-superc-add-__init-to-init_inodecache.patch
affs-add-__init-to-init_inodecache.patch
fs-affs-dirc-unlock-brelse-dir-on-failure-code-clean-up.patch
affs-mount-option-to-avoid-filename-truncates.patch
fs-bfs-inodec-add-__init-to-init_inodecache.patch
kernel-panicc-display-reason-at-end-pr_emerg.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
linux-next.patch
fs-ufs-superc-add-__init-to-init_inodecache.patch
ufs-sb-mutex-merge-mutex_destroy.patch

