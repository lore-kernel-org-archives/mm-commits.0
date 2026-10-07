Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DF32C21F4;
	Wed,  7 Oct 2026 00:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334198; cv=none; b=BxDFdJ8xpVngxEuYcbTfhPiaJbZEEG7eCy9dOPeZv/vVexAYgNiiqS+McNjgQ7JXG+7RMtpqiRNldAhaH47hNkJWMrDypZD5u9ZUn87aoemk3YrI6ediGOL6k/iN799/051QM5UC5nm2wyRvsOscL6MBKpMWKb8vSL0zLYaA35U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334198; c=relaxed/simple;
	bh=nLA4qWuSXAPl1Bi2LNKyfOhpPCBTYFbKmsSXERjmlw8=;
	h=Date:To:From:Subject:Message-Id; b=ueexxQ4SlCh/ovt77wyIBtChYNqve8dMrQEmGtDWPZoeMFF9+IDYnNAus5LL9iDW/0wJpsWm9je0VmQR2RW44xc5YWOwOf6/nQiBXi5siQCr5KDTgH6GTcwz/Wjch/+LpJTxFHp8Cvl5wbHNDvbDnXBbwH3pfDDMkCvaW7Xmucs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZcX0z/gh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZcX0z/gh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFD61F008A1;
	Wed,  7 Oct 2026 00:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334196;
	bh=wzRxjQ5mWUi6vzcFqC2T86v+kzI2j+bt5oICTn4dX2k=;
	h=Date:To:From:Subject;
	b=ZcX0z/gh+u3NpkLJTjlwJ/45wq58tNP7GmiQBysdYG2Ozzx9Kct2K/iE9M3uagFZ2
	 En4Jf5Gk0qkXaahW3WbENKfBXHPtsWp5YzJ0znLJhS6rfCwA8nhDViP1wO1io9XGpM
	 4Xs2rtE0/j9q56GDzXpvs/w4fWUtcHSRgI8Gd1dg=
Date: Tue, 06 Oct 2026 17:49:55 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,bgeffon@google.com,axboe@kernel.dk,jiahao1@lixiang.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-fix-idle-age_sec-underflow-in-idle_store.patch removed from -mm tree
Message-Id: <20261007004956.5BFD61F008A1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: fix idle age_sec underflow in idle_store()
has been removed from the -mm tree.  Its filename was
     zram-fix-idle-age_sec-underflow-in-idle_store.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
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


