From: akpm@linux-foundation.org
Subject: + uml-fix-a-section-warning.patch added to -mm tree
Date: Mon, 11 May 2009 13:14:03 -0700
Message-ID: <200905112014.n4BKE3G9019417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752504AbZEKURb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 16:17:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, jdike@addtoit.com, sam@ravnborg.org


The patch titled
     uml: fix a section warning
has been added to the -mm tree.  Its filename is
     uml-fix-a-section-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: fix a section warning
From: Amerigo Wang <amwang@redhat.com>

When compiling uml on x86_64:

  MODPOST vmlinux.o
WARNING: vmlinux.o (.__syscall_stub.2): unexpected non-allocatable section.
Did you forget to use "ax"/"aw" in a .S file?
Note that for example <linux/init.h> contains
section definitions for use in .S files.

Because modpost checks for missing SHF_ALLOC section flag.  So just add
it.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-i386/stub.S   |    2 +-
 arch/um/sys-x86_64/stub.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/sys-i386/stub.S~uml-fix-a-section-warning arch/um/sys-i386/stub.S
--- a/arch/um/sys-i386/stub.S~uml-fix-a-section-warning
+++ a/arch/um/sys-i386/stub.S
@@ -1,7 +1,7 @@
 #include "as-layout.h"
 
 	.globl syscall_stub
-.section .__syscall_stub, "x"
+.section .__syscall_stub, "ax"
 
 	.globl batch_syscall_stub
 batch_syscall_stub:
diff -puN arch/um/sys-x86_64/stub.S~uml-fix-a-section-warning arch/um/sys-x86_64/stub.S
--- a/arch/um/sys-x86_64/stub.S~uml-fix-a-section-warning
+++ a/arch/um/sys-x86_64/stub.S
@@ -1,7 +1,7 @@
 #include "as-layout.h"
 
 	.globl syscall_stub
-.section .__syscall_stub, "x"
+.section .__syscall_stub, "ax"
 syscall_stub:
 	syscall
 	/* We don't have 64-bit constants, so this constructs the address
_

Patches currently in -mm which might be from amwang@redhat.com are

uml-fix-a-section-warning.patch

