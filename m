Return-Path: <SRS0=oeTy=AY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B52C43446
	for <mm-commits@archiver.kernel.org>; Mon, 13 Jul 2020 23:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D56121924
	for <mm-commits@archiver.kernel.org>; Mon, 13 Jul 2020 23:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594684153;
	bh=GIjoaoZvmubK54wiWfk/Ulz3kn8D27D+Jh/4+I35XhU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=CorMccfk5HgtJNJGaEb05I/bhgJy9N9MCN1zJVAeA8YuNB2CYV6Ik+LYfSSlwabDN
	 1sKz+PmHrcFGC9nvg09VFjB3MkLHpgotvBLprZqUNeZBhlUy8VV50kBO9/EANKCB/H
	 2QuCGdwQi4d3eDsCJHvU3uL5fvPKiTz4hYny8kHE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgGMXtM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jul 2020 19:49:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726830AbgGMXtC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jul 2020 19:49:02 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B473217A0;
        Mon, 13 Jul 2020 23:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594684141;
        bh=GIjoaoZvmubK54wiWfk/Ulz3kn8D27D+Jh/4+I35XhU=;
        h=Date:From:To:Subject:From;
        b=GDJwrENjtGGObsteQOGsLBiB6fF5+J/Y7HEmR6yVC5zhbApcWL/qfw/n/lMZ3r0AV
         nmzd5J+nJFJLkMZLI0R2MID3pz7P6BKTX0OEHPWGF/a00hMFU/M1+6NZFPzV3aRfC6
         EIMpEWNsGNWlKgpeYp4k4F4F9ADoB7oTNCS0pSoA=
