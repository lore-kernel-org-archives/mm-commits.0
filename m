Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9309733D4E8
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671960; cv=none; b=L9zd4qSeN81LchjxGOwt1JWUA0E0hiWqZhQeaPD+M4/kcSfEUwSyRHxRRIVH7LPiYKNp83L0kNrZIO9oWeQ3LU13O/Xpw2IkmNEx2rEqym1rHT+yTbfprAl9xrSIv+IUcUIWAHGcaK0zYwW3ERXyMuCJQX+OJiMJXgVDO/WFEtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671960; c=relaxed/simple;
	bh=xAX+RDf/1HOUlNe8Y8mr1U9XdGi4YC1QX9i6Vu0+RGQ=;
	h=Date:To:From:Subject:Message-Id; b=NUq4v0lczPG/nDnPF1LOInd/DaOgXz+Mwtdk7dkbz3wi3DFWWTHOAWpapm8IxrPj1QpHNiE84/Zd0KEzYNLbyOP59zzpKgaPo09MIYrtmwn5JjkXIstmyRefUxD/aKu/gbgDt07mpf8G89j4Icw5MGU2tWRmjyghWO75raopAJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ox7CP4ED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ox7CP4ED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E95C4CEF7;
	Sat, 28 Mar 2026 04:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671960;
	bh=xAX+RDf/1HOUlNe8Y8mr1U9XdGi4YC1QX9i6Vu0+RGQ=;
	h=Date:To:From:Subject:From;
	b=ox7CP4EDYHAeWrhW6m2PX/QSywsLrU7QQlNpL2+43AcRuW76yELeYvwFMSOC6TanR
	 u2i/2QOtbst/kRSkntygPZ+SFxjqb1rS151d/nkp/xD3jAgY6gICKEKmbFboFFBd6d
	 a4clpzF78F2hIFFVPxAluzOMYsSpunkUsj7RG+6A=
Date: Fri, 27 Mar 2026 21:25:59 -0700
To: mm-commits@vger.kernel.org,wangjinchao600@gmail.com,skhan@linuxfoundation.org,pmladek@suse.com,max.kellermann@ionos.com,lihuafei1@huawei.com,irogers@google.com,eranian@google.com,dianders@chromium.org,cuiyunhui@bytedance.com,corbet@lwn.net,mrungta@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] doc-watchdog-clarify-hardlockup-detection-timing.patch removed from -mm tree
Message-Id: <20260328042600.69E95C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: doc: watchdog: clarify hardlockup detection timing
has been removed from the -mm tree.  Its filename was
     doc-watchdog-clarify-hardlockup-detection-timing.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mayank Rungta <mrungta@google.com>
Subject: doc: watchdog: clarify hardlockup detection timing
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


