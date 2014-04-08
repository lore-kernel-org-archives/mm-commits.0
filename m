From: akpm@linux-foundation.org
Subject: [merged]
 x86-always-define-bug-and-have_arch_bug-even-with-config_bug.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 14:36:33 -0700
Message-ID: <53446be1.oKadjnNXU5oUfVAa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572AbaDHVge (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:36:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, arnd@arndb.de, josh@joshtriplett.org

Subject: [merged] x86-always-define-bug-and-have_arch_bug-even-with-config_bug.patch removed from -mm tree
To: josh@joshtriplett.org,arnd@arndb.de,hpa@zytor.com,mingo@elte.hu,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:36:33 -0700


The patch titled
     Subject: x86: always define BUG() and HAVE_ARCH_BUG, even with !CONFIG_BUG
has been removed from the -mm tree.  Its filename was
     x86-always-define-bug-and-have_arch_bug-even-with-config_bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: x86: always define BUG() and HAVE_ARCH_BUG, even with !CONFIG_BUG

This ensures that BUG() always has a definition that causes a trap (via an
undefined instruction), and that the compiler still recognizes the code
following BUG() as unreachable, avoiding warnings that would otherwise
appear (such as on non-void functions that don't return a value after
BUG()).

In addition to saving a few bytes over the generic infinite-loop
implementation, this implementation traps rather than looping, which
potentially allows for better error-recovery behavior (such as by
rebooting).

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/bug.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/x86/include/asm/bug.h~x86-always-define-bug-and-have_arch_bug-even-with-config_bug arch/x86/include/asm/bug.h
--- a/arch/x86/include/asm/bug.h~x86-always-define-bug-and-have_arch_bug-even-with-config_bug
+++ a/arch/x86/include/asm/bug.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_X86_BUG_H
 #define _ASM_X86_BUG_H
 
-#ifdef CONFIG_BUG
 #define HAVE_ARCH_BUG
 
 #ifdef CONFIG_DEBUG_BUGVERBOSE
@@ -33,8 +32,6 @@ do {								\
 } while (0)
 #endif
 
-#endif /* !CONFIG_BUG */
