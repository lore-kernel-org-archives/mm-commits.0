From: akpm@linux-foundation.org
Subject: + therm_throtc-fix-section-mismatch.patch added to -mm tree
Date: Mon, 20 Aug 2007 22:03:34 -0700
Message-ID: <200708210503.l7L53Y6x007808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41486 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751949AbXHUFDr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Aug 2007 01:03:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org


The patch titled
     therm_throt.c: Fix section mismatch
has been added to the -mm tree.  Its filename is
     therm_throtc-fix-section-mismatch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: therm_throt.c: Fix section mismatch
From: Satyam Sharma <satyam@infradead.org>

Fix bugzilla #8679

WARNING: arch/i386/kernel/built-in.o(.data+0x2148): Section mismatch: reference
to .init.text: (between 'thermal_throttle_cpu_notifier' and 'mtrr_mutex')

comes because struct notifier_block thermal_throttle_cpu_notifier in
arch/i386/kernel/cpu/mcheck/therm_throt.c goes in .data section but the
notifier callback function itself has been marked __cpuinit which becomes
__init == .init.text when HOTPLUG_CPU=n.  The warning is bogus because the
callback will never be called out if HOTPLUG_CPU=n in the first place (as
one can see from kernel/cpu.c, the cpu_chain itself is __cpuinitdata :-)

So, let's mark thermal_throttle_cpu_notifier as __cpuinitdata to fix
the section mismatch warning.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mcheck/therm_throt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/cpu/mcheck/therm_throt.c~therm_throtc-fix-section-mismatch arch/i386/kernel/cpu/mcheck/therm_throt.c
--- a/arch/i386/kernel/cpu/mcheck/therm_throt.c~therm_throtc-fix-section-mismatch
+++ a/arch/i386/kernel/cpu/mcheck/therm_throt.c
@@ -152,7 +152,7 @@ static __cpuinit int thermal_throttle_cp
 	return NOTIFY_OK;
 }
 
-static struct notifier_block thermal_throttle_cpu_notifier =
+static struct notifier_block thermal_throttle_cpu_notifier __cpuinitdata =
 {
 	.notifier_call = thermal_throttle_cpu_callback,
 };
_

Patches currently in -mm which might be from satyam@infradead.org are

origin.patch
git-ieee1394.patch
git-netdev-all.patch
git-net.patch
introduce-u16_max-and-u32_max.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
therm_throtc-fix-section-mismatch.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
