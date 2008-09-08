From: akpm@linux-foundation.org
Subject: + ftrace-fix-unlocking-of-hash.patch added to -mm tree
Date: Mon, 08 Sep 2008 15:28:00 -0700
Message-ID: <200809082228.m88MS0MM013439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754009AbYIHW2Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 18:28:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, srostedt@redhat.com


The patch titled
     ftrace: fix unlocking of hash
has been added to the -mm tree.  Its filename is
     ftrace-fix-unlocking-of-hash.patch

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
Subject: ftrace: fix unlocking of hash
From: Steven Rostedt <rostedt@goodmis.org>

This must be brown paper bag week for Steven Rostedt!

While working on ftrace for PPC, I discovered that the hash locking done
when CONFIG_FTRACE_MCOUNT_RECORD is not set, is totally incorrect.

With a cut and paste error, I had the hash lock macro to lock for both
hash_lock _and_ hash_unlock!

This bug did not affect x86 since this bug was introduced when
CONFIG_FTRACE_MCOUNT_RECORD was added to x86.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/ftrace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/trace/ftrace.c~ftrace-fix-unlocking-of-hash kernel/trace/ftrace.c
--- a/kernel/trace/ftrace.c~ftrace-fix-unlocking-of-hash
+++ a/kernel/trace/ftrace.c
@@ -170,7 +170,8 @@ static int __unregister_ftrace_function(
  */
 static DEFINE_SPINLOCK(ftrace_hash_lock);
 #define ftrace_hash_lock(flags)	  spin_lock_irqsave(&ftrace_hash_lock, flags)
-#define ftrace_hash_unlock(flags) spin_lock_irqsave(&ftrace_hash_lock, flags)
+#define ftrace_hash_unlock(flags) \
+			spin_unlock_irqrestore(&ftrace_hash_lock, flags)
 #else
 /* This is protected via the ftrace_lock with MCOUNT_RECORD. */
 #define ftrace_hash_lock(flags)   do { (void)(flags); } while (0)
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
linux-next.patch
kbuild-ftrace-dont-assume-that-scripts-recordmcountpl-is-executable.patch
ftrace-warn-on-failure-to-disable-mcount-callers.patch
ftrace-remove-direct-reference-to-mcount-in-trace-code.patch
ftrace-use-ftrace_release-for-all-dynamic-ftrace-functions.patch
ftrace-fix-unlocking-of-hash.patch

