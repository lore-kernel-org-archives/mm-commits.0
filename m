From: akpm@linux-foundation.org
Subject: [patch 092/114] kernel/cpuset:
 current_cpuset_is_being_rebound can be  boolean
Date: Tue, 06 Feb 2018 15:41:24 -0800
Message-ID: <20180206234124.Bjk5aiQYx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56172 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753346AbeBFXl0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:41:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: kernel/cpuset: current_cpuset_is_being_rebound can be  boolean

Make current_cpuset_is_being_rebound return bool due to this particular
function only using either one or zero as its return value.

No functional change.

Link: http://lkml.kernel.org/r/1513266622-15860-4-git-send-email-baiyaowei@cmss.chinamobile.com
Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h |    6 +++---
 kernel/cgroup/cpuset.c |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/cpuset.h~kernel-cpuset-current_cpuset_is_being_rebound-can-be-boolean include/linux/cpuset.h
--- a/include/linux/cpuset.h~kernel-cpuset-current_cpuset_is_being_rebound-can-be-boolean
+++ a/include/linux/cpuset.h
@@ -112,7 +112,7 @@ static inline int cpuset_do_slab_mem_spr
 	return task_spread_slab(current);
 }
 
-extern int current_cpuset_is_being_rebound(void);
+extern bool current_cpuset_is_being_rebound(void);
 
 extern void rebuild_sched_domains(void);
 
@@ -247,9 +247,9 @@ static inline int cpuset_do_slab_mem_spr
 	return 0;
 }
 
-static inline int current_cpuset_is_being_rebound(void)
+static inline bool current_cpuset_is_being_rebound(void)
 {
-	return 0;
+	return false;
 }
 
 static inline void rebuild_sched_domains(void)
diff -puN kernel/cgroup/cpuset.c~kernel-cpuset-current_cpuset_is_being_rebound-can-be-boolean kernel/cgroup/cpuset.c
--- a/kernel/cgroup/cpuset.c~kernel-cpuset-current_cpuset_is_being_rebound-can-be-boolean
+++ a/kernel/cgroup/cpuset.c
@@ -1254,9 +1254,9 @@ done:
 	return retval;
 }
 
-int current_cpuset_is_being_rebound(void)
+bool current_cpuset_is_being_rebound(void)
 {
-	int ret;
+	bool ret;
 
 	rcu_read_lock();
 	ret = task_cs(current) == cpuset_being_rebound;
_
