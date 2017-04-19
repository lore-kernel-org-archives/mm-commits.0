From: akpm@linux-foundation.org
Subject: [merged] cpumask-add-helper-cpumask_available.patch
 removed from -mm tree
Date: Wed, 19 Apr 2017 13:41:36 -0700
Message-ID: <20170419204136.ke2kxb2k_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47938 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764621AbdDSUlh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Apr 2017 16:41:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghackmann@google.com, grundler@chromium.org, md@google.com, mka@chromium.org, mm-commits@vger.kernel.org, rusty@rustcorp.com.au, tglx@linutronix.de


The patch titled
     Subject: cpumask: add helper cpumask_available()
has been removed from the -mm tree.  Its filename was
     cpumask-add-helper-cpumask_available.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthias Kaehlcke <mka@chromium.org>
Subject: cpumask: add helper cpumask_available()

With CONFIG_CPUMASK_OFFSTACK=y cpumask_var_t is a struct cpumask pointer,
otherwise a struct cpumask array with a single element.

Some code dealing with cpumasks needs to validate that a cpumask_var_t is
not a NULL pointer when CONFIG_CPUMASK_OFFSTACK=y.  This is typically done
by performing the check always, regardless of the underlying type of
cpumask_var_t.  This works in both cases, however clang raises a warning
like this when CONFIG_CPUMASK_OFFSTACK=n:

kernel/irq/manage.c:839:28: error: address of array
'desc->irq_common_data.affinity' will always evaluate to 'true'
[-Werror,-Wpointer-bool-conversion]

Add the inline helper cpumask_available() which only performs the pointer
check if CONFIG_CPUMASK_OFFSTACK=y.

Link: http://lkml.kernel.org/r/20170412182030.83657-1-mka@chromium.org
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Grant Grundler <grundler@chromium.org>
Cc: Greg Hackmann <ghackmann@google.com>
Cc: Michael Davidson <md@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN include/linux/cpumask.h~cpumask-add-helper-cpumask_available include/linux/cpumask.h
--- a/include/linux/cpumask.h~cpumask-add-helper-cpumask_available
+++ a/include/linux/cpumask.h
@@ -667,6 +667,11 @@ void alloc_bootmem_cpumask_var(cpumask_v
 void free_cpumask_var(cpumask_var_t mask);
 void free_bootmem_cpumask_var(cpumask_var_t mask);
 
+static inline bool cpumask_available(cpumask_var_t mask)
+{
+	return mask != NULL;
+}
+
 #else
 typedef struct cpumask cpumask_var_t[1];
 
@@ -708,6 +713,11 @@ static inline void free_cpumask_var(cpum
 static inline void free_bootmem_cpumask_var(cpumask_var_t mask)
 {
 }
+
+static inline bool cpumask_available(cpumask_var_t mask)
+{
+	return true;
+}
 #endif /* CONFIG_CPUMASK_OFFSTACK */
 
 /* It's common to want to use cpu_all_mask in struct member initializers,
_

Patches currently in -mm which might be from mka@chromium.org are

jiffiesh-declare-jiffies-and-jiffies_64-with-____cacheline_aligned_in_smp.patch

