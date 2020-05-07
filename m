From: akpm@linux-foundation.org
Subject: [merged] powerpc-spufs-simplify-spufs-core-dumping.patch
 removed from -mm tree
Date: Thu, 07 May 2020 09:55:34 -0700
Message-ID: <20200507165534.47_nC9TmP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbgEGQzh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 12:55:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, benh@kernel.crashing.org, ebiederm@xmission.com, hch@lst.de, jk@ozlabs.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, oleg@redhat.com, paulus@samba.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: powerpc/spufs: simplify spufs core dumping
has been removed from the -mm tree.  Its filename was
     powerpc-spufs-simplify-spufs-core-dumping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: powerpc/spufs: simplify spufs core dumping

Replace the coredump ->read method with a ->dump method that must call
dump_emit itself.  That way we avoid a buffer allocation an messing with
set_fs() to call into code that is intended to deal with user buffers. 
For the ->get case we can now use a small on-stack buffer and avoid memory
allocations as well.

Link: http://lkml.kernel.org/r/20200505101256.3121270-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/coredump.c |   85 ++-----
 arch/powerpc/platforms/cell/spufs/file.c     |  203 +++++++----------
 arch/powerpc/platforms/cell/spufs/spufs.h    |    3 
 3 files changed, 116 insertions(+), 175 deletions(-)

--- a/arch/powerpc/platforms/cell/spufs/coredump.c~powerpc-spufs-simplify-spufs-core-dumping
+++ a/arch/powerpc/platforms/cell/spufs/coredump.c
@@ -21,22 +21,6 @@
 
 #include "spufs.h"
 
