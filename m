From: akpm@linux-foundation.org
Subject: +
 kernel-cpuset-current_cpuset_is_being_rebound-can-be-boolean.patch added to -mm tree
Date: Thu, 14 Dec 2017 12:23:56 -0800
Message-ID: <5a32dddc.jPKaX/cLvnaJPg5d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46218 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752612AbdLNUX5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Dec 2017 15:23:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/cpuset: current_cpuset_is_being_rebound can be  boolean
has been added to the -mm tree.  Its filename is
     kernel-cpuset-current_cpuset_is_being_rebound-can-be-boolean.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-cpuset-current_cpuset_is_being_rebound-can-be-boolean.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-cpuset-current_cpuset_is_being_rebound-can-be-boolean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from baiyaowei@cmss.chinamobile.com are

mm-memblock-memblock_is_map-region_memory-can-be-boolean.patch
lib-lockref-__lockref_is_dead-can-be-boolean.patch
kernel-cpuset-current_cpuset_is_being_rebound-can-be-boolean.patch
kernel-resource-iomem_is_exclusive-can-be-boolean.patch
kernel-module-module_is_live-can-be-boolean.patch
kernel-mutex-mutex_is_locked-can-be-boolean.patch
crash_dump-is_kdump_kernel-can-be-boolean.patch

