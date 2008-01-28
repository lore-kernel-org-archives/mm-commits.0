From: akpm@linux-foundation.org
Subject: + kprobes-kretprobe-user-entry-handler-updated.patch added to -mm tree
Date: Sun, 27 Jan 2008 21:24:55 -0800
Message-ID: <200801280525.m0S5PoQc013838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56233 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753981AbYA1Fde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 00:33:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sagar.abhishek@gmail.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, prasanna@in.ibm.com


The patch titled
     kprobes: kretprobe user entry-handler (updated)
has been added to the -mm tree.  Its filename is
     kprobes-kretprobe-user-entry-handler-updated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: kretprobe user entry-handler (updated)
From: Abhishek Sagar <sagar.abhishek@gmail.com>

Provide support to add an optional user defined callback to be run at
function entry of a kretprobe'd function.  Also modify the kprobe smoke
tests to include an entry-handler during the kretprobe sanity test.

Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kprobes.txt |   81 ++++++++++++++++++++++++++++++------
 include/linux/kprobes.h   |    3 +
 kernel/kprobes.c          |    9 +++-
 kernel/test_kprobes.c     |   16 ++++++-
 4 files changed, 94 insertions(+), 15 deletions(-)

diff -puN Documentation/kprobes.txt~kprobes-kretprobe-user-entry-handler-updated Documentation/kprobes.txt
--- a/Documentation/kprobes.txt~kprobes-kretprobe-user-entry-handler-updated
+++ a/Documentation/kprobes.txt
@@ -96,7 +96,9 @@ or in registers (e.g., for x86_64 or for
 The jprobe will work in either case, so long as the handler's
 prototype matches that of the probed function.
 
-1.3 How Does a Return Probe Work?
+1.3 Return Probes
+
+1.3.1 How Does a Return Probe Work?
 
 When you call register_kretprobe(), Kprobes establishes a kprobe at
 the entry to the function.  When the probed function is called and this
@@ -107,9 +109,9 @@ At boot time, Kprobes registers a kprobe
 
 When the probed function executes its return instruction, control
 passes to the trampoline and that probe is hit.  Kprobes' trampoline
-handler calls the user-specified handler associated with the kretprobe,
-then sets the saved instruction pointer to the saved return address,
-and that's where execution resumes upon return from the trap.
+handler calls the user-specified return handler associated with the
+kretprobe, then sets the saved instruction pointer to the saved return
+address, and that's where execution resumes upon return from the trap.
 
 While the probed function is executing, its return address is
 stored in an object of type kretprobe_instance.  Before calling
@@ -131,6 +133,30 @@ zero when the return probe is registered
 time the probed function is entered but there is no kretprobe_instance
 object available for establishing the return probe.
 
+1.3.2 Kretprobe entry-handler
+
+Kretprobes also provides an optional user-specified handler which runs
+on function entry. This handler is specified by setting the entry_handler
+field of the kretprobe struct. Whenever the kprobe placed by kretprobe at the
+function entry is hit, the user-defined entry_handler, if any, is invoked.
+If the entry_handler returns 0 (success) then a corresponding return handler
+is guaranteed to be called upon function return. If the entry_handler
+returns a non-zero error then Kprobes leaves the return address as is, and
+the kretprobe has no further effect for that particular function instance.
+
+Multiple entry and return handler invocations are matched using the unique
+kretprobe_instance object associated with them. Additionally, a user
+may also specify per return-instance private data to be part of each
+kretprobe_instance object. This is especially useful when sharing private
+data between corresponding user entry and return handlers. The size of each
+private data object can be specified at kretprobe registration time by
+setting the data_size field of the kretprobe struct. This data can be
+accessed through the data field of each kretprobe_instance object.
+
+In case probed function is entered but there is no kretprobe_instance
+object available, then in addition to incrementing the nmissed count,
+the user entry_handler invocation is also skipped.
+
 2. Architectures Supported
 
 Kprobes, jprobes, and return probes are implemented on the following
@@ -273,6 +299,8 @@ of interest:
 - ret_addr: the return address
 - rp: points to the corresponding kretprobe object
 - task: points to the corresponding task struct
+- data: points to per return-instance private data; see "Kretprobe
+	entry-handler" for details.
 
 The regs_return_value(regs) macro provides a simple abstraction to
 extract the return value from the appropriate register as defined by
@@ -555,23 +583,52 @@ report failed calls to sys_open().
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/kprobes.h>
+#include <linux/ktime.h>
+
+/* per-instance private data */
+struct my_data {
+	ktime_t entry_stamp;
+};
 
 static const char *probed_func = "sys_open";
 
-/* Return-probe handler: If the probed function fails, log the return value. */
-static int ret_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
+/* Timestamp function entry. */
+static int entry_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
+{
+	struct my_data *data;
+
+	if(!current->mm)
+		return 1; /* skip kernel threads */
+
+	data = (struct my_data *)ri->data;
+	data->entry_stamp = ktime_get();
+	return 0;
+}
+
+/* If the probed function failed, log the return value and duration.
+ * Duration may turn out to be zero consistently, depending upon the
+ * granularity of time accounting on the platform. */
+static int return_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
 {
 	int retval = regs_return_value(regs);
+	struct my_data *data = (struct my_data *)ri->data;
+	s64 delta;
+	ktime_t now;
+
 	if (retval < 0) {
-		printk("%s returns %d\n", probed_func, retval);
+		now = ktime_get();
+		delta = ktime_to_ns(ktime_sub(now, data->entry_stamp));
+		printk("%s: return val = %d (duration = %lld ns)\n",
+		       probed_func, retval, delta);
 	}
 	return 0;
 }
 
 static struct kretprobe my_kretprobe = {
-	.handler = ret_handler,
-	/* Probe up to 20 instances concurrently. */
-	.maxactive = 20
+	.handler = return_handler,
+	.entry_handler = entry_handler,
+	.data_size = sizeof(struct my_data),
+	.maxactive = 20, /* probe up to 20 instances concurrently */
 };
 
 static int __init kretprobe_init(void)
@@ -583,7 +640,7 @@ static int __init kretprobe_init(void)
 		printk("register_kretprobe failed, returned %d\n", ret);
 		return -1;
 	}
