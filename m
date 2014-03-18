From: akpm@linux-foundation.org
Subject: + percpu-add-preemption-checks-to-__this_cpu-ops-fix.patch added
 to -mm tree
Date: Tue, 18 Mar 2014 14:38:10 -0700
Message-ID: <5328bcc2.wxjzrN25gWU7vzFk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaCRViK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Mar 2014 17:38:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, grygorii.strashko@ti.com, cl@linux.com

Subject: + percpu-add-preemption-checks-to-__this_cpu-ops-fix.patch added to -mm tree
To: cl@linux.com,grygorii.strashko@ti.com
From: akpm@linux-foundation.org
Date: Tue, 18 Mar 2014 14:38:10 -0700


The patch titled
     Subject: preemption_checks: avoid snprintf before checking error conditions
has been added to the -mm tree.  Its filename is
     percpu-add-preemption-checks-to-__this_cpu-ops-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/percpu-add-preemption-checks-to-__this_cpu-ops-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/percpu-add-preemption-checks-to-__this_cpu-ops-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: preemption_checks: avoid snprintf before checking error conditions

snprintf can cause hangs.  Move the string processing into the function so
that the string operations only occur when necessary after the conditions
have been checked.

Signed-off-by: Christoph Lameter <cl@linux.com>
Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/smp_processor_id.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN lib/smp_processor_id.c~percpu-add-preemption-checks-to-__this_cpu-ops-fix lib/smp_processor_id.c
--- a/lib/smp_processor_id.c~percpu-add-preemption-checks-to-__this_cpu-ops-fix
+++ a/lib/smp_processor_id.c
@@ -7,7 +7,8 @@
 #include <linux/kallsyms.h>
 #include <linux/sched.h>
 
-notrace static unsigned int check_preemption_disabled(char *what)
+notrace static unsigned int check_preemption_disabled(const char *what1,
+							const char *what2)
 {
 	int this_cpu = raw_smp_processor_id();
 
@@ -38,8 +39,8 @@ notrace static unsigned int check_preemp
 	if (!printk_ratelimit())
 		goto out_enable;
 
-	printk(KERN_ERR "BUG: using %s in preemptible [%08x] code: %s/%d\n",
-		what, preempt_count() - 1, current->comm, current->pid);
+	printk(KERN_ERR "BUG: using %s%s() in preemptible [%08x] code: %s/%d\n",
+		what1, what2, preempt_count() - 1, current->comm, current->pid);
 
 	print_symbol("caller is %s\n", (long)__builtin_return_address(0));
 	dump_stack();
@@ -52,15 +53,12 @@ out:
 
 notrace unsigned int debug_smp_processor_id(void)
 {
-	return check_preemption_disabled("smp_processor_id()");
+	return check_preemption_disabled("smp_processor_id","");
 }
 EXPORT_SYMBOL(debug_smp_processor_id);
 
 notrace void __this_cpu_preempt_check(const char *op)
 {
-	char text[40];
-
-	snprintf(text, sizeof(text), "__this_cpu_%s()", op);
-	check_preemption_disabled(text);
+	check_preemption_disabled("__this_cpu_", op);
 }
 EXPORT_SYMBOL(__this_cpu_preempt_check);
_

Patches currently in -mm which might be from cl@linux.com are

slub-fix-high-order-page-allocation-problem-with-__gfp_nofail.patch
kthread-ensure-locality-of-task_struct-allocations.patch
mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch
kobject-dont-block-for-each-kobject_uevent.patch
kobject-dont-block-for-each-kobject_uevent-v2.patch
slub-do-not-drop-slab_mutex-for-sysfs_slab_add.patch
fork-collapse-copy_flags-into-copy_process.patch
mm-mempolicy-rename-slab_node-for-clarity.patch
mm-mempolicy-remove-per-process-flag.patch
res_counter-remove-interface-for-locked-charging-and-uncharging.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
percpu-add-raw_cpu_ops.patch
mm-use-raw_cpu-ops-for-determining-current-numa-node.patch
modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount.patch
net-replace-__this_cpu_inc-in-routec-with-raw_cpu_inc.patch
percpu-add-preemption-checks-to-__this_cpu-ops.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix.patch

