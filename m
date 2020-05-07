From: akpm@linux-foundation.org
Subject: [merged] powerpc-spufs-stop-using-access_ok.patch removed
 from -mm tree
Date: Thu, 07 May 2020 09:55:31 -0700
Message-ID: <20200507165531.8Xvx9vPCV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbgEGQzc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 12:55:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, benh@kernel.crashing.org, ebiederm@xmission.com, hch@lst.de, jk@ozlabs.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, oleg@redhat.com, paulus@samba.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: powerpc/spufs: stop using access_ok
has been removed from the -mm tree.  Its filename was
     powerpc-spufs-stop-using-access_ok.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: powerpc/spufs: stop using access_ok

Just use the proper non __-prefixed get/put_user variants where that is
not done yet.

Link: http://lkml.kernel.org/r/20200505101256.3121270-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/file.c |   42 ++++-----------------
 1 file changed, 8 insertions(+), 34 deletions(-)

--- a/arch/powerpc/platforms/cell/spufs/file.c~powerpc-spufs-stop-using-access_ok
+++ a/arch/powerpc/platforms/cell/spufs/file.c
@@ -590,17 +590,12 @@ static ssize_t spufs_mbox_read(struct fi
 			size_t len, loff_t *pos)
 {
 	struct spu_context *ctx = file->private_data;
-	u32 mbox_data, __user *udata;
+	u32 mbox_data, __user *udata = (void __user *)buf;
 	ssize_t count;
 
 	if (len < 4)
 		return -EINVAL;
 
-	if (!access_ok(buf, len))
-		return -EFAULT;
-
-	udata = (void __user *)buf;
-
 	count = spu_acquire(ctx);
 	if (count)
 		return count;
@@ -616,7 +611,7 @@ static ssize_t spufs_mbox_read(struct fi
 		 * but still need to return the data we have
 		 * read successfully so far.
 		 */
-		ret = __put_user(mbox_data, udata);
+		ret = put_user(mbox_data, udata);
 		if (ret) {
 			if (!count)
 				count = -EFAULT;
@@ -698,17 +693,12 @@ static ssize_t spufs_ibox_read(struct fi
 			size_t len, loff_t *pos)
 {
 	struct spu_context *ctx = file->private_data;
-	u32 ibox_data, __user *udata;
+	u32 ibox_data, __user *udata = (void __user *)buf;
 	ssize_t count;
 
 	if (len < 4)
 		return -EINVAL;
 
-	if (!access_ok(buf, len))
-		return -EFAULT;
-
-	udata = (void __user *)buf;
-
 	count = spu_acquire(ctx);
 	if (count)
 		goto out;
@@ -727,7 +717,7 @@ static ssize_t spufs_ibox_read(struct fi
 	}
 
 	/* if we can't write at all, return -EFAULT */
-	count = __put_user(ibox_data, udata);
+	count = put_user(ibox_data, udata);
 	if (count)
 		goto out_unlock;
 
@@ -741,7 +731,7 @@ static ssize_t spufs_ibox_read(struct fi
 		 * but still need to return the data we have
 		 * read successfully so far.
 		 */
-		ret = __put_user(ibox_data, udata);
+		ret = put_user(ibox_data, udata);
 		if (ret)
 			break;
 	}
@@ -836,17 +826,13 @@ static ssize_t spufs_wbox_write(struct f
 			size_t len, loff_t *pos)
 {
 	struct spu_context *ctx = file->private_data;
-	u32 wbox_data, __user *udata;
+	u32 wbox_data, __user *udata = (void __user *)buf;
 	ssize_t count;
 
 	if (len < 4)
 		return -EINVAL;
 
-	udata = (void __user *)buf;
-	if (!access_ok(buf, len))
-		return -EFAULT;
-
-	if (__get_user(wbox_data, udata))
+	if (get_user(wbox_data, udata))
 		return -EFAULT;
 
 	count = spu_acquire(ctx);
@@ -873,7 +859,7 @@ static ssize_t spufs_wbox_write(struct f
 	/* write as much as possible */
 	for (count = 4, udata++; (count + 4) <= len; count += 4, udata++) {
 		int ret;
-		ret = __get_user(wbox_data, udata);
+		ret = get_user(wbox_data, udata);
 		if (ret)
 			break;
 
@@ -1982,9 +1968,6 @@ static ssize_t spufs_mbox_info_read(stru
 	u32 stat, data;
 	int ret;
 
-	if (!access_ok(buf, len))
-		return -EFAULT;
-
 	ret = spu_acquire_saved(ctx);
 	if (ret)
 		return ret;
@@ -2028,9 +2011,6 @@ static ssize_t spufs_ibox_info_read(stru
 	u32 stat, data;
 	int ret;
 
-	if (!access_ok(buf, len))
-		return -EFAULT;
-
 	ret = spu_acquire_saved(ctx);
 	if (ret)
 		return ret;
@@ -2082,9 +2062,6 @@ static ssize_t spufs_wbox_info_read(stru
 	u32 data[ARRAY_SIZE(ctx->csa.spu_mailbox_data)];
 	int ret, count;
 
-	if (!access_ok(buf, len))
-		return -EFAULT;
-
 	ret = spu_acquire_saved(ctx);
 	if (ret)
 		return ret;
@@ -2143,9 +2120,6 @@ static ssize_t spufs_dma_info_read(struc
 	struct spu_dma_info info;
 	int ret;
 
-	if (!access_ok(buf, len))
-		return -EFAULT;
-
 	ret = spu_acquire_saved(ctx);
 	if (ret)
 		return ret;
_

Patches currently in -mm which might be from hch@lst.de are

x86-hyperv-use-vmalloc_exec-for-the-hypercall-page.patch
x86-fix-vmap-arguments-in-map_irq_stack.patch
staging-android-ion-use-vmap-instead-of-vm_map_ram.patch
staging-media-ipu3-use-vmap-instead-of-reimplementing-it.patch
dma-mapping-use-vmap-insted-of-reimplementing-it.patch
powerpc-add-an-ioremap_phb-helper.patch
powerpc-remove-__ioremap_at-and-__iounmap_at.patch
mm-remove-__get_vm_area.patch
mm-unexport-unmap_kernel_range_noflush.patch
mm-rename-config_pgtable_mapping-to-config_zsmalloc_pgtable_mapping.patch
mm-only-allow-page-table-mappings-for-built-in-zsmalloc.patch
mm-pass-addr-as-unsigned-long-to-vb_free.patch
mm-remove-vmap_page_range_noflush-and-vunmap_page_range.patch
mm-rename-vmap_page_range-to-map_kernel_range.patch
mm-dont-return-the-number-of-pages-from-map_kernel_range_noflush.patch
mm-remove-map_vm_range.patch
mm-remove-unmap_vmap_area.patch
mm-remove-the-prot-argument-from-vm_map_ram.patch
mm-enforce-that-vmap-cant-map-pages-executable.patch
gpu-drm-remove-the-powerpc-hack-in-drm_legacy_sg_alloc.patch
mm-remove-the-pgprot-argument-to-__vmalloc.patch
mm-remove-the-prot-argument-to-__vmalloc_node.patch
mm-remove-both-instances-of-__vmalloc_node_flags.patch
mm-remove-__vmalloc_node_flags_caller.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node.patch
mm-remove-vmalloc_user_node_flags.patch
arm64-use-__vmalloc_node-in-arch_alloc_vmap_stack.patch
powerpc-use-__vmalloc_node-in-alloc_vm_stack.patch
s390-use-__vmalloc_node-in-stack_alloc.patch
exec-simplify-the-copy_strings_kernel-calling-convention.patch
exec-open-code-copy_string_kernel.patch
amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch
kernel-move-use_mm-unuse_mm-to-kthreadc.patch
kernel-move-use_mm-unuse_mm-to-kthreadc-v2.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-v2.patch
kernel-set-user_ds-in-kthread_use_mm.patch
