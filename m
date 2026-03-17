Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C12D36680F
	for <mm-commits@vger.kernel.org>; Tue, 17 Mar 2026 03:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773719998; cv=none; b=k3tITryV+eBFJ8+odVyYzG2lXiVBpv+RqHY7zG/zabce8AYdgDj8UhTVJmTaIpQK1oW7hZVkr55MJcbYf5l0Y8v5FBXu4CL+nv6GjsFFyXtgHg4jzFh3hI7n/2m6/kR8Q+yyctfoG3BplaJbL3LPRGESDenXMa11lZCuCDACbO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773719998; c=relaxed/simple;
	bh=9xQfMjUwCXKRXnTvDUPuTmazmgSnFuFFaCo7kT4gkWU=;
	h=Date:To:From:Subject:Message-Id; b=QXvjLrpVTKT2h34n96M3rRLgfIkRNpRaQwmmOzrS/WIZKv6L+mHYAz7Qk98usuX/ohymXKaSZKWO7lxi9bTfeGfzFmGNZ3qhpZso6xwTwGUmbwFDsCUpv0CtfZ6cdhhhT0178kUE+0n0AFfJTMMyUoD2/sD/sm6x93A5KvyqYHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eSmMCAhe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eSmMCAhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7CAC4CEF7;
	Tue, 17 Mar 2026 03:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773719997;
	bh=9xQfMjUwCXKRXnTvDUPuTmazmgSnFuFFaCo7kT4gkWU=;
	h=Date:To:From:Subject:From;
	b=eSmMCAhePmQOr45rIp+Z/ZG81VRU9SROCnliQ6n/DtTXB7Sbmgv6rNrqqt4y98tt1
	 S2ynXxDn+l6LyM0xsUHfgY4A4KFY6HBA4MJvEerfxtNaZNhvyF6EQBOof6W/6wvDa8
	 dZL/YyNT2I0c+rSSdbFwkaFL9IBKo3SKA8KPM44Q=
Date: Mon, 16 Mar 2026 20:59:56 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-change-scan_slots-to-return-void.patch added to mm-new branch
Message-Id: <20260317035957.8B7CAC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: change scan_slots to return void
has been added to the -mm mm-new branch.  Its filename is
     zram-change-scan_slots-to-return-void.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-change-scan_slots-to-return-void.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Subject: zram: change scan_slots to return void
Date: Tue, 17 Mar 2026 12:23:19 +0900

scan_slots_for_writeback() and scan_slots_for_recompress() work in a "best
effort" fashion, if they cannot allocate memory for a new pp-slot
candidate they just return and post-processing selects slots that were
successfully scanned thus far.  scan_slots functions never return errors
and their callers never check the return status, so convert them to return
void.

Link: https://lkml.kernel.org/r/20260317032349.753645-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-change-scan_slots-to-return-void
+++ a/drivers/block/zram/zram_drv.c
@@ -1212,9 +1212,9 @@ static int parse_mode(char *val, u32 *mo
 	return 0;
 }
 
-static int scan_slots_for_writeback(struct zram *zram, u32 mode,
-				    unsigned long lo, unsigned long hi,
-				    struct zram_pp_ctl *ctl)
+static void scan_slots_for_writeback(struct zram *zram, u32 mode,
+				     unsigned long lo, unsigned long hi,
+				     struct zram_pp_ctl *ctl)
 {
 	u32 index = lo;
 
@@ -1246,8 +1246,6 @@ next:
 			break;
 		index++;
 	}
-
-	return 0;
 }
 
 static ssize_t writeback_store(struct device *dev,
@@ -2379,8 +2377,8 @@ static bool highest_priority_algorithm(s
 	return true;
 }
 
-static int scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio,
-				     struct zram_pp_ctl *ctl)
+static void scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio,
+				      struct zram_pp_ctl *ctl)
 {
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
 	unsigned long index;
@@ -2415,8 +2413,6 @@ next:
 		if (!ok)
 			break;
 	}
-
-	return 0;
 }
 
 /*
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-do-not-permit-params-change-after-init.patch
zram-do-not-autocorrect-bad-recompression-parameters.patch
zram-drop-num_active_comps.patch
zram-update-recompression-documentation.patch
zram-remove-chained-recompression.patch
zram-unify-and-harden-algo-priority-params-handling.patch
zram-propagate-read_from_bdev_async-errors.patch
zram-change-scan_slots-to-return-void.patch

