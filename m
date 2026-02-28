Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0F3292B54
	for <mm-commits@vger.kernel.org>; Sat, 28 Feb 2026 20:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772309063; cv=none; b=VaxqsvF/3cJupYsA909qipdaEKXu2KSM6uINWFIs9ac9MqDf7+8VNAr5Ed8ojvCDjeipygf1tZjk9QTKu1Ajc5Vw6LI9Vyb2/LxqUfmw8jCXP7lJ3xsRTa8qMhcGgVG2lsdUpt/KAGN45WBa+DX0SPumk5N9+0FwjOiNZ8vg/Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772309063; c=relaxed/simple;
	bh=Kf2ixhBKVWsjRcCLCyScKwZfyfh/dx7M8bMqXGpYPkY=;
	h=Date:To:From:Subject:Message-Id; b=RPa2LrqFyl9je7tJqks4xwkGXC5GIwrngzTOI35+eJcxKFhM2EV8bon41foo4PvjxmqxdSFYJ+5Gr0QbMoOQW5crBYg7T85lJhQblT/mj4SO6PQaeK8I3XncUUCmN5vIp+iRp3p0dbTo+/NeD58JHQPVuaOVoH3SXwMwOaAG4ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wsV4tA/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wsV4tA/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2882CC116D0;
	Sat, 28 Feb 2026 20:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772309063;
	bh=Kf2ixhBKVWsjRcCLCyScKwZfyfh/dx7M8bMqXGpYPkY=;
	h=Date:To:From:Subject:From;
	b=wsV4tA/34B+OpvgZxHn6y+v/rC9Ay2d5Y2YCyVv2GhxhN2+PuNgurgpYX8ahclR9I
	 n/73V1fVSDuMsW9JWdgrWQChl7epDxw6hGvruHyqa9O0lEnPBwoTPQS0IuHWl1pvvN
	 dUEMfMXhJTlh+dSDhGPqUbCI30hFPwTn4lTN0jq4=
Date: Sat, 28 Feb 2026 12:04:22 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,philipp.reisner@linbit.com,minchan@kernel.org,lars.ellenberg@linbit.com,corbet@lwn.net,christoph.boehmwalder@linbit.com,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-drop-num_active_comps.patch added to mm-new branch
Message-Id: <20260228200423.2882CC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: drop ->num_active_comps
has been added to the -mm mm-new branch.  Its filename is
     zram-drop-num_active_comps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-drop-num_active_comps.patch

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
Subject: zram: drop ->num_active_comps
Date: Fri, 27 Feb 2026 17:21:08 +0900

It's not entirely correct to use ->num_active_comps for max-prio limit, as
->num_active_comps just tells the number of configured algorithms, not the
max configured priority.  For instance, in the following theoretical
example:

    [lz4] [nil] [nil] [deflate]

->num_active_comps is 2, while the actual max-prio is 3.

Drop ->num_active_comps and use ZRAM_MAX_COMPS instead.

Link: https://lkml.kernel.org/r/eb7cd3ca578320be9aff13e71298fc36e110af41.1772180459.git.senozhatsky@chromium.org
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

 drivers/block/zram/zram_drv.c |   29 ++++++++++++++++-------------
 drivers/block/zram/zram_drv.h |    1 -
 2 files changed, 16 insertions(+), 14 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-drop-num_active_comps
+++ a/drivers/block/zram/zram_drv.c
@@ -2371,6 +2371,18 @@ next:
 	return 0;
 }
 
+static bool highest_priority_algorithm(struct zram *zram, u32 prio)
+{
+	u32 p;
+
+	for (p = prio + 1; p < ZRAM_MAX_COMPS; p++) {
+		if (zram->comp_algs[p])
+			return false;
+	}
+
+	return true;
+}
+
 /*
  * This function will decompress (unless it's ZRAM_HUGE) the page and then
  * attempt to compress it using provided compression algorithm priority
@@ -2478,12 +2490,11 @@ static int recompress_slot(struct zram *
 		 * Secondary algorithms failed to re-compress the page
 		 * in a way that would save memory.
 		 *
-		 * Mark the object incompressible if the max-priority
-		 * algorithm couldn't re-compress it.
+		 * Mark the object incompressible if the max-priority (the
+		 * last configured one) algorithm couldn't re-compress it.
 		 */
-		if (prio < zram->num_active_comps)
-			return 0;
-		set_slot_flag(zram, index, ZRAM_INCOMPRESSIBLE);
+		if (highest_priority_algorithm(zram, prio))
+			set_slot_flag(zram, index, ZRAM_INCOMPRESSIBLE);
 		return 0;
 	}
 
@@ -2615,12 +2626,6 @@ static ssize_t recompress_store(struct d
 		}
 	}
 
-	prio_max = min(prio_max, (u32)zram->num_active_comps);
-	if (prio >= prio_max) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	if (prio < ZRAM_SECONDARY_COMP || prio >= ZRAM_MAX_COMPS) {
 		ret = -EINVAL;
 		goto out;
@@ -2833,7 +2838,6 @@ static void zram_destroy_comps(struct zr
 		if (!comp)
 			continue;
 		zcomp_destroy(comp);
-		zram->num_active_comps--;
 	}
 
 	for (prio = ZRAM_PRIMARY_COMP; prio < ZRAM_MAX_COMPS; prio++)
@@ -2898,7 +2902,6 @@ static ssize_t disksize_store(struct dev
 		}
 
 		zram->comps[prio] = comp;
-		zram->num_active_comps++;
 	}
 	zram->disksize = disksize;
 	set_capacity_and_notify(zram->disk, zram->disksize >> SECTOR_SHIFT);
--- a/drivers/block/zram/zram_drv.h~zram-drop-num_active_comps
+++ a/drivers/block/zram/zram_drv.h
@@ -125,7 +125,6 @@ struct zram {
 	 */
 	u64 disksize;	/* bytes */
 	const char *comp_algs[ZRAM_MAX_COMPS];
-	s8 num_active_comps;
 	/*
 	 * zram is claimed so open request will be failed
 	 */
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-rename-writeback_compressed-device-attr.patch
zram-do-not-autocorrect-bad-recompression-parameters.patch
zram-drop-num_active_comps.patch
zram-recompression-priority-param-should-override-algo.patch
zram-update-recompression-documentation.patch
zram-remove-chained-recompression.patch

