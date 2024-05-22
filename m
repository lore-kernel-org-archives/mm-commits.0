Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0907CF25
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 22:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716417101; cv=none; b=QvcNz3m83VZxQ1ad9Uw7W5eZVa2WppR3mTs/nMo4wWosTVRTTuA6mWKwGaXCCTO2L3JuxL6PRM723RZDE0CaJhR78rYp7eXJSchIz5zR2YoDdCisg2AqCxqZwb1lDR1HyNhhimHv5BrQt9V25fd53JmhenJYEwSeSRAEr1h1zm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716417101; c=relaxed/simple;
	bh=bIkHSQmlqd47uuBC08r3mmEMflRWVwKJq0d0ZIPPf6U=;
	h=Date:To:From:Subject:Message-Id; b=qnc/CEfmc5baoCyJrjEKCPEI4fCUXn3hqQz1ES6ic4abYh5IANiDCACv1RKFFxblX8WXRzvWqdUw9Su7tyACMDx7tCDxrlXp1ARyOAXP9KPh9hXxJDs79+hMMIhzG/WlxmjDRnjMOR9X83WwKjkYCuLzBEMC+8itl8TOiGhAg6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z8t0lWCQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z8t0lWCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4A4C2BBFC;
	Wed, 22 May 2024 22:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716417101;
	bh=bIkHSQmlqd47uuBC08r3mmEMflRWVwKJq0d0ZIPPf6U=;
	h=Date:To:From:Subject:From;
	b=z8t0lWCQJGaqX8TohU7ZtzOkGVq4Rsl3bj+pHdlE/o+hT6vCO3jmsZly2zRIX1AON
	 9XxBEdUTxYX2fsNxgQiKpWhPv7Pq7juDqg5EOW9TrM395e/5p9TyoHdWK7vwo3463o
	 zW4qBAs39S2Iyk2csEyFwC616DHqfb8EmNwQ5Wr0=
Date: Wed, 22 May 2024 15:31:40 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-move-from-crypto-api-to-custom-comp-backends-api.patch added to mm-unstable branch
Message-Id: <20240522223141.2F4A4C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: move from crypto API to custom comp backends API
has been added to the -mm mm-unstable branch.  Its filename is
     zram-move-from-crypto-api-to-custom-comp-backends-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-move-from-crypto-api-to-custom-comp-backends-api.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: move from crypto API to custom comp backends API
Date: Wed, 15 May 2024 16:12:38 +0900

Patch series "zram: custom comp API and comp algorithms tunables", v4.

This patchset moves zram from crypto API to a custom compression API which
allows us to tune and configure compression algorithms, something that
crypto API, unfortunately, doesn't support yet.  Basically, this series
brings back the bits of compression "backends" code that we had many years
ago.

  Currently, zram supports a pretty decent number of comp backends: lzo,
  lzorle, lz4, lz4hc, 842, deflate, zstd

  At this point we handle 2 parameters: a compression level and a
  pre-trained compression dictionary.  Which seems like a good enough
  start.  The list will be extended in the future.

Examples:

- tunes compression level
	echo "algo=zstd level=11" > /sys/block/zram0/comp_algorithm

- uses a pre-trained dictionary and tunes compression level
	echo "algo=zstd level=11 dict=/etc/dictionary" > /sys/block/zram0/comp_algorithm

Benchmarks
==========

*** zstd
/sys/block/zram0/mm_stat
1750302720 504600204 514416640        0 514416640        1        0    34204    34204

*** zstd level=5
/sys/block/zram0/mm_stat
1750331392 488449001 497905664        0 497905664        1        0    34204    34204

*** zstd dict=/etc/dictionary
/sys/block/zram0/mm_stat
1750335488 464838883 474210304        0 474210304        1        0    34204    34204

*** zstd level=5 dict=/etc/dictionary
/sys/block/zram0/mm_stat
1750319104 451907185 461299712        0 461299712        1        0    34204    34204

*** lz4
/sys/block/zram0/mm_stat
1750319104 664253635 676859904        0 676859904        1        0    34288    34288

