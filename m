From: akpm@linux-foundation.org
Subject: - cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:42:27 -0700
Message-ID: <200804300542.m3U5gRHg029147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758028AbYD3Fnm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:43:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, pj@sgi.com, xemul@openvz.org, yamamoto@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     CGroup API files: move "releasable" to cgroup_debug subsystem
has been removed from the -mm tree.  Its filename was
     cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1307,7 +1296,6 @@ enum cgroup_filetype {
 	FILE_DIR,
 	FILE_TASKLIST,
 	FILE_NOTIFY_ON_RELEASE,
-	FILE_RELEASABLE,
 	FILE_RELEASE_AGENT,
 };
 
@@ -2186,11 +2174,6 @@ static u64 cgroup_read_notify_on_release
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
@@ -2210,12 +2193,6 @@ static struct cftype files[] = {
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

origin.patch
disable-the-memory-controller-by-default-v3.patch
add-a-refcount-check-in-dput.patch

