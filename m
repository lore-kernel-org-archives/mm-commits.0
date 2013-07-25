From: akpm@linux-foundation.org
Subject: [merged]
 drivers-thermal-x86_pkg_temp_thermalc-fix-lockup-of-cpu_down.patch removed
 from -mm tree
Date: Thu, 25 Jul 2013 13:38:46 -0700
Message-ID: <51f18cd6.d/odMZ1nW6XK3bV3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3GYUiu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Jul 2013 16:38:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, srinivas.pandruvada@linux.intel.com, rui.zhang@intel.com, rostedt@goodmis.org

Subject: [merged] drivers-thermal-x86_pkg_temp_thermalc-fix-lockup-of-cpu_down.patch removed from -mm tree
To: rostedt@goodmis.org,rui.zhang@intel.com,srinivas.pandruvada@linux.intel.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 25 Jul 2013 13:38:46 -0700


The patch titled
     Subject: drivers/thermal/x86_pkg_temp_thermal.c: fix lockup of cpu_down()
has been removed from the -mm tree.  Its filename was
     drivers-thermal-x86_pkg_temp_thermalc-fix-lockup-of-cpu_down.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
relay-fix-timer-madness.patch
relay-fix-timer-madness-v2.patch
linux-next.patch

