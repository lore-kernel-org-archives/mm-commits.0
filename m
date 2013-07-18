From: akpm@linux-foundation.org
Subject: +
 drivers-thermal-x86_pkg_temp_thermalc-fix-lockup-of-cpu_down.patch added to -mm tree
Date: Thu, 18 Jul 2013 13:44:02 -0700
Message-ID: <51e85392.1c3bLPcJuHdpBAdd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933559Ab3GRUoD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Jul 2013 16:44:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, srinivas.pandruvada@linux.intel.com, rui.zhang@intel.com, rostedt@goodmis.org

Subject: + drivers-thermal-x86_pkg_temp_thermalc-fix-lockup-of-cpu_down.patch added to -mm tree
To: rostedt@goodmis.org,rui.zhang@intel.com,srinivas.pandruvada@linux.intel.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 18 Jul 2013 13:44:02 -0700


The patch titled
     Subject: drivers/thermal/x86_pkg_temp_thermal.c: fix lockup of cpu_down()
has been added to the -mm tree.  Its filename is
     drivers-thermal-x86_pkg_temp_thermalc-fix-lockup-of-cpu_down.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-thermal-x86_pkg_temp_thermalc-fix-lockup-of-cpu_down.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-thermal-x86_pkg_temp_thermalc-fix-lockup-of-cpu_down.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Steven Rostedt <rostedt@goodmis.org>
Subject: drivers/thermal/x86_pkg_temp_thermal.c: fix lockup of cpu_down()

Commit f1a18a105 ("Thermal: CPU Package temperature thermal") had code
that did a get_online_cpus(), run a loop and then do a put_online_cpus(). 
The problem is that the loop had an error exit that would skip the
put_online_cpus() part.

In the error exit part of the function, it also did a get_online_cpus(),
run a loop and then put_online_cpus().  The only way to get to the error
exit part is with get_online_cpus() already performed.  If this error
condition is hit, the system will be prevented from taking CPUs offline. 
The process taking the CPU offline will lock up hard.

Removing the get_online_cpus() removes the lockup as the hotplug CPU
refcount is back to zero.

This was bisected with ktest.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/x86_pkg_temp_thermal.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/thermal/x86_pkg_temp_thermal.c~drivers-thermal-x86_pkg_temp_thermalc-fix-lockup-of-cpu_down drivers/thermal/x86_pkg_temp_thermal.c
--- a/drivers/thermal/x86_pkg_temp_thermal.c~drivers-thermal-x86_pkg_temp_thermalc-fix-lockup-of-cpu_down
+++ a/drivers/thermal/x86_pkg_temp_thermal.c
@@ -592,7 +592,6 @@ static int __init pkg_temp_thermal_init(
 	return 0;
 
 err_ret:
-	get_online_cpus();
 	for_each_online_cpu(i)
 		put_core_offline(i);
 	put_online_cpus();
_

Patches currently in -mm which might be from rostedt@goodmis.org are

drivers-thermal-x86_pkg_temp_thermalc-fix-lockup-of-cpu_down.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
relay-fix-timer-madness.patch
relay-fix-timer-madness-v2.patch
linux-next.patch

