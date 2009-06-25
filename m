From: akpm@linux-foundation.org
Subject: + kernel-core-add-smp_call_function_any-update.patch added to -mm tree
Date: Thu, 25 Jun 2009 12:08:27 -0700
Message-ID: <200906251908.n5PJ8ROe004832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757011AbZFYTLU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jun 2009 15:11:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, davej@redhat.com, efault@gmx.de, jaswinder@kernel.org, len.brown@intel.com, mingo@elte.hu, tglx@linutronix.de, venkatesh.pallipadi@intel.com, yakui.zhao@intel.com, yanmin_zhang@linux.intel.com


The patch titled
     kernel-core-add-smp_call_function_any-update
has been added to the -mm tree.  Its filename is
     kernel-core-add-smp_call_function_any-update.patch

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
Subject: kernel-core-add-smp_call_function_any-update
From: Rusty Russell <rusty@rustcorp.com.au>

Updated header comment and implementation comment.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Galbraith <efault@gmx.de>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/smp.c~kernel-core-add-smp_call_function_any-update kernel/smp.c
--- a/kernel/smp.c~kernel-core-add-smp_call_function_any-update
+++ a/kernel/smp.c
@@ -322,9 +322,9 @@ EXPORT_SYMBOL(smp_call_function_single);
  * @info: An arbitrary pointer to pass to the function.
  * @wait: If true, wait until function has completed.
  *
- * Returns 0 on success, else a negative status code. Note that @wait
- * will be implicitly turned on in case of allocation failures, since
- * we fall back to on-stack allocation.
+ * Returns 0 on success, else a negative status code (if no cpus were online).
+ * Note that @wait will be implicitly turned on in case of allocation failures,
+ * since we fall back to on-stack allocation.
  */
 int smp_call_function_any(const struct cpumask *mask,
 			  void (*func)(void *info), void *info, int wait)
@@ -346,7 +346,7 @@ int smp_call_function_any(const struct c
 			goto call;
 	}
 
-	/* Any online will do. */
+	/* Any online will do: smp_call_function_single handles nr_cpu_ids. */
 	cpu = cpumask_any_and(mask, cpu_online_mask);
 call:
 	ret = smp_call_function_single(cpu, func, info, wait);
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

eventfd-revised-interface-and-cleanups-4th-rev.patch
linux-next.patch
kernel-core-add-smp_call_function_any.patch
kernel-core-add-smp_call_function_any-update.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
reiser4.patch

