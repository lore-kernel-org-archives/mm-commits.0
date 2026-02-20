Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E39B264617
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 21:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771622451; cv=none; b=SuhYT81rX8hwiV20brZphBo/8LW1HXx2fA3CqG0gJBwiYfXTU+bseW6BBEgWxpOpFfUJZZyhUx7FXflb2zFztnFte5TrKQWcQV3tZb7TRIoI9BiUXKlSd/eIb0RZbdYYeSWb3aN7kB7ry6SE80/JjMVGcRlThB/UXqVv68Bqkn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771622451; c=relaxed/simple;
	bh=QBPQcaXQoRBMAIQ0L6iAMwxd4MpZf971s7dCK78ol/M=;
	h=Date:To:From:Subject:Message-Id; b=GY9NLcyfmEYQdsXWSnsKkl3OYeW9rEg7UpXrs5gPpWj+Pah4QWvpYJHuuicDzJWmLIuMB/tQixTq2MEs6pkvPHQDq3m0q5EOspIcwwSjs1yTQhAL0M5HxeWQjqtNwLEKBdpeXvwUaj4xkzbrD+/jTHORzXgx0y6/UMqQgGK9mO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jy6RS299; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jy6RS299"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB969C116C6;
	Fri, 20 Feb 2026 21:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771622450;
	bh=QBPQcaXQoRBMAIQ0L6iAMwxd4MpZf971s7dCK78ol/M=;
	h=Date:To:From:Subject:From;
	b=jy6RS299Z1D4SMyoVfZJ+FgeoW5C1rmQtHYieDrpLwDQML3lkTRinek/RxbUxpq8x
	 VisTu/H02YGbMPXdLzoHxqia3J+8qd6duxcy8flpvZ8CzAZlVST8+gSiyfajVY5DKb
	 aWngdce4psDzk6OlwKiQKuwlQWKpFASRpOlNJ0pM=
Date: Fri, 20 Feb 2026 13:20:50 -0800
To: mm-commits@vger.kernel.org,wangjinchao600@gmail.com,pmladek@suse.com,max.kellermann@ionos.com,lihuafei1@huawei.com,irogers@google.com,eranian@google.com,dianders@chromium.org,cuiyunhui@bytedance.com,corbet@lwn.net,mrungta@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + doc-watchdog-document-buddy-detector.patch added to mm-nonmm-unstable branch
Message-Id: <20260220212050.BB969C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: doc: watchdog: document buddy detector
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     doc-watchdog-document-buddy-detector.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/doc-watchdog-document-buddy-detector.patch

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
Subject: doc: watchdog: document buddy detector
Date: Thu, 12 Feb 2026 14:12:13 -0700

The current documentation generalizes the hardlockup detector as primarily
NMI-perf-based and lacks details on the SMP "Buddy" detector.

Update the documentation to add a detailed description of the Buddy
detector, and also restructure the "Implementation" section to explicitly
separate "Softlockup Detector", "Hardlockup Detector (NMI/Perf)", and
"Hardlockup Detector (Buddy)".

Clarify that the softlockup hrtimer acts as the heartbeat generator for
both hardlockup mechanisms and centralize the configuration details in a
"Frequency and Heartbeats" section.

Link: https://lkml.kernel.org/r/20260212-hardlockup-watchdog-fixes-v1-4-745f1dce04c3@google.com
Signed-off-by: Mayank Rungta <mrungta@google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: Max Kellermann <max.kellermann@ionos.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Stephane Erainan <eranian@google.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Yunhui Cui <cuiyunhui@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/lockup-watchdogs.rst |  171 +++++++++------
 1 file changed, 112 insertions(+), 59 deletions(-)

--- a/Documentation/admin-guide/lockup-watchdogs.rst~doc-watchdog-document-buddy-detector
+++ a/Documentation/admin-guide/lockup-watchdogs.rst
@@ -30,22 +30,23 @@ timeout is set through the confusingly n
 to cause the system to reboot automatically after a specified amount
 of time.
 
