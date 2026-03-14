Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734CD38AC8F
	for <mm-commits@vger.kernel.org>; Sat, 14 Mar 2026 23:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773531202; cv=none; b=qAIBWIQwuJH9XxhzHY0KbGRhVGqZUKTjPQe/Qt1pnusqBDRw8EjR7gaSzwiXXa7tdlkB0mXNxhXc/DGqIDUQpoX+pOmqHKuvR52aHaLFOijDnMC10A5Vd951t+8vlh0aA8fjSfD7NH/pujIC2IL1x+zamRUeh5p27DLKxzZGT3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773531202; c=relaxed/simple;
	bh=ys+J0JrWRA/yZuk1FBELIkc3FfzbUK5i62EcwhBLM38=;
	h=Date:To:From:Subject:Message-Id; b=J6HOmG1dxkEXdAIWWD5vYU7jSBBd+gBkJBpCUVLVZPrpi3Svd4Jux3QxVOf4NEr679leah/zKhZJzCD8MplPOo8BSAakg27zQnO3MTriZxiLoguK5XU3+uQOalotlRb1Qm3meI1aglqrtMMnHLsblproD9GJgYaV3+VXVaGHj9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sHendkeH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sHendkeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068E5C116C6;
	Sat, 14 Mar 2026 23:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773531202;
	bh=ys+J0JrWRA/yZuk1FBELIkc3FfzbUK5i62EcwhBLM38=;
	h=Date:To:From:Subject:From;
	b=sHendkeHKE6SFWzI+dbxVuOOwVByMtN/EQwTCHL9Cy3BGGGafiW0Du/iCGr9SHHVr
	 vnzDowaad5ucpNWwDWFum1EOOApC/+7GDT14gk/oFI71s2fG0VGVFd0Mknlsz/xuTR
	 9gv8U2+61kMtEYngKS9J+lnOGXE7x8T7+Z39ltlk=
Date: Sat, 14 Mar 2026 16:33:20 -0700
To: mm-commits@vger.kernel.org,wangjinchao600@gmail.com,skhan@linuxfoundation.org,pmladek@suse.com,max.kellermann@ionos.com,lihuafei1@huawei.com,irogers@google.com,eranian@google.com,dianders@chromium.org,cuiyunhui@bytedance.com,corbet@lwn.net,mrungta@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-update-saved-interrupts-during-check.patch added to mm-nonmm-unstable branch
Message-Id: <20260314233322.068E5C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog: Update saved interrupts during check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-update-saved-interrupts-during-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-update-saved-interrupts-during-check.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Mayank Rungta <mrungta@google.com>
Subject: watchdog: Update saved interrupts during check
Date: Thu, 12 Mar 2026 16:22:03 -0700

Currently, arch_touch_nmi_watchdog() causes an early return that skips
updating hrtimer_interrupts_saved.  This leads to stale comparisons and
delayed lockup detection.

I found this issue because in our system the serial console is fairly
chatty.  For example, the 8250 console driver frequently calls
touch_nmi_watchdog() via console_write().  If a CPU locks up after a timer
interrupt but before next watchdog check, we see the following sequence:

  * watchdog_hardlockup_check() saves counter (e.g., 1000)
  * Timer runs and updates the counter (1001)
  * touch_nmi_watchdog() is called
  * CPU locks up
  * 10s pass: check() notices touch, returns early, skips update
  * 10s pass: check() saves counter (1001)
  * 10s pass: check() finally detects lockup

This delays detection to 30 seconds.  With this fix, we detect the lockup
in 20 seconds.

Link: https://lkml.kernel.org/r/20260312-hardlockup-watchdog-fixes-v2-2-45bd8a0cc7ed@google.com
Signed-off-by: Mayank Rungta <mrungta@google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: Max Kellermann <max.kellermann@ionos.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Stephane Erainan <eranian@google.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Yunhui Cui <cuiyunhui@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/kernel/watchdog.c~watchdog-update-saved-interrupts-during-check
+++ a/kernel/watchdog.c
@@ -159,21 +159,28 @@ void watchdog_hardlockup_touch_cpu(unsig
 	per_cpu(watchdog_hardlockup_touched, cpu) = true;
 }
 
-static bool is_hardlockup(unsigned int cpu)
+static void watchdog_hardlockup_update(unsigned int cpu)
 {
 	int hrint = atomic_read(&per_cpu(hrtimer_interrupts, cpu));
 
-	if (per_cpu(hrtimer_interrupts_saved, cpu) == hrint)
-		return true;
-
 	/*
 	 * NOTE: we don't need any fancy atomic_t or READ_ONCE/WRITE_ONCE
 	 * for hrtimer_interrupts_saved. hrtimer_interrupts_saved is
 	 * written/read by a single CPU.
 	 */
 	per_cpu(hrtimer_interrupts_saved, cpu) = hrint;
+}
+
+static bool is_hardlockup(unsigned int cpu)
+{
+	int hrint = atomic_read(&per_cpu(hrtimer_interrupts, cpu));
+
+	if (per_cpu(hrtimer_interrupts_saved, cpu) != hrint) {
+		watchdog_hardlockup_update(cpu);
+		return false;
+	}
 
-	return false;
+	return true;
 }
 
 static void watchdog_hardlockup_kick(void)
@@ -191,6 +198,7 @@ void watchdog_hardlockup_check(unsigned
 	unsigned long flags;
 
 	if (per_cpu(watchdog_hardlockup_touched, cpu)) {
+		watchdog_hardlockup_update(cpu);
 		per_cpu(watchdog_hardlockup_touched, cpu) = false;
 		return;
 	}
_

Patches currently in -mm which might be from mrungta@google.com are

watchdog-return-early-in-watchdog_hardlockup_check.patch
watchdog-update-saved-interrupts-during-check.patch
doc-watchdog-clarify-hardlockup-detection-timing.patch
watchdog-hardlockup-improve-buddy-system-detection-timeliness.patch
doc-watchdog-document-buddy-detector.patch

