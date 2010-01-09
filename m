From: akpm@linux-foundation.org
Subject: + cpumask-let-num__cpus-function-always-return-unsigned-values.patch added to -mm tree
Date: Fri, 08 Jan 2010 16:18:54 -0800
Message-ID: <201001090018.o090IsRH023078@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754243Ab0AIATa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2010 19:19:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, ananth@in.ibm.com, mhiramat@redhat.com, mingo@elte.hu, rusty@rustcorp.com.au


The patch titled
     cpumask: let num_*_cpus() function always return unsigned values
has been added to the -mm tree.  Its filename is
     cpumask-let-num__cpus-function-always-return-unsigned-values.patch

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
cpumask-let-num__cpus-function-always-return-unsigned-values.patch

