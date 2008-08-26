From: akpm@linux-foundation.org
Subject: + ftrace-warn-on-failure-to-disable-mcount-callers.patch added to -mm tree
Date: Tue, 26 Aug 2008 15:52:05 -0700
Message-ID: <200808262252.m7QMq5R8031916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239AbYHZWxV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 18:53:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, mingo@elte.hu, srostedt@redhat.com


The patch titled
     ftrace: warn on failure to disable mcount callers
has been added to the -mm tree.  Its filename is
     ftrace-warn-on-failure-to-disable-mcount-callers.patch

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
@@ -576,6 +576,16 @@ static void ftrace_shutdown_replenish(vo
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
@@ -590,6 +600,23 @@ ftrace_code_disable(struct dyn_ftrace *r
 
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

linux-next.patch
kbuild-ftrace-dont-assume-that-scripts-recordmcountpl-is-executable.patch
ftrace-warn-on-failure-to-disable-mcount-callers.patch

