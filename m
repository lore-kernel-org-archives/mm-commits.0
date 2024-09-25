Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C141C6F2F2
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 09:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727258380; cv=none; b=hpaCc+3l6uFhpQztat79qJEvnbQ6VUav1M1rJiv2wbfHxm1/ddfPeYUHMDvk0LqMG6IrQzPy4iYUXebtJWlYfYb1vR5pZiZH4cv98R5ZIds1mv3dZza3dKkXb/c7ZYPKFv+MkqVr1ZZMTag8GjtSYcFt5/U+wIwZ0JZ9xtBFkAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727258380; c=relaxed/simple;
	bh=WcHHb0M2PXjD3YvbdXOt2F8h6UsfkdYhb7jWWwV3+MU=;
	h=Date:To:From:Subject:Message-Id; b=FuIFhGEGUAxinhUtqylozJuJRSIj31Ik/WkeUJYPFdH6uQexCs9XX1vTuTWTO37X+0QvK3AR4wS683D8zagujfk+SRHMqMgEI6sDyZ/cie4MpD6TDV3vmHYgjqe+DbjgPWegVpZRAc+uW+vShDU02R1xaIySra3aC4Apt/wwZPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0mJzoYx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0mJzoYx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387C9C4CEC3;
	Wed, 25 Sep 2024 09:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727258380;
	bh=WcHHb0M2PXjD3YvbdXOt2F8h6UsfkdYhb7jWWwV3+MU=;
	h=Date:To:From:Subject:From;
	b=0mJzoYx0dy2q0h2H/kw2goDq2D2uOgobI//kxRV/352uozeRlR6pQLiFdFEZNcSAZ
	 iQwpno9b3Q0ccbCmwsrSuFj/3svocUEQUgbEVz6BrXz2fIju3SHPALt2T/4tp6QXF5
	 tK8sGbQnJCdi6sfAS5B7/zlrqRdCE+6ZKDc0SCdc=
Date: Wed, 25 Sep 2024 02:59:39 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,tglx@linutronix.de,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mgorman@suse.de,mcgrof@kernel.org,lizhe.67@bytedance.com,linux@weissschuh.net,kjlx@templeofstupid.com,juri.lelli@redhat.com,john.ogness@linutronix.de,dietmar.eggemann@arm.com,dianders@chromium.org,bsegall@google.com,bristot@redhat.com,tiozhang@didiglobal.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-watchdog-always-restore-watchdog_softlockuphardlockup_user_enabled-after-proc-show.patch added to mm-nonmm-unstable branch
Message-Id: <20240925095940.387C9C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/watchdog: always restore watchdog_softlockup(,hardlockup)_user_enabled after proc show
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-watchdog-always-restore-watchdog_softlockuphardlockup_user_enabled-after-proc-show.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-watchdog-always-restore-watchdog_softlockuphardlockup_user_enabled-after-proc-show.patch

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
From: Tio Zhang <tiozhang@didiglobal.com>
Subject: kernel/watchdog: always restore watchdog_softlockup(,hardlockup)_user_enabled after proc show
Date: Fri, 6 Sep 2024 17:47:00 +0800

Otherwise when watchdog_enabled becomes 0,
watchdog_softlockup(,hardlockup)_user_enabled will changes to 0 after proc
show.

Steps to reproduce:

  step 1:
  # cat /proc/sys/kernel/*watchdog
  1
  1
  1

  | name                             | value
  |----------------------------------|--------------------------
  | watchdog_enabled                 | 1
  |----------------------------------|--------------------------
  | watchdog_hardlockup_user_enabled | 1
  |----------------------------------|--------------------------
  | watchdog_softlockup_user_enabled | 1
  |----------------------------------|--------------------------
  | watchdog_user_enabled            | 1
  |----------------------------------|--------------------------

  step 2:
  # echo 0 > /proc/sys/kernel/watchdog

  | name                             | value
  |----------------------------------|--------------------------
  | watchdog_enabled                 | 0
  |----------------------------------|--------------------------
  | watchdog_hardlockup_user_enabled | 1
  |----------------------------------|--------------------------
  | watchdog_softlockup_user_enabled | 1
  |----------------------------------|--------------------------
  | watchdog_user_enabled            | 0
  |----------------------------------|--------------------------

  step 3:
  # cat /proc/sys/kernel/*watchdog
  0
  0
  0

  | name                             | value
  |----------------------------------|--------------------------
  | watchdog_enabled                 | 0
  |----------------------------------|--------------------------
  | watchdog_hardlockup_user_enabled | 0
  |----------------------------------|--------------------------
  | watchdog_softlockup_user_enabled | 0
  |----------------------------------|--------------------------
  | watchdog_user_enabled            | 0
  |----------------------------------|--------------------------

  step 4:
  # echo 1 > /proc/sys/kernel/watchdog

  | name                             | value
  |----------------------------------|--------------------------
  | watchdog_enabled                 | 0
  |----------------------------------|--------------------------
  | watchdog_hardlockup_user_enabled | 0
  |----------------------------------|--------------------------
  | watchdog_softlockup_user_enabled | 0
  |----------------------------------|--------------------------
  | watchdog_user_enabled            | 0
  |----------------------------------|--------------------------

  step 5:
  # cat /proc/sys/kernel/*watchdog
  0
  0
  0

If we dont do "step 3", do "step 4" right after "step 2", it will be

  | name                             | value
  |----------------------------------|--------------------------
  | watchdog_enabled                 | 1
  |----------------------------------|--------------------------
  | watchdog_hardlockup_user_enabled | 1
  |----------------------------------|--------------------------
  | watchdog_softlockup_user_enabled | 1
  |----------------------------------|--------------------------
  | watchdog_user_enabled            | 1
  |----------------------------------|--------------------------

then everything works correctly.

So this patch fix "step 3"'s value into

| name                             | value
|----------------------------------|--------------------------
| watchdog_enabled                 | 0
|----------------------------------|--------------------------
| watchdog_hardlockup_user_enabled | 1
|----------------------------------|--------------------------
| watchdog_softlockup_user_enabled | 1
|----------------------------------|--------------------------
| watchdog_user_enabled            | 0
|----------------------------------|--------------------------

And still print 0 as before.

Link: https://lkml.kernel.org/r/20240906094700.GA30052@didi-ThinkCentre-M930t-N000
Signed-off-by: Tio Zhang <tiozhang@didiglobal.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Krister Johansen <kjlx@templeofstupid.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/watchdog.c~kernel-watchdog-always-restore-watchdog_softlockuphardlockup_user_enabled-after-proc-show
+++ a/kernel/watchdog.c
@@ -990,6 +990,7 @@ static int proc_watchdog_common(int whic
 
 	mutex_lock(&watchdog_mutex);
 
+	old = *param;
 	if (!write) {
 		/*
 		 * On read synchronize the userspace interface. This is a
@@ -997,8 +998,8 @@ static int proc_watchdog_common(int whic
 		 */
 		*param = (watchdog_enabled & which) != 0;
 		err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+		*param = old;
 	} else {
-		old = READ_ONCE(*param);
 		err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 		if (!err && old != READ_ONCE(*param))
 			proc_watchdog_update();
_

Patches currently in -mm which might be from tiozhang@didiglobal.com are

kernel-watchdog-always-restore-watchdog_softlockuphardlockup_user_enabled-after-proc-show.patch

