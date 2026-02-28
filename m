Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7312D060B
	for <mm-commits@vger.kernel.org>; Sat, 28 Feb 2026 20:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772309068; cv=none; b=MG9dTu6Muoxwgrqm0hiYMwHhe611e5F3Eln43KEvUuzl4fEBNAY7khSPnW74yN1BCbSJmsMo5NJfHEHnc53Nd4Jr5iUDdLl3H4nLvRss0wf5uZYi8o6dQGBZO9wKOCbJKUo7rtcKDtuupRDtBFcZ9Onh97NZ5rBONM7BnG40978=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772309068; c=relaxed/simple;
	bh=mr60NEzxV0PNft1PFjclRfAizOZ//fc4jY6rtsLNEpE=;
	h=Date:To:From:Subject:Message-Id; b=nr/f8sekP8ySZkIFzOwOkmlqlLtyOIS4ZPJZXLaEew4i/RJsELovU7uNo+r7QqxcHkjWxkWO6mDj6IpeuHVJFCkuz0QpSnQ1SBrsL2lqwR4dp/1FJugo0LCeaNt4OidtYCj21+ffSdvV3Le0dBvzzrKJAWgfUDzHJ5f+HcwVSho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FwESPiIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FwESPiIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C391FC116D0;
	Sat, 28 Feb 2026 20:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772309067;
	bh=mr60NEzxV0PNft1PFjclRfAizOZ//fc4jY6rtsLNEpE=;
	h=Date:To:From:Subject:From;
	b=FwESPiIwBuIphOESHjgDnm4cYFa8dry+IEOHBdlNUc9ej1dYj6YC8J3Jyx0HvHxsM
	 WZ9nbmIQcbmmkrD7xXYdIrUbRSH6BCbfOXu5QEQvh6k/yP8O5uF36Q6ZD3He5o0NzC
	 fa+pfGFYz/U51XTSlgn7nSsF3EmIj8jj302zETOs=
Date: Sat, 28 Feb 2026 12:04:27 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,philipp.reisner@linbit.com,minchan@kernel.org,lars.ellenberg@linbit.com,corbet@lwn.net,christoph.boehmwalder@linbit.com,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-update-recompression-documentation.patch added to mm-new branch
Message-Id: <20260228200427.C391FC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: update recompression documentation
has been added to the -mm mm-new branch.  Its filename is
     zram-update-recompression-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-update-recompression-documentation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Date: Fri, 27 Feb 2026 17:21:10 +0900

Emphasize usage of the `priority` parameter for recompression and explain
why `algo` parameter can lead to unexpected behavior and thus is not
recommended.

Link: https://lkml.kernel.org/r/0d9bdbb19a4a1511e8c73d1e91227c47912a8009.1772180459.git.senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: "Christoph Böhmwalder" <christoph.boehmwalder@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
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

zram-rename-writeback_compressed-device-attr.patch
zram-do-not-autocorrect-bad-recompression-parameters.patch
zram-drop-num_active_comps.patch
zram-recompression-priority-param-should-override-algo.patch
zram-update-recompression-documentation.patch
zram-remove-chained-recompression.patch

