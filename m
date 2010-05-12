From: akpm@linux-foundation.org
Subject: + cgroups-make-cftypeunregister_event-void-returning.patch added to -mm tree
Date: Wed, 12 May 2010 16:21:24 -0700
Message-ID: <201005122321.o4CNLO1R027015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758527Ab0ELXVo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 19:21:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill@shutemov.name, balbir@linux.vnet.ibm.com, ext-phil.2.carmody@nokia.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     cgroups: make cftype.unregister_event() void-returning
has been added to the -mm tree.  Its filename is
     cgroups-make-cftypeunregister_event-void-returning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: make cftype.unregister_event() void-returning
From: "Kirill A. Shutemov" <kirill@shutemov.name>

Since we are unable to handle an error returned by
cftype.unregister_event() properly, let's make the callback
void-returning.

mem_cgroup_unregister_event() has been rewritten to be a "never fail"
function.  On mem_cgroup_usage_register_event() we save old buffer for
thresholds array and reuse it in mem_cgroup_usage_unregister_event() to
avoid allocation.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    2 -
 kernel/cgroup.c        |    1 
 mm/memcontrol.c        |   65 ++++++++++++++++++++++++---------------
 3 files changed, 42 insertions(+), 26 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-make-cftypeunregister_event-void-returning include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-make-cftypeunregister_event-void-returning
+++ a/include/linux/cgroup.h
@@ -397,7 +397,7 @@ struct cftype {
 	 * This callback must be implemented, if you want provide
 	 * notification functionality.
 	 */
-	int (*unregister_event)(struct cgroup *cgrp, struct cftype *cft,
+	void (*unregister_event)(struct cgroup *cgrp, struct cftype *cft,
 			struct eventfd_ctx *eventfd);
 };
 
diff -puN kernel/cgroup.c~cgroups-make-cftypeunregister_event-void-returning kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-make-cftypeunregister_event-void-returning
+++ a/kernel/cgroup.c
@@ -2994,7 +2994,6 @@ static void cgroup_event_remove(struct w
 			remove);
 	struct cgroup *cgrp = event->cgrp;
 
-	/* TODO: check return code */
 	event->cft->unregister_event(cgrp, event->cft, event->eventfd);
 
 	eventfd_ctx_put(event->eventfd);
diff -puN mm/memcontrol.c~cgroups-make-cftypeunregister_event-void-returning mm/memcontrol.c
--- a/mm/memcontrol.c~cgroups-make-cftypeunregister_event-void-returning
+++ a/mm/memcontrol.c
@@ -226,9 +226,19 @@ struct mem_cgroup {
 	/* thresholds for memory usage. RCU-protected */
 	struct mem_cgroup_threshold_ary *thresholds;
 
+	/*
+	 * Preallocated buffer to be used in mem_cgroup_unregister_event()
+	 * to make it "never fail".
+	 * It must be able to store at least thresholds->size - 1 entries.
+	 */
+	struct mem_cgroup_threshold_ary *__thresholds;
+
 	/* thresholds for mem+swap usage. RCU-protected */
 	struct mem_cgroup_threshold_ary *memsw_thresholds;
 
+	/* the same as __thresholds, but for memsw_thresholds */
+	struct mem_cgroup_threshold_ary *__memsw_thresholds;
+
 	/* For oom notifier event fd */
 	struct list_head oom_notify;
 
@@ -3568,17 +3578,27 @@ static int mem_cgroup_usage_register_eve
 	else
 		rcu_assign_pointer(memcg->memsw_thresholds, thresholds_new);
 
-	/* To be sure that nobody uses thresholds before freeing it */
+	/* To be sure that nobody uses thresholds */
 	synchronize_rcu();
 
-	kfree(thresholds);
+	/*
+	 * Free old preallocated buffer and use thresholds as new
+	 * preallocated buffer.
+	 */
+	if (type == _MEM) {
+		kfree(memcg->__thresholds);
+		memcg->__thresholds = thresholds;
+	} else {
+		kfree(memcg->__memsw_thresholds);
+		memcg->__memsw_thresholds = thresholds;
+	}
 unlock:
 	mutex_unlock(&memcg->thresholds_lock);
 
 	return ret;
 }
 
-static int mem_cgroup_usage_unregister_event(struct cgroup *cgrp,
+static void mem_cgroup_usage_unregister_event(struct cgroup *cgrp,
 	struct cftype *cft, struct eventfd_ctx *eventfd)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
@@ -3586,7 +3606,7 @@ static int mem_cgroup_usage_unregister_e
 	int type = MEMFILE_TYPE(cft->private);
 	u64 usage;
 	int size = 0;
-	int i, j, ret = 0;
+	int i, j;
 
 	mutex_lock(&memcg->thresholds_lock);
 	if (type == _MEM)
@@ -3613,20 +3633,19 @@ static int mem_cgroup_usage_unregister_e
 			size++;
 	}
 
+	/* Use preallocated buffer for new array of thresholds */
+	if (type == _MEM)
+		thresholds_new = memcg->__thresholds;
+	else
+		thresholds_new = memcg->__memsw_thresholds;
+
 	/* Set thresholds array to NULL if we don't have thresholds */
 	if (!size) {
+		kfree(thresholds_new);
 		thresholds_new = NULL;
-		goto assign;
+		goto swap_buffers;
 	}
 
-	/* Allocate memory for new array of thresholds */
-	thresholds_new = kmalloc(sizeof(*thresholds_new) +
-			size * sizeof(struct mem_cgroup_threshold),
-			GFP_KERNEL);
-	if (!thresholds_new) {
-		ret = -ENOMEM;
-		goto unlock;
-	}
 	thresholds_new->size = size;
 
 	/* Copy thresholds and find current threshold */
@@ -3647,20 +3666,20 @@ static int mem_cgroup_usage_unregister_e
 		j++;
 	}
 
-assign:
-	if (type == _MEM)
+swap_buffers:
+	/* Swap thresholds array and preallocated buffer */
+	if (type == _MEM) {
+		memcg->__thresholds = thresholds;
 		rcu_assign_pointer(memcg->thresholds, thresholds_new);
-	else
+	} else {
+		memcg->__memsw_thresholds = thresholds;
 		rcu_assign_pointer(memcg->memsw_thresholds, thresholds_new);
+	}
 
-	/* To be sure that nobody uses thresholds before freeing it */
+	/* To be sure that nobody uses thresholds */
 	synchronize_rcu();
 
-	kfree(thresholds);
-unlock:
 	mutex_unlock(&memcg->thresholds_lock);
-
-	return ret;
 }
 
 static int mem_cgroup_oom_register_event(struct cgroup *cgrp,
@@ -3688,7 +3707,7 @@ static int mem_cgroup_oom_register_event
 	return 0;
 }
 
-static int mem_cgroup_oom_unregister_event(struct cgroup *cgrp,
+static void mem_cgroup_oom_unregister_event(struct cgroup *cgrp,
 	struct cftype *cft, struct eventfd_ctx *eventfd)
 {
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cgrp);
@@ -3707,8 +3726,6 @@ static int mem_cgroup_oom_unregister_eve
 	}
 
 	mutex_unlock(&memcg_oom_mutex);
