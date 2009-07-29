From: akpm@linux-foundation.org
Subject: + cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state.patch added to -mm tree
Date: Wed, 29 Jul 2009 15:42:46 -0700
Message-ID: <200907292242.n6TMgloI017009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754157AbZG2Wn3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 18:43:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, balbir@in.ibm.com, dhaval@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com


The patch titled
     cgroups: move the cgroup debug subsys into cgroup.c to access internal state
has been added to the -mm tree.  Its filename is
     cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state.patch

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
Subject: cgroups: move the cgroup debug subsys into cgroup.c to access internal state
From: Paul Menage <menage@google.com>

While it's architecturally clean to have the cgroup debug subsystem be
completely independent of the cgroups framework, it limits its usefulness
for debugging the contents of internal data structures.  Move the debug
subsystem code into the scope of all the cgroups data structures to make
more detailed debugging possible.

Signed-off-by: Paul Menage <menage@google.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Makefile       |    1 
 kernel/cgroup.c       |   88 +++++++++++++++++++++++++++++++++
 kernel/cgroup_debug.c |  105 ----------------------------------------
 3 files changed, 88 insertions(+), 106 deletions(-)

diff -puN kernel/Makefile~cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state kernel/Makefile
--- a/kernel/Makefile~cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state
+++ a/kernel/Makefile
@@ -58,7 +58,6 @@ obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup.o
-obj-$(CONFIG_CGROUP_DEBUG) += cgroup_debug.o
 obj-$(CONFIG_CGROUP_FREEZER) += cgroup_freezer.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_CGROUP_NS) += ns_cgroup.o
diff -puN kernel/cgroup.c~cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state
+++ a/kernel/cgroup.c
@@ -3781,3 +3781,91 @@ css_get_next(struct cgroup_subsys *ss, i
 	return ret;
 }
 
