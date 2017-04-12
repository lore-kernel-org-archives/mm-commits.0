From: akpm@linux-foundation.org
Subject: + cpumask-add-helper-cpumask_available.patch added to -mm tree
Date: Wed, 12 Apr 2017 12:36:11 -0700
Message-ID: <58ee81ab.0y0FIj9W94p81AtK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48820 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754445AbdDLTgO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2017 15:36:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mka@chromium.org, ghackmann@google.com, grundler@chromium.org, md@google.com, rusty@rustcorp.com.au, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: cpumask: add helper cpumask_available()
has been added to the -mm tree.  Its filename is
     cpumask-add-helper-cpumask_available.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cpumask-add-helper-cpumask_available.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cpumask-add-helper-cpumask_available.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
cpumask-add-helper-cpumask_available.patch
kernel-irq-use-cpumask_available-for-check-of-cpumask-variable.patch

