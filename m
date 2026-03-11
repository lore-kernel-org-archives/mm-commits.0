Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045C83E6DE5
	for <mm-commits@vger.kernel.org>; Wed, 11 Mar 2026 18:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773252774; cv=none; b=SFv4RD0wslnsahYcXK5cS5X8zKCkSX17RNikY+QtO0u/rWT7s8VsCdMigrrlk9o+yrTxAGBmAhYo5oi77QpZaKqlNt3mf5NQShM+cTkNUZ6WsC9yk7W9sLtGbN+BOIHUTVj4B0BTJ5CLbjcsgmHLfF3yee7ESKaivF9rcG4OqGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773252774; c=relaxed/simple;
	bh=bsi98S859OgWx8/7cuY8+u46+ZfiatIgyrQ5n7at+/w=;
	h=Date:To:From:Subject:Message-Id; b=M9l576krLd+8D+odrUsqYUQrM/t/muYluJmVOgYO5qrpU5TUgrvIK4TzJ+jDqEMopoKqtzIDakD2hRs5B4BY9OtcpttSgiOecRg24QqjrfoItbCDdv14SP02j27TRVjrooEVOiX+nrNyCKciNFiWzUg6htqxXNWpGzUBu43Rx+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FzbjNwug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FzbjNwug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A389EC4CEF7;
	Wed, 11 Mar 2026 18:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773252773;
	bh=bsi98S859OgWx8/7cuY8+u46+ZfiatIgyrQ5n7at+/w=;
	h=Date:To:From:Subject:From;
	b=FzbjNwugRmYcydYyZCGP4EQ7PILZy9w8uFbw6DOAwTCpGBThxT4v/aFaNqBFUWV8T
	 ZRnh7FouV2QJCi2EFtGE59AtIZXf0VuLVro4O8DGj6odxmTAj1OWEOUNTYrN5mBn9a
	 vYXGxFp4vHbe6BH7/6lAy69n2fdhxlOI6oMB6Bcw=
Date: Wed, 11 Mar 2026 11:12:53 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,gaoxu2@honor.com,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-update-recompression-documentation.patch added to mm-unstable branch
Message-Id: <20260311181253.A389EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: update recompression documentation
has been added to the -mm mm-unstable branch.  Its filename is
     zram-update-recompression-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-update-recompression-documentation.patch

This patch will later appear in the mm-unstable branch at
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

zram-do-not-permit-params-change-after-init.patch
zram-do-not-autocorrect-bad-recompression-parameters.patch
zram-drop-num_active_comps.patch
zram-update-recompression-documentation.patch
zram-remove-chained-recompression.patch
zram-unify-and-harden-algo-priority-params-handling.patch