*** lz4 dict=/etc/dictionary
/sys/block/zram0/mm_stat
1750319104 620602911 632705024        0 632705024        1        0    34288    34288

*** lz4hc
/sys/block/zram0/mm_stat
1750315008 609004936 621092864        0 621092864        1        0    34288    34288

*** lz4hc level=5 dict=/etc/dictionary
/sys/block/zram0/mm_stat
1750323200 501315128 511303680        0 511303680        1        0    34288    34288


This patch (of 21):

Crypto API is beautiful and powerful, however, being a generic API, it
lacks support for fine-grained per-algorithm configuration.  A number of
compression algorithms provide various knobs to tune characteristics for
particular data patterns.  The simplest case is "compression level".  A
more complicated and interesting case is user-space trained dictionaries
(e.g.  lz4 and zstd).

Moving to custom backends implementation gives us ability to have our own
minimalistic and extendable API, and algorithms tunings becomes possible.

The list of compression backends is empty at this point, we will add
backends in the followup patches.

Link: https://lkml.kernel.org/r/20240515071645.1788128-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20240515071645.1788128-2-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig    |   39 ---------
 drivers/block/zram/zcomp.c    |  127 +++++++++++---------------------
 drivers/block/zram/zcomp.h    |   26 ++++--
 drivers/block/zram/zram_drv.c |    9 +-
 4 files changed, 73 insertions(+), 128 deletions(-)

--- a/drivers/block/zram/Kconfig~zram-move-from-crypto-api-to-custom-comp-backends-api
+++ a/drivers/block/zram/Kconfig
@@ -2,7 +2,6 @@
 config ZRAM
 	tristate "Compressed RAM block device support"
 	depends on BLOCK && SYSFS && MMU
-	depends on CRYPTO_LZO || CRYPTO_ZSTD || CRYPTO_LZ4 || CRYPTO_LZ4HC || CRYPTO_842
 	select ZSMALLOC
 	help
 	  Creates virtual block devices called /dev/zramX (X = 0, 1, ...).
@@ -15,45 +14,9 @@ config ZRAM
 
 	  See Documentation/admin-guide/blockdev/zram.rst for more information.
 
-choice
-	prompt "Default zram compressor"
-	default ZRAM_DEF_COMP_LZORLE
-	depends on ZRAM
-
-config ZRAM_DEF_COMP_LZORLE
-	bool "lzo-rle"
-	depends on CRYPTO_LZO
-
-config ZRAM_DEF_COMP_ZSTD
-	bool "zstd"
-	depends on CRYPTO_ZSTD
-
-config ZRAM_DEF_COMP_LZ4
-	bool "lz4"
-	depends on CRYPTO_LZ4
-
-config ZRAM_DEF_COMP_LZO
-	bool "lzo"
-	depends on CRYPTO_LZO
-
-config ZRAM_DEF_COMP_LZ4HC
-	bool "lz4hc"
-	depends on CRYPTO_LZ4HC
-
-config ZRAM_DEF_COMP_842
-	bool "842"
-	depends on CRYPTO_842
-
-endchoice
-
 config ZRAM_DEF_COMP
 	string
-	default "lzo-rle" if ZRAM_DEF_COMP_LZORLE
-	default "zstd" if ZRAM_DEF_COMP_ZSTD
-	default "lz4" if ZRAM_DEF_COMP_LZ4
-	default "lzo" if ZRAM_DEF_COMP_LZO
-	default "lz4hc" if ZRAM_DEF_COMP_LZ4HC
-	default "842" if ZRAM_DEF_COMP_842
+	default "unset-value"
 
 config ZRAM_WRITEBACK
        bool "Write back incompressible or idle page to backing device"
--- a/drivers/block/zram/zcomp.c~zram-move-from-crypto-api-to-custom-comp-backends-api
+++ a/drivers/block/zram/zcomp.c
@@ -15,31 +15,16 @@
 
 #include "zcomp.h"
 
