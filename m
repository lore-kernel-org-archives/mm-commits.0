From: akpm@linux-foundation.org
Subject: + fix-section-mismatch-warning-in-lockdep.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:31:42 -0800
Message-ID: <200702272031.l1RKVjbj027409@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50571 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbXB0Ubv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:31:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, mingo@elte.hu


The patch titled
     fix section mismatch warning in lockdep
has been added to the -mm tree.  Its filename is
     fix-section-mismatch-warning-in-lockdep.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Ingo Molnar <mingo@elte.hu>
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

fix-section-mismatch-warning-in-lockdep.patch
kbuild-override-build-timestamp.patch
kbuild-add-the-code-maturity-levels-deprecated-and-obsolete.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
allow-kernel-to-build-on-cygwin.patch
git-lxdialog.patch
git-parisc.patch
x86_64-fix-section-mismatch-warnings.patch
fix-section-mismatch-warning-in-lib-swiotlbc.patch
