Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB32377563;
	Fri, 28 Aug 2026 17:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787937805; cv=none; b=sX1SQ+XEO3im1wlovNkUHvvNutua4C2NGUojuCAF0XKpfQ3/1SiXOy5YnAf1dldITQc71g53q20dM8PQ6c0y0HX9KGt0h+qFH/lDQ9EoS/dPzcCvpaCb8kiTVDrWGtMIZGdf/0z5Wk0Mmch4zr1psK/sj8yIdLpKOsIk5BqgKJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787937805; c=relaxed/simple;
	bh=h9A/7jvz9pekY2on0jx2wVO4f+wekUpazqKkAvWuczM=;
	h=Date:To:From:Subject:Message-Id; b=Jgko01u4/b3Mmxq81YNVJZlPEZbQC0Hsy31uiJeCZkNCGJjbKibgw6S0A1VdjsO7JPkIkiynC1JFecF7B0Ib69qlTnfs5sbbA8J638vaJ+iZvk9gCPFZq3698K1dnUbQv1tDrhpe8xT4iIzqcwK4TS4FFQY3EWRPjsS1GsPUO68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pSkuY1w2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pSkuY1w2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923A91F000E9;
	Fri, 28 Aug 2026 17:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787937803;
	bh=Cs2ZMxhzd4tkFNgRBgxhQjMthxbUyY22zFRACXCbi48=;
	h=Date:To:From:Subject;
	b=pSkuY1w2dbXYKx9nrwP9sRHe4zf7IWO+gUxwcki1E7TFswad+n8GEyhtTuwLiawe4
	 9n9krR9jM1QgbbLPY75YZN6j/vncN35Y55i6Mabd9IQ6cmlM+GauEnw7k2j5CJvKcm
	 MGztSZcFGtMiE/mg7gR0GHWLxZWK/YoPg5XyjiAQ=
Date: Fri, 28 Aug 2026 10:23:23 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,bgeffon@google.com,axboe@kernel.dk,jiahao1@lixiang.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-fix-idle-age_sec-underflow-in-idle_store.patch added to mm-new branch
Message-Id: <20260828172323.923A91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: fix idle age_sec underflow in idle_store()
has been added to the -mm mm-new branch.  Its filename is
     zram-fix-idle-age_sec-underflow-in-idle_store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-fix-idle-age_sec-underflow-in-idle_store.patch

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
From: Hao Jia <jiahao1@lixiang.com>
Subject: zram: fix idle age_sec underflow in idle_store()
Date: Fri, 28 Aug 2026 16:31:49 +0800

After commit 2e8ff2f51dde ("zram: use u32 for entry ac_time tracking"),
idle_store() computes the idle cutoff as:

	cutoff = ktime_sub((u32)ktime_get_boottime_seconds(), age_sec);

Because the left operand is cast to u32, when age_sec exceeds the current
uptime the subtraction wraps modulo 2^32 and the huge result is
zero-extended into the s64 cutoff.  mark_idle() then marks every entry as
idle instead of matching nothing.  For instance, running

	echo 86400 > /sys/block/zramX/idle

on a machine up for only two minutes marks all newly written pages idle
and hands them to idle writeback and recompression.

No slot can have been accessed before the system booted, so an age_sec
that reaches back past uptime cannot match any slot.  Return early in that
case, without walking the table or taking any slot locks.

Track the cutoff as time64_t rather than ktime_t.  Both cutoff and ac_time
are boot-time values in seconds, so a plain arithmetic comparison against
ac_time in mark_idle() is correct and no ktime helpers are needed.

Link: https://lore.kernel.org/20260828083149.45760-1-jiahao.kernel@gmail.com
Fixes: 2e8ff2f51dde ("zram: use u32 for entry ac_time tracking")
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-idle-age_sec-underflow-in-idle_store
+++ a/drivers/block/zram/zram_drv.c
@@ -415,7 +415,7 @@ static ssize_t mem_used_max_store(struct
  * Mark all pages which are older than or equal to cutoff as IDLE.
  * Callers should hold the zram init lock in read mode
  */
-static void mark_idle(struct zram *zram, ktime_t cutoff)
+static void mark_idle(struct zram *zram, time64_t cutoff)
 {
 	int is_idle = 1;
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
@@ -439,7 +439,7 @@ static void mark_idle(struct zram *zram,
 
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
 		is_idle = !cutoff ||
-			ktime_after(cutoff, zram->table[index].attr.ac_time);
+			cutoff > zram->table[index].attr.ac_time;
 #endif
 		if (is_idle)
 			set_slot_flag(zram, index, ZRAM_IDLE);
@@ -453,21 +453,26 @@ static ssize_t idle_store(struct device
 			  const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
-	ktime_t cutoff = 0;
+	time64_t cutoff = 0;
 
 	if (!sysfs_streq(buf, "all")) {
 		/*
 		 * If it did not parse as 'all' try to treat it as an integer
 		 * when we have memory tracking enabled.
 		 */
+		time64_t uptime;
 		u32 age_sec;
 
-		if (IS_ENABLED(CONFIG_ZRAM_TRACK_ENTRY_ACTIME) &&
-		    !kstrtouint(buf, 0, &age_sec))
-			cutoff = ktime_sub((u32)ktime_get_boottime_seconds(),
-					   age_sec);
-		else
+		if (!IS_ENABLED(CONFIG_ZRAM_TRACK_ENTRY_ACTIME) ||
+		    kstrtouint(buf, 0, &age_sec))
 			return -EINVAL;
+
+		/* No slot can be older than the system uptime */
+		uptime = ktime_get_boottime_seconds();
+		if (age_sec >= uptime)
+			return len;
+
+		cutoff = uptime - age_sec;
 	}
 
 	guard(rwsem_read)(&zram->dev_lock);
_

Patches currently in -mm which might be from jiahao1@lixiang.com are

zram-fix-idle-age_sec-underflow-in-idle_store.patch

