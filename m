From: akpm@linux-foundation.org
Subject: + uml-x86_64-should-copy-%fs-during-fork.patch added to -mm tree
Date: Wed, 06 Feb 2008 14:20:21 -0800
Message-ID: <200802062220.m16MKLDH000633@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35213 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760070AbYBFWU1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 17:20:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: x86_64 should copy %fs during fork
has been added to the -mm tree.  Its filename is
     uml-x86_64-should-copy-%fs-during-fork.patch

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
fix-__const_udelay-declaration-and-definition-mismatches.patch
git-kvm.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
uml-runtime-host-vmsplit-detection.patch
uml-style-fixes-in-arch-um-os-linux.patch
uml-x86_64-should-copy-%fs-during-fork.patch
uml-fix-mm_context-memory-leak.patch
