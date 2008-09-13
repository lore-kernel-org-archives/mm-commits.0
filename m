From: akpm@linux-foundation.org
Subject: - ftrace-remove-direct-reference-to-mcount-in-trace-code.patch removed from -mm tree
Date: Sat, 13 Sep 2008 00:46:16 -0700
Message-ID: <200809130746.m8D7kGec026839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753561AbYIMHqd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 13 Sep 2008 03:46:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, srostedt@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ftrace: remove direct reference to mcount in trace code
has been removed from the -mm tree.  Its filename was
     ftrace-remove-direct-reference-to-mcount-in-trace-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ftrace: remove direct reference to mcount in trace code
From: Steven Rostedt <rostedt@goodmis.org>

The mcount record method of ftrace scans objdump for references to mcount.
 Using mcount as the reference to test if the calls to mcount being
replaced are indeed calls to mcount, this use of mcount was also caught as
a location to change.  Using a variable that points to the mcount address
moves this reference into the data section that is not scanned, and we do
not use a false location to try and modify.

The warn on code was what was used to detect this bug.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/ftrace.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN kernel/trace/ftrace.c~ftrace-remove-direct-reference-to-mcount-in-trace-code kernel/trace/ftrace.c
--- a/kernel/trace/ftrace.c~ftrace-remove-direct-reference-to-mcount-in-trace-code
+++ a/kernel/trace/ftrace.c
@@ -37,6 +37,14 @@ int ftrace_enabled __read_mostly;
 static int last_ftrace_enabled;
 
 /*
+ * Since MCOUNT_ADDR may point to mcount itself, we do not want
+ * to get it confused by reading a reference in the code as we
+ * are parsing on objcopy output of text. Use a variable for
+ * it instead.
+ */
+static unsigned long mcount_addr = MCOUNT_ADDR;
+
+/*
  * ftrace_disabled is set when an anomaly is discovered.
  * ftrace_disabled is much stronger than ftrace_enabled.
  */
@@ -596,7 +604,7 @@ ftrace_code_disable(struct dyn_ftrace *r
 	ip = rec->ip;
 
 	nop = ftrace_nop_replace();
-	call = ftrace_call_replace(ip, MCOUNT_ADDR);
+	call = ftrace_call_replace(ip, mcount_addr);
 
 	failed = ftrace_modify_code(ip, call, nop);
 	if (failed) {
_

Patches currently in -mm which might be from rostedt@goodmis.org are

linux-next.patch
ftrace-warn-on-failure-to-disable-mcount-callers.patch

