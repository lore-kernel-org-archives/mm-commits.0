Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAAB4C61D
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 16:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2Q2jNfcR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C6CC433F1;
	Wed, 10 Jan 2024 16:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704902873;
	bh=cIaFW/v8CXvC8Mr4Ac0kb+OCi0CSrOKYLYgZrPq2Sj4=;
	h=Date:To:From:Subject:From;
	b=2Q2jNfcR4hHdeHmgpKBQrM9wowHT4FunGJFicvP5pqOW4X5iwy4lkoimFaz8gWowD
	 gadNlvfMPqgmTE2FGFRYhNk49wdwp5FEiobD5oKYrOSVlTJOLs9ryXKELzqypGuOhj
	 BzJYVbSPHLGOtHvzQlh81slB5eS2quM/iAlasf1Q=
Date: Wed, 10 Jan 2024 08:07:52 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,ming.lei@redhat.com,linux@rasmusvillemoes.dk,andriy.shevchenko@linux.intel.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + cpumask-define-cleanup-function-for-cpumasks.patch added to mm-nonmm-unstable branch
Message-Id: <20240110160753.74C6CC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: cpumask: define cleanup function for cpumasks
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     cpumask-define-cleanup-function-for-cpumasks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cpumask-define-cleanup-function-for-cpumasks.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: cpumask: define cleanup function for cpumasks
Date: Thu, 28 Dec 2023 12:09:34 -0800

Now we can simplify a code that allocates cpumasks for local needs.

Link: https://lkml.kernel.org/r/20231228200936.2475595-8-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/cpumask.h~cpumask-define-cleanup-function-for-cpumasks
+++ a/include/linux/cpumask.h
@@ -7,6 +7,7 @@
  * set of CPUs in a system, one bit position per CPU number.  In general,
  * only nr_cpu_ids (<= NR_CPUS) bits are valid.
  */
+#include <linux/cleanup.h>
 #include <linux/kernel.h>
 #include <linux/threads.h>
 #include <linux/bitmap.h>
@@ -988,6 +989,8 @@ static inline bool cpumask_available(cpu
 }
 #endif /* CONFIG_CPUMASK_OFFSTACK */
 
+DEFINE_FREE(free_cpumask_var, struct cpumask *, if (_T) free_cpumask_var(_T));
+
 /* It's common to want to use cpu_all_mask in struct member initializers,
  * so it has to refer to an address rather than a pointer. */
 extern const DECLARE_BITMAP(cpu_all_bits, NR_CPUS);
_

Patches currently in -mm which might be from yury.norov@gmail.com are

cpumask-introduce-for_each_cpu_and_from.patch
lib-group_cpus-optimize-inner-loop-in-grp_spread_init_one.patch
lib-group_cpus-relax-atomicity-requirement-in-grp_spread_init_one.patch
lib-group_cpus-optimize-outer-loop-in-grp_spread_init_one.patch
lib-group_cpus-dont-zero-cpumasks-in-group_cpus_evenly-on-allocation.patch
lib-group_cpus-drop-unneeded-cpumask_empty-call-in-__group_cpus_evenly.patch
cpumask-define-cleanup-function-for-cpumasks.patch
lib-group_cpus-rework-group_cpus_evenly.patch
lib-group_cpus-simplify-group_cpus_evenly-for-more.patch

