Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9671F3FE3
	for <mm-commits@vger.kernel.org>; Thu, 17 Apr 2025 08:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744879098; cv=none; b=ZMCc+2mk8vs3qHSK6/bm8ojsp9cP5zJh4E5i9d1FmJ/rVL10qP6S9hFaeKONMx8MO5D7aIdDzHHYqT90x/JJ7JOXCbu9wn2gnXM+qF7XENbvVBi94vyje87eXZENb+Dtn3pebs6c9JnLsu0VX/LwzuLcvn7av+SgiARs6F9m7rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744879098; c=relaxed/simple;
	bh=p6dd4/ImTjXpUBj+QsoYgLESKdL0brZbzHV/+SJr12A=;
	h=Date:To:From:Subject:Message-Id; b=AOfKQPLf8F2K1Yv0E3ZGQeW4kjHBReb9EyySyHI/p8ue+1bazJmrzSi3zxYGs3nM+/7fkk5rkUHBz0RRrWoezi4Bi5VmfLiiJ8xRuVv9M2OIRCj3q0tExk5SCR5KlxsWFxCJVn5UTDkXhkr9k9Ip2E88Ys3J01gEbR9oGH4H/w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MxwP1VYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MxwP1VYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D9EC4CEE4;
	Thu, 17 Apr 2025 08:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744879096;
	bh=p6dd4/ImTjXpUBj+QsoYgLESKdL0brZbzHV/+SJr12A=;
	h=Date:To:From:Subject:From;
	b=MxwP1VYJdheZGNiLsHGi8IPGzZHidue8pN96bfFGY5r60pwrNEoqbxRYFyY3K0Nok
	 wwYwTB2BakKGkIOoj1JkVhYIuopNpkBr7XxMVxd+irgnYdOxGhjnYzl/keUeDdvru/
	 pvD9WIXF3Iyh1RrIkblnwf73sRySSHfGHHi41ing=
Date: Thu, 17 Apr 2025 01:38:15 -0700
To: mm-commits@vger.kernel.org,luogengkun@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] watchdog-fix-watchdog-may-detect-false-positive-of-softlockup.patch removed from -mm tree
Message-Id: <20250417083816.97D9EC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog: fix watchdog may detect false positive of softlockup
has been removed from the -mm tree.  Its filename was
     watchdog-fix-watchdog-may-detect-false-positive-of-softlockup.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Luo Gengkun <luogengkun@huaweicloud.com>
Subject: watchdog: fix watchdog may detect false positive of softlockup
Date: Wed, 16 Apr 2025 01:39:22 +0000

The watchdog may detect false positive of softlockup because of stop
softlockup after update watchdog_thresh.  The problem can be described
as follow:

 # We asuume previous watchdog_thresh is 60, so the timer is coming every
 # 24s.
echo 10 > /proc/sys/kernel/watchdog_thresh (User space)
|
+------>+ update watchdog_thresh (We are in kernel now)
	|
	|
	+------>+ watchdog hrtimer (irq context: detect softlockup)
		|
		|
	+-------+
	|
	|
	+ softlockup_stop_all

As showed above, there is a window between update watchdog_thresh and
softlockup_stop_all. During this window, if a timer is coming, a false
positive of softlockup will happen. To fix this problem, use a shadow
variable to store the new value and write back to watchdog_thresh after
softlockup_stop_all.

Link: https://lkml.kernel.org/r/20250416013922.2905051-1-luogengkun@huaweicloud.com
Signed-off-by: Luo Gengkun <luogengkun@huaweicloud.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/kernel/watchdog.c~watchdog-fix-watchdog-may-detect-false-positive-of-softlockup
+++ a/kernel/watchdog.c
@@ -47,6 +47,7 @@ int __read_mostly watchdog_user_enabled
 static int __read_mostly watchdog_hardlockup_user_enabled = WATCHDOG_HARDLOCKUP_DEFAULT;
 static int __read_mostly watchdog_softlockup_user_enabled = 1;
 int __read_mostly watchdog_thresh = 10;
+static int __read_mostly watchdog_thresh_shadow;
 static int __read_mostly watchdog_hardlockup_available;
 
 struct cpumask watchdog_cpumask __read_mostly;
@@ -876,6 +877,7 @@ static void __lockup_detector_reconfigur
 	watchdog_hardlockup_stop();
 
 	softlockup_stop_all();
+	watchdog_thresh = READ_ONCE(watchdog_thresh_shadow);
 	set_sample_period();
 	lockup_detector_update_enable();
 	if (watchdog_enabled && watchdog_thresh)
@@ -1035,10 +1037,12 @@ static int proc_watchdog_thresh(const st
 
 	mutex_lock(&watchdog_mutex);
 
-	old = READ_ONCE(watchdog_thresh);
+	watchdog_thresh_shadow = READ_ONCE(watchdog_thresh);
+
+	old = watchdog_thresh_shadow;
 	err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 
-	if (!err && write && old != READ_ONCE(watchdog_thresh))
+	if (!err && write && old != READ_ONCE(watchdog_thresh_shadow))
 		proc_watchdog_update();
 
 	mutex_unlock(&watchdog_mutex);
@@ -1080,7 +1084,7 @@ static const struct ctl_table watchdog_s
 	},
 	{
 		.procname	= "watchdog_thresh",
-		.data		= &watchdog_thresh,
+		.data		= &watchdog_thresh_shadow,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_watchdog_thresh,
_

Patches currently in -mm which might be from luogengkun@huaweicloud.com are


