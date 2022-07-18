Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 490AAC43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:33:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233136AbiGRAdJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiGRAcz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:32:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F25813FAC
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F145460FA9
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53326C385A2;
        Mon, 18 Jul 2022 00:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104362;
        bh=KOmx2kYlvWJhZ6cwINDKIFATEyhaiFtQfzf44u2cKMw=;
        h=Date:To:From:Subject:From;
        b=DlN2/nXdsG8Lcj+nz5LGy9pJgIRGrbVCXn5TMmsFyKJbZfkzaic3HGshS/VOBrqxQ
         KG2UMt16RF96fcgrKgIAvBSHmtwh7l6+5EzNoHeTE4WKbrts8RkR3HimQGMDKUVbq1
         eb3KlvIBi/WLJrynkzAvOqNYxToY1rr+4O01VjI4=
Date:   Sun, 17 Jul 2022 17:32:41 -0700
To:     mm-commits@vger.kernel.org, yury.norov@gmail.com,
        vschneid@redhat.com, tglx@linutronix.de, peterz@infradead.org,
        mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org,
        elver@google.com, dave.hansen@linux.intel.com, bp@alien8.de,
        andriy.shevchenko@linux.intel.com, sander@svanheule.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] cpumask-fix-invalid-uniprocessor-mask-assumption.patch removed from -mm tree
Message-Id: <20220718003242.53326C385A2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: cpumask: Fix invalid uniprocessor mask assumption
has been removed from the -mm tree.  Its filename was
     cpumask-fix-invalid-uniprocessor-mask-assumption.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sander Vanheule <sander@svanheule.net>
Subject: cpumask: Fix invalid uniprocessor mask assumption
Date: Sat, 2 Jul 2022 18:08:25 +0200

On uniprocessor builds, any CPU mask is assumed to contain exactly one CPU
(cpu0).  This assumption ignores the existence of empty masks, resulting
in incorrect behaviour.

cpumask_first_zero(), cpumask_next_zero(), and for_each_cpu_not() don't
provide behaviour matching the assumption that a UP mask is always "1",
and instead provide behaviour matching the empty mask.

Drop the incorrectly optimised code and use the generic implementations in
all cases.

Link: https://lkml.kernel.org/r/86bf3f005abba2d92120ddd0809235cab4f759a6.1656777646.git.sander@svanheule.net
Signed-off-by: Sander Vanheule <sander@svanheule.net>
Suggested-by: Yury Norov <yury.norov@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Valentin Schneider <vschneid@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |   99 +++++++-------------------------------
 lib/Makefile            |    3 -
 lib/cpumask.c           |    2 
 3 files changed, 22 insertions(+), 82 deletions(-)

--- a/include/linux/cpumask.h~cpumask-fix-invalid-uniprocessor-mask-assumption
+++ a/include/linux/cpumask.h
@@ -116,85 +116,6 @@ static __always_inline unsigned int cpum
 	return cpu;
 }
 
