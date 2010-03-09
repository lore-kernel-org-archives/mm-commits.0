From: akpm@linux-foundation.org
Subject: [merged] cpumask-let-num__cpus-function-always-return-unsigned-values.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:05:42 -0800
Message-ID: <201003091905.o29J5gDR031139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445Ab0CITWz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, ananth@in.ibm.com, mhiramat@redhat.com, mingo@elte.hu, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     cpumask: let num_*_cpus() function always return unsigned values
has been removed from the -mm tree.  Its filename was
     cpumask-let-num__cpus-function-always-return-unsigned-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpumask: let num_*_cpus() function always return unsigned values
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Dependent on CONFIG_SMP the num_*_cpus() functions return unsigned or
signed values.  Let them always return unsigned values to avoid strange
casts.

Fixes at least one warning:

 kernel/kprobes.c: In function 'register_kretprobe':
 kernel/kprobes.c:1038: warning: comparison of distinct pointer types lacks a cast

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/cpumask.h~cpumask-let-num__cpus-function-always-return-unsigned-values include/linux/cpumask.h
--- a/include/linux/cpumask.h~cpumask-let-num__cpus-function-always-return-unsigned-values
+++ a/include/linux/cpumask.h
@@ -90,10 +90,10 @@ extern const struct cpumask *const cpu_a
 #define cpu_present(cpu)	cpumask_test_cpu((cpu), cpu_present_mask)
 #define cpu_active(cpu)		cpumask_test_cpu((cpu), cpu_active_mask)
 #else
-#define num_online_cpus()	1
-#define num_possible_cpus()	1
-#define num_present_cpus()	1
-#define num_active_cpus()	1
+#define num_online_cpus()	1U
+#define num_possible_cpus()	1U
+#define num_present_cpus()	1U
+#define num_active_cpus()	1U
 #define cpu_online(cpu)		((cpu) == 0)
 #define cpu_possible(cpu)	((cpu) == 0)
 #define cpu_present(cpu)	((cpu) == 0)
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

linux-next.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
add-generic-sys_old_select.patch
add-generic-sys_old_mmap.patch
add-generic-sys_ipc-wrapper.patch
add-generic-sys_ipc-wrapper-fix.patch
improve-sys_personality-for-compat-architectures.patch
improve-sys_newuname-for-compat-architectures.patch
add-generic-sys_olduname.patch

