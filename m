From: akpm@linux-foundation.org
Subject: + ftrace-use-ftrace_release-for-all-dynamic-ftrace-functions.patch added to -mm tree
Date: Mon, 08 Sep 2008 15:27:16 -0700
Message-ID: <200809082227.m88MRGrZ013433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753920AbYIHW1m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 18:27:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, srostedt@redhat.com


The patch titled
     ftrace: use ftrace_release for all dynamic ftrace functions
has been added to the -mm tree.  Its filename is
     ftrace-use-ftrace_release-for-all-dynamic-ftrace-functions.patch

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
Subject: ftrace: use ftrace_release for all dynamic ftrace functions
From: Steven Rostedt <rostedt@goodmis.org>

ftrace_release is necessary for all uses of dynamic ftrace and not just
the archs that have CONFIG_FTRACE_MCOUNT_RECORD defined.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ftrace.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN include/linux/ftrace.h~ftrace-use-ftrace_release-for-all-dynamic-ftrace-functions include/linux/ftrace.h
--- a/include/linux/ftrace.h~ftrace-use-ftrace_release-for-all-dynamic-ftrace-functions
+++ a/include/linux/ftrace.h
@@ -77,8 +77,10 @@ extern void mcount_call(void);
 
 extern int skip_trace(unsigned long ip);
 
-void ftrace_disable_daemon(void);
-void ftrace_enable_daemon(void);
+extern void ftrace_release(void *start, unsigned long size);
+
+extern void ftrace_disable_daemon(void);
+extern void ftrace_enable_daemon(void);
 
 #else
 # define skip_trace(ip)				({ 0; })
@@ -86,6 +88,7 @@ void ftrace_enable_daemon(void);
 # define ftrace_set_filter(buf, len, reset)	do { } while (0)
 # define ftrace_disable_daemon()		do { } while (0)
 # define ftrace_enable_daemon()			do { } while (0)
+static inline void ftrace_release(void *start, unsigned long size) { }
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 /* totally disable ftrace - can not re-enable after this */
@@ -199,12 +202,10 @@ static inline void ftrace_dump(void) { }
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 extern void ftrace_init(void);
 extern void ftrace_init_module(unsigned long *start, unsigned long *end);
-extern void ftrace_release(void *start, unsigned long size);
 #else
 static inline void ftrace_init(void) { }
 static inline void
 ftrace_init_module(unsigned long *start, unsigned long *end) { }
-static inline void ftrace_release(void *start, unsigned long size) { }
 #endif
 
 
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
linux-next.patch
kbuild-ftrace-dont-assume-that-scripts-recordmcountpl-is-executable.patch
ftrace-warn-on-failure-to-disable-mcount-callers.patch
ftrace-remove-direct-reference-to-mcount-in-trace-code.patch
ftrace-use-ftrace_release-for-all-dynamic-ftrace-functions.patch
ftrace-fix-unlocking-of-hash.patch

