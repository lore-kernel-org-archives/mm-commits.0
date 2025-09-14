Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B566B33987
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810115; cv=none; b=EY9gelUPuAdKg6oIOTwDEZwCE3yUWrN5+aXtYxxq0f2GvdmoEzFyzWg2Ux/qI3yB6rTSAaWx+NzqOL2Sdy9hVdoGgTWymlr5YZk42EoEdy6afEeRrbrK3PbBVXUfh4KZ0e/1r3ROF7RfAxFaKdXK0cmCXG2aMfb5WUl7knv9fVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810115; c=relaxed/simple;
	bh=YqWpNOoqREe1BhkD6Kqs2ZOz7I2ZJEmnU04KF9Bpmzc=;
	h=Date:To:From:Subject:Message-Id; b=mtYgNmmec9lwMMdBewmoO445z+k/RG3UDiQRaN6Dl/iNP1c4Llbbq+qIsj592iOVl9HSuifbusehKud/fkK5947Uo47rZb7iNQaIian60VxBy4ETPRXG2TYxwbwcnEY8cF9Lkrm2B2q4HoxjAnptNVTPaYkhIoX4q8Bo3w0UqE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f6ZKec28; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f6ZKec28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A05CC4CEF7;
	Sun, 14 Sep 2025 00:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810115;
	bh=YqWpNOoqREe1BhkD6Kqs2ZOz7I2ZJEmnU04KF9Bpmzc=;
	h=Date:To:From:Subject:From;
	b=f6ZKec28qeNvRMrCneKWE65B9PRH+ilvk173vRRnC92y1UtxGFGL0UXVSupQIt7gF
	 EA0Rg8y+SKkAdqg3KCph6ckfyUNWSyS0XZhu/ki0Xyz+0MNhpmE3oTBm2NcnaS/nvC
	 mdic558KDkJiiNEL4u5mryxoSamjQC+3FQKWH7hU=
Date: Sat, 13 Sep 2025 17:35:15 -0700
To: mm-commits@vger.kernel.org,yaoma@linux.alibaba.com,tglx@linutronix.de,max.kellermann@ionos.com,lihuafei1@huawei.com,yaozhenguo1@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-softlockup-fix-wrong-output-when-watchdog_thresh-3.patch removed from -mm tree
Message-Id: <20250914003515.8A05CC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog/softlockup: fix wrong output when watchdog_thresh < 3
has been removed from the -mm tree.  Its filename was
     watchdog-softlockup-fix-wrong-output-when-watchdog_thresh-3.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhenguoYao <yaozhenguo1@gmail.com>
Subject: watchdog/softlockup: fix wrong output when watchdog_thresh < 3
Date: Tue, 12 Aug 2025 15:41:32 +0800

When watchdog_thresh is below 3, sample_period will be less than 1 second.
So the following output will print when softlockup:

CPU#3 Utilization every 0s during lockup

Fix this by changing time unit from seconds to milliseconds.

Link: https://lkml.kernel.org/r/20250812074132.27810-1-yaozhenguo@jd.com
Signed-off-by: ZhenguoYao <yaozhenguo1@gmail.com>
Cc: Bitao Hu <yaoma@linux.alibaba.com>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: Max Kellermann <max.kellermann@ionos.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/watchdog.c~watchdog-softlockup-fix-wrong-output-when-watchdog_thresh-3
+++ a/kernel/watchdog.c
@@ -455,17 +455,17 @@ static void print_cpustat(void)
 {
 	int i, group;
 	u8 tail = __this_cpu_read(cpustat_tail);
-	u64 sample_period_second = sample_period;
+	u64 sample_period_msecond = sample_period;
 
-	do_div(sample_period_second, NSEC_PER_SEC);
+	do_div(sample_period_msecond, NSEC_PER_MSEC);
 
 	/*
 	 * Outputting the "watchdog" prefix on every line is redundant and not
 	 * concise, and the original alarm information is sufficient for
 	 * positioning in logs, hence here printk() is used instead of pr_crit().
 	 */
-	printk(KERN_CRIT "CPU#%d Utilization every %llus during lockup:\n",
-	       smp_processor_id(), sample_period_second);
+	printk(KERN_CRIT "CPU#%d Utilization every %llums during lockup:\n",
+	       smp_processor_id(), sample_period_msecond);
 
 	for (i = 0; i < NUM_SAMPLE_PERIODS; i++) {
 		group = (tail + i) % NUM_SAMPLE_PERIODS;
_

Patches currently in -mm which might be from yaozhenguo1@gmail.com are