+#ifdef CONFIG_CGROUP_DEBUG
+static struct cgroup_subsys_state *debug_create(struct cgroup_subsys *ss,
+						   struct cgroup *cont)
+{
+	struct cgroup_subsys_state *css = kzalloc(sizeof(*css), GFP_KERNEL);
+
+	if (!css)
+		return ERR_PTR(-ENOMEM);
+
+	return css;
+}
+
+static void debug_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	kfree(cont->subsys[debug_subsys_id]);
+}
+
+static u64 cgroup_refcount_read(struct cgroup *cont, struct cftype *cft)
+{
+	return atomic_read(&cont->count);
+}
+
+static u64 debug_taskcount_read(struct cgroup *cont, struct cftype *cft)
+{
+	return cgroup_task_count(cont);
+}
+
+static u64 current_css_set_read(struct cgroup *cont, struct cftype *cft)
+{
+	return (u64)(unsigned long)current->cgroups;
+}
+
+static u64 current_css_set_refcount_read(struct cgroup *cont,
+					   struct cftype *cft)
+{
+	u64 count;
+
+	rcu_read_lock();
+	count = atomic_read(&current->cgroups->refcount);
+	rcu_read_unlock();
+	return count;
+}
+
+static u64 releasable_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	return test_bit(CGRP_RELEASABLE, &cgrp->flags);
+}
+
+static struct cftype debug_files[] =  {
+	{
+		.name = "cgroup_refcount",
+		.read_u64 = cgroup_refcount_read,
+	},
+	{
+		.name = "taskcount",
+		.read_u64 = debug_taskcount_read,
+	},
+
+	{
+		.name = "current_css_set",
+		.read_u64 = current_css_set_read,
+	},
+
+	{
+		.name = "current_css_set_refcount",
+		.read_u64 = current_css_set_refcount_read,
+	},
+
+	{
+		.name = "releasable",
+		.read_u64 = releasable_read,
+	},
+};
+
+static int debug_populate(struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	return cgroup_add_files(cont, ss, debug_files,
+				ARRAY_SIZE(debug_files));
+}
+
+struct cgroup_subsys debug_subsys = {
+	.name = "debug",
+	.create = debug_create,
+	.destroy = debug_destroy,
+	.populate = debug_populate,
+	.subsys_id = debug_subsys_id,
+};
+#endif /* CONFIG_CGROUP_DEBUG */
diff -puN kernel/cgroup_debug.c~cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state /dev/null
--- a/kernel/cgroup_debug.c
+++ /dev/null
@@ -1,105 +0,0 @@
-/*
- * kernel/cgroup_debug.c - Example cgroup subsystem that
- * exposes debug info
- *
- * Copyright (C) Google Inc, 2007
- *
- * Developed by Paul Menage (menage@google.com)
- *
- */
-
-#include <linux/cgroup.h>
-#include <linux/fs.h>
-#include <linux/slab.h>
-#include <linux/rcupdate.h>
-
-#include <asm/atomic.h>
-
-static struct cgroup_subsys_state *debug_create(struct cgroup_subsys *ss,
-						   struct cgroup *cont)
-{
-	struct cgroup_subsys_state *css = kzalloc(sizeof(*css), GFP_KERNEL);
-
-	if (!css)
-		return ERR_PTR(-ENOMEM);
-
-	return css;
-}
-
-static void debug_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
-{
-	kfree(cont->subsys[debug_subsys_id]);
-}
-
-static u64 cgroup_refcount_read(struct cgroup *cont, struct cftype *cft)
-{
-	return atomic_read(&cont->count);
-}
-
-static u64 taskcount_read(struct cgroup *cont, struct cftype *cft)
-{
-	u64 count;
-
-	count = cgroup_task_count(cont);
-	return count;
-}
-
-static u64 current_css_set_read(struct cgroup *cont, struct cftype *cft)
-{
-	return (u64)(long)current->cgroups;
-}
-
-static u64 current_css_set_refcount_read(struct cgroup *cont,
-					   struct cftype *cft)
-{
-	u64 count;
-
-	rcu_read_lock();
-	count = atomic_read(&current->cgroups->refcount);
-	rcu_read_unlock();
-	return count;
-}
-
-static u64 releasable_read(struct cgroup *cgrp, struct cftype *cft)
-{
-	return test_bit(CGRP_RELEASABLE, &cgrp->flags);
-}
-
-static struct cftype files[] =  {
-	{
-		.name = "cgroup_refcount",
-		.read_u64 = cgroup_refcount_read,
-	},
-	{
-		.name = "taskcount",
-		.read_u64 = taskcount_read,
-	},
-
-	{
-		.name = "current_css_set",
-		.read_u64 = current_css_set_read,
-	},
-
-	{
-		.name = "current_css_set_refcount",
-		.read_u64 = current_css_set_refcount_read,
-	},
-
-	{
-		.name = "releasable",
-		.read_u64 = releasable_read,
-	},
-};
-
-static int debug_populate(struct cgroup_subsys *ss, struct cgroup *cont)
-{
-	return cgroup_add_files(cont, ss, files, ARRAY_SIZE(files));
-}
-
-struct cgroup_subsys debug_subsys = {
-	.name = "debug",
-	.create = debug_create,
-	.destroy = debug_destroy,
-	.populate = debug_populate,
-	.subsys_id = debug_subsys_id,
-};
_

Patches currently in -mm which might be from menage@google.com are

cgroups-fix-pid-namespace-bug.patch
cgroup-avoid-permanent-sleep-at-rmdir-v7.patch
mm-remove-obsoleted-alloc_pages-cpuset-comment.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware-fix.patch
include-linux-credh-work-around-gcc-424-warning-in-get_cred.patch
cgroups-make-unlock-sequence-in-cgroup_get_sb-consistent.patch
cgroups-support-named-cgroups-hierarchies.patch
cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state.patch
cgroups-add-a-back-pointer-from-struct-cg_cgroup_link-to-struct-cgroup.patch
cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
add-a-refcount-check-in-dput.patch

