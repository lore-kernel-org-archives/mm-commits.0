From: akpm@linux-foundation.org
Subject: + kernel-kprobesc-convert-printk-to-pr_foo.patch added to -mm
 tree
Date: Tue, 06 May 2014 13:47:41 -0700
Message-ID: <53694a6d.+DjOsy755Mp3477w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40843 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaEFUrm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2014 16:47:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ananth@in.ibm.com, fabf@skynet.be

Subject: + kernel-kprobesc-convert-printk-to-pr_foo.patch added to -mm tree
To: fabf@skynet.be,ananth@in.ibm.com
From: akpm@linux-foundation.org
Date: Tue, 06 May 2014 13:47:41 -0700


The patch titled
     Subject: kernel/kprobes.c: convert printk to pr_foo()
has been added to the -mm tree.  Its filename is
     kernel-kprobesc-convert-printk-to-pr_foo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-kprobesc-convert-printk-to-pr_foo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-kprobesc-convert-printk-to-pr_foo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: kernel/kprobes.c: convert printk to pr_foo()

Also fixes some checkpatch warnings
-Static initialization
-Lines over 80 characters

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff -puN kernel/kprobes.c~kernel-kprobesc-convert-printk-to-pr_foo kernel/kprobes.c
--- a/kernel/kprobes.c~kernel-kprobesc-convert-printk-to-pr_foo
+++ a/kernel/kprobes.c
@@ -76,7 +76,7 @@ static bool kprobes_all_disarmed;
 
 /* This protects kprobe_table and optimizing_list */
 static DEFINE_MUTEX(kprobe_mutex);
-static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
+static DEFINE_PER_CPU(struct kprobe *, kprobe_instance);
 static struct {
 	raw_spinlock_t lock ____cacheline_aligned_in_smp;
 } kretprobe_table_locks[KPROBE_TABLE_SIZE];
