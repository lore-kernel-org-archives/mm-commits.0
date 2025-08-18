Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B8A244664
	for <mm-commits@vger.kernel.org>; Mon, 18 Aug 2025 02:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755482964; cv=none; b=DMMiyRp4NGgbYCOaOJks79JjIu/ib0eZ0wo5UsaH+bz+/uEg61oEBGvKPZrpiNs+/XhO8KZRqw//tnWtEARRxepfrv2X36fy+3o51vVFRJA3cVnFcoeaRYXMomBaB1UJOMoYtCmnpfi0n7jLLf/Y2gyuRgA3lnlIQSYdNZoDqTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755482964; c=relaxed/simple;
	bh=XLmVUfHj8RY8CNHR3QUDGm8rRjOUhgTus/Q+f+tPusg=;
	h=Date:To:From:Subject:Message-Id; b=l3KT3Z+seidDcUwm+NYfZ6RGskPV9dXF2Vpmc4nLr7PXZlHguOeZiPQqcUOU8xdgnTI2JJ0rCa/c05pvJkyPa+7kr8yciBHiVnQm/Y/cUtefA131jgDwHW1RXTw+2qc51j9mtTKAvTGyhzT92F6oi5lorfRek5f6X9BCTzo4yuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iFFYmNNA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iFFYmNNA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42873C4CEEB;
	Mon, 18 Aug 2025 02:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755482963;
	bh=XLmVUfHj8RY8CNHR3QUDGm8rRjOUhgTus/Q+f+tPusg=;
	h=Date:To:From:Subject:From;
	b=iFFYmNNADPDuoGkZlfBdhAWA3eiHJmQpn7Rc5SHx2v6jYKuDdSh9Y26ByLp+R7tEC
	 er49Rjp37e0bOE07KgSI//5Wqsz6CoQRHVBrPmyxubtTva2dp/cHC4O43WBuVLbWDS
	 FZZIthd83Ph3Th7WotupFzMBq7+jd/EO5K648ymU=
Date: Sun, 17 Aug 2025 19:09:22 -0700
To: mm-commits@vger.kernel.org,yaoma@linux.alibaba.com,tglx@linutronix.de,max.kellermann@ionos.com,lihuafei1@huawei.com,yaozhenguo1@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-softlockup-fix-wrong-output-when-watchdog_thresh-3.patch added to mm-nonmm-unstable branch
Message-Id: <20250818020923.42873C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog/softlockup: fix wrong output when watchdog_thresh < 3
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-softlockup-fix-wrong-output-when-watchdog_thresh-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-softlockup-fix-wrong-output-when-watchdog_thresh-3.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

watchdog-softlockup-fix-wrong-output-when-watchdog_thresh-3.patch

