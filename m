From: akpm@linux-foundation.org
Subject: + lkdtm-prefix-enum-constants.patch added to -mm tree
Date: Thu, 21 Oct 2010 14:03:44 -0700
Message-ID: <201010212103.o9LL3ikB003415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758058Ab0JUVEY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 17:04:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, ankita@in.ibm.com


The patch titled
     lkdtm: prefix enum constants
has been added to the -mm tree.  Its filename is
     lkdtm-prefix-enum-constants.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lkdtm: prefix enum constants
From: Namhyung Kim <namhyung@gmail.com>

Prefix cname and ctype constants with CN/CT_.  This is especially for the
conflict on BUG which causes a build break if arch defines it as a inline
function, i.e.  MIPS.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Ankita Garg <ankita@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lkdtm.c |  128 ++++++++++++++++++++---------------------
 1 file changed, 64 insertions(+), 64 deletions(-)

diff -puN drivers/misc/lkdtm.c~lkdtm-prefix-enum-constants drivers/misc/lkdtm.c
--- a/drivers/misc/lkdtm.c~lkdtm-prefix-enum-constants
+++ a/drivers/misc/lkdtm.c
@@ -52,32 +52,32 @@
 #define REC_NUM_DEFAULT 10
 
 enum cname {
-	INVALID,
-	INT_HARDWARE_ENTRY,
-	INT_HW_IRQ_EN,
-	INT_TASKLET_ENTRY,
-	FS_DEVRW,
-	MEM_SWAPOUT,
-	TIMERADD,
-	SCSI_DISPATCH_CMD,
-	IDE_CORE_CP,
-	DIRECT,
+	CN_INVALID,
+	CN_INT_HARDWARE_ENTRY,
+	CN_INT_HW_IRQ_EN,
+	CN_INT_TASKLET_ENTRY,
+	CN_FS_DEVRW,
+	CN_MEM_SWAPOUT,
+	CN_TIMERADD,
+	CN_SCSI_DISPATCH_CMD,
+	CN_IDE_CORE_CP,
+	CN_DIRECT,
 };
 
 enum ctype {
-	NONE,
-	PANIC,
-	BUG,
-	EXCEPTION,
-	LOOP,
-	OVERFLOW,
-	CORRUPT_STACK,
-	UNALIGNED_LOAD_STORE_WRITE,
-	OVERWRITE_ALLOCATION,
-	WRITE_AFTER_FREE,
-	SOFTLOCKUP,
-	HARDLOCKUP,
-	HUNG_TASK,
+	CT_NONE,
+	CT_PANIC,
+	CT_BUG,
+	CT_EXCEPTION,
+	CT_LOOP,
+	CT_OVERFLOW,
+	CT_CORRUPT_STACK,
+	CT_UNALIGNED_LOAD_STORE_WRITE,
+	CT_OVERWRITE_ALLOCATION,
+	CT_WRITE_AFTER_FREE,
+	CT_SOFTLOCKUP,
+	CT_HARDLOCKUP,
+	CT_HUNG_TASK,
 };
 
 static char* cp_name[] = {
@@ -117,8 +117,8 @@ static char* cpoint_type;
 static int cpoint_count = DEFAULT_COUNT;
 static int recur_count = REC_NUM_DEFAULT;
 
-static enum cname cpoint = INVALID;
-static enum ctype cptype = NONE;
+static enum cname cpoint = CN_INVALID;
+static enum ctype cptype = CT_NONE;
 static int count = DEFAULT_COUNT;
 
 module_param(recur_count, int, 0644);
@@ -207,12 +207,12 @@ static enum ctype parse_cp_type(const ch
 			return i + 1;
 	}
 
-	return NONE;
+	return CT_NONE;
 }
 
 static const char *cp_type_to_str(enum ctype type)
 {
-	if (type == NONE || type < 0 || type > ARRAY_SIZE(cp_type))
+	if (type == CT_NONE || type < 0 || type > ARRAY_SIZE(cp_type))
 		return "None";
 
 	return cp_type[type - 1];
@@ -220,7 +220,7 @@ static const char *cp_type_to_str(enum c
 
 static const char *cp_name_to_str(enum cname name)
 {
-	if (name == INVALID || name < 0 || name > ARRAY_SIZE(cp_name))
+	if (name == CN_INVALID || name < 0 || name > ARRAY_SIZE(cp_name))
 		return "INVALID";
 
 	return cp_name[name - 1];
@@ -245,7 +245,7 @@ static int lkdtm_parse_commandline(void)
 		return -EINVAL;
 
 	cptype = parse_cp_type(cpoint_type, strlen(cpoint_type));
-	if (cptype == NONE)
+	if (cptype == CT_NONE)
 		return -EINVAL;
 
 	for (i = 0; i < ARRAY_SIZE(cp_name); i++) {
@@ -274,30 +274,30 @@ static int recursive_loop(int a)
 static void lkdtm_do_action(enum ctype which)
 {
 	switch (which) {
-	case PANIC:
+	case CT_PANIC:
 		panic("dumptest");
 		break;
-	case BUG:
+	case CT_BUG:
 		BUG();
 		break;
-	case EXCEPTION:
+	case CT_EXCEPTION:
 		*((int *) 0) = 0;
 		break;
-	case LOOP:
+	case CT_LOOP:
 		for (;;)
 			;
 		break;
-	case OVERFLOW:
+	case CT_OVERFLOW:
 		(void) recursive_loop(0);
 		break;
-	case CORRUPT_STACK: {
+	case CT_CORRUPT_STACK: {
 		volatile u32 data[8];
 		volatile u32 *p = data;
 
 		p[12] = 0x12345678;
 		break;
 	}
-	case UNALIGNED_LOAD_STORE_WRITE: {
+	case CT_UNALIGNED_LOAD_STORE_WRITE: {
 		static u8 data[5] __attribute__((aligned(4))) = {1, 2,
 				3, 4, 5};
 		u32 *p;
@@ -309,7 +309,7 @@ static void lkdtm_do_action(enum ctype w
 		*p = val;
 		 break;
 	}
-	case OVERWRITE_ALLOCATION: {
+	case CT_OVERWRITE_ALLOCATION: {
 		size_t len = 1020;
 		u32 *data = kmalloc(len, GFP_KERNEL);
 
@@ -317,7 +317,7 @@ static void lkdtm_do_action(enum ctype w
 		kfree(data);
 		break;
 	}
-	case WRITE_AFTER_FREE: {
+	case CT_WRITE_AFTER_FREE: {
 		size_t len = 1024;
 		u32 *data = kmalloc(len, GFP_KERNEL);
 
@@ -326,21 +326,21 @@ static void lkdtm_do_action(enum ctype w
 		memset(data, 0x78, len);
 		break;
 	}
-	case SOFTLOCKUP:
+	case CT_SOFTLOCKUP:
 		preempt_disable();
 		for (;;)
 			cpu_relax();
 		break;
-	case HARDLOCKUP:
+	case CT_HARDLOCKUP:
 		local_irq_disable();
 		for (;;)
 			cpu_relax();
 		break;
-	case HUNG_TASK:
+	case CT_HUNG_TASK:
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule();
 		break;
-	case NONE:
+	case CT_NONE:
 	default:
 		break;
 	}
@@ -363,43 +363,43 @@ static int lkdtm_register_cpoint(enum cn
 {
 	int ret;
 
-	cpoint = INVALID;
+	cpoint = CN_INVALID;
 	if (lkdtm.entry != NULL)
 		unregister_jprobe(&lkdtm);
 
 	switch (which) {
-	case DIRECT:
+	case CN_DIRECT:
 		lkdtm_do_action(cptype);
 		return 0;
-	case INT_HARDWARE_ENTRY:
+	case CN_INT_HARDWARE_ENTRY:
 		lkdtm.kp.symbol_name = "do_IRQ";
 		lkdtm.entry = (kprobe_opcode_t*) jp_do_irq;
 		break;
-	case INT_HW_IRQ_EN:
+	case CN_INT_HW_IRQ_EN:
 		lkdtm.kp.symbol_name = "handle_IRQ_event";
 		lkdtm.entry = (kprobe_opcode_t*) jp_handle_irq_event;
 		break;
-	case INT_TASKLET_ENTRY:
+	case CN_INT_TASKLET_ENTRY:
 		lkdtm.kp.symbol_name = "tasklet_action";
 		lkdtm.entry = (kprobe_opcode_t*) jp_tasklet_action;
 		break;
-	case FS_DEVRW:
+	case CN_FS_DEVRW:
 		lkdtm.kp.symbol_name = "ll_rw_block";
 		lkdtm.entry = (kprobe_opcode_t*) jp_ll_rw_block;
 		break;
-	case MEM_SWAPOUT:
+	case CN_MEM_SWAPOUT:
 		lkdtm.kp.symbol_name = "shrink_inactive_list";
 		lkdtm.entry = (kprobe_opcode_t*) jp_shrink_inactive_list;
 		break;
-	case TIMERADD:
+	case CN_TIMERADD:
 		lkdtm.kp.symbol_name = "hrtimer_start";
 		lkdtm.entry = (kprobe_opcode_t*) jp_hrtimer_start;
 		break;
-	case SCSI_DISPATCH_CMD:
+	case CN_SCSI_DISPATCH_CMD:
 		lkdtm.kp.symbol_name = "scsi_dispatch_cmd";
 		lkdtm.entry = (kprobe_opcode_t*) jp_scsi_dispatch_cmd;
 		break;
-	case IDE_CORE_CP:
+	case CN_IDE_CORE_CP:
 #ifdef CONFIG_IDE
 		lkdtm.kp.symbol_name = "generic_ide_ioctl";
 		lkdtm.entry = (kprobe_opcode_t*) jp_generic_ide_ioctl;
@@ -416,7 +416,7 @@ static int lkdtm_register_cpoint(enum cn
 	cpoint = which;
 	if ((ret = register_jprobe(&lkdtm)) < 0) {
 		printk(KERN_INFO "lkdtm: Couldn't register jprobe\n");
-		cpoint = INVALID;
+		cpoint = CN_INVALID;
 	}
 
 	return ret;
@@ -445,7 +445,7 @@ static ssize_t do_register_entry(enum cn
 	cptype = parse_cp_type(buf, count);
 	free_page((unsigned long) buf);
 
-	if (cptype == NONE)
+	if (cptype == CT_NONE)
 		return -EINVAL;
 
 	err = lkdtm_register_cpoint(which);
@@ -487,49 +487,49 @@ static int lkdtm_debugfs_open(struct ino
 static ssize_t int_hardware_entry(struct file *f, const char __user *buf,
 		size_t count, loff_t *off)
 {
-	return do_register_entry(INT_HARDWARE_ENTRY, f, buf, count, off);
+	return do_register_entry(CN_INT_HARDWARE_ENTRY, f, buf, count, off);
 }
 
 static ssize_t int_hw_irq_en(struct file *f, const char __user *buf,
 		size_t count, loff_t *off)
 {
-	return do_register_entry(INT_HW_IRQ_EN, f, buf, count, off);
+	return do_register_entry(CN_INT_HW_IRQ_EN, f, buf, count, off);
 }
 
 static ssize_t int_tasklet_entry(struct file *f, const char __user *buf,
 		size_t count, loff_t *off)
 {
-	return do_register_entry(INT_TASKLET_ENTRY, f, buf, count, off);
+	return do_register_entry(CN_INT_TASKLET_ENTRY, f, buf, count, off);
 }
 
 static ssize_t fs_devrw_entry(struct file *f, const char __user *buf,
 		size_t count, loff_t *off)
 {
-	return do_register_entry(FS_DEVRW, f, buf, count, off);
+	return do_register_entry(CN_FS_DEVRW, f, buf, count, off);
 }
 
 static ssize_t mem_swapout_entry(struct file *f, const char __user *buf,
 		size_t count, loff_t *off)
 {
-	return do_register_entry(MEM_SWAPOUT, f, buf, count, off);
+	return do_register_entry(CN_MEM_SWAPOUT, f, buf, count, off);
 }
 
 static ssize_t timeradd_entry(struct file *f, const char __user *buf,
 		size_t count, loff_t *off)
 {
-	return do_register_entry(TIMERADD, f, buf, count, off);
+	return do_register_entry(CN_TIMERADD, f, buf, count, off);
 }
 
 static ssize_t scsi_dispatch_cmd_entry(struct file *f,
 		const char __user *buf, size_t count, loff_t *off)
 {
-	return do_register_entry(SCSI_DISPATCH_CMD, f, buf, count, off);
+	return do_register_entry(CN_SCSI_DISPATCH_CMD, f, buf, count, off);
 }
 
 static ssize_t ide_core_cp_entry(struct file *f, const char __user *buf,
 		size_t count, loff_t *off)
 {
-	return do_register_entry(IDE_CORE_CP, f, buf, count, off);
+	return do_register_entry(CN_IDE_CORE_CP, f, buf, count, off);
 }
 
 /* Special entry to just crash directly. Available without KPROBEs */
@@ -557,7 +557,7 @@ static ssize_t direct_entry(struct file 
 
 	type = parse_cp_type(buf, count);
 	free_page((unsigned long) buf);
-	if (type == NONE)
+	if (type == CT_NONE)
 		return -EINVAL;
 
 	printk(KERN_INFO "lkdtm: Performing direct entry %s\n",
@@ -649,7 +649,7 @@ static int __init lkdtm_module_init(void
 		goto out_err;
 	}
 
-	if (cpoint != INVALID && cptype != NONE) {
+	if (cpoint != CN_INVALID && cptype != CT_NONE) {
 		ret = lkdtm_register_cpoint(cpoint);
 		if (ret < 0) {
 			printk(KERN_INFO "lkdtm: Invalid crash point %d\n",
_

Patches currently in -mm which might be from namhyung@gmail.com are

linux-next.patch
posix-timers-annotate-lock_timer.patch
vfs-remove-a-warning-on-open_fmode.patch
vfs-add-__fmode_exec.patch
mm-remove-temporary-variable-on-generic_file_direct_write.patch
mm-add-casts-to-from-gfp_t-in-gfp_to_alloc_flags.patch
mm-wrap-get_locked_pte-using-__cond_lock.patch
mm-add-lock-release-annotation-on-do_wp_page.patch
mm-wrap-follow_pte-using-__cond_lock.patch
rmap-annotate-lock-context-change-on-page_lock_anon_vma.patch
rmap-wrap-page_check_address-using-__cond_lock.patch
rmap-make-anon_vma_free-static.patch
rmap-make-anon_vma_free-static-fix.patch
vmalloc-rename-temporary-variable-in-__insert_vmap_area.patch
vmalloc-annotate-lock-context-change-on-s_start-stop.patch
mm-declare-some-external-symbols.patch
vmstat-include-compactionh-when-config_compaction.patch
vmstat-include-compactionh-when-config_compaction-fix.patch
mm-fix-sparse-warnings-on-gfp_zone_table-bad.patch
lkdtm-prefix-enum-constants.patch
init-mark-__user-address-space-on-string-literals.patch
kernel-userc-add-lock-release-annotation-on-free_user.patch
printk-fixup-declaration-of-kmsg_reasons.patch
printk-add-lock-context-annotation.patch
printk-change-type-of-boot_delay-to-int.patch
printk-declare-printk_ratelimit_state-in-ratelimith.patch
printk-declare-printk_ratelimit_state-in-ratelimith-fix.patch
lib-parser-cleanup-match_number.patch
ptrace-annotate-lock-context-change-on-exit_ptrace.patch
ptrace-change-signature-of-sys_ptrace-and-friends.patch
ptrace-cleanup-ptrace_request.patch
ptrace-change-signature-of-arch_ptrace.patch
ptrace-cleanup-arch_ptrace-on-x86.patch
ptrace-cleanup-arch_ptrace-on-arm.patch
ptrace-cleanup-arch_ptrace-on-avr32.patch
ptrace-cleanup-arch_ptrace-and-friends-on-blackfin.patch
ptrace-cleanup-arch_ptrace-on-cris.patch
ptrace-cleanup-arch_ptrace-on-frv.patch
ptrace-cleanup-arch_ptrace-on-h8300.patch
ptrace-cleanup-arch_ptrace-on-m32r.patch
ptrace-cleanup-arch_ptrace-on-m68k.patch
ptrace-cleanup-arch_ptrace-on-m68knommu.patch
ptrace-cleanup-arch_ptrace-on-microblaze.patch
ptrace-cleanup-arch_ptrace-on-mips.patch
ptrace-cleanup-arch_ptrace-on-mn10300.patch
ptrace-cleanup-arch_ptrace-on-parisc.patch
ptrace-cleanup-arch_ptrace-on-powerpc.patch
ptrace-cleanup-arch_ptrace-on-score.patch
ptrace-cleanup-arch_ptrace-on-sh.patch
ptrace-cleanup-arch_ptrace-on-sparc.patch
ptrace-cleanup-arch_ptrace-on-tile.patch
ptrace-cleanup-arch_ptrace-on-um.patch
ptrace-cleanup-arch_ptrace-on-xtensa.patch
signals-annotate-lock_task_sighand.patch
signals-annotate-lock-context-change-on-ptrace_stop.patch
exit-add-lock-context-annotation-on-find_new_reaper.patch