Date:   Mon, 13 Jul 2020 16:49:00 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20200713234900.ImY3vIw_A%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap                                 |    5 ---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c  |    3 --
 drivers/gpu/drm/i915/display/intel_fbc.c |    6 ----
 drivers/pinctrl/intel/pinctrl-baytrail.c |   13 --------
 fs/io_uring.c                            |    3 --
 fs/read_write.c                          |   31 ---------------------
 include/linux/fs.h                       |    3 --
 mm/filemap.c                             |    8 -----
 8 files changed, 72 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -1912,10 +1912,7 @@ static int psp_hw_fini(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 	struct psp_context *psp = &adev->psp;
-<<<<<<< HEAD
-=======
 	int ret;
->>>>>>> linux-next/akpm-base
 
 	if (psp->adev->psp.ta_fw) {
 		psp_ras_terminate(psp);
--- a/drivers/gpu/drm/i915/display/intel_fbc.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/display/intel_fbc.c
@@ -714,8 +714,6 @@ static void intel_fbc_update_state_cache
 	cache->fb.format = fb->format;
 	cache->fb.modifier = fb->modifier;
 
-<<<<<<< HEAD
-=======
 	/* FIXME is this correct? */
 	cache->fb.stride = plane_state->color_plane[0].stride;
 	if (drm_rotation_90_or_270(plane_state->hw.rotation))
@@ -724,7 +722,6 @@ static void intel_fbc_update_state_cache
 	/* FBC1 compression interval: arbitrary choice of 1 second */
 	cache->interval = drm_mode_vrefresh(&crtc_state->hw.adjusted_mode);
 
->>>>>>> linux-next/akpm-base
 	cache->fence_y_offset = intel_plane_fence_y_offset(plane_state);
 
 	drm_WARN_ON(&dev_priv->drm, plane_state->flags & PLANE_HAS_FENCE &&
@@ -898,11 +895,8 @@ static void intel_fbc_get_reg_params(str
 
 	params->fence_id = cache->fence_id;
 	params->fence_y_offset = cache->fence_y_offset;
-<<<<<<< HEAD
-=======
 
 	params->interval = cache->interval;
->>>>>>> linux-next/akpm-base
 
 	params->crtc.pipe = crtc->pipe;
 	params->crtc.i9xx_plane = to_intel_plane(crtc->base.primary)->i9xx_plane;
--- a/drivers/pinctrl/intel/pinctrl-baytrail.c~linux-next-git-rejects
+++ a/drivers/pinctrl/intel/pinctrl-baytrail.c
@@ -1206,7 +1206,6 @@ static int byt_gpio_direction_output(str
 	raw_spin_lock_irqsave(&byt_lock, flags);
 
 	byt_gpio_direct_irq_check(vg, offset);
-<<<<<<< HEAD
 
 	reg = readl(val_reg);
 	reg &= ~BYT_DIR_MASK;
@@ -1217,18 +1216,6 @@ static int byt_gpio_direction_output(str
 
 	writel(reg, val_reg);
 
-=======
-
-	reg = readl(val_reg);
-	reg &= ~BYT_DIR_MASK;
-	if (value)
-		reg |= BYT_LEVEL;
-	else
-		reg &= ~BYT_LEVEL;
-
-	writel(reg, val_reg);
-
->>>>>>> linux-next/akpm-base
 	raw_spin_unlock_irqrestore(&byt_lock, flags);
 	return 0;
 }
--- a/fs/io_uring.c~linux-next-git-rejects
+++ a/fs/io_uring.c
@@ -7674,11 +7674,8 @@ static void io_ring_ctx_free(struct io_r
 	io_mem_free(ctx->sq_sqes);
 
 	percpu_ref_exit(&ctx->refs);
-<<<<<<< HEAD
-=======
 	io_unaccount_mem(ctx, ring_pages(ctx->sq_entries, ctx->cq_entries),
 			 ACCT_LOCKED);
->>>>>>> linux-next/akpm-base
 	free_uid(ctx->user);
 	put_cred(ctx->creds);
 	kfree(ctx->cancel_hash);
--- a/fs/read_write.c~linux-next-git-rejects
+++ a/fs/read_write.c
@@ -418,11 +418,6 @@ static ssize_t new_sync_read(struct file
 	return ret;
 }
 
-<<<<<<< HEAD
-ssize_t __kernel_read(struct file *file, void *buf, size_t count, loff_t *pos)
-{
-	mm_segment_t old_fs = get_fs();
-=======
 static void warn_unsupported(struct file *file, const char *op)
 {
 	pr_warn_ratelimited(
@@ -432,7 +427,6 @@ static void warn_unsupported(struct file
 
 ssize_t __kernel_read(struct file *file, void *buf, size_t count, loff_t *pos)
 {
->>>>>>> linux-next/akpm-base
 	ssize_t ret;
 
 	if (WARN_ON_ONCE(!(file->f_mode & FMODE_READ)))
@@ -442,16 +436,6 @@ ssize_t __kernel_read(struct file *file,
 
 	if (count > MAX_RW_COUNT)
 		count =  MAX_RW_COUNT;
-<<<<<<< HEAD
-	set_fs(KERNEL_DS);
-	if (file->f_op->read)
-		ret = file->f_op->read(file, (void __user *)buf, count, pos);
-	else if (file->f_op->read_iter)
-		ret = new_sync_read(file, (void __user *)buf, count, pos);
-	else
-		ret = -EINVAL;
-	set_fs(old_fs);
-=======
 	if (file->f_op->read_iter) {
 		struct kvec iov = { .iov_base = buf, .iov_len = count };
 		struct kiocb kiocb;
@@ -467,7 +451,6 @@ ssize_t __kernel_read(struct file *file,
 			warn_unsupported(file, "read");
 		ret = -EINVAL;
 	}
->>>>>>> linux-next/akpm-base
 	if (ret > 0) {
 		fsnotify_access(file);
 		add_rchar(current, ret);
@@ -537,12 +520,8 @@ static ssize_t new_sync_write(struct fil
 }
 
 /* caller is responsible for file_start_write/file_end_write */
-<<<<<<< HEAD
-ssize_t __kernel_write(struct file *file, const void *buf, size_t count, loff_t *pos)
-=======
 ssize_t __kernel_write(struct file *file, const void *buf, size_t count,
 		loff_t *pos)
->>>>>>> linux-next/akpm-base
 {
 	ssize_t ret;
 
@@ -553,15 +532,6 @@ ssize_t __kernel_write(struct file *file
 
 	if (count > MAX_RW_COUNT)
 		count =  MAX_RW_COUNT;
-<<<<<<< HEAD
-	if (file->f_op->write)
-		ret = file->f_op->write(file, p, count, pos);
-	else if (file->f_op->write_iter)
-		ret = new_sync_write(file, p, count, pos);
-	else
-		ret = -EINVAL;
-	set_fs(old_fs);
-=======
 	if (file->f_op->write_iter) {
 		struct kvec iov = { .iov_base = (void *)buf, .iov_len = count };
 		struct kiocb kiocb;
@@ -578,7 +548,6 @@ ssize_t __kernel_write(struct file *file
 			warn_unsupported(file, "write");
 		ret = -EINVAL;
 	}
->>>>>>> linux-next/akpm-base
 	if (ret > 0) {
 		fsnotify_modify(file);
 		add_wchar(current, ret);
--- a/include/linux/fs.h~linux-next-git-rejects
+++ a/include/linux/fs.h
@@ -320,11 +320,8 @@ enum rw_hint {
 #define IOCB_SYNC		(1 << 5)
 #define IOCB_WRITE		(1 << 6)
 #define IOCB_NOWAIT		(1 << 7)
-<<<<<<< HEAD
-=======
 /* iocb->ki_waitq is valid */
 #define IOCB_WAITQ		(1 << 8)
->>>>>>> linux-next/akpm-base
 #define IOCB_NOIO		(1 << 9)
 
 struct kiocb {
--- a/.mailmap~linux-next-git-rejects
+++ a/.mailmap
@@ -100,13 +100,8 @@ Greg Kroah-Hartman <gregkh@suse.de>
 Greg Kroah-Hartman <greg@kroah.com>
 Gregory CLEMENT <gregory.clement@bootlin.com> <gregory.clement@free-electrons.com>
 Hanjun Guo <guohanjun@huawei.com> <hanjun.guo@linaro.org>
-<<<<<<< HEAD
-Heiko Carstens <hca@linux.ibm.com> <h.carstens@de.ibm.com>
-Heiko Carstens <hca@linux.ibm.com> <heiko.carstens@de.ibm.com>
-=======
 Heiko Carstens <hca@linux.ibm.com>
 Heiko Carstens <heiko.carstens@de.ibm.com>
->>>>>>> linux-next/akpm-base
 Henk Vergonet <Henk.Vergonet@gmail.com>
 Henrik Kretzschmar <henne@nachtwindheim.de>
 Henrik Rydberg <rydberg@bitmath.org>
--- a/mm/filemap.c~linux-next-git-rejects
+++ a/mm/filemap.c
@@ -2053,11 +2053,7 @@ find_page:
 
 		page = find_get_page(mapping, index);
 		if (!page) {
-<<<<<<< HEAD
-			if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_NOIO))
-=======
 			if (iocb->ki_flags & IOCB_NOIO)
->>>>>>> linux-next/akpm-base
 				goto would_block;
 			page_cache_sync_readahead(mapping,
 					ra, filp,
@@ -2204,11 +2200,7 @@ page_not_up_to_date_locked:
 		}
 
 readpage:
-<<<<<<< HEAD
-		if (iocb->ki_flags & IOCB_NOIO) {
-=======
 		if (iocb->ki_flags & (IOCB_NOWAIT |IOCB_NOIO)) {
->>>>>>> linux-next/akpm-base
 			unlock_page(page);
 			put_page(page);
 			goto would_block;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-close-race-between-munmap-and-expand_upwards-downwards-fix.patch
mm.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
linux-next-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