-static ssize_t do_coredump_read(int num, struct spu_context *ctx, void *buffer,
-				size_t size, loff_t *off)
-{
-	u64 data;
-	int ret;
-
-	if (spufs_coredump_read[num].read)
-		return spufs_coredump_read[num].read(ctx, buffer, size, off);
-
-	data = spufs_coredump_read[num].get(ctx);
-	ret = snprintf(buffer, size, "0x%.16llx", data);
-	if (ret >= size)
-		return size;
-	return ++ret; /* count trailing NULL */
-}
-
 static int spufs_ctx_note_size(struct spu_context *ctx, int dfd)
 {
 	int i, sz, total = 0;
@@ -118,58 +102,43 @@ int spufs_coredump_extra_notes_size(void
 static int spufs_arch_write_note(struct spu_context *ctx, int i,
 				  struct coredump_params *cprm, int dfd)
 {
-	loff_t pos = 0;
-	int sz, rc, total = 0;
-	const int bufsz = PAGE_SIZE;
-	char *name;
-	char fullname[80], *buf;
+	size_t sz = spufs_coredump_read[i].size;
+	char fullname[80];
 	struct elf_note en;
-	size_t skip;
+	size_t ret;
 
-	buf = (void *)get_zeroed_page(GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	name = spufs_coredump_read[i].name;
-	sz = spufs_coredump_read[i].size;
-
-	sprintf(fullname, "SPU/%d/%s", dfd, name);
+	sprintf(fullname, "SPU/%d/%s", dfd, spufs_coredump_read[i].name);
 	en.n_namesz = strlen(fullname) + 1;
 	en.n_descsz = sz;
 	en.n_type = NT_SPU;
 
 	if (!dump_emit(cprm, &en, sizeof(en)))
-		goto Eio;
-
+		return -EIO;
 	if (!dump_emit(cprm, fullname, en.n_namesz))
-		goto Eio;
-
+		return -EIO;
 	if (!dump_align(cprm, 4))
-		goto Eio;
+		return -EIO;
+
+	if (spufs_coredump_read[i].dump) {
+		ret = spufs_coredump_read[i].dump(ctx, cprm);
+		if (ret < 0)
+			return ret;
+	} else {
+		char buf[32];
+
+		ret = snprintf(buf, sizeof(buf), "0x%.16llx",
+			       spufs_coredump_read[i].get(ctx));
+		if (ret >= sizeof(buf))
+			return sizeof(buf);
+
+		/* count trailing the NULL: */
+		if (!dump_emit(cprm, buf, ret + 1))
+			return -EIO;
+	}
 
-	do {
-		rc = do_coredump_read(i, ctx, buf, bufsz, &pos);
-		if (rc > 0) {
-			if (!dump_emit(cprm, buf, rc))
-				goto Eio;
-			total += rc;
-		}
-	} while (rc == bufsz && total < sz);
-
-	if (rc < 0)
-		goto out;
-
-	skip = roundup(cprm->pos - total + sz, 4) - cprm->pos;
-	if (!dump_skip(cprm, skip))
-		goto Eio;
-
-	rc = 0;
-out:
-	free_page((unsigned long)buf);
-	return rc;
-Eio:
-	free_page((unsigned long)buf);
-	return -EIO;
+	if (!dump_skip(cprm, roundup(cprm->pos - ret + sz, 4) - cprm->pos))
+		return -EIO;
+	return 0;
 }
 
 int spufs_coredump_extra_notes_write(struct coredump_params *cprm)
--- a/arch/powerpc/platforms/cell/spufs/file.c~powerpc-spufs-simplify-spufs-core-dumping
+++ a/arch/powerpc/platforms/cell/spufs/file.c
@@ -9,6 +9,7 @@
 
 #undef DEBUG
 
+#include <linux/coredump.h>
 #include <linux/fs.h>
 #include <linux/ioctl.h>
 #include <linux/export.h>
@@ -129,6 +130,14 @@ out:
 	return ret;
 }
 
+static ssize_t spufs_dump_emit(struct coredump_params *cprm, void *buf,
+		size_t size)
+{
+	if (!dump_emit(cprm, buf, size))
+		return -EIO;
+	return size;
+}
+
 #define DEFINE_SPUFS_SIMPLE_ATTRIBUTE(__fops, __get, __set, __fmt)	\
 static int __fops ## _open(struct inode *inode, struct file *file)	\
 {									\
@@ -172,12 +181,9 @@ spufs_mem_release(struct inode *inode, s
 }
 
 static ssize_t
-__spufs_mem_read(struct spu_context *ctx, char __user *buffer,
-			size_t size, loff_t *pos)
+spufs_mem_dump(struct spu_context *ctx, struct coredump_params *cprm)
 {
-	char *local_store = ctx->ops->get_ls(ctx);
-	return simple_read_from_buffer(buffer, size, pos, local_store,
-					LS_SIZE);
+	return spufs_dump_emit(cprm, ctx->ops->get_ls(ctx), LS_SIZE);
 }
 
 static ssize_t
@@ -190,7 +196,8 @@ spufs_mem_read(struct file *file, char _
 	ret = spu_acquire(ctx);
 	if (ret)
 		return ret;
-	ret = __spufs_mem_read(ctx, buffer, size, pos);
+	ret = simple_read_from_buffer(buffer, size, pos, ctx->ops->get_ls(ctx),
+				      LS_SIZE);
 	spu_release(ctx);
 
 	return ret;
@@ -459,12 +466,10 @@ spufs_regs_open(struct inode *inode, str
 }
 
 static ssize_t
-__spufs_regs_read(struct spu_context *ctx, char __user *buffer,
-			size_t size, loff_t *pos)
+spufs_regs_dump(struct spu_context *ctx, struct coredump_params *cprm)
 {
-	struct spu_lscsa *lscsa = ctx->csa.lscsa;
-	return simple_read_from_buffer(buffer, size, pos,
-				      lscsa->gprs, sizeof lscsa->gprs);
+	return spufs_dump_emit(cprm, ctx->csa.lscsa->gprs,
+			       sizeof(ctx->csa.lscsa->gprs));
 }
 
 static ssize_t
@@ -482,7 +487,8 @@ spufs_regs_read(struct file *file, char
 	ret = spu_acquire_saved(ctx);
 	if (ret)
 		return ret;
-	ret = __spufs_regs_read(ctx, buffer, size, pos);
+	ret = simple_read_from_buffer(buffer, size, pos, ctx->csa.lscsa->gprs,
+				      sizeof(ctx->csa.lscsa->gprs));
 	spu_release_saved(ctx);
 	return ret;
 }
@@ -517,12 +523,10 @@ static const struct file_operations spuf
 };
 
 static ssize_t
-__spufs_fpcr_read(struct spu_context *ctx, char __user * buffer,
-			size_t size, loff_t * pos)
+spufs_fpcr_dump(struct spu_context *ctx, struct coredump_params *cprm)
 {
-	struct spu_lscsa *lscsa = ctx->csa.lscsa;
-	return simple_read_from_buffer(buffer, size, pos,
-				      &lscsa->fpcr, sizeof(lscsa->fpcr));
+	return spufs_dump_emit(cprm, &ctx->csa.lscsa->fpcr,
+			       sizeof(ctx->csa.lscsa->fpcr));
 }
 
 static ssize_t
@@ -535,7 +539,8 @@ spufs_fpcr_read(struct file *file, char
 	ret = spu_acquire_saved(ctx);
 	if (ret)
 		return ret;
-	ret = __spufs_fpcr_read(ctx, buffer, size, pos);
+	ret = simple_read_from_buffer(buffer, size, pos, &ctx->csa.lscsa->fpcr,
+				      sizeof(ctx->csa.lscsa->fpcr));
 	spu_release_saved(ctx);
 	return ret;
 }
@@ -953,28 +958,26 @@ spufs_signal1_release(struct inode *inod
 	return 0;
 }
 
-static ssize_t __spufs_signal1_read(struct spu_context *ctx, char __user *buf,
-			size_t len, loff_t *pos)
+static ssize_t spufs_signal1_dump(struct spu_context *ctx,
+		struct coredump_params *cprm)
 {
-	int ret = 0;
-	u32 data;
+	if (!ctx->csa.spu_chnlcnt_RW[3])
+		return 0;
+	return spufs_dump_emit(cprm, &ctx->csa.spu_chnldata_RW[3],
+			       sizeof(ctx->csa.spu_chnldata_RW[3]));
+}
 
-	if (len < 4)
+static ssize_t __spufs_signal1_read(struct spu_context *ctx, char __user *buf,
+			size_t len)
+{
+	if (len < sizeof(ctx->csa.spu_chnldata_RW[3]))
 		return -EINVAL;
-
-	if (ctx->csa.spu_chnlcnt_RW[3]) {
-		data = ctx->csa.spu_chnldata_RW[3];
-		ret = 4;
-	}
-
-	if (!ret)
-		goto out;
-
-	if (copy_to_user(buf, &data, 4))
+	if (!ctx->csa.spu_chnlcnt_RW[3])
+		return 0;
+	if (copy_to_user(buf, &ctx->csa.spu_chnldata_RW[3],
+			 sizeof(ctx->csa.spu_chnldata_RW[3])))
 		return -EFAULT;
-
-out:
-	return ret;
+	return sizeof(ctx->csa.spu_chnldata_RW[3]);
 }
 
 static ssize_t spufs_signal1_read(struct file *file, char __user *buf,
@@ -986,7 +989,7 @@ static ssize_t spufs_signal1_read(struct
 	ret = spu_acquire_saved(ctx);
 	if (ret)
 		return ret;
-	ret = __spufs_signal1_read(ctx, buf, len, pos);
+	ret = __spufs_signal1_read(ctx, buf, len);
 	spu_release_saved(ctx);
 
 	return ret;
@@ -1090,28 +1093,26 @@ spufs_signal2_release(struct inode *inod
 	return 0;
 }
 
-static ssize_t __spufs_signal2_read(struct spu_context *ctx, char __user *buf,
-			size_t len, loff_t *pos)
+static ssize_t spufs_signal2_dump(struct spu_context *ctx,
+		struct coredump_params *cprm)
 {
-	int ret = 0;
-	u32 data;
+	if (!ctx->csa.spu_chnlcnt_RW[4])
+		return 0;
+	return spufs_dump_emit(cprm, &ctx->csa.spu_chnldata_RW[4],
+			       sizeof(ctx->csa.spu_chnldata_RW[4]));
+}
 
-	if (len < 4)
+static ssize_t __spufs_signal2_read(struct spu_context *ctx, char __user *buf,
+			size_t len)
+{
+	if (len < sizeof(ctx->csa.spu_chnldata_RW[4]))
 		return -EINVAL;
-
-	if (ctx->csa.spu_chnlcnt_RW[4]) {
-		data =  ctx->csa.spu_chnldata_RW[4];
-		ret = 4;
-	}
-
-	if (!ret)
-		goto out;
-
-	if (copy_to_user(buf, &data, 4))
+	if (!ctx->csa.spu_chnlcnt_RW[4])
+		return 0;
+	if (copy_to_user(buf, &ctx->csa.spu_chnldata_RW[4],
+			 sizeof(ctx->csa.spu_chnldata_RW[4])))
 		return -EFAULT;
-
-out:
-	return ret;
+	return sizeof(ctx->csa.spu_chnldata_RW[4]);
 }
 
 static ssize_t spufs_signal2_read(struct file *file, char __user *buf,
@@ -1123,7 +1124,7 @@ static ssize_t spufs_signal2_read(struct
 	ret = spu_acquire_saved(ctx);
 	if (ret)
 		return ret;
-	ret = __spufs_signal2_read(ctx, buf, len, pos);
+	ret = __spufs_signal2_read(ctx, buf, len);
 	spu_release_saved(ctx);
 
 	return ret;
@@ -1947,18 +1948,13 @@ static const struct file_operations spuf
 	.release	= single_release,
 };
 
-static ssize_t __spufs_mbox_info_read(struct spu_context *ctx,
-			char __user *buf, size_t len, loff_t *pos)
+static ssize_t spufs_mbox_info_dump(struct spu_context *ctx,
+		struct coredump_params *cprm)
 {
-	u32 data;
-
-	/* EOF if there's no entry in the mbox */
 	if (!(ctx->csa.prob.mb_stat_R & 0x0000ff))
 		return 0;
-
-	data = ctx->csa.prob.pu_mb_R;
-
-	return simple_read_from_buffer(buf, len, pos, &data, sizeof data);
+	return spufs_dump_emit(cprm, &ctx->csa.prob.pu_mb_R,
+			       sizeof(ctx->csa.prob.pu_mb_R));
 }
 
 static ssize_t spufs_mbox_info_read(struct file *file, char __user *buf,
@@ -1990,18 +1986,13 @@ static const struct file_operations spuf
 	.llseek  = generic_file_llseek,
 };
 
-static ssize_t __spufs_ibox_info_read(struct spu_context *ctx,
-				char __user *buf, size_t len, loff_t *pos)
+static ssize_t spufs_ibox_info_dump(struct spu_context *ctx,
+		struct coredump_params *cprm)
 {
-	u32 data;
-
-	/* EOF if there's no entry in the ibox */
 	if (!(ctx->csa.prob.mb_stat_R & 0xff0000))
 		return 0;
-
-	data = ctx->csa.priv2.puint_mb_R;
-
-	return simple_read_from_buffer(buf, len, pos, &data, sizeof data);
+	return spufs_dump_emit(cprm, &ctx->csa.priv2.puint_mb_R,
+			       sizeof(ctx->csa.priv2.puint_mb_R));
 }
 
 static ssize_t spufs_ibox_info_read(struct file *file, char __user *buf,
@@ -2038,21 +2029,11 @@ static size_t spufs_wbox_info_cnt(struct
 	return (4 - ((ctx->csa.prob.mb_stat_R & 0x00ff00) >> 8)) * sizeof(u32);
 }
 
-static ssize_t __spufs_wbox_info_read(struct spu_context *ctx,
-			char __user *buf, size_t len, loff_t *pos)
+static ssize_t spufs_wbox_info_dump(struct spu_context *ctx,
+		struct coredump_params *cprm)
 {
-	int i, cnt;
-	u32 data[4];
-	u32 wbox_stat;
-
-	wbox_stat = ctx->csa.prob.mb_stat_R;
-	cnt = spufs_wbox_info_cnt(ctx);
-	for (i = 0; i < cnt; i++) {
-		data[i] = ctx->csa.spu_mailbox_data[i];
-	}
-
-	return simple_read_from_buffer(buf, len, pos, &data,
-				cnt * sizeof(u32));
+	return spufs_dump_emit(cprm, &ctx->csa.spu_mailbox_data,
+			spufs_wbox_info_cnt(ctx));
 }
 
 static ssize_t spufs_wbox_info_read(struct file *file, char __user *buf,
@@ -2102,15 +2083,13 @@ static void spufs_get_dma_info(struct sp
 	}
 }
 
-static ssize_t __spufs_dma_info_read(struct spu_context *ctx,
-			char __user *buf, size_t len, loff_t *pos)
+static ssize_t spufs_dma_info_dump(struct spu_context *ctx,
+		struct coredump_params *cprm)
 {
 	struct spu_dma_info info;
 
 	spufs_get_dma_info(ctx, &info);
-
-	return simple_read_from_buffer(buf, len, pos, &info,
-				sizeof info);
+	return spufs_dump_emit(cprm, &info, sizeof(info));
 }
 
 static ssize_t spufs_dma_info_read(struct file *file, char __user *buf,
@@ -2158,22 +2137,13 @@ static void spufs_get_proxydma_info(stru
 	}
 }
 
-static ssize_t __spufs_proxydma_info_read(struct spu_context *ctx,
-			char __user *buf, size_t len, loff_t *pos)
+static ssize_t spufs_proxydma_info_dump(struct spu_context *ctx,
+		struct coredump_params *cprm)
 {
 	struct spu_proxydma_info info;
-	int ret = sizeof info;
-
-	if (len < ret)
-		return -EINVAL;
-
-	if (!access_ok(buf, len))
-		return -EFAULT;
 
 	spufs_get_proxydma_info(ctx, &info);
-
-	return simple_read_from_buffer(buf, len, pos, &info,
-				sizeof info);
+	return spufs_dump_emit(cprm, &info, sizeof(info));
 }
 
 static ssize_t spufs_proxydma_info_read(struct file *file, char __user *buf,
@@ -2183,6 +2153,9 @@ static ssize_t spufs_proxydma_info_read(
 	struct spu_proxydma_info info;
 	int ret;
 
+	if (len < sizeof(info))
+		return -EINVAL;
+
 	ret = spu_acquire_saved(ctx);
 	if (ret)
 		return ret;
@@ -2636,23 +2609,23 @@ const struct spufs_tree_descr spufs_dir_
 };
 
 const struct spufs_coredump_reader spufs_coredump_read[] = {
-	{ "regs", __spufs_regs_read, NULL, sizeof(struct spu_reg128[128])},
-	{ "fpcr", __spufs_fpcr_read, NULL, sizeof(struct spu_reg128) },
+	{ "regs", spufs_regs_dump, NULL, sizeof(struct spu_reg128[128])},
+	{ "fpcr", spufs_fpcr_dump, NULL, sizeof(struct spu_reg128) },
 	{ "lslr", NULL, spufs_lslr_get, 19 },
 	{ "decr", NULL, spufs_decr_get, 19 },
 	{ "decr_status", NULL, spufs_decr_status_get, 19 },
-	{ "mem", __spufs_mem_read, NULL, LS_SIZE, },
-	{ "signal1", __spufs_signal1_read, NULL, sizeof(u32) },
+	{ "mem", spufs_mem_dump, NULL, LS_SIZE, },
+	{ "signal1", spufs_signal1_dump, NULL, sizeof(u32) },
 	{ "signal1_type", NULL, spufs_signal1_type_get, 19 },
-	{ "signal2", __spufs_signal2_read, NULL, sizeof(u32) },
+	{ "signal2", spufs_signal2_dump, NULL, sizeof(u32) },
 	{ "signal2_type", NULL, spufs_signal2_type_get, 19 },
 	{ "event_mask", NULL, spufs_event_mask_get, 19 },
 	{ "event_status", NULL, spufs_event_status_get, 19 },
-	{ "mbox_info", __spufs_mbox_info_read, NULL, sizeof(u32) },
-	{ "ibox_info", __spufs_ibox_info_read, NULL, sizeof(u32) },
-	{ "wbox_info", __spufs_wbox_info_read, NULL, 4 * sizeof(u32)},
-	{ "dma_info", __spufs_dma_info_read, NULL, sizeof(struct spu_dma_info)},
-	{ "proxydma_info", __spufs_proxydma_info_read,
+	{ "mbox_info", spufs_mbox_info_dump, NULL, sizeof(u32) },
+	{ "ibox_info", spufs_ibox_info_dump, NULL, sizeof(u32) },
+	{ "wbox_info", spufs_wbox_info_dump, NULL, 4 * sizeof(u32)},
+	{ "dma_info", spufs_dma_info_dump, NULL, sizeof(struct spu_dma_info)},
+	{ "proxydma_info", spufs_proxydma_info_dump,
 			   NULL, sizeof(struct spu_proxydma_info)},
 	{ "object-id", NULL, spufs_object_id_get, 19 },
 	{ "npc", NULL, spufs_npc_get, 19 },
--- a/arch/powerpc/platforms/cell/spufs/spufs.h~powerpc-spufs-simplify-spufs-core-dumping
+++ a/arch/powerpc/platforms/cell/spufs/spufs.h
@@ -337,8 +337,7 @@ void spufs_dma_callback(struct spu *spu,
 extern struct spu_coredump_calls spufs_coredump_calls;
 struct spufs_coredump_reader {
 	char *name;
-	ssize_t (*read)(struct spu_context *ctx,
-			char __user *buffer, size_t size, loff_t *pos);
+	ssize_t (*dump)(struct spu_context *ctx, struct coredump_params *cprm);
 	u64 (*get)(struct spu_context *ctx);
 	size_t size;
 };
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
