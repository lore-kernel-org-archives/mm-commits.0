From: akpm@linux-foundation.org
Subject: - fix-section-mismatch-warning-in-lockdep.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:06:28 -0800
Message-ID: <200703020506.l2256SjN000799@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42432 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422787AbXCBFH4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:07:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, mingo@elte.hu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fix section mismatch warning in lockdep
has been removed from the -mm tree.  Its filename was
     fix-section-mismatch-warning-in-lockdep.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix section mismatch warning in lockdep
From: Sam Ravnborg <sam@ravnborg.org>

lockdep_init() is marked __init but used in several places
outside __init code. This causes following warnings:
$ scripts/mod/modpost kernel/lockdep.o
WARNING: kernel/built-in.o - Section mismatch: reference to .init.text:lockdep_init from .text.lockdep_init_map after 'lockdep_init_map' (at offset 0x105)
WARNING: kernel/built-in.o - Section mismatch: reference to .init.text:lockdep_init from .text.lockdep_reset_lock after 'lockdep_reset_lock' (at offset 0x35)
WARNING: kernel/built-in.o - Section mismatch: reference to .init.text:lockdep_init from .text.__lock_acquire after '__lock_acquire' (at offset 0xb2)

The warnings are less obviously due to heavy inlining by gcc - this is not
altered.

Fix the section mismatch warnings by removing the __init marking, which
seems obviously wrong.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/lockdep.c~fix-section-mismatch-warning-in-lockdep kernel/lockdep.c
--- a/kernel/lockdep.c~fix-section-mismatch-warning-in-lockdep
+++ a/kernel/lockdep.c
@@ -2602,7 +2602,7 @@ out_restore:
 	raw_local_irq_restore(flags);
 }
 
-void __init lockdep_init(void)
+void lockdep_init(void)
 {
 	int i;
 
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
kbuild-override-build-timestamp.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
allow-kernel-to-build-on-cygwin.patch
pcie-fix-section-mismatch-warning.patch
aer-fix-section-mismatch-warning.patch
pci-do-not-mark-exported-functions-as-__devinit.patch
x86_64-fix-section-mismatch-warnings.patch
fix-section-mismatch-warning-in-lib-swiotlbc.patch
extend-print_symbol-capability.patch
