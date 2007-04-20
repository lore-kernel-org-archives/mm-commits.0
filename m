From: akpm@linux-foundation.org
Subject: + spin_lock_unlocked-macro-cleanup-in-arch-ia64.patch added to -mm tree
Date: Fri, 20 Apr 2007 15:59:18 -0700
Message-ID: <200704202259.l3KMxID2025844@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767288AbXDTW7V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 18:59:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: milindchoudhary@gmail.com, tony.luck@intel.com


The patch titled
     SPIN_LOCK_UNLOCKED macro cleanup in arch/ia64
has been added to the -mm tree.  Its filename is
     spin_lock_unlocked-macro-cleanup-in-arch-ia64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SPIN_LOCK_UNLOCKED macro cleanup in arch/ia64
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

SPIN_LOCK_UNLOCKED macro cleanup, use __SPIN_LOCK_UNLOCKED instead.

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/traps.c  |    6 +++---
 arch/ia64/kernel/unwind.c |    2 +-
 arch/ia64/mm/tlb.c        |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/ia64/kernel/traps.c~spin_lock_unlocked-macro-cleanup-in-arch-ia64 arch/ia64/kernel/traps.c
--- a/arch/ia64/kernel/traps.c~spin_lock_unlocked-macro-cleanup-in-arch-ia64
+++ a/arch/ia64/kernel/traps.c
@@ -59,9 +59,9 @@ die (const char *str, struct pt_regs *re
 		u32 lock_owner;
 		int lock_owner_depth;
 	} die = {
-		.lock =			SPIN_LOCK_UNLOCKED,
-		.lock_owner =		-1,
-		.lock_owner_depth =	0
+		.lock =	__SPIN_LOCK_UNLOCKED(die.lock),
+		.lock_owner = -1,
+		.lock_owner_depth = 0
 	};
 	static int die_counter;
 	int cpu = get_cpu();
diff -puN arch/ia64/kernel/unwind.c~spin_lock_unlocked-macro-cleanup-in-arch-ia64 arch/ia64/kernel/unwind.c
--- a/arch/ia64/kernel/unwind.c~spin_lock_unlocked-macro-cleanup-in-arch-ia64
+++ a/arch/ia64/kernel/unwind.c
@@ -145,7 +145,7 @@ static struct {
 # endif
 } unw = {
 	.tables = &unw.kernel_table,
-	.lock = SPIN_LOCK_UNLOCKED,
+	.lock = __SPIN_LOCK_UNLOCKED(unw.lock),
 	.save_order = {
 		UNW_REG_RP, UNW_REG_PFS, UNW_REG_PSP, UNW_REG_PR,
 		UNW_REG_UNAT, UNW_REG_LC, UNW_REG_FPSR, UNW_REG_PRI_UNAT_GR
diff -puN arch/ia64/mm/tlb.c~spin_lock_unlocked-macro-cleanup-in-arch-ia64 arch/ia64/mm/tlb.c
--- a/arch/ia64/mm/tlb.c~spin_lock_unlocked-macro-cleanup-in-arch-ia64
+++ a/arch/ia64/mm/tlb.c
@@ -32,9 +32,9 @@ static struct {
 } purge;
 
 struct ia64_ctx ia64_ctx = {
-	.lock =		SPIN_LOCK_UNLOCKED,
-	.next =		1,
-	.max_ctx =	~0U
+	.lock =	__SPIN_LOCK_UNLOCKED(ia64_ctx.lock),
+	.next =	1,
+	.max_ctx = ~0U
 };
 
 DEFINE_PER_CPU(u8, ia64_need_tlb_flush);
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

git-alsa.patch
git-powerpc.patch
spin_lock_unlocked-cleanup-in-arch-powerpc.patch
spin_lock_unlocked-macro-cleanup-in-arch-ia64.patch
git-ieee1394.patch
spin_lock_unlocked-cleanup-in-drivers-ata-pata_winbondc.patch
spin_lock_unlocked-cleanup-in-arch-mips.patch
round_up-macro-cleanup-in-drivers-net-ppp_genericc.patch
spin_lock_unlocked-cleanup-in-drivers-atm-net.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
pcie-remove-spin_lock_unlocked.patch
spin_lock_unlocked-cleanup-in-drivers-s390.patch
round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch
round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch
spin_lock_unlocked-cleanup-in-arch-m68k.patch
round_up-macro-cleanup-in-drivers-char-lpc.patch
round_up-macro-cleanup-in-fs-selectcompatreaddirc.patch
round_up-macro-cleanup-in-fs-smbfs-requestc.patch
spin_lock_unlocked-cleanup-in-init_taskh.patch
spin_lock_unlocked-cleanup-in-drivers-char-keyboard.patch
spin_lock_unlocked-cleanup-in-drivers-serial.patch
