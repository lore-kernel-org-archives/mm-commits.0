From: akpm@linux-foundation.org
Subject: [merged] include-linux-kernelh-hide-internal-macros-from-userspace.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:55:10 -0700
Message-ID: <201107260754.p6Q7sDpQ003334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752832Ab1GZHzO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:55:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lacombar@gmail.com, cl@linux.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, mmarek@suse.cz, rostedt@goodmis.org, rusty@rustcorp.com.au, xiyou.wangcong@gmail.com, mm-commits@vge


The patch titled
     include/linux/kernel.h: hide internal macros from userspace
has been removed from the -mm tree.  Its filename was
     include-linux-kernelh-hide-internal-macros-from-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/kernel.h: hide internal macros from userspace
From: Arnaud Lacombe <lacombar@gmail.com>

Unexpose to userland the following macros
 - __FUNCTION__
 - NUMA_BUILD
 - COMPACTION_BUILD
 - REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   43 +++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff -puN include/linux/kernel.h~include-linux-kernelh-hide-internal-macros-from-userspace include/linux/kernel.h
--- a/include/linux/kernel.h~include-linux-kernelh-hide-internal-macros-from-userspace
+++ a/include/linux/kernel.h
@@ -691,6 +691,27 @@ extern int __build_bug_on_failed;
 #endif
 #endif	/* __CHECKER__ */
 
+/* Trap pasters of __FUNCTION__ at compile-time */
+#define __FUNCTION__ (__func__)
+
+/* This helps us to avoid #ifdef CONFIG_NUMA */
+#ifdef CONFIG_NUMA
+#define NUMA_BUILD 1
+#else
+#define NUMA_BUILD 0
+#endif
+
+/* This helps us avoid #ifdef CONFIG_COMPACTION */
+#ifdef CONFIG_COMPACTION
+#define COMPACTION_BUILD 1
+#else
+#define COMPACTION_BUILD 0
+#endif
+
+/* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
+#ifdef CONFIG_FTRACE_MCOUNT_RECORD
+# define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
+#endif
 
 struct sysinfo;
 extern int do_sysinfo(struct sysinfo *info);
@@ -715,26 +736,4 @@ struct sysinfo {
 	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
 };
 
-/* Trap pasters of __FUNCTION__ at compile-time */
-#define __FUNCTION__ (__func__)
-
-/* This helps us to avoid #ifdef CONFIG_NUMA */
-#ifdef CONFIG_NUMA
-#define NUMA_BUILD 1
-#else
-#define NUMA_BUILD 0
-#endif
-
-/* This helps us avoid #ifdef CONFIG_COMPACTION */
-#ifdef CONFIG_COMPACTION
-#define COMPACTION_BUILD 1
-#else
-#define COMPACTION_BUILD 0
-#endif
-
-/* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
-#ifdef CONFIG_FTRACE_MCOUNT_RECORD
-# define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
-#endif
