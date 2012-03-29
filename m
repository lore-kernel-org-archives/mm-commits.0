From: akpm@linux-foundation.org
Subject: [merged] lib-cpumaskc-remove-__any_online_cpu.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:13:42 -0700
Message-ID: <20120329191342.684ADA01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:39142 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933699Ab2C2TNo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2012 15:13:44 -0400
Received: by laai8 with SMTP id i8so146152laa.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:13:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srivatsa.bhat@linux.vnet.ibm.com, eric.dumazet@gmail.com, kosaki.motohiro@jp.fujitsu.com, rusty@rustcorp.com.au, venki@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/cpumask.c: remove __any_online_cpu()
has been removed from the -mm tree.  Its filename was
     lib-cpumaskc-remove-__any_online_cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: lib/cpumask.c: remove __any_online_cpu()

__any_online_cpu() is not optimal and also unnecessary.  So, replace its
use by faster cpumask_* operations.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |    3 +--
 lib/cpumask.c           |   12 ------------
 2 files changed, 1 insertion(+), 14 deletions(-)

diff -puN include/linux/cpumask.h~lib-cpumaskc-remove-__any_online_cpu include/linux/cpumask.h
--- a/include/linux/cpumask.h~lib-cpumaskc-remove-__any_online_cpu
+++ a/include/linux/cpumask.h
@@ -810,11 +810,10 @@ static inline const struct cpumask *get_
 #else /* NR_CPUS > 1 */
 int __first_cpu(const cpumask_t *srcp);
 int __next_cpu(int n, const cpumask_t *srcp);
-int __any_online_cpu(const cpumask_t *mask);
 
 #define first_cpu(src)		__first_cpu(&(src))
 #define next_cpu(n, src)	__next_cpu((n), &(src))
-#define any_online_cpu(mask) __any_online_cpu(&(mask))
+#define any_online_cpu(mask) cpumask_any_and(&mask, cpu_online_mask)
 #define for_each_cpu_mask(cpu, mask)			\
 	for ((cpu) = -1;				\
 		(cpu) = next_cpu((cpu), (mask)),	\
diff -puN lib/cpumask.c~lib-cpumaskc-remove-__any_online_cpu lib/cpumask.c
--- a/lib/cpumask.c~lib-cpumaskc-remove-__any_online_cpu
+++ a/lib/cpumask.c
@@ -26,18 +26,6 @@ int __next_cpu_nr(int n, const cpumask_t
 EXPORT_SYMBOL(__next_cpu_nr);
 #endif
 
-int __any_online_cpu(const cpumask_t *mask)
-{
-	int cpu;
-
-	for_each_cpu(cpu, mask) {
-		if (cpu_online(cpu))
-			break;
-	}
-	return cpu;
-}
-EXPORT_SYMBOL(__any_online_cpu);
