From: akpm@linux-foundation.org
Subject: - publish-rcutorture-module-parameters-via-sysfs-read-only.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:21:32 -0800
Message-ID: <200703070421.l274LW1q018906@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47036 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161313AbXCGEVf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:21:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh@freedesktop.org, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Publish rcutorture module parameters via sysfs, read-only
has been removed from the -mm tree.  Its filename was
     publish-rcutorture-module-parameters-via-sysfs-read-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Publish rcutorture module parameters via sysfs, read-only
From: Josh Triplett <josh@freedesktop.org>

rcutorture's module parameters currently use permissions of 0, so they
don't show up in /sys/module/rcutorture/parameters.  Change the permissions
on all module parameters to world-readable (0444).

rcutorture does all of its initialization and thread startup when loaded
and relies on the parameters not changing during execution, so they should
not permit writing.  However, reading seems fine.

Signed-off-by: Josh Triplett <josh@freedesktop.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcutorture.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN kernel/rcutorture.c~publish-rcutorture-module-parameters-via-sysfs-read-only kernel/rcutorture.c
--- a/kernel/rcutorture.c~publish-rcutorture-module-parameters-via-sysfs-read-only
+++ a/kernel/rcutorture.c
@@ -60,19 +60,19 @@ static int test_no_idle_hz;	/* Test RCU'
 static int shuffle_interval = 5; /* Interval between shuffles (in sec)*/
 static char *torture_type = "rcu"; /* What RCU implementation to torture. */
 
-module_param(nreaders, int, 0);
+module_param(nreaders, int, 0444);
 MODULE_PARM_DESC(nreaders, "Number of RCU reader threads");
-module_param(nfakewriters, int, 0);
+module_param(nfakewriters, int, 0444);
 MODULE_PARM_DESC(nfakewriters, "Number of RCU fake writer threads");
-module_param(stat_interval, int, 0);
+module_param(stat_interval, int, 0444);
 MODULE_PARM_DESC(stat_interval, "Number of seconds between stats printk()s");
-module_param(verbose, bool, 0);
+module_param(verbose, bool, 0444);
 MODULE_PARM_DESC(verbose, "Enable verbose debugging printk()s");
-module_param(test_no_idle_hz, bool, 0);
+module_param(test_no_idle_hz, bool, 0444);
 MODULE_PARM_DESC(test_no_idle_hz, "Test support for tickless idle CPUs");
-module_param(shuffle_interval, int, 0);
+module_param(shuffle_interval, int, 0444);
 MODULE_PARM_DESC(shuffle_interval, "Number of seconds between shuffles");
-module_param(torture_type, charp, 0);
+module_param(torture_type, charp, 0444);
 MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, srcu)");
 
 #define TORTURE_FLAG "-torture:"
_

Patches currently in -mm which might be from josh@freedesktop.org are

origin.patch
rcutorture-mark-rcu_torture_init-as-__init.patch
