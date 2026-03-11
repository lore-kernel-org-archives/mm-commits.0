Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823AB3E6DE5
	for <mm-commits@vger.kernel.org>; Wed, 11 Mar 2026 18:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773252771; cv=none; b=jGE15J5bd7+Bgsuhh8Rjpt8Scdm0DxZLhBPxwY8owjc5QbfB6aEUt0o7f43/GsBwsLshnm/ZYB2D7vuGdAEPA27xiCc0uC+1c6xDZ1hklnhYezFYHeYcaWVuCZ7xSUXiNtG8sgOV30k4fcqwXxxHjr+08SqUgussv9lZCZC+LOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773252771; c=relaxed/simple;
	bh=EhumJ3u8aPYqaFqt+sJXmO2qn54kIZ0WetimaEspkos=;
	h=Date:To:From:Subject:Message-Id; b=ug1g4tgzq+JLJe8Mgj30053i44AxsB6/7ibTzTzyl499FtZEes7BkyixExFJOaEuTizGsCk7f5GablyhNRHRP3vWBex2mCN5iSVsOr2ldE12Osgk0w1hc5WLEuhLEp6B2OqAwo30U4HADdhdIhPmvqIJU/ILYHRX1dikl/L4ck8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AiFAOLkM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AiFAOLkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16534C4CEF7;
	Wed, 11 Mar 2026 18:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773252771;
	bh=EhumJ3u8aPYqaFqt+sJXmO2qn54kIZ0WetimaEspkos=;
	h=Date:To:From:Subject:From;
	b=AiFAOLkM4AtAZVIZw1sSJI+6jMEKW3XgOj/b+SpqBjkYE8pKe7BZwjgaY6L7oYaj+
	 XivBUtLPAMEQAIzDFRYXhAPt9IdVXrrZeQcQounUJve/vWYCg3PYvXdUtbsb1PYT5i
	 ox4ooEimnjRyZNHj6o/GW1FtY82rQPFoP4AgXMhc=
Date: Wed, 11 Mar 2026 11:12:50 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,gaoxu2@honor.com,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-drop-num_active_comps.patch added to mm-unstable branch
Message-Id: <20260311181251.16534C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: drop ->num_active_comps
has been added to the -mm mm-unstable branch.  Its filename is
     zram-drop-num_active_comps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-drop-num_active_comps.patch

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
Subject: zram: drop ->num_active_comps
Date: Wed, 11 Mar 2026 17:42:46 +0900

It's not entirely correct to use ->num_active_comps for max-prio limit, as
->num_active_comps just tells the number of configured algorithms, not the
max configured priority.  For instance, in the following theoretical
example:

    [lz4] [nil] [nil] [deflate]

->num_active_comps is 2, while the actual max-prio is 3.

Drop ->num_active_comps and use ZRAM_MAX_COMPS instead.

Link: https://lkml.kernel.org/r/20260311084312.1766036-4-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Minchan Kim <minchan@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: gao xu <gaoxu2@honor.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   29 ++++++++++++++++-------------
 drivers/block/zram/zram_drv.h |    1 -
 2 files changed, 16 insertions(+), 14 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-drop-num_active_comps
+++ a/drivers/block/zram/zram_drv.c
@@ -2335,6 +2335,18 @@ static int zram_bvec_write(struct zram *
 #define RECOMPRESS_IDLE		(1 << 0)
 #define RECOMPRESS_HUGE		(1 << 1)
 
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
 static int scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio_max,
 				     struct zram_pp_ctl *ctl)
 {
@@ -2482,12 +2494,11 @@ static int recompress_slot(struct zram *
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
 
@@ -2619,12 +2630,6 @@ static ssize_t recompress_store(struct d
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
@@ -2837,7 +2842,6 @@ static void zram_destroy_comps(struct zr
 		if (!comp)
 			continue;
 		zcomp_destroy(comp);
-		zram->num_active_comps--;
 	}
 
 	for (prio = ZRAM_PRIMARY_COMP; prio < ZRAM_MAX_COMPS; prio++)
@@ -2902,7 +2906,6 @@ static ssize_t disksize_store(struct dev
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

zram-do-not-permit-params-change-after-init.patch
zram-do-not-autocorrect-bad-recompression-parameters.patch
zram-drop-num_active_comps.patch
zram-update-recompression-documentation.patch
zram-remove-chained-recompression.patch
zram-unify-and-harden-algo-priority-params-handling.patch

