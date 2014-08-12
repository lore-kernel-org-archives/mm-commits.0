From: akpm@linux-foundation.org
Subject: [to-be-updated] kernel-kprobesc-convert-printk-to-pr_foo.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 13:20:48 -0700
Message-ID: <53ea7720.xo/MIWR+z/rV20jT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:47010 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674AbaHLUUt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 16:20:49 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so2689536pde.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 13:20:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, ananth@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/kprobes.c: convert printk to pr_foo()
has been removed from the -mm tree.  Its filename was
     kernel-kprobesc-convert-printk-to-pr_foo.patch

This patch was dropped because an updated version will be merged

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
@@ -2132,7 +2134,7 @@ static int __init init_kprobes(void)
 			kprobe_lookup_name(kretprobe_blacklist[i].name,
 					   kretprobe_blacklist[i].addr);
 			if (!kretprobe_blacklist[i].addr)
-				printk("kretprobe: lookup failed: %s\n",
+				pr_warn("kretprobe: lookup failed: %s\n",
 				       kretprobe_blacklist[i].name);
 		}
 	}
@@ -2314,7 +2316,7 @@ static void arm_all_kprobes(void)
 	}
 
 	kprobes_all_disarmed = false;
-	printk(KERN_INFO "Kprobes globally enabled\n");
+	pr_info("Kprobes globally enabled\n");
 
 already_enabled:
 	mutex_unlock(&kprobe_mutex);
@@ -2336,7 +2338,7 @@ static void disarm_all_kprobes(void)
 	}
 
 	kprobes_all_disarmed = true;
-	printk(KERN_INFO "Kprobes globally disabled\n");
+	pr_info("Kprobes globally disabled\n");
 
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch

