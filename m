From: akpm@linux-foundation.org
Subject: [merged] documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:41:02 -0700
Message-ID: <201103232044.p2NKicVg029112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933299Ab1CWUpJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:45:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gong.chen@linux.intel.com, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Documentation/vm/page-types.c: auto debugfs mount for hwpoison operation
has been removed from the -mm tree.  Its filename was
     documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/vm/page-types.c: auto debugfs mount for hwpoison operation
From: Chen Gong <gong.chen@linux.intel.com>

page-types.c doesn't supply a way to specify the debugfs path and the
original debugfs path is not usual on most machines.  This patch supplies
a way to auto mount debugfs if needed.

This patch is heavily inspired by tools/perf/utils/debugfs.c

[akpm@linux-foundation.org: make functions static]
[akpm@linux-foundation.org: fix debugfs_mount() signature]
Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page-types.c |  105 ++++++++++++++++++++++++++++++--
 1 file changed, 101 insertions(+), 4 deletions(-)

diff -puN Documentation/vm/page-types.c~documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation Documentation/vm/page-types.c
--- a/Documentation/vm/page-types.c~documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation
+++ a/Documentation/vm/page-types.c
@@ -32,8 +32,20 @@
 #include <sys/types.h>
 #include <sys/errno.h>
 #include <sys/fcntl.h>
+#include <sys/mount.h>
+#include <sys/statfs.h>
+#include "../../include/linux/magic.h"
 
 
+#ifndef MAX_PATH
+# define MAX_PATH 256
+#endif
+
+#ifndef STR
+# define _STR(x) #x
+# define STR(x) _STR(x)
+#endif
+
 /*
  * pagemap kernel ABI bits
  */
@@ -152,6 +164,12 @@ static const char *page_flag_names[] = {
 };
 
 
+static const char *debugfs_known_mountpoints[] = {
+	"/sys/kernel/debug",
+	"/debug",
+	0,
+};
+
 /*
  * data structures
  */
@@ -184,7 +202,7 @@ static int		kpageflags_fd;
 static int		opt_hwpoison;
 static int		opt_unpoison;
 
-static const char	hwpoison_debug_fs[] = "/debug/hwpoison";
+static char		hwpoison_debug_fs[MAX_PATH+1];
 static int		hwpoison_inject_fd;
 static int		hwpoison_forget_fd;
 
@@ -464,21 +482,100 @@ static uint64_t kpageflags_flags(uint64_
 	return flags;
 }
 
+/* verify that a mountpoint is actually a debugfs instance */
+static int debugfs_valid_mountpoint(const char *debugfs)
+{
+	struct statfs st_fs;
+
+	if (statfs(debugfs, &st_fs) < 0)
+		return -ENOENT;
+	else if (st_fs.f_type != (long) DEBUGFS_MAGIC)
+		return -ENOENT;
+
+	return 0;
+}
+
+/* find the path to the mounted debugfs */
+static const char *debugfs_find_mountpoint(void)
+{
+	const char **ptr;
+	char type[100];
+	FILE *fp;
+
+	ptr = debugfs_known_mountpoints;
+	while (*ptr) {
+		if (debugfs_valid_mountpoint(*ptr) == 0) {
+			strcpy(hwpoison_debug_fs, *ptr);
+			return hwpoison_debug_fs;
+		}
+		ptr++;
+	}
+
+	/* give up and parse /proc/mounts */
+	fp = fopen("/proc/mounts", "r");
+	if (fp == NULL)
+		perror("Can't open /proc/mounts for read");
+
+	while (fscanf(fp, "%*s %"
+		      STR(MAX_PATH)
+		      "s %99s %*s %*d %*d\n",
+		      hwpoison_debug_fs, type) == 2) {
+		if (strcmp(type, "debugfs") == 0)
+			break;
+	}
+	fclose(fp);
+
+	if (strcmp(type, "debugfs") != 0)
+		return NULL;
+
+	return hwpoison_debug_fs;
+}
+
+/* mount the debugfs somewhere if it's not mounted */
+
+static void debugfs_mount(void)
+{
+	const char **ptr;
+
+	/* see if it's already mounted */
+	if (debugfs_find_mountpoint())
+		return;
+
+	ptr = debugfs_known_mountpoints;
+	while (*ptr) {
+		if (mount(NULL, *ptr, "debugfs", 0, NULL) == 0) {
+			/* save the mountpoint */
+			strcpy(hwpoison_debug_fs, *ptr);
+			break;
+		}
+		ptr++;
+	}
+
+	if (*ptr == NULL) {
+		perror("mount debugfs");
+		exit(EXIT_FAILURE);
+	}
+}
+
 /*
  * page actions
  */
 
 static void prepare_hwpoison_fd(void)
 {
-	char buf[100];
+	char buf[MAX_PATH + 1];
+
+	debugfs_mount();
 
 	if (opt_hwpoison && !hwpoison_inject_fd) {
-		sprintf(buf, "%s/corrupt-pfn", hwpoison_debug_fs);
+		snprintf(buf, MAX_PATH, "%s/hwpoison/corrupt-pfn",
+			hwpoison_debug_fs);
 		hwpoison_inject_fd = checked_open(buf, O_WRONLY);
 	}
 
 	if (opt_unpoison && !hwpoison_forget_fd) {
-		sprintf(buf, "%s/unpoison-pfn", hwpoison_debug_fs);
+		snprintf(buf, MAX_PATH, "%s/hwpoison/unpoison-pfn",
+			hwpoison_debug_fs);
 		hwpoison_forget_fd = checked_open(buf, O_WRONLY);
 	}
 }
_

Patches currently in -mm which might be from gong.chen@linux.intel.com are

origin.patch

