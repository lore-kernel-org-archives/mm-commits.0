From: akpm@linux-foundation.org
Subject: + disable-the-memory-controller-by-default-v3.patch added to -mm tree
Date: Tue, 15 Apr 2008 16:32:15 -0700
Message-ID: <200804152332.m3FNWFXA021607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753183AbYDOXcm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 19:32:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     memcg: disable the memory controller by default
has been added to the -mm tree.  Its filename is
     disable-the-memory-controller-by-default-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: disable the memory controller by default
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Due to the overhead of the memory controller the memory controller is now
disabled by default.  This patch adds cgroup_enable.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: AMAMOTO Takashi <yamamoto@valinux.co.jp>
Acked-by: Paul Menage <menage@google.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    3 +++
 kernel/cgroup.c                     |   17 +++++++++++++----
 mm/memcontrol.c                     |    1 +
 3 files changed, 17 insertions(+), 4 deletions(-)

diff -puN Documentation/kernel-parameters.txt~disable-the-memory-controller-by-default-v3 Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~disable-the-memory-controller-by-default-v3
+++ a/Documentation/kernel-parameters.txt
@@ -376,8 +376,11 @@ and is between 256 and 4096 characters. 
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
@@ -3020,7 +3020,7 @@ static void cgroup_release_agent(struct 
 	mutex_unlock(&cgroup_mutex);
 }
 
-static int __init cgroup_disable(char *str)
+static inline int __init cgroup_turnonoff(char *str, int disable)
 {
 	int i;
 	char *token;
@@ -3033,13 +3033,22 @@ static int __init cgroup_disable(char *s
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
@@ -1115,4 +1115,5 @@ struct cgroup_subsys mem_cgroup_subsys =
 	.populate = mem_cgroup_populate,
 	.attach = mem_cgroup_move_task,
 	.early_init = 0,
+	.disabled = 1,
 };
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

memcg-fix-oops-in-oom-handling.patch
disable-the-memory-controller-by-default-v3.patch
git-sched.patch
oom_kill-remove-unused-parameter-in-badness.patch
cgroups-use-a-hash-table-for-css_set-finding.patch
cgroups-simplify-init_subsys.patch
cgroups-remove-the-css_set-linked-list.patch
cgroups-add-an-owner-to-the-mm_struct.patch
memcgroup-add-the-max_usage-member-on-the-res_counter.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch
memcgroup-make-the-memory-controller-more-desktop-responsive.patch

