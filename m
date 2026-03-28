Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809BF337BB0
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671965; cv=none; b=L5AvLIyOpWfDyc+DdUjwQQYIjlHHDkN+xzdKBpH9PFZyVhokTpFdHy176Iu0x2E/uH06+DThKLspGSKbAmU4vlRAtTG35cHsLInVN2x9ZVLSYBiRZGM8o3Rvsu/6uquezDn0KY5MkUNFK82I31hSDkz784bCF8sN56z5l9f7oVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671965; c=relaxed/simple;
	bh=7iInZNj4ZvdWHU/hwcjI4mwezcC0JLcze58HcLjZTrU=;
	h=Date:To:From:Subject:Message-Id; b=bDWEY6PasdNPw824Tk6ZtITvagcQgi8M9SXFUl7O96o7OIU3BjEMrmN4YSyN7t9arqEJwFjboFy4a8z20LjXn1xvUocKtsFVr7u5mlIzG6dnMoew62LSbxChFE0gUvp29A48KH875+3DKQ4ceB4oq702hiLKRc/59apMvn0OZqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2Rr6n7az; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2Rr6n7az"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266FDC4CEF7;
	Sat, 28 Mar 2026 04:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671965;
	bh=7iInZNj4ZvdWHU/hwcjI4mwezcC0JLcze58HcLjZTrU=;
	h=Date:To:From:Subject:From;
	b=2Rr6n7azpZ6gbWfN5UP531JHyxmZLgPlo8lN2bnnSde1GovYjErONozCaCePUhgl6
	 FJnZm8TCZ/JVibGAy71fGl5yfOnWnJCs2Dzz5g4Mradvo7yrzf+lXjb+oQMQ8sJGWs
	 Vh8F6vqrxIifQLAvY+v4rSx+gu3NKODwbSPU+Rxw=
Date: Fri, 27 Mar 2026 21:26:04 -0700
To: mm-commits@vger.kernel.org,wangjinchao600@gmail.com,skhan@linuxfoundation.org,mrungta@google.com,max.kellermann@ionos.com,lihuafei1@huawei.com,irogers@google.com,eranian@google.com,dianders@chromium.org,cuiyunhui@bytedance.com,corbet@lwn.net,pmladek@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] doc-watchdog-futher-improvements.patch removed from -mm tree
Message-Id: <20260328042605.266FDC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: doc: watchdog: futher improvements
has been removed from the -mm tree.  Its filename was
     doc-watchdog-futher-improvements.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


