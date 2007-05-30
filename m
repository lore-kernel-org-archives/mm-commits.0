From: akpm@linux-foundation.org
Subject: + containersv10-simple-debug-info-subsystem.patch added to -mm tree
Date: Wed, 30 May 2007 00:15:22 -0700
Message-ID: <200705300715.l4U7FLrr021371@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47243 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751833AbXE3HQO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 03:16:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, balbir@in.ibm.com, dev@openvz.org, ebiederm@xmission.com, haveblue@us.ibm.com, herbert@13thfloor.at, pj@sgi.com, serue@us.ibm.com, vatsa@in.ibm.com


The patch titled
     Containers: simple debug info subsystem
has been added to the -mm tree.  Its filename is
     containersv10-simple-debug-info-subsystem.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Containers: simple debug info subsystem
From: Paul Menage <menage@google.com>

This example subsystem exports debugging information as an aid to diagnosing
refcount leaks, etc, in the container framework.

Signed-off-by: Paul Menage <menage@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/container_subsys.h |    4 +
 init/Kconfig                     |   10 +++
 kernel/Makefile                  |    1 
 kernel/container_debug.c         |   89 +++++++++++++++++++++++++++++
 4 files changed, 104 insertions(+)

diff -puN include/linux/container_subsys.h~containersv10-simple-debug-info-subsystem include/linux/container_subsys.h
--- a/include/linux/container_subsys.h~containersv10-simple-debug-info-subsystem
+++ a/include/linux/container_subsys.h
@@ -19,4 +19,8 @@ SUBSYS(cpuset)
 
 /* */
 
+#ifdef CONFIG_CONTAINER_DEBUG
+SUBSYS(debug)
+#endif
+
 /* */
diff -puN init/Kconfig~containersv10-simple-debug-info-subsystem init/Kconfig
--- a/init/Kconfig~containersv10-simple-debug-info-subsystem
+++ a/init/Kconfig
@@ -306,6 +306,16 @@ config LOG_BUF_SHIFT
 config CONTAINERS
 	bool
 
+config CONTAINER_DEBUG
+	bool "Example debug container subsystem"
+	select CONTAINERS
+	help
+	  This option enables a simple container subsystem that
+	  exports useful debugging information about the containers
+	  framework
+
+	  Say N if unsure
+
 config CPUSETS
 	bool "Cpuset support"
 	depends on SMP
diff -puN kernel/Makefile~containersv10-simple-debug-info-subsystem kernel/Makefile
--- a/kernel/Makefile~containersv10-simple-debug-info-subsystem
+++ a/kernel/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CONTAINERS) += container.o
+obj-$(CONFIG_CONTAINER_DEBUG) += container_debug.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_CONTAINER_CPUACCT) += cpu_acct.o
 obj-$(CONFIG_IKCONFIG) += configs.o
diff -puN /dev/null kernel/container_debug.c
--- /dev/null
+++ a/kernel/container_debug.c
@@ -0,0 +1,89 @@
+/*
+ * kernel/ccontainer_debug.c - Example container subsystem that
+ * exposes debug info
+ *
+ * Copyright (C) Google Inc, 2007
+ *
+ * Developed by Paul Menage (menage@google.com)
+ *
+ */
+
+#include <linux/container.h>
+#include <linux/fs.h>
+
+static int debug_create(struct container_subsys *ss, struct container *cont)
+{
+	struct container_subsys_state *css = kzalloc(sizeof(*css), GFP_KERNEL);
+	if (!css)
+		return -ENOMEM;
+	cont->subsys[debug_subsys_id] = css;
+	return 0;
+}
+
+static void debug_destroy(struct container_subsys *ss, struct container *cont)
+{
+	kfree(cont->subsys[debug_subsys_id]);
+}
+
+static u64 container_refcount_read(struct container *cont, struct cftype *cft)
+{
+	return atomic_read(&cont->count);
+}
+
+static u64 taskcount_read(struct container *cont, struct cftype *cft)
+{
+	u64 count;
+	container_lock();
+	count = container_task_count(cont);
+	container_unlock();
+	return count;
+}
+
+static u64 current_css_group_read(struct container *cont, struct cftype *cft)
+{
+	return (u64) current->containers;
+}
+
+static u64 current_css_group_refcount_read(struct container *cont,
+					   struct cftype *cft)
+{
+	u64 count;
+	rcu_read_lock();
+	count = atomic_read(&current->containers->ref.refcount);
+	rcu_read_unlock();
+	return count;
+}
+
+static struct cftype files[] =  {
+	{
+		.name = "debug.container_refcount",
+		.read_uint = container_refcount_read,
+	},
+	{
+		.name = "debug.taskcount",
+		.read_uint = taskcount_read,
+	},
+
+	{
+		.name = "debug.current_css_group",
+		.read_uint = current_css_group_read,
+	},
+
+	{
+		.name = "debug.current_css_group_refcount",
+		.read_uint = current_css_group_refcount_read,
+	},
+};
+
+static int debug_populate(struct container_subsys *ss, struct container *cont)
+{
+	return container_add_files(cont, files, ARRAY_SIZE(files));
+}
+
+struct container_subsys debug_subsys = {
+	.name = "debug",
+	.create = debug_create,
+	.destroy = debug_destroy,
+	.populate = debug_populate,
+	.subsys_id = debug_subsys_id,
+};
_

Patches currently in -mm which might be from menage@google.com are

reduce-cpusetc-write_lock_irq-to-read_lock.patch
reduce-cpusetc-write_lock_irq-to-read_lock-fix.patch
containersv10-basic-container-framework.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface.patch
containersv10-add-procfs-interface-fix.patch
containersv10-make-cpusets-a-client-of-containers.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-support-for-automatic-userspace-release-agents.patch