-#if NR_CPUS == 1
-/* Uniprocessor.  Assume all masks are "1". */
-static inline unsigned int cpumask_first(const struct cpumask *srcp)
-{
-	return 0;
-}
-
-static inline unsigned int cpumask_first_zero(const struct cpumask *srcp)
-{
-	return 0;
-}
-
-static inline unsigned int cpumask_first_and(const struct cpumask *srcp1,
-					     const struct cpumask *srcp2)
-{
-	return 0;
-}
-
-static inline unsigned int cpumask_last(const struct cpumask *srcp)
-{
-	return 0;
-}
-
-/* Valid inputs for n are -1 and 0. */
-static inline unsigned int cpumask_next(int n, const struct cpumask *srcp)
-{
-	return n+1;
-}
-
-static inline unsigned int cpumask_next_zero(int n, const struct cpumask *srcp)
-{
-	return n+1;
-}
-
-static inline unsigned int cpumask_next_and(int n,
-					    const struct cpumask *srcp,
-					    const struct cpumask *andp)
-{
-	return n+1;
-}
-
-static inline unsigned int cpumask_next_wrap(int n, const struct cpumask *mask,
-					     int start, bool wrap)
-{
-	/* cpu0 unless stop condition, wrap and at cpu0, then nr_cpumask_bits */
-	return (wrap && n == 0);
-}
-
-/* cpu must be a valid cpu, ie 0, so there's no other choice. */
-static inline unsigned int cpumask_any_but(const struct cpumask *mask,
-					   unsigned int cpu)
-{
-	return 1;
-}
-
-static inline unsigned int cpumask_local_spread(unsigned int i, int node)
-{
-	return 0;
-}
-
-static inline int cpumask_any_and_distribute(const struct cpumask *src1p,
-					     const struct cpumask *src2p) {
-	return cpumask_first_and(src1p, src2p);
-}
-
-static inline int cpumask_any_distribute(const struct cpumask *srcp)
-{
-	return cpumask_first(srcp);
-}
-
-#define for_each_cpu(cpu, mask)			\
-	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
-#define for_each_cpu_not(cpu, mask)		\
-	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
-#define for_each_cpu_wrap(cpu, mask, start)	\
-	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask, (void)(start))
-#define for_each_cpu_and(cpu, mask1, mask2)	\
-	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask1, (void)mask2)
-#else
 /**
  * cpumask_first - get the first cpu in a cpumask
  * @srcp: the cpumask pointer
@@ -260,10 +181,29 @@ static inline unsigned int cpumask_next_
 
 int __pure cpumask_next_and(int n, const struct cpumask *, const struct cpumask *);
 int __pure cpumask_any_but(const struct cpumask *mask, unsigned int cpu);
+
+#if NR_CPUS == 1
+/* Uniprocessor: there is only one valid CPU */
+static inline unsigned int cpumask_local_spread(unsigned int i, int node)
+{
+	return 0;
+}
+
+static inline int cpumask_any_and_distribute(const struct cpumask *src1p,
+					     const struct cpumask *src2p) {
+	return cpumask_first_and(src1p, src2p);
+}
+
+static inline int cpumask_any_distribute(const struct cpumask *srcp)
+{
+	return cpumask_first(srcp);
+}
+#else
 unsigned int cpumask_local_spread(unsigned int i, int node);
 int cpumask_any_and_distribute(const struct cpumask *src1p,
 			       const struct cpumask *src2p);
 int cpumask_any_distribute(const struct cpumask *srcp);
+#endif /* NR_CPUS */
 
 /**
  * for_each_cpu - iterate over every cpu in a mask
@@ -324,7 +264,6 @@ extern int cpumask_next_wrap(int n, cons
 	for ((cpu) = -1;						\
 		(cpu) = cpumask_next_and((cpu), (mask1), (mask2)),	\
 		(cpu) < nr_cpu_ids;)
-#endif /* SMP */
 
 #define CPU_BITS_NONE						\
 {								\
--- a/lib/cpumask.c~cpumask-fix-invalid-uniprocessor-mask-assumption
+++ a/lib/cpumask.c
@@ -192,6 +192,7 @@ void __init free_bootmem_cpumask_var(cpu
 }
 #endif
 
+#if NR_CPUS > 1
 /**
  * cpumask_local_spread - select the i'th cpu with local numa cpu's first
  * @i: index number
@@ -279,3 +280,4 @@ int cpumask_any_distribute(const struct
 	return next;
 }
 EXPORT_SYMBOL(cpumask_any_distribute);
+#endif /* NR_CPUS */
--- a/lib/Makefile~cpumask-fix-invalid-uniprocessor-mask-assumption
+++ a/lib/Makefile
@@ -34,10 +34,9 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
 	 earlycpio.o seq_buf.o siphash.o dec_and_lock.o \
 	 nmi_backtrace.o nodemask.o win_minmax.o memcat_p.o \
-	 buildid.o
+	 buildid.o cpumask.o
 
 lib-$(CONFIG_PRINTK) += dump_stack.o
-lib-$(CONFIG_SMP) += cpumask.o
 
 lib-y	+= kobject.o klist.o
 obj-y	+= lockref.o
_

Patches currently in -mm which might be from sander@svanheule.net are


