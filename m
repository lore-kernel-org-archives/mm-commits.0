Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3ED18858C
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855603; cv=none; b=RZkPlkM4T3N1vyKCKUmasA13gYcREReb6v0+pWsHtJjSsZp+KhbVyXu2yoTLnnTOZ2cK6JIA7JmSE40t+xb4Ij1cUE0rZQ0Y9hqPDNBxm2jPuJ/jKOE0GaXSYGUhkypz8l9OtPvGoUu8XRL7uDXoo94wtgmpFAshK+/Uvs3YGMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855603; c=relaxed/simple;
	bh=abqzUEwD75yd6bjHrBVNpdlKV454QbVKJiuL9i6KXeg=;
	h=Date:To:From:Subject:Message-Id; b=M1VslegVWhPFzVHvlnVo8NF0nMDahnkJQsc3H6HnR/nMa9hij3+3NXOqZDUYSdYmWB1hCY9MWLlAgBmM0PA9T0zi3j5/3m5C+1ouo7luH0t4GA5bxmZisKLd8gsQ4IwIFFecz3Hny6FExy++maYR1bQlFJeMHSoZq4rTqA4x3PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kPYl5TfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kPYl5TfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EB1C4CECF;
	Wed,  6 Nov 2024 01:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855602;
	bh=abqzUEwD75yd6bjHrBVNpdlKV454QbVKJiuL9i6KXeg=;
	h=Date:To:From:Subject:From;
	b=kPYl5TfLorEedg2wu0eK4Azcp2vIlsAh6GiKOqhTxxI5owBpDz0RSz8YF0KdZOsvi
	 R+Rybgya+RHrybXHsHJhytBny+8sO5KhfNsldZoveYv8Ebtmi+J31WUw33Eu/hAn9L
	 Kyd2mjRONPRO95B0ZQBNCVRVAHbikaPESnYFVybo=
Date: Tue, 05 Nov 2024 17:13:22 -0800
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,tglx@linutronix.de,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mgorman@suse.de,mcgrof@kernel.org,lizhe.67@bytedance.com,linux@weissschuh.net,kjlx@templeofstupid.com,juri.lelli@redhat.com,john.ogness@linutronix.de,dietmar.eggemann@arm.com,dianders@chromium.org,bsegall@google.com,bristot@redhat.com,tiozhang@didiglobal.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-watchdog-always-restore-watchdog_softlockuphardlockup_user_enabled-after-proc-show.patch removed from -mm tree
Message-Id: <20241106011322.D8EB1C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/watchdog: always restore watchdog_softlockup(,hardlockup)_user_enabled after proc show
has been removed from the -mm tree.  Its filename was
     kernel-watchdog-always-restore-watchdog_softlockuphardlockup_user_enabled-after-proc-show.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


