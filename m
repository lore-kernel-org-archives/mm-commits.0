From: akpm@linux-foundation.org
Subject: - kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:18:01 -0800
Message-ID: <200901072218.n07MI1fX017562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608AbZAGWir (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:38:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, mingo@elte.hu, paulus@samba.org, rmk@arm.linux.org.uk, sch


The patch titled
     kprobes: add kprobe_insn_mutex and cleanup arch_remove_kprobe()
has been removed from the -mm tree.  Its filename was
     kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: add kprobe_insn_mutex and cleanup arch_remove_kprobe()
From: Masami Hiramatsu <mhiramat@redhat.com>

Add kprobe_insn_mutex for protecting kprobe_insn_pages hlist, and remove
kprobe_mutex from architecture dependent code.

This allows us to call arch_remove_kprobe() (and free_insn_slot) while
holding kprobe_mutex.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/kprobes.c     |    2 --
 arch/ia64/kernel/kprobes.c    |    8 +++++---
 arch/powerpc/kernel/kprobes.c |    7 ++++---
 arch/s390/kernel/kprobes.c    |    7 ++++---
 arch/x86/kernel/kprobes.c     |    7 ++++---
 include/linux/kprobes.h       |    1 -
 kernel/kprobes.c              |   25 +++++++++++++++++++++----
 7 files changed, 38 insertions(+), 19 deletions(-)

diff -puN arch/arm/kernel/kprobes.c~kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe arch/arm/kernel/kprobes.c
--- a/arch/arm/kernel/kprobes.c~kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe
+++ a/arch/arm/kernel/kprobes.c
@@ -92,9 +92,7 @@ void __kprobes arch_disarm_kprobe(struct
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
 	if (p->ainsn.insn) {
-		mutex_lock(&kprobe_mutex);
 		free_insn_slot(p->ainsn.insn, 0);
-		mutex_unlock(&kprobe_mutex);
 		p->ainsn.insn = NULL;
 	}
 }
diff -puN arch/ia64/kernel/kprobes.c~kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe arch/ia64/kernel/kprobes.c
--- a/arch/ia64/kernel/kprobes.c~kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe
+++ a/arch/ia64/kernel/kprobes.c
@@ -670,9 +670,11 @@ void __kprobes arch_disarm_kprobe(struct
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
-	free_insn_slot(p->ainsn.insn, p->ainsn.inst_flag & INST_FLAG_BOOSTABLE);
-	mutex_unlock(&kprobe_mutex);
+	if (p->ainsn.insn) {
+		free_insn_slot(p->ainsn.insn,
+			       p->ainsn.inst_flag & INST_FLAG_BOOSTABLE);
+		p->ainsn.insn = NULL;
+	}
 }
 /*
  * We are resuming execution after a single step fault, so the pt_regs
diff -puN arch/powerpc/kernel/kprobes.c~kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe arch/powerpc/kernel/kprobes.c
--- a/arch/powerpc/kernel/kprobes.c~kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe
+++ a/arch/powerpc/kernel/kprobes.c
@@ -96,9 +96,10 @@ void __kprobes arch_disarm_kprobe(struct
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
-	free_insn_slot(p->ainsn.insn, 0);
-	mutex_unlock(&kprobe_mutex);
+	if (p->ainsn.insn) {
+		free_insn_slot(p->ainsn.insn, 0);
+		p->ainsn.insn = NULL;
+	}
 }
 
 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
diff -puN arch/s390/kernel/kprobes.c~kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe arch/s390/kernel/kprobes.c
--- a/arch/s390/kernel/kprobes.c~kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe
+++ a/arch/s390/kernel/kprobes.c
@@ -218,9 +218,10 @@ void __kprobes arch_disarm_kprobe(struct
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
-	free_insn_slot(p->ainsn.insn, 0);
-	mutex_unlock(&kprobe_mutex);
+	if (p->ainsn.insn) {
+		free_insn_slot(p->ainsn.insn, 0);
+		p->ainsn.insn = NULL;
+	}
 }
 
 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
diff -puN arch/x86/kernel/kprobes.c~kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe arch/x86/kernel/kprobes.c
--- a/arch/x86/kernel/kprobes.c~kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe
+++ a/arch/x86/kernel/kprobes.c
@@ -376,9 +376,10 @@ void __kprobes arch_disarm_kprobe(struct
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
-	free_insn_slot(p->ainsn.insn, (p->ainsn.boostable == 1));
-	mutex_unlock(&kprobe_mutex);
+	if (p->ainsn.insn) {
+		free_insn_slot(p->ainsn.insn, (p->ainsn.boostable == 1));
+		p->ainsn.insn = NULL;
+	}
 }
 
 static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
diff -puN include/linux/kprobes.h~kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe
+++ a/include/linux/kprobes.h
@@ -201,7 +201,6 @@ static inline int init_test_probes(void)
 }
 #endif /* CONFIG_KPROBES_SANITY_TEST */
 
-extern struct mutex kprobe_mutex;
 extern int arch_prepare_kprobe(struct kprobe *p);
 extern void arch_arm_kprobe(struct kprobe *p);
 extern void arch_disarm_kprobe(struct kprobe *p);
diff -puN kernel/kprobes.c~kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe
+++ a/kernel/kprobes.c
@@ -69,7 +69,7 @@ static struct hlist_head kretprobe_inst_
 /* NOTE: change this value only with kprobe_mutex held */
 static bool kprobe_enabled;
 
-DEFINE_MUTEX(kprobe_mutex);		/* Protects kprobe_table */
+static DEFINE_MUTEX(kprobe_mutex);	/* Protects kprobe_table */
 static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
 static struct {
 	spinlock_t lock ____cacheline_aligned_in_smp;
@@ -115,6 +115,7 @@ enum kprobe_slot_state {
 	SLOT_USED = 2,
 };
 
+static DEFINE_MUTEX(kprobe_insn_mutex);	/* Protects kprobe_insn_pages */
 static struct hlist_head kprobe_insn_pages;
 static int kprobe_garbage_slots;
 static int collect_garbage_slots(void);
@@ -144,10 +145,10 @@ loop_end:
 }
 
 /**
- * get_insn_slot() - Find a slot on an executable page for an instruction.
+ * __get_insn_slot() - Find a slot on an executable page for an instruction.
  * We allocate an executable page if there's no room on existing ones.
  */
-kprobe_opcode_t __kprobes *get_insn_slot(void)
+static kprobe_opcode_t __kprobes *__get_insn_slot(void)
 {
 	struct kprobe_insn_page *kip;
 	struct hlist_node *pos;
@@ -196,6 +197,15 @@ kprobe_opcode_t __kprobes *get_insn_slot
 	return kip->insns;
 }
 
+kprobe_opcode_t __kprobes *get_insn_slot(void)
+{
+	kprobe_opcode_t *ret;
+	mutex_lock(&kprobe_insn_mutex);
+	ret = __get_insn_slot();
+	mutex_unlock(&kprobe_insn_mutex);
+	return ret;
+}
+
 /* Return 1 if all garbages are collected, otherwise 0. */
 static int __kprobes collect_one_slot(struct kprobe_insn_page *kip, int idx)
 {
@@ -226,9 +236,13 @@ static int __kprobes collect_garbage_slo
 {
 	struct kprobe_insn_page *kip;
 	struct hlist_node *pos, *next;
+	int safety;
 
 	/* Ensure no-one is preepmted on the garbages */
-	if (check_safety() != 0)
+	mutex_unlock(&kprobe_insn_mutex);
+	safety = check_safety();
+	mutex_lock(&kprobe_insn_mutex);
+	if (safety != 0)
 		return -EAGAIN;
 
 	hlist_for_each_entry_safe(kip, pos, next, &kprobe_insn_pages, hlist) {
@@ -251,6 +265,7 @@ void __kprobes free_insn_slot(kprobe_opc
 	struct kprobe_insn_page *kip;
 	struct hlist_node *pos;
 
+	mutex_lock(&kprobe_insn_mutex);
 	hlist_for_each_entry(kip, pos, &kprobe_insn_pages, hlist) {
 		if (kip->insns <= slot &&
 		    slot < kip->insns + (INSNS_PER_PAGE * MAX_INSN_SIZE)) {
@@ -267,6 +282,8 @@ void __kprobes free_insn_slot(kprobe_opc
 
 	if (dirty && ++kprobe_garbage_slots > INSNS_PER_PAGE)
 		collect_garbage_slots();
+
+	mutex_unlock(&kprobe_insn_mutex);
 }
 #endif
 
_

Patches currently in -mm which might be from mhiramat@redhat.com are

origin.patch

