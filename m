Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F80185946
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 21:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725311911; cv=none; b=KKP2B93HiNTz40NsSKmMAPRbbgSCV/l517YUdvbdCkbHxjemW4/e0iY8nvuMakHnLJ2oh7VNfUozvAsWv/64c13nu2N1S/ItFOoKRdEelLc/dLkr3fEOiHcNDAbeiLl+WQO/HDU0z71iHXEHHhFEVAnKEBIsPGMVYIttZm6yPhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725311911; c=relaxed/simple;
	bh=kPAw/KytnoZweeO17XtbypB5feMsOapcJlrNM2zb1Fw=;
	h=Date:To:From:Subject:Message-Id; b=hH/MyXSmcvrgDcbqK4nyXioNVUjBRKy6+lGuEsfa1a68SAO6used0nYOMCXls6dbqW0D2WETMor1TCIMidi+88Jcd2RbOuCRLflaQftYUNuW/iZsAsN3+fu3pFov4umgrobuwMSzAO8k4jJay9bCOr1iwxHHqcszJw3J6+RdmMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bLNki9F1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bLNki9F1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEAFFC4CEC2;
	Mon,  2 Sep 2024 21:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725311911;
	bh=kPAw/KytnoZweeO17XtbypB5feMsOapcJlrNM2zb1Fw=;
	h=Date:To:From:Subject:From;
	b=bLNki9F1SlXcKPYuhrlhdZKpI5YKlWsx9KHZiy/akh9LC4Ec1yDsm8AAgPDGo5jXl
	 oVZ1FuPHrhSdwtr8fIUQFDm4BzWfhhDKJav9lCqW/p9BLt5CG4/zWLVn7usoXMWkNh
	 HYTuEyXpEdIO4QXZwhOFQCCIDZDAUMyobpYlVDqU=
Date: Mon, 02 Sep 2024 14:18:30 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-check-that-backends-array-has-at-least-one-backend.patch added to mm-unstable branch
Message-Id: <20240902211830.DEAFFC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: check that backends array has at least one backend
has been added to the -mm mm-unstable branch.  Its filename is
     zram-check-that-backends-array-has-at-least-one-backend.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-check-that-backends-array-has-at-least-one-backend.patch

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

lib-zstd-export-api-needed-for-dictionary-support.patch
lib-lz4hc-export-lz4_resetstreamhc-symbol.patch
lib-zstd-fix-null-deref-in-zstd_createcdict_advanced2.patch
zram-introduce-custom-comp-backends-api.patch
zram-add-lzo-and-lzorle-compression-backends-support.patch
zram-add-lz4-compression-backend-support.patch
zram-add-lz4hc-compression-backend-support.patch
zram-add-zstd-compression-backend-support.patch
zram-pass-estimated-src-size-hint-to-zstd.patch
zram-add-zlib-compression-backend-support.patch
zram-add-842-compression-backend-support.patch
zram-check-that-backends-array-has-at-least-one-backend.patch
zram-introduce-zcomp_params-structure.patch
zram-recalculate-zstd-compression-params-once.patch
zram-introduce-algorithm_params-device-attribute.patch
zram-add-support-for-dict-comp-config.patch
zram-introduce-zcomp_req-structure.patch
zram-introduce-zcomp_ctx-structure.patch
zram-move-immutable-comp-params-away-from-per-cpu-context.patch
zram-add-dictionary-support-to-lz4.patch
zram-add-dictionary-support-to-lz4hc.patch
zram-add-dictionary-support-to-zstd-backend.patch
documentation-zram-add-documentation-for-algorithm-parameters.patch
zram-support-priority-parameter-in-recompression.patch

