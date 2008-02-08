From: akpm@linux-foundation.org
Subject: - uml-x86_64-should-copy-%fs-during-fork.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:21:10 -0800
Message-ID: <200802082020.m18KKp6H011261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38928 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932404AbYBHUfC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:35:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: x86_64 should copy %fs during fork
has been removed from the -mm tree.  Its filename was
     uml-x86_64-should-copy-%fs-during-fork.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: x86_64 should copy %fs during fork
From: Jeff Dike <jdike@addtoit.com>

%fs needs to be copied from parent to child during fork.

Tidied up some whitespace while I was here.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/processor-x86_64.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/asm-um/processor-x86_64.h~uml-x86_64-should-copy-%fs-during-fork include/asm-um/processor-x86_64.h
--- a/include/asm-um/processor-x86_64.h~uml-x86_64-should-copy-%fs-during-fork
+++ a/include/asm-um/processor-x86_64.h
@@ -26,7 +26,7 @@ static inline void rep_nop(void)
 #define cpu_relax()   rep_nop()
 
 #define INIT_ARCH_THREAD { .debugregs  		= { [ 0 ... 7 ] = 0 }, \
-                           .debugregs_seq	= 0,			       \
+			   .debugregs_seq	= 0, \
 			   .fs			= 0, \
 			   .faultinfo		= { 0, 0, 0 } }
 
@@ -37,6 +37,7 @@ static inline void arch_flush_thread(str
 static inline void arch_copy_thread(struct arch_thread *from,
                                     struct arch_thread *to)
 {
+	to->fs = from->fs;
 }
 
 #include "asm/arch/user.h"
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-update-defconfig.patch
random-add-async-notification-support-to-dev-random.patch
