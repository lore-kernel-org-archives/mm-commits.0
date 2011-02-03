From: akpm@linux-foundation.org
Subject: [merged] memsw-deprecate-noswapaccount-kernel-parameter-and-schedule-it-for-removal.patch removed from -mm tree
Date: Thu, 03 Feb 2011 11:45:57 -0800
Message-ID: <201102031945.p13Jjv8P020960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756453Ab1BCTqD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 14:46:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memsw: deprecate noswapaccount kernel parameter and schedule it for removal
has been removed from the -mm tree.  Its filename was
     memsw-deprecate-noswapaccount-kernel-parameter-and-schedule-it-for-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memsw: deprecate noswapaccount kernel parameter and schedule it for removal
From: Michal Hocko <mhocko@suse.cz>

noswapaccount couldn't be used to control memsw for both on/off cases so
we have added swapaccount[=0|1] parameter.  This way we can turn the
feature in two ways noswapaccount resp.  swapaccount=0.  We have kept the
original noswapaccount but I think we should remove it after some time as
it just makes more command line parameters without any advantages and also
the code to handle parameters is uglier if we want both parameters.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Requested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   16 ++++++++++++++++
 mm/memcontrol.c                            |    1 +
 2 files changed, 17 insertions(+)

diff -puN Documentation/feature-removal-schedule.txt~memsw-deprecate-noswapaccount-kernel-parameter-and-schedule-it-for-removal Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~memsw-deprecate-noswapaccount-kernel-parameter-and-schedule-it-for-removal
+++ a/Documentation/feature-removal-schedule.txt
@@ -603,3 +603,19 @@ Why:	The adm9240, w83792d and w83793 har
 Who:	Jean Delvare <khali@linux-fr.org>
 
 ----------------------------
+
+What:	noswapaccount kernel command line parameter
+When:	2.6.40
+Why:	The original implementation of memsw feature enabled by
+	CONFIG_CGROUP_MEM_RES_CTLR_SWAP could be disabled by the noswapaccount
+	kernel parameter (introduced in 2.6.29-rc1). Later on, this decision
+	turned out to be not ideal because we cannot have the feature compiled
+	in and disabled by default and let only interested to enable it
+	(e.g. general distribution kernels might need it). Therefore we have
+	added swapaccount[=0|1] parameter (introduced in 2.6.37) which provides
+	the both possibilities. If we remove noswapaccount we will have
+	less command line parameters with the same functionality and we
+	can also cleanup the parameter handling a bit ().
+Who:	Michal Hocko <mhocko@suse.cz>
+
+----------------------------
diff -puN mm/memcontrol.c~memsw-deprecate-noswapaccount-kernel-parameter-and-schedule-it-for-removal mm/memcontrol.c
--- a/mm/memcontrol.c~memsw-deprecate-noswapaccount-kernel-parameter-and-schedule-it-for-removal
+++ a/mm/memcontrol.c
@@ -5034,6 +5034,7 @@ __setup("swapaccount", enable_swap_accou
 
 static int __init disable_swap_account(char *s)
 {
+	printk_once("noswapaccount is deprecated and will be removed in 2.6.40. Use swapaccount=0 instead\n");
 	enable_swap_account("=0");
 	return 1;
 }
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
memsw-remove-noswapaccount-kernel-parameter.patch

