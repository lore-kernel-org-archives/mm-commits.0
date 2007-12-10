From: akpm@linux-foundation.org
Subject: + uml-use-barrier-instead-of-mb.patch added to -mm tree
Date: Mon, 10 Dec 2007 15:52:40 -0800
Message-ID: <200712102352.lBANqeC6025458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34279 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751960AbXLJXws (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Dec 2007 18:52:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: use barrier() instead of mb()
has been added to the -mm tree.  Its filename is
     uml-use-barrier-instead-of-mb.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
update-stale-maintainers-entries.patch
git-kvm.patch
git-x86.patch
uml-add-asm-um-asmh.patch
uml-arch-um-include-inith-needs-a-definition-of-__used.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-tidy-pgtableh-fix.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
uml-host-tls-diagnostics.patch
uml-move-um_virt_to_phys.patch
uml-header-untangling.patch
uml-style-cleanup.patch
uml-currenth-cleanup.patch
uml-fix-page-table-data-sizes.patch
uml-add-virt_to_pte.patch
uml-simplify-sigsegv-handling.patch
uml-use-ptrace-directly-in-libc-code.patch
uml-kill-processes-instead-of-panicing-kernel.patch
uml-clean-up-task_size-usage.patch
uml-cover-stubs-with-a-vma.patch
uml-fix-command-line-cflags-and-ldflags-support.patch
uml-style-fixes-in-arch-um-os-linux.patch
uml-miscellaneous-code-cleanups.patch
uml-style-fixes-in-filec.patch
uml-64-bit-tlb-fixes.patch
uml-customize-tlbh.patch
uml-runtime-detection-of-host-vmsplit-on-i386.patch
uml-eliminate-setjmp_wrapper.patch
uml-install-panic-notifier-earlier.patch
uml-use-barrier-instead-of-mb.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
