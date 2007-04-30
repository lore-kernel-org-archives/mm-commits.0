From: akpm@linux-foundation.org
Subject: - spin_lock_unlocked-cleanup-in-arch-powerpc.patch removed from -mm tree
Date: Mon, 30 Apr 2007 14:44:39 -0700
Message-ID: <200704302144.l3ULidSs015612@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031148AbXD3Vp1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 17:45:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: milindchoudhary@gmail.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     SPIN_LOCK_UNLOCKED cleanup in arch/powerpc
has been removed from the -mm tree.  Its filename was
     spin_lock_unlocked-cleanup-in-arch-powerpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SPIN_LOCK_UNLOCKED cleanup in arch/powerpc
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

SPIN_LOCK_UNLOCKED cleanup,use DEFINE_SPINLOCK or __SPIN_LOCK_UNLOCKED
where ever appropriate.

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/irq.c              |    2 +-
 arch/powerpc/kernel/rtas.c             |    2 +-
 arch/powerpc/oprofile/op_model_cell.c  |    2 +-
 arch/powerpc/platforms/cell/spu_base.c |    2 +-
 arch/powerpc/platforms/ps3/htab.c      |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/powerpc/kernel/irq.c~spin_lock_unlocked-cleanup-in-arch-powerpc arch/powerpc/kernel/irq.c
--- a/arch/powerpc/kernel/irq.c~spin_lock_unlocked-cleanup-in-arch-powerpc
+++ a/arch/powerpc/kernel/irq.c
@@ -394,7 +394,7 @@ EXPORT_SYMBOL(do_softirq);
 #ifdef CONFIG_PPC_MERGE
 
 static LIST_HEAD(irq_hosts);
-static spinlock_t irq_big_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(irq_big_lock);
 static DEFINE_PER_CPU(unsigned int, irq_radix_reader);
 static unsigned int irq_radix_writer;
 struct irq_map_entry irq_map[NR_IRQS];
diff -puN arch/powerpc/kernel/rtas.c~spin_lock_unlocked-cleanup-in-arch-powerpc arch/powerpc/kernel/rtas.c
--- a/arch/powerpc/kernel/rtas.c~spin_lock_unlocked-cleanup-in-arch-powerpc
+++ a/arch/powerpc/kernel/rtas.c
@@ -36,7 +36,7 @@
 #include <asm/syscalls.h>
 
 struct rtas_t rtas = {
-	.lock = SPIN_LOCK_UNLOCKED
+	.lock = __SPIN_LOCK_UNLOCKED(rtas.lock)
 };
 EXPORT_SYMBOL(rtas);
 
diff -puN arch/powerpc/oprofile/op_model_cell.c~spin_lock_unlocked-cleanup-in-arch-powerpc arch/powerpc/oprofile/op_model_cell.c
--- a/arch/powerpc/oprofile/op_model_cell.c~spin_lock_unlocked-cleanup-in-arch-powerpc
+++ a/arch/powerpc/oprofile/op_model_cell.c
@@ -131,7 +131,7 @@ static int pm_rtas_token;
 static u32 reset_value[NR_PHYS_CTRS];
 static int num_counters;
 static int oprofile_running;
-static spinlock_t virt_cntr_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(virt_cntr_lock);
 
 static u32 ctr_enabled;
 
diff -puN arch/powerpc/platforms/cell/spu_base.c~spin_lock_unlocked-cleanup-in-arch-powerpc arch/powerpc/platforms/cell/spu_base.c
--- a/arch/powerpc/platforms/cell/spu_base.c~spin_lock_unlocked-cleanup-in-arch-powerpc
+++ a/arch/powerpc/platforms/cell/spu_base.c
@@ -43,7 +43,7 @@ const struct spu_priv1_ops *spu_priv1_op
 static struct list_head spu_list[MAX_NUMNODES];
 static LIST_HEAD(spu_full_list);
 static DEFINE_MUTEX(spu_mutex);
-static spinlock_t spu_list_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(spu_list_lock);
 
 EXPORT_SYMBOL_GPL(spu_priv1_ops);
 
diff -puN arch/powerpc/platforms/ps3/htab.c~spin_lock_unlocked-cleanup-in-arch-powerpc arch/powerpc/platforms/ps3/htab.c
--- a/arch/powerpc/platforms/ps3/htab.c~spin_lock_unlocked-cleanup-in-arch-powerpc
+++ a/arch/powerpc/platforms/ps3/htab.c
@@ -39,7 +39,7 @@ static unsigned long htab_addr;
 static unsigned char *bolttab;
 static unsigned char *inusetab;
 
-static spinlock_t ps3_bolttab_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(ps3_bolttab_lock);
 
 #define debug_dump_hpte(_a, _b, _c, _d, _e, _f, _g) \
 	_debug_dump_hpte(_a, _b, _c, _d, _e, _f, _g, __func__, __LINE__)
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

origin.patch
git-alsa.patch
spin_lock_unlocked-macro-cleanup-in-arch-ia64.patch
git-jfs.patch
nfs-use-__set_current_state.patch
git-ocfs2.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
pcie-remove-spin_lock_unlocked.patch
round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch
round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch
spin_lock_unlocked-cleanup-in-arch-m68k.patch
round_up-macro-cleanup-in-drivers-char-lpc.patch
round_up-macro-cleanup-in-fs-selectcompatreaddirc.patch
round_up-macro-cleanup-in-fs-smbfs-requestc.patch
spin_lock_unlocked-cleanup-in-init_taskh.patch
spin_lock_unlocked-cleanup-in-drivers-char-keyboard.patch
spin_lock_unlocked-cleanup-in-drivers-serial.patch
reiserfs-use-__set_current_state.patch
drivers-char-use-__set_current_state.patch
