From: akpm@linux-foundation.org
Subject: - spin_lock_unlocked-macro-cleanup-in-arch-ia64.patch removed from -mm tree
Date: Tue, 08 May 2007 20:03:47 -0700
Message-ID: <200705090303.l4933lKK010982@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033384AbXEIDDu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:03:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: milindchoudhary@gmail.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     SPIN_LOCK_UNLOCKED macro cleanup in arch/ia64
has been removed from the -mm tree.  Its filename was
     spin_lock_unlocked-macro-cleanup-in-arch-ia64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-alsa.patch
git-ia64.patch
nfs-use-__set_current_state.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
pcie-remove-spin_lock_unlocked.patch
round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch
