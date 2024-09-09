Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D3E18E347
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925273; cv=none; b=RjcL1CdliAo6pm9MzR0Rf5Lp6NqXaOUGdHN8U+ZVSvTUTNpMZyxz9gvcNK6O0Gn7hSSV9497lhmxhl5I7z2QjRbidBEQbUXTQWsASOuKNqbDX5f85/ohf84crAjMcrQ4QPrt9I8GB8/fiFOKHZlLXogYn7rEmTk1Os0HwGfo4Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925273; c=relaxed/simple;
	bh=9+HkPJ39sRBEq4zpnV3HEr6+XyxmbeFFt208RF5cf8I=;
	h=Date:To:From:Subject:Message-Id; b=gCjbNB1medYySHmucnEBe3TsG29Pcaz4lAH8Zz3AIALPVjh/0rc/KXMrJQ6YCZ69re97vwVw0opzm+y+ub+zdJTh6Bkc2+nftdJq9JYmSaB7XKCAUNUgDWKI/M0Lk9EKoxi/1fagsemc74ZafDJ2tlWjL13k1dimxcSOVfraZj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fExhH9Ma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fExhH9Ma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BD5C4CEC5;
	Mon,  9 Sep 2024 23:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925272;
	bh=9+HkPJ39sRBEq4zpnV3HEr6+XyxmbeFFt208RF5cf8I=;
	h=Date:To:From:Subject:From;
	b=fExhH9MajWrlx9Lloz6SPYE0WT5Z3He5NTHujUQ03wodavhKZMf80xzI2OiLh4vKK
	 KC1WeFab84RGVkKD9OprUEqQI0McsT5/h9xFgfrWIUjKXJ0geQeZ11dtos5iIx9gu4
	 AyErzW/L3QheQ/vVDVfxmgaiXUbq62GbTDPKWH8o=
Date: Mon, 09 Sep 2024 16:41:12 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-check-that-backends-array-has-at-least-one-backend.patch removed from -mm tree
Message-Id: <20240909234112.C5BD5C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: check that backends array has at least one backend
has been removed from the -mm tree.  Its filename was
     zram-check-that-backends-array-has-at-least-one-backend.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: check that backends array has at least one backend
Date: Mon, 2 Sep 2024 19:56:00 +0900

Make sure that backends array has anything apart from the sentinel NULL
value.

We also select LZO_BACKEND if none backends were selected.

Link: https://lkml.kernel.org/r/20240902105656.1383858-13-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig |   19 +++++++++++++------
 drivers/block/zram/zcomp.c |    8 ++++++++
 2 files changed, 21 insertions(+), 6 deletions(-)

--- a/drivers/block/zram/Kconfig~zram-check-that-backends-array-has-at-least-one-backend
+++ a/drivers/block/zram/Kconfig
@@ -14,12 +14,6 @@ config ZRAM
 
 	  See Documentation/admin-guide/blockdev/zram.rst for more information.
 
-config ZRAM_BACKEND_LZO
-	bool "lzo and lzo-rle compression support"
-	depends on ZRAM
-	select LZO_COMPRESS
-	select LZO_DECOMPRESS
-
 config ZRAM_BACKEND_LZ4
 	bool "lz4 compression support"
 	depends on ZRAM
@@ -50,6 +44,19 @@ config ZRAM_BACKEND_842
 	select 842_COMPRESS
 	select 842_DECOMPRESS
 
+config ZRAM_BACKEND_FORCE_LZO
+	depends on ZRAM
+	def_bool !ZRAM_BACKEND_LZ4 && !ZRAM_BACKEND_LZ4HC && \
+		!ZRAM_BACKEND_ZSTD && !ZRAM_BACKEND_DEFLATE && \
+		!ZRAM_BACKEND_842
+
+config ZRAM_BACKEND_LZO
+	bool "lzo and lzo-rle compression support" if !ZRAM_BACKEND_FORCE_LZO
+	depends on ZRAM
+	default ZRAM_BACKEND_FORCE_LZO
+	select LZO_COMPRESS
+	select LZO_DECOMPRESS
+
 choice
 	prompt "Default zram compressor"
 	default ZRAM_DEF_COMP_LZORLE
--- a/drivers/block/zram/zcomp.c~zram-check-that-backends-array-has-at-least-one-backend
+++ a/drivers/block/zram/zcomp.c
@@ -192,6 +192,14 @@ struct zcomp *zcomp_create(const char *a
 	struct zcomp *comp;
 	int error;
 
+	/*
+	 * The backends array has a sentinel NULL value, so the minimum
+	 * size is 1. In order to be valid the array, apart from the
+	 * sentinel NULL element, should have at least one compression
+	 * backend selected.
+	 */
+	BUILD_BUG_ON(ARRAY_SIZE(backends) <= 1);
+
 	comp = kzalloc(sizeof(struct zcomp), GFP_KERNEL);
 	if (!comp)
 		return ERR_PTR(-ENOMEM);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-use-unique-zsmalloc-caches-names.patch

