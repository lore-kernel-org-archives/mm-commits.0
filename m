From: akpm@linux-foundation.org
Subject: + cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch added to -mm tree
Date: Wed, 27 Feb 2008 17:04:49 -0800
Message-ID: <200802280104.m1S14oCX008272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:32790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763275AbYB1BFj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 20:05:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, pj@sgi.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     CGroup API files: move "releasable" to cgroup_debug subsystem
has been added to the -mm tree.  Its filename is
     cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch

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
Subject: CGroup API files: move "releasable" to cgroup_debug subsystem
From: Paul Menage <menage@google.com>

The "releasable" control file provided by the cgroup framework exports the
state of a per-cgroup flag that's related to the notify-on-release feature. 
This isn't really generally useful, unless you're trying to debug this
particular feature of cgroups.

This patch moves the "releasable" file to the cgroup_debug subsystem.

Signed-off-by: Paul Menage <menage@google.com>
Cc: "Li Zefan" <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |   11 +++++++++++
 kernel/cgroup.c        |   23 -----------------------
 kernel/cgroup_debug.c  |   12 +++++++++++-
 3 files changed, 22 insertions(+), 24 deletions(-)

diff -puN include/linux/cgroup.h~cgroup-api-files-move-releasable-to-cgroup_debug-subsystem include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroup-api-files-move-releasable-to-cgroup_debug-subsystem
+++ a/include/linux/cgroup.h
@@ -88,6 +88,17 @@ static inline void css_put(struct cgroup
 		__css_put(css);
 }
 
+/* bits in struct cgroup flags field */
+enum {
+	/* Control Group is dead */
+	CGRP_REMOVED,
+	/* Control Group has previously had a child cgroup or a task,
+	 * but no longer (only if CGRP_NOTIFY_ON_RELEASE is set) */
+	CGRP_RELEASABLE,
+	/* Control Group requires release notifications to userspace */
+	CGRP_NOTIFY_ON_RELEASE,
+};
+
 struct cgroup {
 	unsigned long flags;		/* "unsigned long" so bitops work */
 
diff -puN kernel/cgroup.c~cgroup-api-files-move-releasable-to-cgroup_debug-subsystem kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-api-files-move-releasable-to-cgroup_debug-subsystem
+++ a/kernel/cgroup.c
@@ -119,17 +119,6 @@ static int root_count;
  */
 static int need_forkexit_callback;
 
-/* bits in struct cgroup flags field */
-enum {
-	/* Control Group is dead */
-	CGRP_REMOVED,
-	/* Control Group has previously had a child cgroup or a task,
-	 * but no longer (only if CGRP_NOTIFY_ON_RELEASE is set) */
-	CGRP_RELEASABLE,
-	/* Control Group requires release notifications to userspace */
-	CGRP_NOTIFY_ON_RELEASE,
-};
-
 /* convenient tests for these bits */
 inline int cgroup_is_removed(const struct cgroup *cgrp)
 {
@@ -1299,7 +1288,6 @@ enum cgroup_filetype {
 	FILE_DIR,
 	FILE_TASKLIST,
 	FILE_NOTIFY_ON_RELEASE,
-	FILE_RELEASABLE,
 	FILE_RELEASE_AGENT,
 };
 
@@ -2173,11 +2161,6 @@ static u64 cgroup_read_notify_on_release
 	return notify_on_release(cgrp);
 }
 
-static u64 cgroup_read_releasable(struct cgroup *cgrp, struct cftype *cft)
-{
-	return test_bit(CGRP_RELEASABLE, &cgrp->flags);
-}
-
 /*
  * for the common functions, 'private' gives the type of file
  */
@@ -2197,12 +2180,6 @@ static struct cftype files[] = {
 		.write = cgroup_common_file_write,
 		.private = FILE_NOTIFY_ON_RELEASE,
 	},
-
-	{
-		.name = "releasable",
-		.read_u64 = cgroup_read_releasable,
-		.private = FILE_RELEASABLE,
-	}
 };
 
 static struct cftype cft_release_agent = {
diff -puN kernel/cgroup_debug.c~cgroup-api-files-move-releasable-to-cgroup_debug-subsystem kernel/cgroup_debug.c
--- a/kernel/cgroup_debug.c~cgroup-api-files-move-releasable-to-cgroup_debug-subsystem
+++ a/kernel/cgroup_debug.c
@@ -1,5 +1,5 @@
 /*
- * kernel/ccontainer_debug.c - Example cgroup subsystem that
+ * kernel/cgroup_debug.c - Example cgroup subsystem that
  * exposes debug info
  *
  * Copyright (C) Google Inc, 2007
@@ -62,6 +62,11 @@ static u64 current_css_set_refcount_read
 	return count;
 }
 
+static u64 releasable_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	return test_bit(CGRP_RELEASABLE, &cgrp->flags);
+}
+
 static struct cftype files[] =  {
 	{
 		.name = "cgroup_refcount",
@@ -81,6 +86,11 @@ static struct cftype files[] =  {
 		.name = "current_css_set_refcount",
 		.read_u64 = current_css_set_refcount_read,
 	},
+
+	{
+		.name = "releasable",
+		.read_u64 = releasable_read,
+	}
 };
 
 static int debug_populate(struct cgroup_subsys *ss, struct cgroup *cont)
_

Patches currently in -mm which might be from menage@google.com are

cgroup-fix-default-notify_on_release-setting.patch
memory-resource-controller-use-strstrip-while-parsing-arguments.patch
memory-controller-rename-to-memory-resource-controller.patch
make-cgroup_enable_task_cg_lists-static.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
add-a-refcount-check-in-dput.patch
