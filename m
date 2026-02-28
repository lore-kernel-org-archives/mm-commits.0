Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A04175A8C
	for <mm-commits@vger.kernel.org>; Sat, 28 Feb 2026 20:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772309066; cv=none; b=ZfPX/Bxo+eHZtqlzxdiro7pEaPkMRgWJPSG4xgSVA2/tXR4oItVZ2WcGbzDI2zxarW2UKLcygZ6rwQFZJAYTOolPmIUvZBUQTajfCT7qMM0IyB0IB7bsY0XBcplHLSx2yfSNEbp1jkm+c+n8OG5y20OM6vC60ohBmBKEKmrfwuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772309066; c=relaxed/simple;
	bh=TJQKFtevc6z0IpyX2qNF87GXA/jJYBu4xkUe9fSoogE=;
	h=Date:To:From:Subject:Message-Id; b=AXfWkVdQ4+sPodhVxndjmxuQSBa42tR5Chrc/eC3B+w4xiTbUrsV8jSccj1OZ8S5qeMxLKN9M7Ke3S7RT6py2ATHSXqLYZsH6rpUYAxvXUixM0Mf8fEVRJo9ukiH36aXJ4VYuJuOsdiHsUZ/4pHkY3/2M7/Exmo5yCo9hpzM6cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2VkH9+aA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2VkH9+aA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49E3C116D0;
	Sat, 28 Feb 2026 20:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772309065;
	bh=TJQKFtevc6z0IpyX2qNF87GXA/jJYBu4xkUe9fSoogE=;
	h=Date:To:From:Subject:From;
	b=2VkH9+aAlsMR4d/y4KWbHK3BjI4A0jjXYiRxNsNJMEWCqfeWo3YMqpP+3/xvRUVyY
	 zPCh9Qup5gOa0qgVcdtK3xuUhND3fiGe3YsNCc9S720c2x18Dda9iWePlvk0fwmlmx
	 yUpy1wiYQWJqLvYiO/NY8p3r9awBhw2eGRGDtaY4=
Date: Sat, 28 Feb 2026 12:04:25 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,philipp.reisner@linbit.com,minchan@kernel.org,lars.ellenberg@linbit.com,corbet@lwn.net,christoph.boehmwalder@linbit.com,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-recompression-priority-param-should-override-algo.patch added to mm-new branch
Message-Id: <20260228200425.B49E3C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: recompression priority param should override algo
has been added to the -mm mm-new branch.  Its filename is
     zram-recompression-priority-param-should-override-algo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-recompression-priority-param-should-override-algo.patch

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
Subject: zram: recompression priority param should override algo
Date: Fri, 27 Feb 2026 17:21:09 +0900

Recompression algorithm lookup by name is ambiguous and can lead to
unexpected results.  The problem is that the system can configure the same
algorithm but with different parameters (compression level, C/D-dicts,
etc.) multiple times:

    [zstd clevel=3] [zstd clevel=8 dict=/etc/dict]

making it impossible to distinguish compressors by name.  It is advised to
always use "priority".  Additionally, override "algo" with "priority",
when both params are provided.

Link: https://lkml.kernel.org/r/831636c74ca6d72317de02d96585cc6833d082e6.1772180459.git.senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Minchan Kim <minchan@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: "Christoph Böhmwalder" <christoph.boehmwalder@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-recompression-priority-param-should-override-algo
+++ a/drivers/block/zram/zram_drv.c
@@ -2594,6 +2594,16 @@ static ssize_t recompress_store(struct d
 			if (ret)
 				return ret;
 
+			/*
+			 * "priority" overrides "algo".
+			 *
+			 * We can have several algorithms configured with
+			 * different params (compression/acceleration level,
+			 * C/D-dict, etc.) but under the same name.
+			 *
+			 * "algorithm" name lookup is ambiguous.
+			 */
+			algo = NULL;
 			prio_max = min(prio + 1, ZRAM_MAX_COMPS);
 			continue;
 		}
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-rename-writeback_compressed-device-attr.patch
zram-do-not-autocorrect-bad-recompression-parameters.patch
zram-drop-num_active_comps.patch
zram-recompression-priority-param-should-override-algo.patch
zram-update-recompression-documentation.patch
zram-remove-chained-recompression.patch