-	printk("Planted return probe at %p\n", my_kretprobe.kp.addr);
+	printk("Kretprobe active on %s\n", my_kretprobe.kp.symbol_name);
 	return 0;
 }
 
@@ -593,7 +650,7 @@ static void __exit kretprobe_exit(void)
 	printk("kretprobe unregistered\n");
 	/* nmissed > 0 suggests that maxactive was set too low. */
 	printk("Missed probing %d instances of %s\n",
-		my_kretprobe.nmissed, probed_func);
+	       my_kretprobe.nmissed, probed_func);
 }
 
 module_init(kretprobe_init)
diff -puN include/linux/kprobes.h~kprobes-kretprobe-user-entry-handler-updated include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-kretprobe-user-entry-handler-updated
+++ a/include/linux/kprobes.h
@@ -152,8 +152,10 @@ static inline int arch_trampoline_kprobe
 struct kretprobe {
 	struct kprobe kp;
 	kretprobe_handler_t handler;
+	kretprobe_handler_t entry_handler;
 	int maxactive;
 	int nmissed;
+	size_t data_size;
 	struct hlist_head free_instances;
 	struct hlist_head used_instances;
 };
@@ -164,6 +166,7 @@ struct kretprobe_instance {
 	struct kretprobe *rp;
 	kprobe_opcode_t *ret_addr;
 	struct task_struct *task;
+	char data[0];
 };
 
 struct kretprobe_blackpoint {
diff -puN kernel/kprobes.c~kprobes-kretprobe-user-entry-handler-updated kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-kretprobe-user-entry-handler-updated
+++ a/kernel/kprobes.c
@@ -699,6 +699,12 @@ static int __kprobes pre_handler_kretpro
 				 struct kretprobe_instance, uflist);
 		ri->rp = rp;
 		ri->task = current;
+
+		if (rp->entry_handler && rp->entry_handler(ri, regs)) {
+			spin_unlock_irqrestore(&kretprobe_lock, flags);
+			return 0;
+		}
+
 		arch_prepare_kretprobe(ri, regs);
 
 		/* XXX(hch): why is there no hlist_move_head? */
@@ -745,7 +751,8 @@ int __kprobes register_kretprobe(struct 
 	INIT_HLIST_HEAD(&rp->used_instances);
 	INIT_HLIST_HEAD(&rp->free_instances);
 	for (i = 0; i < rp->maxactive; i++) {
-		inst = kmalloc(sizeof(struct kretprobe_instance), GFP_KERNEL);
+		inst = kmalloc(sizeof(struct kretprobe_instance) +
+			       rp->data_size, GFP_KERNEL);
 		if (inst == NULL) {
 			free_rp_inst(rp);
 			return -ENOMEM;
diff -puN kernel/test_kprobes.c~kprobes-kretprobe-user-entry-handler-updated kernel/test_kprobes.c
--- a/kernel/test_kprobes.c~kprobes-kretprobe-user-entry-handler-updated
+++ a/kernel/test_kprobes.c
@@ -135,6 +135,12 @@ static int test_jprobe(void)
 #ifdef CONFIG_KRETPROBES
 static u32 krph_val;
 
+static int entry_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
+{
+	krph_val = (rand1 / div_factor);
+	return 0;
+}
+
 static int return_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
 {
 	unsigned long ret = regs_return_value(regs);
@@ -144,13 +150,19 @@ static int return_handler(struct kretpro
 		printk(KERN_ERR "Kprobe smoke test failed: "
 				"incorrect value in kretprobe handler\n");
 	}
+	if (krph_val == 0) {
+		handler_errors++;
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"call to kretprobe entry handler failed\n");
+	}
 
-	krph_val = (rand1 / div_factor);
+	krph_val = rand1;
 	return 0;
 }
 
 static struct kretprobe rp = {
 	.handler	= return_handler,
+	.entry_handler  = entry_handler,
 	.kp.symbol_name = "kprobe_target"
 };
 
@@ -167,7 +179,7 @@ static int test_kretprobe(void)
 
 	ret = kprobe_target(rand1);
 	unregister_kretprobe(&rp);
-	if (krph_val == 0) {
+	if (krph_val != rand1) {
 		printk(KERN_ERR "Kprobe smoke test failed: "
 				"kretprobe handler not called\n");
 		handler_errors++;
_

Patches currently in -mm which might be from sagar.abhishek@gmail.com are

git-x86.patch
kprobes-kretprobe-user-entry-handler-updated.patch