-static const char * const backends[] = {
-#if IS_ENABLED(CONFIG_CRYPTO_LZO)
-	"lzo",
-	"lzo-rle",
-#endif
-#if IS_ENABLED(CONFIG_CRYPTO_LZ4)
-	"lz4",
-#endif
-#if IS_ENABLED(CONFIG_CRYPTO_LZ4HC)
-	"lz4hc",
-#endif
-#if IS_ENABLED(CONFIG_CRYPTO_842)
-	"842",
-#endif
-#if IS_ENABLED(CONFIG_CRYPTO_ZSTD)
-	"zstd",
-#endif
+static struct zcomp_backend *backends[] = {
+	NULL
 };
 
-static void zcomp_strm_free(struct zcomp_strm *zstrm)
+static void zcomp_strm_free(struct zcomp *comp, struct zcomp_strm *zstrm)
 {
-	if (!IS_ERR_OR_NULL(zstrm->tfm))
-		crypto_free_comp(zstrm->tfm);
+	if (zstrm->ctx)
+		comp->backend->destroy_ctx(zstrm->ctx);
 	vfree(zstrm->buffer);
-	zstrm->tfm = NULL;
+	zstrm->ctx = NULL;
 	zstrm->buffer = NULL;
 }
 
@@ -47,60 +32,55 @@ static void zcomp_strm_free(struct zcomp
  * Initialize zcomp_strm structure with ->tfm initialized by backend, and
  * ->buffer. Return a negative value on error.
  */
-static int zcomp_strm_init(struct zcomp_strm *zstrm, struct zcomp *comp)
+static int zcomp_strm_init(struct zcomp *comp, struct zcomp_strm *zstrm)
 {
-	zstrm->tfm = crypto_alloc_comp(comp->name, 0, 0);
+	zstrm->ctx = comp->backend->create_ctx();
+
 	/*
 	 * allocate 2 pages. 1 for compressed data, plus 1 extra for the
 	 * case when compressed size is larger than the original one
 	 */
 	zstrm->buffer = vzalloc(2 * PAGE_SIZE);
-	if (IS_ERR_OR_NULL(zstrm->tfm) || !zstrm->buffer) {
-		zcomp_strm_free(zstrm);
+	if (!zstrm->ctx || !zstrm->buffer) {
+		zcomp_strm_free(comp, zstrm);
 		return -ENOMEM;
 	}
 	return 0;
 }
 
+static struct zcomp_backend *lookup_backend(const char *comp)
+{
+	int i = 0;
+
+	while (backends[i]) {
+		if (sysfs_streq(comp, backends[i]->name))
+			break;
+		i++;
+	}
+	return backends[i];
+}
+
 bool zcomp_available_algorithm(const char *comp)
 {
-	/*
-	 * Crypto does not ignore a trailing new line symbol,
-	 * so make sure you don't supply a string containing
-	 * one.
-	 * This also means that we permit zcomp initialisation
-	 * with any compressing algorithm known to crypto api.
-	 */
-	return crypto_has_comp(comp, 0, 0) == 1;
+	return lookup_backend(comp) != NULL;
 }
 
 /* show available compressors */
 ssize_t zcomp_available_show(const char *comp, char *buf)
 {
-	bool known_algorithm = false;
 	ssize_t sz = 0;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(backends); i++) {
-		if (!strcmp(comp, backends[i])) {
-			known_algorithm = true;
+	for (i = 0; i < ARRAY_SIZE(backends) - 1; i++) {
+		if (!strcmp(comp, backends[i]->name)) {
 			sz += scnprintf(buf + sz, PAGE_SIZE - sz - 2,
-					"[%s] ", backends[i]);
+					"[%s] ", backends[i]->name);
 		} else {
 			sz += scnprintf(buf + sz, PAGE_SIZE - sz - 2,
-					"%s ", backends[i]);
+					"%s ", backends[i]->name);
 		}
 	}
 
-	/*
-	 * Out-of-tree module known to crypto api or a missing
-	 * entry in `backends'.
-	 */
-	if (!known_algorithm && crypto_has_comp(comp, 0, 0) == 1)
-		sz += scnprintf(buf + sz, PAGE_SIZE - sz - 2,
-				"[%s] ", comp);
-
-	sz += scnprintf(buf + sz, PAGE_SIZE - sz, "\n");
 	return sz;
 }
 
@@ -115,8 +95,8 @@ void zcomp_stream_put(struct zcomp *comp
 	local_unlock(&comp->stream->lock);
 }
 
-int zcomp_compress(struct zcomp_strm *zstrm,
-		const void *src, unsigned int *dst_len)
+int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
+		   const void *src, unsigned int *dst_len)
 {
 	/*
 	 * Our dst memory (zstrm->buffer) is always `2 * PAGE_SIZE' sized
@@ -132,21 +112,19 @@ int zcomp_compress(struct zcomp_strm *zs
 	 * the dst buffer, zram_drv will take care of the fact that
 	 * compressed buffer is too big.
 	 */
-	*dst_len = PAGE_SIZE * 2;
+	size_t dlen = PAGE_SIZE * 2;
+	int ret;
 
-	return crypto_comp_compress(zstrm->tfm,
-			src, PAGE_SIZE,
-			zstrm->buffer, dst_len);
+	ret = comp->backend->compress(zstrm->ctx, src, zstrm->buffer, &dlen);
+	if (!ret)
+		*dst_len = dlen;
+	return ret;
 }
 
-int zcomp_decompress(struct zcomp_strm *zstrm,
-		const void *src, unsigned int src_len, void *dst)
+int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
+		     const void *src, unsigned int src_len, void *dst)
 {
-	unsigned int dst_len = PAGE_SIZE;
-
-	return crypto_comp_decompress(zstrm->tfm,
-			src, src_len,
-			dst, &dst_len);
+	return comp->backend->decompress(zstrm->ctx, src, src_len, dst);
 }
 
 int zcomp_cpu_up_prepare(unsigned int cpu, struct hlist_node *node)
