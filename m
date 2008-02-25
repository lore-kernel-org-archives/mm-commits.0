From: akpm@linux-foundation.org
Subject: - ptrace-fix-2625-ptrace_bts_config-structure-declaration.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:46:13 -0800
Message-ID: <200802250046.m1P0kDiu006324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754997AbYBYAt3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:49:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anderson@redhat.com, mingo@elte.hu, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ptrace: fix 2.6.25 ptrace_bts_config structure declaration
has been removed from the -mm tree.  Its filename was
     ptrace-fix-2625-ptrace_bts_config-structure-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: fix 2.6.25 ptrace_bts_config structure declaration
From: Dave Anderson <anderson@redhat.com>

The 2.6.25 ptrace_bts_config structure in asm-x86/ptrace-abi.h is defined
with u32 types:

   #include <asm/types.h>

   /* configuration/status structure used in PTRACE_BTS_CONFIG and
      PTRACE_BTS_STATUS commands.
   */
   struct ptrace_bts_config {
           /* requested or actual size of BTS buffer in bytes */
           u32 size;
           /* bitmask of below flags */
           u32 flags;
           /* buffer overflow signal */
           u32 signal;
           /* actual size of bts_struct in bytes */
           u32 bts_size;
   };
   #endif

But u32 is only accessible in asm-x86/types.h if __KERNEL__, leading to
compile errors when ptrace.h is included from user-space.  Perhaps the
double-underscore versions that are exported to user-space in
asm-x86/types.h should be used instead?

Signed-off-by: Dave Anderson <anderson@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/ptrace-abi.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/asm-x86/ptrace-abi.h~ptrace-fix-2625-ptrace_bts_config-structure-declaration include/asm-x86/ptrace-abi.h
--- a/include/asm-x86/ptrace-abi.h~ptrace-fix-2625-ptrace_bts_config-structure-declaration
+++ a/include/asm-x86/ptrace-abi.h
@@ -89,13 +89,13 @@
 */
 struct ptrace_bts_config {
 	/* requested or actual size of BTS buffer in bytes */
-	u32 size;
+	__u32 size;
 	/* bitmask of below flags */
-	u32 flags;
+	__u32 flags;
 	/* buffer overflow signal */
-	u32 signal;
+	__u32 signal;
 	/* actual size of bts_struct in bytes */
-	u32 bts_size;
+	__u32 bts_size;
 };
 #endif
 
_

Patches currently in -mm which might be from anderson@redhat.com are

git-x86.patch
