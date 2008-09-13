From: akpm@linux-foundation.org
Subject: - ftrace-fix-unlocking-of-hash.patch removed from -mm tree
Date: Sat, 13 Sep 2008 00:46:20 -0700
Message-ID: <200809130746.m8D7kKOA026845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753908AbYIMHqe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 13 Sep 2008 03:46:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, srostedt@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ftrace: fix unlocking of hash
has been removed from the -mm tree.  Its filename was
     ftrace-fix-unlocking-of-hash.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
ftrace-warn-on-failure-to-disable-mcount-callers.patch

