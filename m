From: akpm@linux-foundation.org
Subject: - disable-the-memory-controller-by-default-v3.patch removed from -mm tree
Date: Thu, 01 May 2008 02:48:58 -0700
Message-ID: <200805010948.m419mx0v031722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49052 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754976AbYEAJtz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:49:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, stable@kernel.org, xemul@openvz.org, yamamoto@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: disable the memory controller by default
has been removed from the -mm tree.  Its filename was
     disable-the-memory-controller-by-default-v3.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: disable the memory controller by default
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Due to the overhead of the memory controller the memory controller is now
disabled by default.  This patch adds cgroup_enable.

[akpm@linux-foundation.org: `inline __init' doesn't make sense]
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: AMAMOTO Takashi <yamamoto@valinux.co.jp>
Acked-by: Paul Menage <menage@google.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    3 +++
 kernel/cgroup.c                     |   17 +++++++++++++----
 mm/memcontrol.c                     |    1 +
 3 files changed, 17 insertions(+), 4 deletions(-)

diff -puN Documentation/kernel-parameters.txt~disable-the-memory-controller-by-default-v3 Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~disable-the-memory-controller-by-default-v3
+++ a/Documentation/kernel-parameters.txt
@@ -382,8 +382,11 @@ and is between 256 and 4096 characters. 
 			See Documentation/s390/CommonIO for details.
 
 	cgroup_disable= [KNL] Disable a particular controller
+	cgroup_enable=  [KNL] Enable a particular controller
+			For both cgroup_enable and cgroup_enable
 			Format: {name of the controller(s) to disable}
 				{Currently supported controllers - "memory"}
+				{Memory controller is disabled by default}
 
 	checkreqprot	[SELINUX] Set initial checkreqprot flag value.
 			Format: { "0" | "1" }
diff -puN kernel/cgroup.c~disable-the-memory-controller-by-default-v3 kernel/cgroup.c
--- a/kernel/cgroup.c~disable-the-memory-controller-by-default-v3
+++ a/kernel/cgroup.c
@@ -3120,7 +3120,7 @@ static void cgroup_release_agent(struct 
 	mutex_unlock(&cgroup_mutex);
 }
 
-static int __init cgroup_disable(char *str)
+static int __init cgroup_turnonoff(char *str, int disable)
 {
 	int i;
 	char *token;
@@ -3133,13 +3133,22 @@ static int __init cgroup_disable(char *s
 			struct cgroup_subsys *ss = subsys[i];
 
 			if (!strcmp(token, ss->name)) {
-				ss->disabled = 1;
-				printk(KERN_INFO "Disabling %s control group"
-					" subsystem\n", ss->name);
+				ss->disabled = disable;
 				break;
 			}
 		}
 	}
 	return 1;
 }
+
+static int __init cgroup_disable(char *str)
+{
+	return cgroup_turnonoff(str, 1);
+}
 __setup("cgroup_disable=", cgroup_disable);
+
+static int __init cgroup_enable(char *str)
+{
+	return cgroup_turnonoff(str, 0);
+}
+__setup("cgroup_enable=", cgroup_enable);
diff -puN mm/memcontrol.c~disable-the-memory-controller-by-default-v3 mm/memcontrol.c
--- a/mm/memcontrol.c~disable-the-memory-controller-by-default-v3
+++ a/mm/memcontrol.c
@@ -1106,4 +1106,5 @@ struct cgroup_subsys mem_cgroup_subsys =
 	.populate = mem_cgroup_populate,
 	.attach = mem_cgroup_move_task,
 	.early_init = 0,
+	.disabled = 1,
 };
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
disable-the-memory-controller-by-default-v3.patch
git-kvm.patch
memcg-simple-stats-for-memory-resource-controller.patch

