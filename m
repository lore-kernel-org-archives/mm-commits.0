From: akpm@linux-foundation.org
Subject: + padata-removed-unused-code.patch tentatively added to -mm tree
Date: Fri, 01 Apr 2016 12:54:22 -0700
Message-ID: <56fed1ee.i2EcsRidtnqIVEQo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43610 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbcDATyX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Apr 2016 15:54:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rcochran@linutronix.de, davem@davemloft.net, herbert@gondor.apana.org.au, steffen.klassert@secunet.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/padata.c: removed unused code
has been added to the -mm tree.  Its filename is
     padata-removed-unused-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/padata-removed-unused-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/padata-removed-unused-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Richard Cochran <rcochran@linutronix.de>
Subject: kernel/padata.c: removed unused code

By accident I stumbled across code that has never been used.  This driver
has EXPORT_SYMBOL functions, and the only user of the code is pcrypt.c,
but this only uses a subset of the exported symbols.

According to 'git log -G', the functions, padata_set_cpumasks,
padata_add_cpu, and padata_remove_cpu have never been used since they were
first introduced.  This patch removes the unused code.

On one 64 bit build, with CRYPTO_PCRYPT built in, the text is more than 4k
smaller.

  kbuild_hp> size $KBUILD_OUTPUT/vmlinux
      text    data     bss      dec hex    filename
  10566658 4678360 1122304 16367322 f9beda vmlinux
  10561984 4678360 1122304 16362648 f9ac98 vmlinux

On another config, 32 bit, the saving is about 0.5k bytes.

  kbuild_hp-x86> size $KBUILD_OUTPUT/vmlinux
  6012005 2409513 2785280 11206798 ab008e vmlinux
  6011491 2409513 2785280 11206284 aafe8c vmlinux

Signed-off-by: Richard Cochran <rcochran@linutronix.de>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/padata.h |    5 -
 kernel/padata.c        |   99 ---------------------------------------
 2 files changed, 104 deletions(-)

diff -puN include/linux/padata.h~padata-removed-unused-code include/linux/padata.h
--- a/include/linux/padata.h~padata-removed-unused-code
+++ a/include/linux/padata.h
@@ -175,11 +175,6 @@ extern int padata_do_parallel(struct pad
 extern void padata_do_serial(struct padata_priv *padata);
 extern int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 			      cpumask_var_t cpumask);
-extern int padata_set_cpumasks(struct padata_instance *pinst,
-			       cpumask_var_t pcpumask,
-			       cpumask_var_t cbcpumask);
-extern int padata_add_cpu(struct padata_instance *pinst, int cpu, int mask);
-extern int padata_remove_cpu(struct padata_instance *pinst, int cpu, int mask);
 extern int padata_start(struct padata_instance *pinst);
 extern void padata_stop(struct padata_instance *pinst);
 extern int padata_register_cpumask_notifier(struct padata_instance *pinst,
diff -puN kernel/padata.c~padata-removed-unused-code kernel/padata.c
--- a/kernel/padata.c~padata-removed-unused-code
+++ a/kernel/padata.c
@@ -607,33 +607,6 @@ out_replace:
 }
 
 /**
- * padata_set_cpumasks - Set both parallel and serial cpumasks. The first
- *                       one is used by parallel workers and the second one
- *                       by the wokers doing serialization.
- *
- * @pinst: padata instance
- * @pcpumask: the cpumask to use for parallel workers
- * @cbcpumask: the cpumsak to use for serial workers
- */
-int padata_set_cpumasks(struct padata_instance *pinst, cpumask_var_t pcpumask,
-			cpumask_var_t cbcpumask)
-{
-	int err;
-
-	mutex_lock(&pinst->lock);
-	get_online_cpus();
-
-	err = __padata_set_cpumasks(pinst, pcpumask, cbcpumask);
-
-	put_online_cpus();
-	mutex_unlock(&pinst->lock);
-
-	return err;
-
-}
-EXPORT_SYMBOL(padata_set_cpumasks);
-
-/**
  * padata_set_cpumask: Sets specified by @cpumask_type cpumask to the value
  *                     equivalent to @cpumask.
  *
@@ -694,42 +667,6 @@ static int __padata_add_cpu(struct padat
 	return 0;
 }
 
- /**
- * padata_add_cpu - add a cpu to one or both(parallel and serial)
- *                  padata cpumasks.
- *
- * @pinst: padata instance
- * @cpu: cpu to add
- * @mask: bitmask of flags specifying to which cpumask @cpu shuld be added.
- *        The @mask may be any combination of the following flags:
- *          PADATA_CPU_SERIAL   - serial cpumask
- *          PADATA_CPU_PARALLEL - parallel cpumask
- */
-
-int padata_add_cpu(struct padata_instance *pinst, int cpu, int mask)
-{
-	int err;
-
-	if (!(mask & (PADATA_CPU_SERIAL | PADATA_CPU_PARALLEL)))
-		return -EINVAL;
-
-	mutex_lock(&pinst->lock);
-
-	get_online_cpus();
-	if (mask & PADATA_CPU_SERIAL)
-		cpumask_set_cpu(cpu, pinst->cpumask.cbcpu);
-	if (mask & PADATA_CPU_PARALLEL)
-		cpumask_set_cpu(cpu, pinst->cpumask.pcpu);
-
-	err = __padata_add_cpu(pinst, cpu);
-	put_online_cpus();
-
-	mutex_unlock(&pinst->lock);
-
-	return err;
-}
-EXPORT_SYMBOL(padata_add_cpu);
-
 static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 {
 	struct parallel_data *pd = NULL;
@@ -754,41 +691,6 @@ static int __padata_remove_cpu(struct pa
 	return 0;
 }
 
- /**
- * padata_remove_cpu - remove a cpu from the one or both(serial and parallel)
- *                     padata cpumasks.
- *
- * @pinst: padata instance
- * @cpu: cpu to remove
- * @mask: bitmask specifying from which cpumask @cpu should be removed
- *        The @mask may be any combination of the following flags:
- *          PADATA_CPU_SERIAL   - serial cpumask
- *          PADATA_CPU_PARALLEL - parallel cpumask
- */
-int padata_remove_cpu(struct padata_instance *pinst, int cpu, int mask)
-{
-	int err;
-
-	if (!(mask & (PADATA_CPU_SERIAL | PADATA_CPU_PARALLEL)))
-		return -EINVAL;
-
-	mutex_lock(&pinst->lock);
-
-	get_online_cpus();
-	if (mask & PADATA_CPU_SERIAL)
-		cpumask_clear_cpu(cpu, pinst->cpumask.cbcpu);
-	if (mask & PADATA_CPU_PARALLEL)
-		cpumask_clear_cpu(cpu, pinst->cpumask.pcpu);
-
-	err = __padata_remove_cpu(pinst, cpu);
-	put_online_cpus();
-
-	mutex_unlock(&pinst->lock);
-
-	return err;
-}
-EXPORT_SYMBOL(padata_remove_cpu);
