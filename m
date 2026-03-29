Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87D824EAB1
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744857; cv=none; b=qa5kyF0xfmCeqT74kvrBQU3C2iRH15ozznIgOGkz59Wgd2b26JRYxwGkhbcIDpEX5sQM252CMP9T7ZkryHf4Mg8uWprL6J1SV4SDXeyLAnGH/6m8ew50O6PEizsfQbG716vrFpNIcaMuMDrc8BNb7Gikz+au/tizWAxFZBPhho8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744857; c=relaxed/simple;
	bh=913sxvAZQXdOcO1gedlHlOcL6RC+DGqRpGE4NMEFEqQ=;
	h=Date:To:From:Subject:Message-Id; b=S4bhCeiMBwTJVOhBGTi0i6KQMWEQObwO2A1OdAEQhcNYm0W4+MZyGIsazhoI6yOTsOnUhgAijoVea8o/B2plHyNLNVYSoLcpRroLW9WUaBYhLdPUM8BbyWKczbU1peUw9G+hUbBVh4zwaRltfWIn4zeMURmmiIWXCvvTaWQ3Kog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NefcnXFz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NefcnXFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69013C4CEF7;
	Sun, 29 Mar 2026 00:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744857;
	bh=913sxvAZQXdOcO1gedlHlOcL6RC+DGqRpGE4NMEFEqQ=;
	h=Date:To:From:Subject:From;
	b=NefcnXFzTunExM5g4i2wFmFhRWekVia7Yvo1kAblCVoSdEkGMhqZj6d2m1HWNXRSc
	 /IWb0l5DufqfploMMXASqsPBewSAoKWnPvV1pbr42/ewDtMpMvmpXGm2b0CJaN3hVY
	 MtClFzjCk1WzfFe4pASrcz34HPcGZlrH9VWxivVA=
Date: Sat, 28 Mar 2026 17:40:56 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,gaoxu2@honor.com,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-update-recompression-documentation.patch removed from -mm tree
Message-Id: <20260329004057.69013C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: update recompression documentation
has been removed from the -mm tree.  Its filename was
     zram-update-recompression-documentation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: update recompression documentation
Date: Wed, 11 Mar 2026 17:42:47 +0900

Emphasize usage of the `priority` parameter for recompression and explain
why `algo` parameter can lead to unexpected behavior and thus is not
recommended.

Link: https://lkml.kernel.org/r/20260311084312.1766036-5-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: gao xu <gaoxu2@honor.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |   40 ++++++++----------
 1 file changed, 18 insertions(+), 22 deletions(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~zram-update-recompression-documentation
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -462,7 +462,7 @@ know it via /sys/block/zram0/bd_stat's 3
 recompression
 -------------
 
-With CONFIG_ZRAM_MULTI_COMP, zram can recompress pages using alternative
+With `CONFIG_ZRAM_MULTI_COMP`, zram can recompress pages using alternative
 (secondary) compression algorithms. The basic idea is that alternative
 compression algorithm can provide better compression ratio at a price of
 (potentially) slower compression/decompression speeds. Alternative compression
@@ -471,7 +471,7 @@ that default algorithm failed to compres
 recompression - pages that are cold and sit in the memory can be recompressed
 using more effective algorithm and, hence, reduce zsmalloc memory usage.
 
-With CONFIG_ZRAM_MULTI_COMP, zram supports up to 4 compression algorithms:
+With `CONFIG_ZRAM_MULTI_COMP`, zram supports up to 4 compression algorithms:
 one primary and up to 3 secondary ones. Primary zram compressor is explained
 in "3) Select compression algorithm", secondary algorithms are configured
 using recomp_algorithm device attribute.
@@ -495,34 +495,43 @@ configuration:::
 	#select deflate recompression algorithm, priority 2
 	echo "algo=deflate priority=2" > /sys/block/zramX/recomp_algorithm
 
-Another device attribute that CONFIG_ZRAM_MULTI_COMP enables is recompress,
+Another device attribute that `CONFIG_ZRAM_MULTI_COMP` enables is `recompress`,
 which controls recompression.
 
 Examples:::
 
 	#IDLE pages recompression is activated by `idle` mode
-	echo "type=idle" > /sys/block/zramX/recompress
+	echo "type=idle priority=1" > /sys/block/zramX/recompress
 
 	#HUGE pages recompression is activated by `huge` mode
-	echo "type=huge" > /sys/block/zram0/recompress
+	echo "type=huge priority=2" > /sys/block/zram0/recompress
 
 	#HUGE_IDLE pages recompression is activated by `huge_idle` mode
-	echo "type=huge_idle" > /sys/block/zramX/recompress
+	echo "type=huge_idle priority=1" > /sys/block/zramX/recompress
 
 The number of idle pages can be significant, so user-space can pass a size
 threshold (in bytes) to the recompress knob: zram will recompress only pages
 of equal or greater size:::
 
 	#recompress all pages larger than 3000 bytes
-	echo "threshold=3000" > /sys/block/zramX/recompress
+	echo "threshold=3000 priority=1" > /sys/block/zramX/recompress
 
 	#recompress idle pages larger than 2000 bytes
-	echo "type=idle threshold=2000" > /sys/block/zramX/recompress
+	echo "type=idle threshold=2000 priority=1" > \
+		/sys/block/zramX/recompress
 
 It is also possible to limit the number of pages zram re-compression will
 attempt to recompress:::
 
-	echo "type=huge_idle max_pages=42" > /sys/block/zramX/recompress
+	echo "type=huge_idle priority=1 max_pages=42" > \
+		/sys/block/zramX/recompress
+
+It is advised to always specify `priority` parameter.  While it is also
+possible to specify `algo` parameter, so that `zram` will use algorithm's
+name to determine the priority, it is not recommended, since it can lead to
+unexpected results when the same algorithm is configured with different
+priorities (e.g. different parameters).  `priority` is the only way to
+guarantee that the expected algorithm will be used.
 
 During re-compression for every page, that matches re-compression criteria,
 ZRAM iterates the list of registered alternative compression algorithms in
@@ -533,19 +542,6 @@ no secondary algorithms left to try. If
 successfully re-compressed the page such a page is marked as incompressible,
 so ZRAM will not attempt to re-compress it in the future.
 
-This re-compression behaviour, when it iterates through the list of
-registered compression algorithms, increases our chances of finding the
-algorithm that successfully compresses a particular page. Sometimes, however,
-it is convenient (and sometimes even necessary) to limit recompression to
-only one particular algorithm so that it will not try any other algorithms.
-This can be achieved by providing a `algo` or `priority` parameter:::
-
-	#use zstd algorithm only (if registered)
-	echo "type=huge algo=zstd" > /sys/block/zramX/recompress
-
-	#use zstd algorithm only (if zstd was registered under priority 1)
-	echo "type=huge priority=1" > /sys/block/zramX/recompress
-
 memory tracking
 ===============
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


