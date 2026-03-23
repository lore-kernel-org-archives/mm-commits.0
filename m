Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319B95C613
	for <mm-commits@vger.kernel.org>; Mon, 23 Mar 2026 23:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774308270; cv=none; b=Go/1SFAG7BdneBRWmfDxcDmeELToqXpVsD54cBBQtp7XNSbHdbs4ZwELyHwojUssFj/Rpj8c5wVXuB1cZHgNvdEv1H1SxUx30tK6A12YAbfkE3pu5PnsaaSANKCpJ9dW9eFIm8E7jHe/txOjdlvn8Exb9CdTXrIZXoLJ7DVqj7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774308270; c=relaxed/simple;
	bh=Bp7UJln7g9LZBGouSSZytmwt7Vq4e2DdOol1V8op56k=;
	h=Date:To:From:Subject:Message-Id; b=BhMa1Vpx5GKoRxdKoKa26XzI+JMdlSRGEffpljvMHtPZWwv4xj3s0HT6AKFtTeXC/0vNOxVJ3X1QArRNAxm5PMBeIRKuxcqvAgv9y3sx66f7cRZpPDxJLPJp5RUgQxSdHcO4AQSY0Alf4BVsfkdzWg7rIuHRw/u82swB5DFyVLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2VTLcTIs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2VTLcTIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61F0C4CEF7;
	Mon, 23 Mar 2026 23:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774308269;
	bh=Bp7UJln7g9LZBGouSSZytmwt7Vq4e2DdOol1V8op56k=;
	h=Date:To:From:Subject:From;
	b=2VTLcTIsSJiBaBxT8vCJS3NTJ4zj2Xgf+tBB3dob3/ptjlLVGo/RxImA9AnyjNJ1n
	 2ctMVLG4AiyLig+D8a3Rx5Hm/LYZU2vNC18CUBodqqY6Og0aa7zDfIlG1c7sCP2rQK
	 xhOh1nncVMdA2ptWd+21xqxBB0JPbCQeujd/mhRo=
Date: Mon, 23 Mar 2026 16:24:29 -0700
To: mm-commits@vger.kernel.org,wangjinchao600@gmail.com,skhan@linuxfoundation.org,mrungta@google.com,max.kellermann@ionos.com,lihuafei1@huawei.com,irogers@google.com,eranian@google.com,dianders@chromium.org,cuiyunhui@bytedance.com,corbet@lwn.net,pmladek@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + doc-watchdog-futher-improvements.patch added to mm-nonmm-unstable branch
Message-Id: <20260323232429.B61F0C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: doc: watchdog: futher improvements
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     doc-watchdog-futher-improvements.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/doc-watchdog-futher-improvements.patch

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
From: Petr Mladek <pmladek@suse.com>
Subject: doc: watchdog: futher improvements
Date: Mon, 23 Mar 2026 18:21:38 +0100

Make further additions and alterations to the watchdog documentation.

Link: https://lkml.kernel.org/r/acF3tXBxSr0KOP9b@pathway.suse.cz
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: Max Kellermann <max.kellermann@ionos.com>
Cc: Mayank Rungta <mrungta@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Stephane Erainan <eranian@google.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Yunhui Cui <cuiyunhui@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/lockup-watchdogs.rst |   38 ++++++++-------
 1 file changed, 21 insertions(+), 17 deletions(-)

--- a/Documentation/admin-guide/lockup-watchdogs.rst~doc-watchdog-futher-improvements
+++ a/Documentation/admin-guide/lockup-watchdogs.rst
@@ -41,32 +41,36 @@ is a trade-off between fast response to
 Implementation
 ==============
 
-The soft lockup detector is built on top of the hrtimer subsystem.
-The hard lockup detector is built on top of the perf subsystem
-(on architectures that support it) or uses an SMP "buddy" system.
+The soft and hard lockup detectors are built around a hrtimer.
+In addition, the softlockup detector regularly schedules a job, and
+the hard lockup detector might use Perf/NMI events on architectures
+that support it.
+
+Frequency and Heartbeats
+------------------------
+
+The core of the detectors in a hrtimer. It servers multiple purpose:
+
+- schedules watchdog job for the softlockup detector
+- bumps the interrupt counter for hardlockup detectors (heartbeat)
+- detects softlockups
+- detects hardlockups in Buddy mode
+
+The period of this hrtimer is 2*watchdog_thresh/5, which is 4 seconds
+by default. The hrtimer has two or three chances to generate an interrupt
+(heartbeat) before the hardlockup detector kicks in.
 
 Softlockup Detector
 -------------------
 
-The watchdog job runs in a stop scheduling thread that updates a
-timestamp every time it is scheduled. If that timestamp is not updated
-for 2*watchdog_thresh seconds (the softlockup threshold) the
+The watchdog job is scheduled by the hrtimer and runs in a stop scheduling
+thread. It updates a timestamp every time it is scheduled. If that timestamp
+is not updated for 2*watchdog_thresh seconds (the softlockup threshold) the
 'softlockup detector' (coded inside the hrtimer callback function)
 will dump useful debug information to the system log, after which it
 will call panic if it was instructed to do so or resume execution of
 other kernel code.
 
-Frequency and Heartbeats
-------------------------
-
-The hrtimer used by the softlockup detector serves a dual purpose:
-it detects softlockups, and it also generates the interrupts
-(heartbeats) that the hardlockup detectors use to verify CPU liveness.
-
-The period of this hrtimer is 2*watchdog_thresh/5. This means the
-hrtimer has two or three chances to generate an interrupt before the
-NMI hardlockup detector kicks in.
-
 Hardlockup Detector (NMI/Perf)
 ------------------------------
 
_

Patches currently in -mm which might be from pmladek@suse.com are

hung_task-increment-the-global-counter-immediately.patch
doc-watchdog-futher-improvements.patch

