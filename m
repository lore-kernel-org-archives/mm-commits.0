From: akpm@linux-foundation.org
Subject: - i386-fix-a-couple-of-busy-loops-in-mach_wakecpuhwait_for_init_deassert.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:13:58 -0700
Message-ID: <200708201913.l7KJDw6P018497@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51906 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760613AbXHTTVa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, ak@suse.de, heiko.carstens@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     i386: Fix a couple of busy loops in  mach_wakecpu.h:wait_for_init_deassert()
has been removed from the -mm tree.  Its filename was
     i386-fix-a-couple-of-busy-loops-in-mach_wakecpuhwait_for_init_deassert.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: Fix a couple of busy loops in  mach_wakecpu.h:wait_for_init_deassert()
From: Satyam Sharma <satyam@infradead.org>

Use cpu_relax() in the busy loops, as atomic_read() doesn't automatically
imply volatility for i386 and x86_64. x86_64 doesn't have this issue because
it open-codes the while loop in smpboot.c:smp_callin() itself that already
uses cpu_relax().

For i386, however, smpboot.c:smp_callin() calls wait_for_init_deassert()
which is buggy for mach-default and mach-es7000 cases.

[ I test-built a kernel -- smp_callin() itself got inlined in its only
  callsite, smpboot.c:start_secondary() -- and the relevant piece of
  code disassembles to the following:

0xc1019704 <start_secondary+12>:        mov    0xc144c4c8,%eax
0xc1019709 <start_secondary+17>:        test   %eax,%eax
0xc101970b <start_secondary+19>:        je     0xc1019709 <start_secondary+17>

  init_deasserted (at 0xc144c4c8) gets fetched into %eax only once and
  then we loop over the test of the stale value in the register only,
  so these look like real bugs to me. With the fix below, this becomes:

0xc1019706 <start_secondary+14>:        pause
0xc1019708 <start_secondary+16>:        cmpl   $0x0,0xc144c4c8
0xc101970f <start_secondary+23>:        je     0xc1019706 <start_secondary+14>

  which looks nice and healthy. ]

Thanks to Heiko Carstens for noticing this.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/mach-default/mach_wakecpu.h |    3 ++-
 include/asm-i386/mach-es7000/mach_wakecpu.h  |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN include/asm-i386/mach-default/mach_wakecpu.h~i386-fix-a-couple-of-busy-loops-in-mach_wakecpuhwait_for_init_deassert include/asm-i386/mach-default/mach_wakecpu.h
--- a/include/asm-i386/mach-default/mach_wakecpu.h~i386-fix-a-couple-of-busy-loops-in-mach_wakecpuhwait_for_init_deassert
+++ a/include/asm-i386/mach-default/mach_wakecpu.h
@@ -15,7 +15,8 @@
 
 static inline void wait_for_init_deassert(atomic_t *deassert)
 {
-	while (!atomic_read(deassert));
+	while (!atomic_read(deassert))
+		cpu_relax();
 	return;
 }
 
diff -puN include/asm-i386/mach-es7000/mach_wakecpu.h~i386-fix-a-couple-of-busy-loops-in-mach_wakecpuhwait_for_init_deassert include/asm-i386/mach-es7000/mach_wakecpu.h
--- a/include/asm-i386/mach-es7000/mach_wakecpu.h~i386-fix-a-couple-of-busy-loops-in-mach_wakecpuhwait_for_init_deassert
+++ a/include/asm-i386/mach-es7000/mach_wakecpu.h
@@ -31,7 +31,8 @@ wakeup_secondary_cpu(int phys_apicid, un
 static inline void wait_for_init_deassert(atomic_t *deassert)
 {
 #ifdef WAKE_SECONDARY_VIA_INIT
-	while (!atomic_read(deassert));
+	while (!atomic_read(deassert))
+		cpu_relax();
 #endif
 	return;
 }
_

Patches currently in -mm which might be from satyam@infradead.org are

origin.patch
git-ieee1394.patch
git-netdev-all.patch
git-net.patch
introduce-u16_max-and-u32_max.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
