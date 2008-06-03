From: akpm@linux-foundation.org
Subject: + uml-stub-needs-to-tolerate-sigwinch.patch added to -mm tree
Date: Tue, 03 Jun 2008 12:31:18 -0700
Message-ID: <200806031931.m53JVIcf015908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753944AbYFCTbW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 15:31:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, benedict.verheyen@gmail.com, jdike@linux.intel.com


The patch titled
     uml: stub needs to tolerate SIGWINCH
has been added to the -mm tree.  Its filename is
     uml-stub-needs-to-tolerate-sigwinch.patch

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

uml-deal-with-host-time-going-backwards.patch
uml-deal-with-inaccessible-address-space-start.patch
uml-memcpy-export-needs-to-follow-host-declaration.patch
uml-stub-needs-to-tolerate-sigwinch.patch
linux-next.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch
uml-activate_mm-remove-the-dead-pf_borrowed_mm-check.patch