+Configuration
+=============
+
+A kernel knob is provided that allows administrators to configure
+this period. The "watchdog_thresh" parameter (default 10 seconds)
+controls the threshold. The right value for a particular environment
+is a trade-off between fast response to lockups and detection overhead.
+
 Implementation
 ==============
 
-The soft and hard lockup detectors are built on top of the hrtimer and
-perf subsystems, respectively. A direct consequence of this is that,
-in principle, they should work in any architecture where these
-subsystems are present.
-
-A periodic hrtimer runs to generate interrupts and kick the watchdog
-job. An NMI perf event is generated every "watchdog_thresh"
-(compile-time initialized to 10 and configurable through sysctl of the
-same name) seconds to check for hardlockups. If any CPU in the system
-does not receive any hrtimer interrupt during that time the
-'hardlockup detector' (the handler for the NMI perf event) will
-generate a kernel warning or call panic, depending on the
-configuration.
+The soft lockup detector is built on top of the hrtimer subsystem.
+The hard lockup detector is built on top of the perf subsystem
+(on architectures that support it) or uses an SMP "buddy" system.
+
+Softlockup Detector
+-------------------
 
 The watchdog job runs in a stop scheduling thread that updates a
 timestamp every time it is scheduled. If that timestamp is not updated
@@ -55,53 +56,105 @@ will dump useful debug information to th
 will call panic if it was instructed to do so or resume execution of
 other kernel code.
 
