Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793329352;
	b=CwRuhWsL1276dTpIHUVqOV7gdnabL/txhLJvSvasDhpdJH5tEJIR3hK2+w/s/aV7aLdw
	 ms+eptstKNF3UWHnO48ZlNMQQ/ICyYOSNG3aQBRoyO8qwfmvrGuAh8OeP8vRg8VTloVN/
	 NUSv4KX6B9DogZdvGcdC5U9q/WCkt3qpc+LCRergSruTtpTN7bekS1NpAlg6Df1SJ0brv
	 sZcc/WcIWTjw0mjycUdLBo1GHsVtN6wWy0XJ2YdRKpg1bF4J52riPcAVlyRO//mhfv0ON
	 /ItPruVu9fAaFtWbRTNNb8lgHddWZ8PjKe6B4E2Wi16/uHb0Iw10ebNPurBTgMUoYzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793329352;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=+oeKKUp0iscolM+jrB9UEvEfVq514pIzo2BJoQClWKI=;
	b=kpmYeo4Hzuwuhp6x0g/Rl1Y5J05EMnLpPe7vRodI/Wa+mpeHN/+eKoxY43SQbJ/xfmo4
	 uOUzfMc5eBOu1chw2wP4LeX6blQr+vgGyG7dxtTaaXdwFbfFtCLieWc7QpsuwArd2PZkx
	 U7Iz4WQ/N70WIYbPtXpX0Bmpn79uIiiZFq6noAusDwHNH7TvY6cIbGsSA78D6HdA7N66X
	 kstuh14x/2/1BaBr9sNltAC1VNDga8Y1X/xm5PTRInSM75/8PmmOmIn7rQpT1AQsXIa7q
	 +M/iBLQ0TpwmNcSi9DHKeXrGUiU2i7jb12nRbeQrwnkPkHW2el9FaPjkKCkY8nSzKng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OgdOcte3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA76606A31F
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 03:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OgdOcte3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC021F000C1;
	Fri, 30 Oct 2026 03:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793329351;
	bh=+oeKKUp0iscolM+jrB9UEvEfVq514pIzo2BJoQClWKI=;
	h=Date:To:From:Subject;
	b=OgdOcte3u3V0riTg8JQC6blSuWUZb/Sowg2iY2tp7oG6Q5dIQNDqtAYKBry2mKsKr
	 kGSgF5JzbfI9vG14eB7pDuFrRMdhxsK7B4dACsov+Pmn6G+D6G6pwL/oUqJgVhe6tl
	 KueEQdGh3kSiozzdPta/Ir6jPZT73NEXw9ZacnyQ=
Date: Thu, 29 Oct 2026 20:02:31 -0700
To: mm-commits@vger.kernel.org,zhangbo56@xiaomi.com,zhangbo0325@gmail.com,
	richardycc@google.com,minchan@kernel.org,hdanton@sina.com,bgeffon@google.com,
	baohua@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-lz4hc-pre-initialize-dictionary-stream-in-setup_params.patch added to mm-nonmm-unstable branch
Message-Id: <20261030030231.6DC021F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zram: lz4hc: pre-initialize dictionary stream in setup_params
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     zram-lz4hc-pre-initialize-dictionary-stream-in-setup_params.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-lz4hc-pre-initialize-dictionary-stream-in-setup_params.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: zram: lz4hc: pre-initialize dictionary stream in setup_params
Date: Sun, 25 Oct 2026 11:18:23 +0900

Pre-initialize the dictionary stream once in lz4hc_setup_params(), store
it in params->drv_data, and memcpy() it into the per-CPU stream before
LZ4_compress_HC_continue(), matching backend_lz4.  This avoids resetting
and hashing the dictionary on every page compression.

This also rejects dictionaries larger than 64 KB at device init time
(matching backend_lz4), instead of failing every page compression with
-EINVAL.

Link: https://lore.kernel.org/20261025021839.1542805-8-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Bo Zhang <zhangbo0325@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Cc: Bo Zhang <zhangbo56@xiaomi.com>
Cc: Hillf Danton <hdanton@sina.com>
---

 drivers/block/zram/backend_lz4hc.c |   31 ++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

--- a/drivers/block/zram/backend_lz4hc.c~zram-lz4hc-pre-initialize-dictionary-stream-in-setup_params
+++ a/drivers/block/zram/backend_lz4hc.c
@@ -18,10 +18,20 @@ struct lz4hc_ctx {
 
 static void lz4hc_release_params(struct zcomp_params *params)
 {
+	LZ4_streamHC_t *dict_stream = params->drv_data;
+
+	params->drv_data = NULL;
+	if (!dict_stream)
+		return;
+
+	vfree(dict_stream);
 }
 
 static int lz4hc_setup_params(struct zcomp_params *params)
 {
+	LZ4_streamHC_t *dict_stream;
+	int ret;
+
 	if (params->level == ZCOMP_PARAM_NOT_SET) {
 		params->level = LZ4HC_DEFAULT_CLEVEL;
 	} else if (params->level < 1 || params->level > LZ4HC_MAX_CLEVEL) {
@@ -35,6 +45,21 @@ static int lz4hc_setup_params(struct zco
 		return -EINVAL;
 	}
 
+	if (!params->dict || !params->dict_sz)
+		return 0;
+
+	dict_stream = vzalloc(sizeof(*dict_stream));
+	if (!dict_stream)
+		return -ENOMEM;
+
+	LZ4_resetStreamHC(dict_stream, params->level);
+	ret = LZ4_loadDictHC(dict_stream, params->dict, params->dict_sz);
+	if (ret != params->dict_sz) {
+		vfree(dict_stream);
+		return -EINVAL;
+	}
+	params->drv_data = dict_stream;
+
 	return 0;
 }
 
@@ -93,11 +118,7 @@ static int lz4hc_compress(struct zcomp_p
 				      zctx->mem);
 	} else {
 		/* Cstrm needs to be reset */
-		LZ4_resetStreamHC(zctx->cstrm, params->level);
-		ret = LZ4_loadDictHC(zctx->cstrm, params->dict,
-				     params->dict_sz);
-		if (ret != params->dict_sz)
-			return -EINVAL;
+		memcpy(zctx->cstrm, params->drv_data, sizeof(*zctx->cstrm));
 		ret = LZ4_compress_HC_continue(zctx->cstrm, req->src, req->dst,
 					       req->src_len, req->dst_len);
 	}
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