@@ -297,9 +297,9 @@ static inline void reset_kprobe_instance
 
 /*
  * This routine is called either:
- * 	- under the kprobe_mutex - during kprobe_[un]register()
- * 				OR
- * 	- with preemption disabled - from arch/xxx/kernel/kprobes.c
+ *	- under the kprobe_mutex - during kprobe_[un]register()
+ *				OR
+ *	- with preemption disabled - from arch/xxx/kernel/kprobes.c
  */
 struct kprobe *get_kprobe(void *addr)
 {
@@ -567,7 +567,8 @@ static void wait_for_kprobe_optimizer(vo
 {
 	mutex_lock(&kprobe_mutex);
 
-	while (!list_empty(&optimizing_list) || !list_empty(&unoptimizing_list)) {
+	while (!list_empty(&optimizing_list) ||
+	       !list_empty(&unoptimizing_list)) {
 		mutex_unlock(&kprobe_mutex);
 
 		/* this will also make optimizing_work execute immmediately */
@@ -676,8 +677,8 @@ static void reuse_unused_kprobe(struct k
 	 */
 	op = container_of(ap, struct optimized_kprobe, kp);
 	if (unlikely(list_empty(&op->list)))
-		printk(KERN_WARNING "Warning: found a stray unused "
-			"aggrprobe@%p\n", ap->addr);
+		pr_warn("Warning: found a stray unused aggrprobe@%p\n",
+			ap->addr);
 	/* Enable the probe again */
 	ap->flags &= ~KPROBE_FLAG_DISABLED;
 	/* Optimize it again (remove from op->list) */
@@ -794,7 +795,7 @@ static void optimize_all_kprobes(void)
 			if (!kprobe_disabled(p))
 				optimize_kprobe(p);
 	}
-	printk(KERN_INFO "Kprobes globally optimized\n");
+	pr_info("Kprobes globally optimized\n");
 out:
 	mutex_unlock(&kprobe_mutex);
 }
@@ -824,7 +825,7 @@ static void unoptimize_all_kprobes(void)
 
 	/* Wait for unoptimizing completion */
 	wait_for_kprobe_optimizer();
-	printk(KERN_INFO "Kprobes globally unoptimized\n");
+	pr_info("Kprobes globally unoptimized\n");
 }
 
 static DEFINE_MUTEX(kprobe_sysctl_mutex);
@@ -896,7 +897,7 @@ static void __disarm_kprobe(struct kprob
 /* There should be no unused kprobes can be reused without optimization */
 static void reuse_unused_kprobe(struct kprobe *ap)
 {
-	printk(KERN_ERR "Error: There should be no unused kprobe here.\n");
+	pr_err("Error: There should be no unused kprobe here.\n");
 	BUG_ON(kprobe_unused(ap));
 }
 
@@ -955,7 +956,8 @@ static void disarm_kprobe_ftrace(struct
 	}
 	ret = ftrace_set_filter_ip(&kprobe_ftrace_ops,
 			   (unsigned long)p->addr, 1, 0);
-	WARN(ret < 0, "Failed to disarm kprobe-ftrace at %p (%d)\n", p->addr, ret);
+	WARN(ret < 0, "Failed to disarm kprobe-ftrace at %p (%d)\n",
+	     p->addr, ret);
 }
 #else	/* !CONFIG_KPROBES_ON_FTRACE */
 #define prepare_kprobe(p)	arch_prepare_kprobe(p)
@@ -1389,7 +1391,7 @@ static struct kprobe *__get_valid_kprobe
 	if (p != ap) {
 		list_for_each_entry_rcu(list_p, &ap->list, list)
 			if (list_p == p)
-			/* kprobe p is a valid probe */
+				/* kprobe p is a valid probe */
 				goto valid;
 		return NULL;
 	}
@@ -2018,8 +2020,8 @@ EXPORT_SYMBOL_GPL(enable_kprobe);
 
 void dump_kprobe(struct kprobe *kp)
 {
-	printk(KERN_WARNING "Dumping kprobe:\n");
-	printk(KERN_WARNING "Name: %s\nAddress: %p\nOffset: %x\n",
+	pr_warn("Dumping kprobe:\n");
+	pr_warn("Name: %s\nAddress: %p\nOffset: %x\n",
 	       kp->symbol_name, kp->addr, kp->offset);
 }
 NOKPROBE_SYMBOL(dump_kprobe);
@@ -2128,7 +2130,7 @@ static int __init init_kprobes(void)
 			kprobe_lookup_name(kretprobe_blacklist[i].name,
 					   kretprobe_blacklist[i].addr);
 			if (!kretprobe_blacklist[i].addr)
-				printk("kretprobe: lookup failed: %s\n",
+				pr_warn("kretprobe: lookup failed: %s\n",
 				       kretprobe_blacklist[i].name);
 		}
 	}
@@ -2310,7 +2312,7 @@ static void arm_all_kprobes(void)
 	}
 
 	kprobes_all_disarmed = false;
-	printk(KERN_INFO "Kprobes globally enabled\n");
+	pr_info("Kprobes globally enabled\n");
 
 already_enabled:
 	mutex_unlock(&kprobe_mutex);
@@ -2332,7 +2334,7 @@ static void disarm_all_kprobes(void)
 	}
 
 	kprobes_all_disarmed = true;
-	printk(KERN_INFO "Kprobes globally disabled\n");
+	pr_info("Kprobes globally disabled\n");
 
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-affs-superc-bugfix-double-free.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
fs-fscache-convert-printk-to-pr_foo.patch
fs-fscache-replace-seq_printf-by-seq_puts.patch
ntfs-remove-null-value-assignments.patch
fs-squashfs-squashfsh-replace-pr_warning-by-pr_warn.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
fs-9p-kerneldoc-fixes.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
mm-vmallocc-replace-seq_printf-by-seq_puts.patch
mm-mempolicyc-parameter-doc-uniformization.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
kernel-cpuc-convert-printk-to-pr_foo.patch
kernel-backtracetestc-replace-no-level-printk-by-pr_info.patch
kernel-capabilityc-code-clean-up.patch
kernel-exec_domainc-code-clean-up.patch
lib-libcrc32cc-use-ptr_err_or_zero.patch
lib-vsprintfc-fix-comparison-to-bool.patch
kernel-compatc-use-sizeof-instead-of-sizeof.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-cpusetc-kernel-doc-fixes.patch
kernel-cpusetc-convert-printk-to-pr_foo.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
init-mainc-code-clean-up.patch
ufs-sb-mutex-merge-mutex_destroy.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
kernel-latencytopc-convert-seq_printf-to-seq_puts.patch
kernel-posix-timersc-code-clean-up.patch
kernel-profilec-convert-printk-to-pr_foo.patch
kernel-rcu-treec-make-rcu-node-arrays-static-const-char-const.patch

