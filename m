Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0173AC1C
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810117; cv=none; b=APVJcZ93CPEX1+t+GuTczcNVsXi+2y50XxuEH2seAbi+WeLeEQWp/hvDj+mRMrOtcKbPOClT+7lZIP11sooqZN7Xi9yU4XkLb+xFTQJJIBh5rOOFWas71Jx2RF9iOVjUSf/JPyxhXHV3oKdd0nYZZr/Kiruv0mHSuLV2k6/ZRRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810117; c=relaxed/simple;
	bh=lzxA1q+BgqHiX/L/y0rwcaKgbcNeCz65M7rYzNHCMq4=;
	h=Date:To:From:Subject:Message-Id; b=NMgXSddOstNZfWDci7Ivbdn97u7D7k4Xgh+ep0oNE4RfABLoUrL3tTj2o8KKHadq2ORIc6Xt2zefV4TIUrMZ43dI6M8dYKTZhXNAbfmPEaWV+9DBgMw1OhZvhgWG8Y7OtSQxxICbUNUBFRnNGJTyzSF84id9WZrpTEBvcBxrlaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RkCn+fGo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RkCn+fGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA90C4CEEB;
	Sun, 14 Sep 2025 00:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810116;
	bh=lzxA1q+BgqHiX/L/y0rwcaKgbcNeCz65M7rYzNHCMq4=;
	h=Date:To:From:Subject:From;
	b=RkCn+fGokS5gefeRSPIKdUFNQEsWNySj+ET+guffkBnoalAl83HtB/eTo4JaYAL6c
	 GXSigpfWEuAPD7mHtQ/JLhTvNmfGwkulYbi4c0Ykk+slvtqk/8n+79RdyY1XrNeMYV
	 x3Ot6cAEjcOWNsHS+ZEYTR/oYSxbELxmctO1gh9A=
Date: Sat, 13 Sep 2025 17:35:16 -0700
To: mm-commits@vger.kernel.org,yaoma@linux.alibaba.com,tglx@linutronix.de,max.kellermann@ionos.com,lihuafei1@huawei.com,yaozhenguo1@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-softlockup-fix-incorrect-cpu-utilization-output-during-softlockup.patch removed from -mm tree
Message-Id: <20250914003516.BAA90C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog/softlockup: fix incorrect CPU utilization output during softlockup
has been removed from the -mm tree.  Its filename was
     watchdog-softlockup-fix-incorrect-cpu-utilization-output-during-softlockup.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhenguoYao <yaozhenguo1@gmail.com>
Subject: watchdog/softlockup: fix incorrect CPU utilization output during softlockup
Date: Tue, 12 Aug 2025 16:25:10 +0800

Since we use 16-bit precision, the raw data will undergo integer division,
which may sometimes result in data loss.  This can lead to slightly
inaccurate CPU utilization calculations.  Under normal circumstances, this
isn't an issue.  However, when CPU utilization reaches 100%, the
calculated result might exceed 100%.  For example, with raw data like the
following:

sample_period 400000134 new_stat 83648414036 old_stat 83247417494

sample_period=400000134/2^24=23
new_stat=83648414036/2^24=4985
old_stat=83247417494/2^24=4961
util=105%

Below log will output：

CPU#3 Utilization every 0s during lockup:
    #1:   0% system,          0% softirq,   105% hardirq,     0% idle
    #2:   0% system,          0% softirq,   105% hardirq,     0% idle
    #3:   0% system,          0% softirq,   100% hardirq,     0% idle
    #4:   0% system,          0% softirq,   105% hardirq,     0% idle
    #5:   0% system,          0% softirq,   105% hardirq,     0% idle

To avoid confusion, we enforce a 100% display cap when calculations exceed
this threshold.

We also round to the nearest multiple of 16.8 milliseconds to improve the
accuracy.

[yaozhenguo1@gmail.com: make get_16bit_precision() more accurate, fix comment layout]
  Link: https://lkml.kernel.org/r/20250818081438.40540-1-yaozhenguo@jd.com
Link: https://lkml.kernel.org/r/20250812082510.32291-1-yaozhenguo@jd.com
Signed-off-by: ZhenguoYao <yaozhenguo1@gmail.com>
Cc: Bitao Hu <yaoma@linux.alibaba.com>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: Max Kellermann <max.kellermann@ionos.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/kernel/watchdog.c~watchdog-softlockup-fix-incorrect-cpu-utilization-output-during-softlockup
+++ a/kernel/watchdog.c
@@ -425,7 +425,11 @@ static DEFINE_PER_CPU(u8, cpustat_tail);
  */
 static u16 get_16bit_precision(u64 data_ns)
 {
-	return data_ns >> 24LL; /* 2^24ns ~= 16.8ms */
+	/*
+	 * 2^24ns ~= 16.8ms
+	 * Round to the nearest multiple of 16.8 milliseconds.
+	 */
+	return (data_ns + (1 << 23)) >> 24LL;
 }
 
 static void update_cpustat(void)
@@ -444,6 +448,14 @@ static void update_cpustat(void)
 		old_stat = __this_cpu_read(cpustat_old[i]);
 		new_stat = get_16bit_precision(cpustat[tracked_stats[i]]);
 		util = DIV_ROUND_UP(100 * (new_stat - old_stat), sample_period_16);
+		/*
+		 * Since we use 16-bit precision, the raw data will undergo
+		 * integer division, which may sometimes result in data loss,
+		 * and then result might exceed 100%. To avoid confusion,
+		 * we enforce a 100% display cap when calculations exceed this threshold.
+		 */
+		if (util > 100)
+			util = 100;
 		__this_cpu_write(cpustat_util[tail][i], util);
 		__this_cpu_write(cpustat_old[i], new_stat);
 	}
_

Patches currently in -mm which might be from yaozhenguo1@gmail.com are


