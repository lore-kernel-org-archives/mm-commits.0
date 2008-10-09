From: akpm@linux-foundation.org
Subject: - ftrace-warn-on-failure-to-disable-mcount-callers.patch removed from -mm tree
Date: Thu, 09 Oct 2008 15:28:28 -0700
Message-ID: <200810092228.m99MSS6o006082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55082 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751981AbYJIW3p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 18:29:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, mingo@elte.hu, srostedt@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ftrace: warn on failure to disable mcount callers
has been removed from the -mm tree.  Its filename was
     ftrace-warn-on-failure-to-disable-mcount-callers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ftrace: warn on failure to disable mcount callers
From: Steven Rostedt <rostedt@goodmis.org>

With the recent updates to ftrace, there should not be any failures when
modifying the code. If there is, then we need to warn about it.

This patch has a cleaned up version of the code that I used to discover
that the weak symbols were causing failures.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/ftrace.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff -puN kernel/trace/ftrace.c~ftrace-warn-on-failure-to-disable-mcount-callers kernel/trace/ftrace.c
--- a/kernel/trace/ftrace.c~ftrace-warn-on-failure-to-disable-mcount-callers
+++ a/kernel/trace/ftrace.c
@@ -583,6 +583,16 @@ static void ftrace_shutdown_replenish(vo
 	ftrace_pages->next = (void *)get_zeroed_page(GFP_KERNEL);
 }
 
+static void print_ip_ins(const char *fmt, unsigned char *p)
+{
+	int i;
+
+	printk(KERN_CONT "%s", fmt);
+
+	for (i = 0; i < MCOUNT_INSN_SIZE; i++)
+		printk(KERN_CONT "%s%02x", i ? ":" : "", p[i]);
+}
+
 static int
 ftrace_code_disable(struct dyn_ftrace *rec)
 {
@@ -597,6 +607,23 @@ ftrace_code_disable(struct dyn_ftrace *r
 
 	failed = ftrace_modify_code(ip, call, nop);
 	if (failed) {
+		switch (failed) {
+		case 1:
+			WARN_ON_ONCE(1);
+			pr_info("ftrace faulted on modifying ");
+			print_ip_sym(ip);
+			break;
+		case 2:
+			WARN_ON_ONCE(1);
+			pr_info("ftrace failed to modify ");
+			print_ip_sym(ip);
+			print_ip_ins(" expected: ", call);
+			print_ip_ins(" actual: ", (unsigned char *)ip);
+			print_ip_ins(" replace: ", nop);
+			printk(KERN_CONT "\n");
+			break;
+		}
+
 		rec->flags |= FTRACE_FL_FAILED;
 		return 0;
 	}
_

Patches currently in -mm which might be from rostedt@goodmis.org are

git-tip.patch

