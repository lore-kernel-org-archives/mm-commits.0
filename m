From: akpm@linux-foundation.org
Subject: - x86-64-eliminate-dead-code.patch removed from -mm tree
Date: Sat, 13 Sep 2008 00:45:31 -0700
Message-ID: <200809130745.m8D7jVhT026773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753183AbYIMHp4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 13 Sep 2008 03:45:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86-64: eliminate dead code
has been removed from the -mm tree.  Its filename was
     x86-64-eliminate-dead-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86-64: eliminate dead code
From: Jan Beulich <jbeulich@novell.com>

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/mmu.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN include/asm-x86/mmu.h~x86-64-eliminate-dead-code include/asm-x86/mmu.h
--- a/include/asm-x86/mmu.h~x86-64-eliminate-dead-code
+++ a/include/asm-x86/mmu.h
@@ -7,14 +7,9 @@
 /*
  * The x86 doesn't have a mmu context, but
  * we put the segment information here.
- *
- * cpu_vm_mask is used to optimize ldt flushing.
  */
 typedef struct {
 	void *ldt;
-#ifdef CONFIG_X86_64
-	rwlock_t ldtlock;
-#endif
 	int size;
 	struct mutex lock;
 	void *vdso;
_

Patches currently in -mm which might be from jbeulich@novell.com are

linux-next.patch
adjust-init-section-definitions.patch
kconfig-eliminate-def_bool-n-constructs.patch

