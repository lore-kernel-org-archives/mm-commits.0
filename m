From: akpm@linux-foundation.org
Subject: [merged] asm-generic-systemh-drop-useless-__kernel__.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:54:59 -0700
Message-ID: <201107260754.p6Q7s291003308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491Ab1GZHy5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:54:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     asm-generic/system.h: drop useless __KERNEL__
has been removed from the -mm tree.  Its filename was
     asm-generic-systemh-drop-useless-__kernel__.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asm-generic/system.h: drop useless __KERNEL__
From: Mike Frysinger <vapier@gentoo.org>

This header isn't exported to user-space, and even if it was, the
__KERNEL__ check covers the entire file, so we'd get a useless stub in the
first place.  So punt it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/system.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/asm-generic/system.h~asm-generic-systemh-drop-useless-__kernel__ include/asm-generic/system.h
--- a/include/asm-generic/system.h~asm-generic-systemh-drop-useless-__kernel__
+++ a/include/asm-generic/system.h
@@ -14,7 +14,6 @@
 #ifndef __ASM_GENERIC_SYSTEM_H
 #define __ASM_GENERIC_SYSTEM_H
 
-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
 #include <linux/types.h>
@@ -139,5 +138,4 @@ unsigned long __xchg(unsigned long x, vo
 
 #endif /* !__ASSEMBLY__ */
 
-#endif /* __KERNEL__ */
 #endif /* __ASM_GENERIC_SYSTEM_H */
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
ptrace-unify-show_regs-prototype.patch
ptrace-unify-show_regs-prototype-fix.patch
atomic-use-linux-atomich.patch
atomic-move-atomic_add_unless-to-generic-code.patch
atomic-cleanup-asm-generic-atomich-inclusion.patch
atomic-update-comments-in-atomich.patch
asm-generic-atomich-simplify-inc-dec-test-helpers.patch
asm-generic-atomich-fix-type-used-in-atomic_clear_mask.patch
asm-generic-atomich-add-atomic_set_mask-helper.patch
asm-generic-atomich-allow-smp-peeps-to-leverage-this.patch

