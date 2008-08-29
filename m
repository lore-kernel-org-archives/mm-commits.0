From: akpm@linux-foundation.org
Subject: + ftrace-remove-direct-reference-to-mcount-in-trace-code.patch added to -mm tree
Date: Thu, 28 Aug 2008 17:02:25 -0700
Message-ID: <200808290002.m7T02PUe021305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753219AbYH2AD3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 20:03:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, srostedt@redhat.com


The patch titled
     ftrace: remove direct reference to mcount in trace code
has been added to the -mm tree.  Its filename is
     ftrace-remove-direct-reference-to-mcount-in-trace-code.patch

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

origin.patch
linux-next.patch
kbuild-ftrace-dont-assume-that-scripts-recordmcountpl-is-executable.patch
ftrace-warn-on-failure-to-disable-mcount-callers.patch
ftrace-remove-direct-reference-to-mcount-in-trace-code.patch

