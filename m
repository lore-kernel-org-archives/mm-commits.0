From: akpm@linux-foundation.org
Subject: - uml-use-barrier-instead-of-mb.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:37:36 -0800
Message-ID: <200802052237.m15MbHiv012841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57898 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762291AbYBEWle (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: use barrier() instead of mb()
has been removed from the -mm tree.  Its filename was
     uml-use-barrier-instead-of-mb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: use barrier() instead of mb()
From: Jeff Dike <jdike@addtoit.com>

signals_enabled and pending have requirements on the order in which they are
modified.  This used to be done by declaring them volatile and putting an mb()
where the ordering requirements were in effect.

After getting a better (I hope) understanding of how to do this correctly, the
volatile declarations are gone and the mb()'s replaced by barrier()'s.

One of the mb()'s was deleted because I see no problematic writes that could
be re-ordered past that point.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/signal.c |   28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff -puN arch/um/os-Linux/signal.c~uml-use-barrier-instead-of-mb arch/um/os-Linux/signal.c
--- a/arch/um/os-Linux/signal.c~uml-use-barrier-instead-of-mb
+++ a/arch/um/os-Linux/signal.c
@@ -15,6 +15,9 @@
 #include "sysdep/sigcontext.h"
 #include "user.h"
 
+/* Copied from linux/compiler-gcc.h since we can't include it directly */
+#define barrier() __asm__ __volatile__("": : :"memory")
+
 /*
  * These are the asynchronous signals.  SIGPROF is excluded because we want to
  * be able to profile all of UML, not just the non-critical sections.  If
@@ -27,13 +30,8 @@
 #define SIGVTALRM_BIT 1
 #define SIGVTALRM_MASK (1 << SIGVTALRM_BIT)
 
-/*
- * These are used by both the signal handlers and
- * block/unblock_signals.  I don't want modifications cached in a
- * register - they must go straight to memory.
- */
-static volatile int signals_enabled = 1;
-static volatile int pending = 0;
+static int signals_enabled;
+static unsigned int pending;
 
 void sig_handler(int sig, struct sigcontext *sc)
 {
@@ -198,7 +196,7 @@ void block_signals(void)
 	 * This might matter if gcc figures out how to inline this and
 	 * decides to shuffle this code into the caller.
 	 */
-	mb();
+	barrier();
 }
 
 void unblock_signals(void)
@@ -224,21 +222,11 @@ void unblock_signals(void)
 		 * Setting signals_enabled and reading pending must
 		 * happen in this order.
 		 */
-		mb();
+		barrier();
 
 		save_pending = pending;
-		if (save_pending == 0) {
-			/*
-			 * This must return with signals enabled, so
-			 * this barrier ensures that writes are
-			 * flushed out before the return.  This might
-			 * matter if gcc figures out how to inline
-			 * this (unlikely, given its size) and decides
-			 * to shuffle this code into the caller.
-			 */
-			mb();
+		if (save_pending == 0)
 			return;
-		}
 
 		pending = 0;
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
