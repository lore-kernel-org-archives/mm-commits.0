From: akpm@linux-foundation.org
Subject: [merged] spufs-use-simple_write_to_buffer.patch removed from -mm tree
Date: Mon, 24 Jan 2011 11:36:08 -0800
Message-ID: <201101241936.p0OJa8Nh005738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753256Ab1AXTgp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Jan 2011 14:36:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, arnd@arndb.de, benh@kernel.crashing.org, jk@ozlabs.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     spufs: use simple_write_to_buffer()
has been removed from the -mm tree.  Its filename was
     spufs-use-simple_write_to_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
