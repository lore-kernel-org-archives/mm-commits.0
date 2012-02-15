From: akpm@linux-foundation.org
Subject: + lib-cpumaskc-remove-__any_online_cpu.patch added to -mm tree
Date: Wed, 15 Feb 2012 13:14:22 -0800
Message-ID: <20120215211422.AD3A4A01C7@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:33590 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab2BOVOX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2012 16:14:23 -0500
Received: by ghrr17 with SMTP id r17so200415ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2012 13:14:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srivatsa.bhat@linux.vnet.ibm.com, eric.dumazet@gmail.com, kosaki.motohiro@jp.fujitsu.com, rusty@rustcorp.com.au, venki@google.com


The patch titled
     Subject: lib/cpumask.c: remove __any_online_cpu()
has been added to the -mm tree.  Its filename is
     lib-cpumaskc-remove-__any_online_cpu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -809,11 +809,10 @@ static inline const struct cpumask *get_
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
