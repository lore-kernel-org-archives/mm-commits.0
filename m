Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BC5378800
	for <mm-commits@vger.kernel.org>; Sat, 14 Mar 2026 23:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773531204; cv=none; b=Xd8LV3Mf3mARpWpcEC/KLEYDpQk1VU64jlTc3wfE25d9CJ8EWqNwcz1E8OrOa1oa/PDyZSynBZfH7Q4v/LawBoCr65puGe9bIDYJDbXHobqWeYfHxGb83WObuMNfwQni1kQ9ZVfFb7R2Qq8rIfgzjFCbECvSQZTzcg2q2oAAcbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773531204; c=relaxed/simple;
	bh=mDwFAAtJzyFBpZamFsZGWjLgw0rYZ1Y56q7yfgiTki0=;
	h=Date:To:From:Subject:Message-Id; b=BKQ/tCPhCrHazQSpaZit88PxqcJDoNTeoyu5mu08NU+NN5TYmK2Pw3vLdKKCYqmAPr7dsUKl0G8aeoW/IyV3avnVD96OaKisVWI8QbpSJnu86GXLQ4yPUntoLrzuRC0HqLbVE12T6ieIjyWeWv6dLTLrpqclH7gb811p4zUXZOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1h5Nwtc5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1h5Nwtc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24EF7C116C6;
	Sat, 14 Mar 2026 23:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773531204;
	bh=mDwFAAtJzyFBpZamFsZGWjLgw0rYZ1Y56q7yfgiTki0=;
	h=Date:To:From:Subject:From;
	b=1h5Nwtc54A/wuR54nhDJLueJ8HWvU0wdGKdQlmr/d6KHj+Kznb31lYshtjAQ+1JrL
	 LF1dNKnQTvlI9SyZTK4QxPC3iKGWcdUXIUxpY9AL+tGsgQ6KMWbgC7tPCxBihviTBp
	 HjuQTJ6MI8zTpAVhMvf3bD6OKfEbSL9FoNcYjkv8=
Date: Sat, 14 Mar 2026 16:33:23 -0700
To: mm-commits@vger.kernel.org,wangjinchao600@gmail.com,skhan@linuxfoundation.org,pmladek@suse.com,max.kellermann@ionos.com,lihuafei1@huawei.com,irogers@google.com,eranian@google.com,dianders@chromium.org,cuiyunhui@bytedance.com,corbet@lwn.net,mrungta@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + doc-watchdog-clarify-hardlockup-detection-timing.patch added to mm-nonmm-unstable branch
Message-Id: <20260314233324.24EF7C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: doc: watchdog: Clarify hardlockup detection timing
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     doc-watchdog-clarify-hardlockup-detection-timing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/doc-watchdog-clarify-hardlockup-detection-timing.patch

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
Subject: doc: watchdog: Clarify hardlockup detection timing
Date: Thu, 12 Mar 2026 16:22:04 -0700

The current documentation implies that a hardlockup is strictly defined as
looping for "more than 10 seconds." However, the detection mechanism is
periodic (based on `watchdog_thresh`), meaning detection time varies
significantly depending on when the lockup occurs relative to the NMI perf
event.

Update the definition to remove the strict "more than 10 seconds"
constraint in the introduction and defer details to the Implementation
section.

Additionally, add a "Detection Overhead" section illustrating the Best
Case (~6s) and Worst Case (~20s) detection scenarios to provide
administrators with a clearer understanding of the watchdog's latency.

Link: https://lkml.kernel.org/r/20260312-hardlockup-watchdog-fixes-v2-3-45bd8a0cc7ed@google.com
Signed-off-by: Mayank Rungta <mrungta@google.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: Max Kellermann <max.kellermann@ionos.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Stephane Erainan <eranian@google.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Yunhui Cui <cuiyunhui@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/lockup-watchdogs.rst |   41 ++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/lockup-watchdogs.rst~doc-watchdog-clarify-hardlockup-detection-timing
+++ a/Documentation/admin-guide/lockup-watchdogs.rst
@@ -16,7 +16,7 @@ details), and a compile option, "BOOTPAR
 provided for this.
 
 A 'hardlockup' is defined as a bug that causes the CPU to loop in
-kernel mode for more than 10 seconds (see "Implementation" below for
+kernel mode for several seconds (see "Implementation" below for
 details), without letting other interrupts have a chance to run.
 Similarly to the softlockup case, the current stack trace is displayed
 upon detection and the system will stay locked up unless the default
@@ -64,6 +64,45 @@ administrators to configure the period o
 event. The right value for a particular environment is a trade-off
 between fast response to lockups and detection overhead.
 
+Detection Overhead
+------------------
+
+The hardlockup detector checks for lockups using a periodic NMI perf
+event. This means the time to detect a lockup can vary depending on
+when the lockup occurs relative to the NMI check window.
+
+**Best Case:**
+In the best case scenario, the lockup occurs just before the first
+heartbeat is due. The detector will notice the missing hrtimer
+interrupt almost immediately during the next check.
+
+::
+
+  Time 100.0: cpu 1 heartbeat
+  Time 100.1: hardlockup_check, cpu1 stores its state
+  Time 103.9: Hard Lockup on cpu1
+  Time 104.0: cpu 1 heartbeat never comes
+  Time 110.1: hardlockup_check, cpu1 checks the state again, should be the same, declares lockup
+
+  Time to detection: ~6 seconds
+
+**Worst Case:**
+In the worst case scenario, the lockup occurs shortly after a valid
+interrupt (heartbeat) which itself happened just after the NMI check.
+The next NMI check sees that the interrupt count has changed (due to
+that one heartbeat), assumes the CPU is healthy, and resets the
+baseline. The lockup is only detected at the subsequent check.
+
+::
+
+  Time 100.0: hardlockup_check, cpu1 stores its state
+  Time 100.1: cpu 1 heartbeat
+  Time 100.2: Hard Lockup on cpu1
+  Time 110.0: hardlockup_check, cpu1 stores its state (misses lockup as state changed)
+  Time 120.0: hardlockup_check, cpu1 checks the state again, should be the same, declares lockup
+
+  Time to detection: ~20 seconds
+
 By default, the watchdog runs on all online cores.  However, on a
 kernel configured with NO_HZ_FULL, by default the watchdog runs only
 on the housekeeping cores, not the cores specified in the "nohz_full"
_

Patches currently in -mm which might be from mrungta@google.com are

watchdog-return-early-in-watchdog_hardlockup_check.patch
watchdog-update-saved-interrupts-during-check.patch
doc-watchdog-clarify-hardlockup-detection-timing.patch
watchdog-hardlockup-improve-buddy-system-detection-timeliness.patch
doc-watchdog-document-buddy-detector.patch