-The period of the hrtimer is 2*watchdog_thresh/5, which means it has
-two or three chances to generate an interrupt before the hardlockup
-detector kicks in.
-
-As explained above, a kernel knob is provided that allows
-administrators to configure the period of the hrtimer and the perf
-event. The right value for a particular environment is a trade-off
-between fast response to lockups and detection overhead.
-
-Detection Overhead
-------------------
-
-The hardlockup detector checks for lockups using a periodic NMI perf
-event. This means the time to detect a lockup can vary depending on
-when the lockup occurs relative to the NMI check window.
-
-**Best Case:**
-In the best case scenario, the lockup occurs just before the first
-heartbeat is due. The detector will notice the missing hrtimer
-interrupt almost immediately during the next check.
-
-::
-
-  Time 100.0: cpu 1 heartbeat
-  Time 100.1: hardlockup_check, cpu1 stores its state
-  Time 103.9: Hard Lockup on cpu1
-  Time 104.0: cpu 1 heartbeat never comes
-  Time 110.1: hardlockup_check, cpu1 checks the state again, should be the same, declares lockup
-
-  Time to detection: ~6 seconds
-
-**Worst Case:**
-In the worst case scenario, the lockup occurs shortly after a valid
-interrupt (heartbeat) which itself happened just after the NMI check.
-The next NMI check sees that the interrupt count has changed (due to
-that one heartbeat), assumes the CPU is healthy, and resets the
-baseline. The lockup is only detected at the subsequent check.
-
-::
-
-  Time 100.0: hardlockup_check, cpu1 stores its state
-  Time 100.1: cpu 1 heartbeat
-  Time 100.2: Hard Lockup on cpu1
-  Time 110.0: hardlockup_check, cpu1 stores its state (misses lockup as state changed)
-  Time 120.0: hardlockup_check, cpu1 checks the state again, should be the same, declares lockup
+Frequency and Heartbeats
+------------------------
+
+The hrtimer used by the softlockup detector serves a dual purpose:
+it detects softlockups, and it also generates the interrupts
+(heartbeats) that the hardlockup detectors use to verify CPU liveness.
+
+The period of this hrtimer is 2*watchdog_thresh/5. This means the
+hrtimer has two or three chances to generate an interrupt before the
+NMI hardlockup detector kicks in.
+
+Hardlockup Detector (NMI/Perf)
+------------------------------
+
+On architectures that support NMI (Non-Maskable Interrupt) perf events,
+a periodic NMI is generated every "watchdog_thresh" seconds.
+
+If any CPU in the system does not receive any hrtimer interrupt
+(heartbeat) during the "watchdog_thresh" window, the 'hardlockup
+detector' (the handler for the NMI perf event) will generate a kernel
+warning or call panic.
+
+**Detection Overhead (NMI):**
+
+The time to detect a lockup can vary depending on when the lockup
+occurs relative to the NMI check window. Examples below assume a watchdog_thresh of 10.
+
+* **Best Case:** The lockup occurs just before the first heartbeat is
+  due. The detector will notice the missing hrtimer interrupt almost
+  immediately during the next check.
+
+  ::
+
+    Time 100.0: cpu 1 heartbeat
+    Time 100.1: hardlockup_check, cpu1 stores its state
+    Time 103.9: Hard Lockup on cpu1
+    Time 104.0: cpu 1 heartbeat never comes
+    Time 110.1: hardlockup_check, cpu1 checks the state again, should be the same, declares lockup
+
+    Time to detection: ~6 seconds
+
+* **Worst Case:** The lockup occurs shortly after a valid interrupt
+  (heartbeat) which itself happened just after the NMI check. The next
+  NMI check sees that the interrupt count has changed (due to that one
+  heartbeat), assumes the CPU is healthy, and resets the baseline. The
+  lockup is only detected at the subsequent check.
+
+  ::
+
+    Time 100.0: hardlockup_check, cpu1 stores its state
+    Time 100.1: cpu 1 heartbeat
+    Time 100.2: Hard Lockup on cpu1
+    Time 110.0: hardlockup_check, cpu1 stores its state (misses lockup as state changed)
+    Time 120.0: hardlockup_check, cpu1 checks the state again, should be the same, declares lockup
+
+    Time to detection: ~20 seconds
+
+Hardlockup Detector (Buddy)
+---------------------------
+
+On architectures or configurations where NMI perf events are not
+available (or disabled), the kernel may use the "buddy" hardlockup
+detector. This mechanism requires SMP (Symmetric Multi-Processing).
+
+In this mode, each CPU is assigned a "buddy" CPU to monitor. The
+monitoring CPU runs its own hrtimer (the same one used for softlockup
+detection) and checks if the buddy CPU's hrtimer interrupt count has
+increased.
+
+To ensure timeliness and avoid false positives, the buddy system performs
+checks at every hrtimer interval (2*watchdog_thresh/5, which is 4 seconds
+by default). It uses a missed-interrupt threshold of 3. If the buddy's
+interrupt count has not changed for 3 consecutive checks, it is assumed
+that the buddy CPU is hardlocked (interrupts disabled). The monitoring
+CPU will then trigger the hardlockup response (warning or panic).
+
+**Detection Overhead (Buddy):**
+
+With a default check interval of 4 seconds (watchdog_thresh = 10):
+
+* **Best case:** Lockup occurs just before a check.
+    Detected in ~8s (0s till 1st check + 4s till 2nd + 4s till 3rd).
+* **Worst case:** Lockup occurs just after a check.
+    Detected in ~12s (4s till 1st check + 4s till 2nd + 4s till 3rd).
+
+**Limitations of the Buddy Detector:**
+
+1.  **All-CPU Lockup:** If all CPUs lock up simultaneously, the buddy
+    detector cannot detect the condition because the monitoring CPUs
+    are also frozen.
+2.  **Stack Traces:** Unlike the NMI detector, the buddy detector
+    cannot directly interrupt the locked CPU to grab a stack trace.
+    It relies on architecture-specific mechanisms (like NMI backtrace
+    support) to try and retrieve the status of the locked CPU. If
+    such support is missing, the log may only show that a lockup
+    occurred without providing the locked CPU's stack.
 
-  Time to detection: ~20 seconds
+Watchdog Core Exclusion
+=======================
 
 By default, the watchdog runs on all online cores.  However, on a
 kernel configured with NO_HZ_FULL, by default the watchdog runs only
_

Patches currently in -mm which might be from mrungta@google.com are

watchdog-hardlockup-always-update-saved-interrupts-during-check.patch
doc-watchdog-clarify-hardlockup-detection-timing.patch
watchdog-hardlockup-improve-buddy-system-detection-timeliness.patch
doc-watchdog-document-buddy-detector.patch

