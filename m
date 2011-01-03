From: akpm@linux-foundation.org
Subject: + spufs-use-simple_write_to_buffer.patch added to -mm tree
Date: Mon, 03 Jan 2011 13:11:13 -0800
Message-ID: <201101032111.p03LBDsW028685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751155Ab1ACVL3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jan 2011 16:11:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, arnd@arndb.de, benh@kernel.crashing.org, jk@ozlabs.org, paulus@samba.org


The patch titled
     spufs: use simple_write_to_buffer()
has been added to the -mm tree.  Its filename is
     spufs-use-simple_write_to_buffer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spufs: use simple_write_to_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Simplify several write fileoperations for spufs by using
simple_write_to_buffer().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jeremy Kerr <jk@ozlabs.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/file.c |   27 +++++----------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/file.c~spufs-use-simple_write_to_buffer arch/powerpc/platforms/cell/spufs/file.c
--- a/arch/powerpc/platforms/cell/spufs/file.c~spufs-use-simple_write_to_buffer
+++ a/arch/powerpc/platforms/cell/spufs/file.c
@@ -219,24 +219,17 @@ spufs_mem_write(struct file *file, const
 	loff_t pos = *ppos;
 	int ret;
 
-	if (pos < 0)
-		return -EINVAL;
 	if (pos > LS_SIZE)
 		return -EFBIG;
-	if (size > LS_SIZE - pos)
-		size = LS_SIZE - pos;
 
 	ret = spu_acquire(ctx);
 	if (ret)
 		return ret;
 
 	local_store = ctx->ops->get_ls(ctx);
-	ret = copy_from_user(local_store + pos, buffer, size);
+	size = simple_write_to_buffer(local_store, LS_SIZE, ppos, buffer, size);
 	spu_release(ctx);
 
-	if (ret)
-		return -EFAULT;
-	*ppos = pos + size;
 	return size;
 }
 
@@ -574,18 +567,15 @@ spufs_regs_write(struct file *file, cons
 	if (*pos >= sizeof(lscsa->gprs))
 		return -EFBIG;
 
-	size = min_t(ssize_t, sizeof(lscsa->gprs) - *pos, size);
-	*pos += size;
-
 	ret = spu_acquire_saved(ctx);
 	if (ret)
 		return ret;
 
-	ret = copy_from_user((char *)lscsa->gprs + *pos - size,
-			     buffer, size) ? -EFAULT : size;
+	size = simple_write_to_buffer(lscsa->gprs, sizeof(lscsa->gprs), pos,
+					buffer, size);
 
 	spu_release_saved(ctx);
-	return ret;
+	return size;
 }
 
 static const struct file_operations spufs_regs_fops = {
@@ -630,18 +620,15 @@ spufs_fpcr_write(struct file *file, cons
 	if (*pos >= sizeof(lscsa->fpcr))
 		return -EFBIG;
 
-	size = min_t(ssize_t, sizeof(lscsa->fpcr) - *pos, size);
-
 	ret = spu_acquire_saved(ctx);
 	if (ret)
 		return ret;
 
-	*pos += size;
-	ret = copy_from_user((char *)&lscsa->fpcr + *pos - size,
-			     buffer, size) ? -EFAULT : size;
+	size = simple_write_to_buffer(&lscsa->fpcr, sizeof(lscsa->fpcr), pos,
+					buffer, size);
 
 	spu_release_saved(ctx);
-	return ret;
+	return size;
 }
 
 static const struct file_operations spufs_fpcr_fops = {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

spufs-use-simple_write_to_buffer.patch
uml-use-simple_write_to_buffer.patch
bitops-merge-little-and-big-endian-definisions-in-asm-generic-bitops-leh.patch
bitops-rename-generic-little-endian-bitops-functions.patch
s390-introduce-little-endian-bitops.patch
arm-introduce-little-endian-bitops.patch
m68k-introduce-little-endian-bitops.patch
bitops-introduce-config_generic_find_le_bit.patch
m68knommu-introduce-little-endian-bitops.patch
m68knommu-introduce-little-endian-bitops-build-fix.patch
bitops-introduce-little-endian-bitops-for-most-architectures.patch
rds-stop-including-asm-generic-bitops-leh.patch
kvm-stop-including-asm-generic-bitops-leh.patch
asm-generic-use-little-endian-bitops.patch
ext3-use-little-endian-bitops.patch
ext4-use-little-endian-bitops.patch
ocfs2-use-little-endian-bitops.patch
nilfs2-use-little-endian-bitops.patch
reiserfs-use-little-endian-bitops.patch
udf-use-little-endian-bitops.patch
ufs-use-little-endian-bitops.patch
md-use-little-endian-bit-operations.patch
dm-use-little-endian-bit-operations.patch
bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh.patch
m68k-remove-inline-asm-from-minix_find_first_zero_bit.patch
bitops-remove-minix-bitops-from-asm-bitopsh.patch
bitops-use-find_first_zero_bit-instead-of-find_next_zero_bitaddr-size-0.patch

