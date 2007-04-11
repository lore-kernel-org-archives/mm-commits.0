From: akpm@linux-foundation.org
Subject: + spin_lock_unlocked-cleanup-in-arch-powerpc.patch added to -mm tree
Date: Wed, 11 Apr 2007 13:32:29 -0700
Message-ID: <200704112032.l3BKWTsj013732@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59627 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030502AbXDKUcg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 16:32:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: milindchoudhary@gmail.com, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     SPIN_LOCK_UNLOCKED cleanup in arch/powerpc
has been added to the -mm tree.  Its filename is
     spin_lock_unlocked-cleanup-in-arch-powerpc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -130,7 +130,7 @@ static int pm_rtas_token;
 static u32 reset_value[NR_PHYS_CTRS];
 static int num_counters;
 static int oprofile_running;
-static spinlock_t virt_cntr_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(virt_cntr_lock);
 
 static u32 ctr_enabled;
 
diff -puN arch/powerpc/platforms/cell/spu_base.c~spin_lock_unlocked-cleanup-in-arch-powerpc arch/powerpc/platforms/cell/spu_base.c
--- a/arch/powerpc/platforms/cell/spu_base.c~spin_lock_unlocked-cleanup-in-arch-powerpc
+++ a/arch/powerpc/platforms/cell/spu_base.c
@@ -41,7 +41,7 @@ const struct spu_priv1_ops *spu_priv1_op
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

unused-round_up-name_offset-macro-in-arch-powerpc.patch
spin_lock_unlocked-cleanup-in-arch-powerpc.patch
spin_lock_unlocked-cleanup-in-drivers-ata-pata_winbondc.patch
round_up-macro-cleanup-in-drivers-net-ppp_genericc.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch
round_up-macro-cleanup-in-drivers-char-lpc.patch
round_up-macro-cleanup-in-fs-selectcompatreaddirc.patch
round_up-macro-cleanup-in-fs-smbfs-requestc.patch
