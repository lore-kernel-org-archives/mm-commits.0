From: akpm@linux-foundation.org
Subject: [to-be-updated]
 huge-tmpfs-get_unmapped_area-align-fault-supply-huge-page-fix-fix-2.patch
 removed from -mm tree
Date: Thu, 21 Apr 2016 13:45:58 -0700
Message-ID: <57193c06.UZKkrAmq/2F/D4sc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbcDUUp7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 16:45:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: huge-tmpfs-get_unmapped_area-align-fault-supply-huge-page-fix-fix-2
has been removed from the -mm tree.  Its filename was
     huge-tmpfs-get_unmapped_area-align-fault-supply-huge-page-fix-fix-2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: huge-tmpfs-get_unmapped_area-align-fault-supply-huge-page-fix-fix-2

Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/shmem.c~huge-tmpfs-get_unmapped_area-align-fault-supply-huge-page-fix-fix-2 mm/shmem.c
--- a/mm/shmem.c~huge-tmpfs-get_unmapped_area-align-fault-supply-huge-page-fix-fix-2
+++ a/mm/shmem.c
@@ -4305,7 +4305,11 @@ unsigned long shmem_get_unmapped_area(st
 				      unsigned long addr, unsigned long len,
 				      unsigned long pgoff, unsigned long flags)
 {
+#ifdef CONFIG_MMU
 	return current->mm->get_unmapped_area(file, addr, len, pgoff, flags);
+#else
+	return -ENOSYS;
+#endif
 }
 
 void shmem_truncate_range(struct inode *inode, loff_t lstart, loff_t lend)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-compaction-direct-freepage-allocation-for-async-direct-compaction-checkpatch-fixes.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

