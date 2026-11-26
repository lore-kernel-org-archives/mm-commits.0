Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795674863;
	b=2a0jBDjRuStcEiC3NlvwHOnOVAI7HM6rxknz9Y7RWvYHKS7LgA385J6jehuMewc1Br5o
	 RO8yPZO9ehtte8RBGdxxc8dFVwhCvDKUrxcNveiKwacqjiLfZvfLgAyMTZranrLQQ0njk
	 yINHQHgsJ/zMimEld2kaFNCDwECZe9wm2cQhx5kQrRucht7ysLqVn1cdNZizxYNJF7mXG
	 UbVlxPoo5GC6xxQ5fE8uLew6d4VtoLnYna/nG3cFjVzlWd9I0Zt5QOX703AhzQzwGfR6b
	 zYDshAH26v26D8KkrVpOQs7PPf07qosI0/lsIq+cR79NyZDAwt0+Nt5OkPwD4lTj8Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795674863;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=ldKOf2KCu2DytPe6506lKabWdpkSZ2fbL5F/m2JN6/A=;
	b=Ch5p77PnzN3aHoDX54hTA/4O1jV5YMCnaBx/NYOInS68fAl6oguLTWZvQN8CzCF6ZmZk
	 vqY1JIFBJ8vTxwpNFNdb30i7Sd7woCWiodA8vluDXdBN+JKPT3x6IInvWWmEEbsKv1JwH
	 I7DzRVZqqB04/tiI1MKu8VA1ekgLFW1ebNfb3JCe3VhmYYRqDo9aGMTTZtfiqyz2WmHTu
	 DuR4HduEOFqSxU5D4Oo/yv+w93qzpWP7ETJoTE4LsdcSPpsXeeyAcrCmHcY0N67+rR8gX
	 vLjOevNcJwMQR62V9Zvmhi0nj4wHqbwA5MjAIF3+YmnmkbjdD5+yQP6rWxHV4PdkDeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=v37i29Si;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85FF606A31E
	for <mm-commits@vger.kernel.org>; Thu, 26 Nov 2026 06:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=v37i29Si
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850791F000CF;
	Thu, 26 Nov 2026 06:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795674861;
	bh=ldKOf2KCu2DytPe6506lKabWdpkSZ2fbL5F/m2JN6/A=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=v37i29SiVPpAJm40ZjjcCro35+2M5uI9OzK4XMeOlyQzcUgmw8zd/kSJaVOyc+C1i
	 kwwgajnvrjv9JeT+OGJOq5w9EsvEsSPEgwrqKdxS4c0QTSjnUXEkeCnLRcf39pNB5B
	 QMZFDZ9/wNtrjpUmTnfh82YrzPwjCfUtc9DXreic=
Date: Wed, 25 Nov 2026 22:34:20 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,alx@kernel.org,
	senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261126014518.1318583-1-senozhatsky@chromium.org>
References: <20261126014518.1318583-1-senozhatsky@chromium.org>
Subject: + zram-do-not-modify-cont-sysfs-store-buffers.patch added to mm-new branch
Message-Id: <20261126063421.850791F000CF@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zram: do not modify cont sysfs store buffers
has been added to the -mm mm-new branch.  Its filename is
     zram-do-not-modify-cont-sysfs-store-buffers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-do-not-modify-cont-sysfs-store-buffers.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: do not modify cont sysfs store buffers
Date: Thu, 26 Nov 2026 10:45:07 +0900

zram sysfs handlers that accept key=value arguments (e.g. 
algorithm_params_store(), etc.) pass their const char *buf parameter
through skip_spaces(), discarding const, and then mutate it in-place via
next_arg().  This is not dangerous per se because kernfs_fop_write_iter()
passes a temp copy of user string to zram, however it is still probably
worth fixing, just for the sake of correctness.

Allocate a temp non-const buffer for args tokenisation.

Link: https://patch.msgid.link/20261126014518.1318583-1-senozhatsky@chromium.org
Link: https://lore.kernel.org/all/awcpkJD6K1xtx_Pe@devuan/
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Alejandro Colomar <alx@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>

 drivers/block/zram/zram_drv.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-do-not-modify-cont-sysfs-store-buffers
