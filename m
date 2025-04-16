Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58DD165F16
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 02:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744771012; cv=none; b=IrQxkJ4h+2BZ6HyE+7f8PqZ4FZ0A6kGErHw9Xm+NyqLzYC1Yx+4BC1q0UcmloWDDoUUd4D4cZ/8kFHu8C1SAEn4TON0PBLR1crmtu4pBFYbciOf6y/NVMc7WYu/roR44BWGd9XyG7S1+9dXVrszh3gpJuU20KOPfVUN+7TSS4Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744771012; c=relaxed/simple;
	bh=uSVtPPh6bQmCySC4HGJW/CQjOW63f1ccyQ6NdNzib1A=;
	h=Date:To:From:Subject:Message-Id; b=GR8qNnQTGqHMjynUepXR/2gY+ZKMATw1HWJFOb3/bSrAMsJBECQ47PYeKofHGJ9oJisKz/x7lQ+GmXymDsLYpERpDtTIVMEthPyCkErJsLgQj5nbwRO4cUlQeJimBo9z6nnx5sw2Td57euxGCNSvIS4IVX+GPWv1+cQRsY6lhKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aYXjs+EJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aYXjs+EJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE2DC4CEE7;
	Wed, 16 Apr 2025 02:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744771012;
	bh=uSVtPPh6bQmCySC4HGJW/CQjOW63f1ccyQ6NdNzib1A=;
	h=Date:To:From:Subject:From;
	b=aYXjs+EJK9sidAZDXUdMKpXYXUEhLjBkfmORNOAUxo/YCwMA0RJ68LQeAxZy1V8CI
	 r7MN8tBnAhVS2kfaOAydog8vovRlTtZBa+MTYPkkKEG+PpW+w7Vl8u0VqLC3cNgX3X
	 usvEd2iZyAOZ4nLeZnjw657xkYCofnxezgAbjJ98=
Date: Tue, 15 Apr 2025 19:36:51 -0700
To: mm-commits@vger.kernel.org,luogengkun@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-fix-watchdog-may-detect-false-positive-of-softlockup.patch added to mm-nonmm-unstable branch
Message-Id: <20250416023652.0FE2DC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog: fix watchdog may detect false positive of softlockup
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-fix-watchdog-may-detect-false-positive-of-softlockup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-fix-watchdog-may-detect-false-positive-of-softlockup.patch

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
From: Luo Gengkun <luogengkun@huaweicloud.com>
Subject: watchdog: fix watchdog may detect false positive of softlockup
Date: Wed, 16 Apr 2025 01:39:22 +0000

The watchdog may dectect false positive of softlockup because of stop
softlockup after update watchdog_thresh. The problem can be described as
follow:

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

watchdog-fix-watchdog-may-detect-false-positive-of-softlockup.patch

