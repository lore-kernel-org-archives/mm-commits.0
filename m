Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A44F334C1D;
	Fri, 28 Aug 2026 05:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787896660; cv=none; b=m7d6jF46qtkLWH/3yvHZWMD7Cp29Og8bSeWFYASKbjR1acxc+YPygSWJPPkn1r5CG1ktZm/i3mFvHkvmSFUSqj3yIyOoycxeTlAjaFPDPi54N+D1JvNk3rmfjM1FXAEGHMFbf4V1MJOrRfXVzUpr+/ZDcRNBF/fSgmcHqWnaQkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787896660; c=relaxed/simple;
	bh=g2m1/eW8HXmaIha/h0l+bLkpTwam+q6DzMs9u4ERt9c=;
	h=Date:To:From:Subject:Message-Id; b=W5YP7Gi0q0duqwz9dM/s+OhgtKn2mFd/aOtTJlJXSc5ZkXiZ9B3eq4D3lcYnxzVJeiLhqpp5SHGNYCs5lPfCkbJgj9lrkJoygzGeZmt35ndDn2W8kEeV3FpNNDkpSfj3sIS00LzYUK9ZUrz27AgY6r4uyuVzFlw4h1e/5GYC5LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gD73cRhn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gD73cRhn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3611F000E9;
	Fri, 28 Aug 2026 05:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787896659;
	bh=V8Oy7CFt8a6UaQQPZS0grIO/F2OjiBYf+DqNpt70i4o=;
	h=Date:To:From:Subject;
	b=gD73cRhnayzHs3DRHLzM/AiUzQCygnJHQJpNFKymc/esze/B2FiFYP+9bJTOqVgRN
	 srPljsy+pBDzjw7B2K79Vp8FpjpeBfMzMJSKUAyf4hTj8LuYXA+NMiT57al4Wa3zn3
	 locncOhbaUleVf3dQjr0j7g5sgsfIxxhbJZr153U=
Date: Thu, 27 Aug 2026 22:57:38 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,axboe@kernel.dk,jiahao1@lixiang.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] zram-fix-idle-age_sec-underflow-in-idle_store.patch removed from -mm tree
Message-Id: <20260828055738.DA3611F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: fix idle age_sec underflow in idle_store()
has been removed from the -mm tree.  Its filename was
     zram-fix-idle-age_sec-underflow-in-idle_store.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Hao Jia <jiahao1@lixiang.com>
Subject: zram: fix idle age_sec underflow in idle_store()
Date: Tue, 25 Aug 2026 17:23:16 +0800

After commit 2e8ff2f51dde ("zram: use u32 for entry ac_time tracking"),
idle_store() computes the idle cutoff as follows:

	cutoff = ktime_sub((u32)ktime_get_boottime_seconds(), age_sec);

Because the left operand is cast to a 32-bit unsigned integer, when
age_sec exceeds the current uptime, the subtraction wraps modulo 2^32 and
the huge result is zero-extended into the s64 cutoff.  mark_idle()
subsequently marks every entry as idle instead of matching nothing,
breaking the intended semantics of /sys/block/zramX/idle.  For instance,
running echo 86400 > idle on a machine up for only two minutes causes all
newly written pages to be marked as idle and handed over to idle writeback
and recompression.

Drop the explicit cast to perform the subtraction in signed arithmetic
again, restoring the previous behavior: an age_sec greater than uptime
yields a negative cutoff, and one equal to uptime yields 0.  Since a
cutoff of 0 is now a valid computed value, it can no longer double as the
"all" sentinel.  Switch to KTIME_MIN instead, which no ac_time can be
after.

Link: https://lore.kernel.org/20260825092316.69658-1-jiahao.kernel@gmail.com
Fixes: 2e8ff2f51dde ("zram: use u32 for entry ac_time tracking")
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-idle-age_sec-underflow-in-idle_store
+++ a/drivers/block/zram/zram_drv.c
@@ -438,7 +438,7 @@ static void mark_idle(struct zram *zram,
 		}
 
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
-		is_idle = !cutoff ||
+		is_idle = cutoff == KTIME_MIN ||
 			ktime_after(cutoff, zram->table[index].attr.ac_time);
 #endif
 		if (is_idle)
@@ -453,7 +453,7 @@ static ssize_t idle_store(struct device
 			  const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
-	ktime_t cutoff = 0;
+	ktime_t cutoff = KTIME_MIN;
 
 	if (!sysfs_streq(buf, "all")) {
 		/*
@@ -464,7 +464,7 @@ static ssize_t idle_store(struct device
 
 		if (IS_ENABLED(CONFIG_ZRAM_TRACK_ENTRY_ACTIME) &&
 		    !kstrtouint(buf, 0, &age_sec))
-			cutoff = ktime_sub((u32)ktime_get_boottime_seconds(),
+			cutoff = ktime_sub(ktime_get_boottime_seconds(),
 					   age_sec);
 		else
 			return -EINVAL;
@@ -475,7 +475,7 @@ static ssize_t idle_store(struct device
 		return -EINVAL;
 
 	/*
-	 * A cutoff of 0 marks everything as idle, this is the
+	 * A cutoff of KTIME_MIN marks everything as idle, this is the
 	 * "all" behavior.
 	 */
 	mark_idle(zram, cutoff);
_

Patches currently in -mm which might be from jiahao1@lixiang.com are