+++ a/drivers/block/zram/zram_drv.c
@@ -1247,10 +1247,15 @@ static ssize_t writeback_store(struct de
 	unsigned long lo = 0, hi;
 	struct zram_pp_ctl *pp_ctl = NULL;
 	struct zram_wb_ctl *wb_ctl = NULL;
+	char *kbuf __free(kfree) = NULL;
 	char *args, *param, *val;
 	ssize_t ret = len;
 	int err, mode = 0;
 
+	kbuf = kstrndup(buf, len, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
 	guard(rwsem_write)(&zram->dev_lock);
 	if (!init_done(zram))
 		return -EINVAL;
@@ -1271,7 +1276,7 @@ static ssize_t writeback_store(struct de
 		goto out;
 	}
 
-	args = skip_spaces(buf);
+	args = skip_spaces(kbuf);
 	while (*args) {
 		args = next_arg(args, &param, &val);
 
@@ -1747,12 +1752,17 @@ static ssize_t algorithm_params_store(st
 	char *args, *param, *val, *algo = NULL, *dict_path = NULL;
 	struct deflate_params deflate_params;
 	struct zram *zram = dev_to_zram(dev);
+	char *kbuf __free(kfree) = NULL;
 	bool prio_param = false;
 	int ret;
 
 	deflate_params.winbits = ZCOMP_PARAM_NOT_SET;
 
-	args = skip_spaces(buf);
+	kbuf = kstrndup(buf, len, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
+	args = skip_spaces(kbuf);
 	while (*args) {
 		args = next_arg(args, &param, &val);
 
@@ -1867,12 +1877,17 @@ static ssize_t recomp_algorithm_store(st
 				      size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
+	char *kbuf __free(kfree) = NULL;
 	int prio = ZRAM_SECONDARY_COMP;
 	char *args, *param, *val;
 	char *alg = NULL;
 	int ret;
 
-	args = skip_spaces(buf);
+	kbuf = kstrndup(buf, len, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
+	args = skip_spaces(kbuf);
 	while (*args) {
 		args = next_arg(args, &param, &val);
 
@@ -2560,6 +2575,7 @@ static ssize_t recompress_store(struct d
 	struct zram *zram = dev_to_zram(dev);
 	char *args, *param, *val, *algo = NULL;
 	u64 num_recomp_pages = ULLONG_MAX;
+	char *kbuf __free(kfree) = NULL;
 	struct zram_pp_ctl *ctl = NULL;
 	s32 prio = ZRAM_SECONDARY_COMP;
 	u32 mode = 0, threshold = 0;
@@ -2568,7 +2584,11 @@ static ssize_t recompress_store(struct d
 	bool prio_param = false;
 	ssize_t ret;
 
-	args = skip_spaces(buf);
+	kbuf = kstrndup(buf, len, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
+	args = skip_spaces(kbuf);
 	while (*args) {
 		args = next_arg(args, &param, &val);
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-prefix-backends-printk-s.patch
zram-remove-debugfs-entry-on-init-failure.patch
zram-reset-writeback-state-in-zram_reset_device.patch
zram-move-mark_slot_accessed-under-existing-slot-lock-sections.patch
zram-remove-stale-warn_on-from-zram_read_page.patch
zram-zstd-do-not-allocate-empty-c-d-dictionaries.patch
zram-lz4hc-pre-initialize-dictionary-stream-in-setup_params.patch
zram-lz4-use-lz4_decompress_safe_usingdict.patch
zram-lz4hc-use-lz4_decompress_safe_usingdict.patch
zram-zstd-do-not-use-kvzalloc-for-zstd-allocations.patch
zram-split-zcomp-into-separate-r-w-streams.patch
zram-introduce-shared-decompression-streams.patch
zram-allocate-bounce-buffer-for-spanning-objects.patch
zram-borrow-idle-decompression-streams-in-exclusive-mode.patch
zram-use-a-singleton-compression-context-for-recompression.patch
zram-drop-stale-comment-in-write_incompressible_page.patch
zram-drop-get_slot_handle-and-set_slot_handle.patch
zsmalloc-return-handle-from-obj_allocated.patch
zsmalloc-switch-handle-type-to-struct-zs_handle.patch
zram-check-mem_limit-before-allocating-zsmalloc-object.patch
zram-allocate-zsmalloc-object-under-slot-lock.patch
zswap-do-not-free-the-entry-if-its-pool-is-null.patch
zsmalloc-encode-1-based-obj_idx-so-valid-obj-is-never-0.patch
zsmalloc-embed-struct-zs_handle-into-zram-and-zswap-entries.patch
zsmalloc-fold-zs_obj_write-into-zs_store.patch
zsmalloc-populate-new-zspage-outside-class-lock-in-zs_store.patch
zram-fix-quadratic-writeback-bitmap-search.patch
zsmalloc-free-a-zspages-pages-in-one-batch.patch
zram-keep-the-hot-statistics-per-cpu.patch
zram-do-not-modify-cont-sysfs-store-buffers.patch
zsmalloc-fix-spdx-license-identifier.patch
zram-use-spdx-license-identifier.patch

