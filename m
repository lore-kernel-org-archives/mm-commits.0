From: akpm@linux-foundation.org
Subject: - spufs-use-the-new-vm_ops-access.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:21:52 -0700
Message-ID: <200807242321.m6ONLq79010432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753601AbYGXXXE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:23:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, airlied@linux.ie, arnd@arndb.de, hugh@veritas.com, paulus@samba.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     spufs: use new vm_ops->access to allow local state access from gdb
has been removed from the -mm tree.  Its filename was
     spufs-use-the-new-vm_ops-access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spufs: use new vm_ops->access to allow local state access from gdb
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

This uses the new vm_ops->access to allow gdb to access the SPU local
store.  We currently prevent access to problem state registers, this can
be done later if really needed but it's safer not to.

[akpm@linux-foundation.org: fix typo]
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/file.c |   23 +++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN arch/powerpc/platforms/cell/spufs/file.c~spufs-use-the-new-vm_ops-access arch/powerpc/platforms/cell/spufs/file.c
--- a/arch/powerpc/platforms/cell/spufs/file.c~spufs-use-the-new-vm_ops-access
+++ a/arch/powerpc/platforms/cell/spufs/file.c
@@ -288,9 +288,32 @@ spufs_mem_mmap_fault(struct vm_area_stru
 	return VM_FAULT_NOPAGE;
 }
 
+static int spufs_mem_mmap_access(struct vm_area_struct *vma,
+				unsigned long address,
+				void *buf, int len, int write)
+{
+	struct spu_context *ctx = vma->vm_file->private_data;
+	unsigned long offset = address - vma->vm_start;
+	char *local_store;
+
+	if (write && !(vma->vm_flags & VM_WRITE))
+		return -EACCES;
+	if (spu_acquire(ctx))
+		return -EINTR;
+	if ((offset + len) > vma->vm_end)
+		len = vma->vm_end - offset;
+	local_store = ctx->ops->get_ls(ctx);
+	if (write)
+		memcpy_toio(local_store + offset, buf, len);
+	else
+		memcpy_fromio(buf, local_store + offset, len);
+	spu_release(ctx);
+	return len;
+}
 
 static struct vm_operations_struct spufs_mem_mmap_vmops = {
 	.fault = spufs_mem_mmap_fault,
+	.access = spufs_mem_mmap_access,
 };
 
 static int spufs_mem_mmap(struct file *file, struct vm_area_struct *vma)
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
linux-next.patch
powerpc-86xx-mpc8610_hpcd-add-watchdog-node.patch
gpiolib-allow-user-selection.patch
gpiolib-allow-user-selection-update.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-pasemi_mac.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-speculative-page-references-fix-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-implement-pte_special-update.patch
powerpc-lockless-get_user_pages.patch
powerpc-hugetlb-pgtable-cache-access-cleanup.patch
mm-print-swapcache-page-count-in-show_swap_cache_info.patch
lib-generic-show_mem.patch
powerpc-use-generic-show_mem.patch

