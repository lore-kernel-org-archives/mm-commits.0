From: akpm@linux-foundation.org
Subject: - uml-stub-needs-to-tolerate-sigwinch.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:47:47 -0700
Message-ID: <200806081947.m58Jllh8017445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753901AbYFHTr5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:47:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, benedict.verheyen@gmail.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: stub needs to tolerate SIGWINCH
has been removed from the -mm tree.  Its filename was
     uml-stub-needs-to-tolerate-sigwinch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: stub needs to tolerate SIGWINCH
From: Jeff Dike <jdike@addtoit.com>

We lost the marking of SIGWINCH as being OK to receive during stub
execution, causing a panic should that happen.

Cc: Benedict Verheyen <benedict.verheyen@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/skas/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/os-Linux/skas/process.c~uml-stub-needs-to-tolerate-sigwinch arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-stub-needs-to-tolerate-sigwinch
+++ a/arch/um/os-Linux/skas/process.c
@@ -55,7 +55,7 @@ static int ptrace_dump_regs(int pid)
  * Signals that are OK to receive in the stub - we'll just continue it.
  * SIGWINCH will happen when UML is inside a detached screen.
  */
-#define STUB_SIG_MASK (1 << SIGVTALRM)
+#define STUB_SIG_MASK ((1 << SIGVTALRM) | (1 << SIGWINCH))
 
 /* Signals that the stub will finish with - anything else is an error */
 #define STUB_DONE_MASK (1 << SIGTRAP)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
linux-next.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch

