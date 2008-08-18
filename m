From: akpm@linux-foundation.org
Subject: - kexec-jump-__ftrace_enabled_save-restore.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:39:34 -0700
Message-ID: <200808181939.m7IJdY7F008334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758168AbYHRTkS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:40:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, ebiederm@xmission.com, mingo@elte.hu, pavel@ucw.cz, rjw@sisk.pl, rostedt@goodmis.org, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kexec jump: __ftrace_enabled_save/restore
has been removed from the -mm tree.  Its filename was
     kexec-jump-__ftrace_enabled_save-restore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec jump: __ftrace_enabled_save/restore
From: Huang Ying <ying.huang@intel.com>

Add __ftrace_enabled_save/restore, used to disable ftrace for a while. 
Now, this is used by kexec jump, which need a version without lock, for
general situation, a locked version should be used.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ftrace.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN include/linux/ftrace.h~kexec-jump-__ftrace_enabled_save-restore include/linux/ftrace.h
--- a/include/linux/ftrace.h~kexec-jump-__ftrace_enabled_save-restore
+++ a/include/linux/ftrace.h
@@ -98,6 +98,27 @@ static inline void tracer_disable(void)
 #endif
 }
 
+/* Ftrace disable/restore without lock. Some synchronization mechanism
+ * must be used to prevent ftrace_enabled to be changed between
+ * disable/restore. */
+static inline int __ftrace_enabled_save(void)
+{
+#ifdef CONFIG_FTRACE
+	int saved_ftrace_enabled = ftrace_enabled;
+	ftrace_enabled = 0;
+	return saved_ftrace_enabled;
+#else
+	return 0;
+#endif
+}
+
+static inline void __ftrace_enabled_restore(int enabled)
+{
+#ifdef CONFIG_FTRACE
+	ftrace_enabled = enabled;
+#endif
+}
+
 #ifdef CONFIG_FRAME_POINTER
 /* TODO: need to fix this for ARM */
 # define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
_

Patches currently in -mm which might be from ying.huang@intel.com are

origin.patch

