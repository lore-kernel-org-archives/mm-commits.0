From: akpm@linux-foundation.org
Subject: [merged] uml-fix-a-section-warning.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:37:01 -0700
Message-ID: <200906171837.n5HIb11F003122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755947AbZFQSqp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:46:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, jdike@addtoit.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     uml: fix a section warning
has been removed from the -mm tree.  Its filename was
     uml-fix-a-section-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