@@ -158,7 +136,7 @@ int zcomp_cpu_up_prepare(unsigned int cp
 	zstrm = per_cpu_ptr(comp->stream, cpu);
 	local_lock_init(&zstrm->lock);
 
-	ret = zcomp_strm_init(zstrm, comp);
+	ret = zcomp_strm_init(comp, zstrm);
 	if (ret)
 		pr_err("Can't allocate a compression stream\n");
 	return ret;
@@ -170,7 +148,7 @@ int zcomp_cpu_dead(unsigned int cpu, str
 	struct zcomp_strm *zstrm;
 
 	zstrm = per_cpu_ptr(comp->stream, cpu);
-	zcomp_strm_free(zstrm);
+	zcomp_strm_free(comp, zstrm);
 	return 0;
 }
 
@@ -199,32 +177,21 @@ void zcomp_destroy(struct zcomp *comp)
 	kfree(comp);
 }
 
-/*
- * search available compressors for requested algorithm.
- * allocate new zcomp and initialize it. return compressing
- * backend pointer or ERR_PTR if things went bad. ERR_PTR(-EINVAL)
- * if requested algorithm is not supported, ERR_PTR(-ENOMEM) in
- * case of allocation error, or any other error potentially
- * returned by zcomp_init().
- */
 struct zcomp *zcomp_create(const char *alg)
 {
 	struct zcomp *comp;
 	int error;
 
-	/*
-	 * Crypto API will execute /sbin/modprobe if the compression module
-	 * is not loaded yet. We must do it here, otherwise we are about to
-	 * call /sbin/modprobe under CPU hot-plug lock.
-	 */
-	if (!zcomp_available_algorithm(alg))
-		return ERR_PTR(-EINVAL);
-
 	comp = kzalloc(sizeof(struct zcomp), GFP_KERNEL);
 	if (!comp)
 		return ERR_PTR(-ENOMEM);
 
-	comp->name = alg;
+	comp->backend = lookup_backend(alg);
+	if (!comp->backend) {
+		kfree(comp);
+		return ERR_PTR(-EINVAL);
+	}
+
 	error = zcomp_init(comp);
 	if (error) {
 		kfree(comp);
--- a/drivers/block/zram/zcomp.h~zram-move-from-crypto-api-to-custom-comp-backends-api
+++ a/drivers/block/zram/zcomp.h
@@ -12,13 +12,26 @@ struct zcomp_strm {
 	local_lock_t lock;
 	/* compression/decompression buffer */
 	void *buffer;
-	struct crypto_comp *tfm;
+	void *ctx;
+};
+
+struct zcomp_backend {
+	int (*compress)(void *ctx, const unsigned char *src,
+			unsigned char *dst, size_t *dst_len);
+
+	int (*decompress)(void *ctx, const unsigned char *src, size_t src_len,
+			  unsigned char *dst);
+
+	void *(*create_ctx)(void);
+	void (*destroy_ctx)(void *ctx);
+
+	const char *name;
 };
 
 /* dynamic per-device compression frontend */
 struct zcomp {
 	struct zcomp_strm __percpu *stream;
-	const char *name;
+	struct zcomp_backend *backend;
 	struct hlist_node node;
 };
 
@@ -33,10 +46,9 @@ void zcomp_destroy(struct zcomp *comp);
 struct zcomp_strm *zcomp_stream_get(struct zcomp *comp);
 void zcomp_stream_put(struct zcomp *comp);
 
-int zcomp_compress(struct zcomp_strm *zstrm,
-		const void *src, unsigned int *dst_len);
-
-int zcomp_decompress(struct zcomp_strm *zstrm,
-		const void *src, unsigned int src_len, void *dst);
+int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
+		   const void *src, unsigned int *dst_len);
+int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
+		     const void *src, unsigned int src_len, void *dst);
 
 #endif /* _ZCOMP_H_ */
