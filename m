From: akpm@linux-foundation.org
Subject: [folded-merged]
 percpu-add-preemption-checks-to-__this_cpu-ops-fix.patch removed from -mm
 tree
Date: Mon, 07 Apr 2014 15:20:10 -0700
Message-ID: <5343249a.SNKCl1Z3X+nXuI55%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780AbaDGWUP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:20:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, grygorii.strashko@ti.com, cl@linux.com

Subject: [folded-merged] percpu-add-preemption-checks-to-__this_cpu-ops-fix.patch removed from -mm tree
To: cl@linux.com,grygorii.strashko@ti.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:20:10 -0700


The patch titled
     Subject: preemption_checks: avoid snprintf before checking error conditions
has been removed from the -mm tree.  Its filename was
     percpu-add-preemption-checks-to-__this_cpu-ops-fix.patch

This patch was dropped because it was folded into percpu-add-preemption-checks-to-__this_cpu-ops.patch

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
