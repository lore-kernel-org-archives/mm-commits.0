From: akpm@linux-foundation.org
Subject: + kexec-jump-__ftrace_enabled_save-restore.patch added to -mm tree
Date: Tue, 12 Aug 2008 16:15:51 -0700
Message-ID: <200808122315.m7CNFpZA018748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751917AbYHLXQ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 19:16:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, ebiederm@xmission.com, mingo@elte.hu, pavel@ucw.cz, rjw@sisk.pl, rostedt@goodmis.org, vgoyal@redhat.com


The patch titled
     kexec jump: __ftrace_enabled_save/restore
has been added to the -mm tree.  Its filename is
     kexec-jump-__ftrace_enabled_save-restore.patch

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
kexec-jump-clean-up-ifdef-and-comments.patch
kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size.patch
kexec-jump-check-code-size-in-control-page.patch
kexec-jump-remove-duplication-of-kexec_restart_prepare.patch
kexec-jump-in-sync-with-hibernation-implementation.patch
kexec-jump-__ftrace_enabled_save-restore.patch
kexec-jump-fix-for-ftrace.patch

