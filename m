Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91443613D
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 19:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721849236; cv=none; b=sWr8B6B8HmlZXvpAqS7BN5wIkfW+ydXnjD6TpMgoIdjz/L1RYAabBikh155422gwCfdK1ThqxRitrD4LEvKLnfT/dYowZzZ0jV+87J0qe5a+STJRQs4EFhWBcmmUk4qJJzkkz5f5T4fmTVDySGEhTx8mBLKcf3gyeddUMEEEA/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721849236; c=relaxed/simple;
	bh=vcsMyaL/J5TC6qyjVr29cWtArdPtJr3aeW1ZE4q5y6o=;
	h=Date:To:From:Subject:Message-Id; b=tlIJIrVpR2bkStn3PVxFOF/KsBWY5bmVWd/n3DQSWpWMg6HFhuirOyPgNuME0QMmK4XhpX91+YlNRrOTpY+cWrX0Sg/mxVI6gjLwj3suQcbwlhWDgP5TC5GmmdcUh19pAY+yylDdX5A5V2EW+vbadUQx9X0+Jw6JuulsScFt2pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FrcRLtrU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FrcRLtrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657C5C32781;
	Wed, 24 Jul 2024 19:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721849236;
	bh=vcsMyaL/J5TC6qyjVr29cWtArdPtJr3aeW1ZE4q5y6o=;
	h=Date:To:From:Subject:From;
	b=FrcRLtrUX7x0dYgiUaFLCi7ZYGEg1gY8SpavkKzp8J1rROJ3s3DbE5JPI2/FbgNPc
	 KRYag+mmZ1FVeLg0V3tfli9FlNAmUIqtek/fUmso/RqtD9HtD4o8oGH1aA6CTXE2EX
	 Xz/YTT4AfmtX8tGx4NIjtzOFeEf5fTyfgV82Vlv8=
Date: Wed, 24 Jul 2024 12:27:15 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,nphamcs@gmail.com,ngupta@vflare.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-zram-add-documentation-for-algorithm-parameters.patch added to mm-unstable branch
Message-Id: <20240724192716.657C5C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation/zram: add documentation for algorithm parameters
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-zram-add-documentation-for-algorithm-parameters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-zram-add-documentation-for-algorithm-parameters.patch

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
Subject: Documentation/zram: add documentation for algorithm parameters
Date: Fri, 12 Jul 2024 14:18:34 +0900

Document brief description of compression algorithms' parameters:
compression level and pre-trained dictionary.

Link: https://lkml.kernel.org/r/20240712051850.484318-24-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |   45 ++++++++++++++----
 1 file changed, 36 insertions(+), 9 deletions(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~documentation-zram-add-documentation-for-algorithm-parameters
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -102,15 +102,33 @@ Examples::
 	#select lzo compression algorithm
 	echo lzo > /sys/block/zram0/comp_algorithm
 
-For the time being, the `comp_algorithm` content does not necessarily
-show every compression algorithm supported by the kernel. We keep this
-list primarily to simplify device configuration and one can configure
-a new device with a compression algorithm that is not listed in
-`comp_algorithm`. The thing is that, internally, ZRAM uses Crypto API
-and, if some of the algorithms were built as modules, it's impossible
-to list all of them using, for instance, /proc/crypto or any other
-method. This, however, has an advantage of permitting the usage of
-custom crypto compression modules (implementing S/W or H/W compression).
+For the time being, the `comp_algorithm` content shows only compression
+algorithms that are supported by zram.
+
+It is also possible to pass algorithm specific configuration parameters::
+
+	#set compression level to 8
+	echo "zstd level=8" > /sys/block/zram0/comp_algorithm
+
+Note that `comp_algorithm` also supports `algo=name` format::
+
+	#set compression level to 8
+	echo "algo=zstd level=8" > /sys/block/zram0/comp_algorithm
+
+Certain compression algorithms support pre-trained dictionaries, which
+significantly change algorithms' characteristics. In order to configure
+compression algorithm to use external pre-trained dictionary, pass full
+path to the dictionary along with other parameters::
+
+	#pass path to pre-trained dictionary
+	echo "algo=zstd dict=/etc/dictioary" > /sys/block/zram0/comp_algorithm
+
+Parameters are algorithm specific: not all algorithms support pre-trained
+dictionaries, not all algorithms support 'level'. Furthermore, for certain
+algorithms 'level' controls the compression level (the higher the value the
+better the compression ratio, it even can take negatives values for some
+algorithms), for other algorithms 'level' is acceleration level (the higher
+the value the lower the compression ratio).
 
 4) Set Disksize
 ===============
@@ -442,6 +460,15 @@ configuration:::
 	#select deflate recompression algorithm, priority 2
 	echo "algo=deflate priority=2" > /sys/block/zramX/recomp_algorithm
 
+The `recomp_algorithm` also supports algorithm configuration parameters, e.g.
+compression level and pre-trained dircionary::
+
+	#pass compression level
+	echo "algo=zstd level=8" > /sys/block/zramX/recomp_algorithm
+
+	#pass path to pre-trained dictionary
+	echo "algo=zstd dict=/etc/dictioary" > /sys/block/zramX/recomp_algorithm
+
 Another device attribute that CONFIG_ZRAM_MULTI_COMP enables is recompress,
 which controls recompression.
 
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
zram-extend-comp_algorithm-attr-write-handling.patch
zram-add-support-for-dict-comp-config.patch
zram-introduce-zcomp_req-structure.patch
zram-introduce-zcomp_ctx-structure.patch
zram-move-immutable-comp-params-away-from-per-cpu-context.patch
zram-add-dictionary-support-to-lz4.patch
zram-add-dictionary-support-to-lz4hc.patch
zram-add-dictionary-support-to-zstd-backend.patch
documentation-zram-add-documentation-for-algorithm-parameters.patch