--- a/drivers/block/zram/zram_drv.c~zram-move-from-crypto-api-to-custom-comp-backends-api
+++ a/drivers/block/zram/zram_drv.c
@@ -1327,7 +1327,8 @@ static int zram_read_from_zspool(struct
 		ret = 0;
 	} else {
 		dst = kmap_local_page(page);
-		ret = zcomp_decompress(zstrm, src, size, dst);
+		ret = zcomp_decompress(zram->comps[prio], zstrm,
+				       src, size, dst);
 		kunmap_local(dst);
 		zcomp_stream_put(zram->comps[prio]);
 	}
@@ -1414,7 +1415,8 @@ static int zram_write_page(struct zram *
 compress_again:
 	zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
 	src = kmap_local_page(page);
-	ret = zcomp_compress(zstrm, src, &comp_len);
+	ret = zcomp_compress(zram->comps[ZRAM_PRIMARY_COMP], zstrm,
+			     src, &comp_len);
 	kunmap_local(src);
 
 	if (unlikely(ret)) {
@@ -1601,7 +1603,8 @@ static int zram_recompress(struct zram *
 		num_recomps++;
 		zstrm = zcomp_stream_get(zram->comps[prio]);
 		src = kmap_local_page(page);
-		ret = zcomp_compress(zstrm, src, &comp_len_new);
+		ret = zcomp_compress(zram->comps[prio], zstrm,
+				     src, &comp_len_new);
 		kunmap_local(src);
 
 		if (ret) {
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-move-from-crypto-api-to-custom-comp-backends-api.patch
zram-add-lzo-and-lzorle-compression-backends-support.patch
zram-add-lz4-compression-backend-support.patch
zram-add-lz4hc-compression-backend-support.patch
zram-add-zstd-compression-backend-support.patch
zram-pass-estimated-src-size-hint-to-zstd.patch
zram-add-zlib-compression-backend-support.patch
zram-add-842-compression-backend-support.patch
zram-check-that-backends-array-has-at-least-one-backend.patch
zram-introduce-zcomp_config-structure.patch
zram-extend-comp_algorithm-attr-write-handling.patch
zram-support-compression-level-comp-config.patch
zram-add-support-for-dict-comp-config.patch
lib-zstd-export-api-needed-for-dictionary-support.patch
zram-add-dictionary-support-to-zstd-backend.patch
zram-add-config-init-release-backend-callbacks.patch
zram-share-dictionaries-between-per-cpu-contexts.patch
zram-add-dictionary-support-to-lz4.patch
lib-lz4hc-export-lz4_resetstreamhc-symbol.patch
zram-add-dictionary-support-to-lz4hc.patch
documentation-zram-add-documentation-for-algorithm-parameters.patch

