Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C284C4C61D
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 16:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VCvIct5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21635C433F1;
	Wed, 10 Jan 2024 16:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704902862;
	bh=0u3sZGIO0KH95vSCf39kGxLBizpIMBfcB2xg9+rLrP0=;
	h=Date:To:From:Subject:From;
	b=VCvIct5Ye+TGlhVjrg4LVHHFqoPhjQgw0sCo2QONn6EMo+m5VHlg2U4BXPlwxVFxW
	 gEue02V7X5mekbm/JWtzFriP8uufqhflVFmDMmOmSpltROP+pHNlo2y+aSExi5n/zT
	 Kg8kM3UpDrrf/bTebU1/6ZB2fmHSEFnbRTPRm1D8=
Date: Wed, 10 Jan 2024 08:07:41 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,ming.lei@redhat.com,linux@rasmusvillemoes.dk,andriy.shevchenko@linux.intel.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + cpumask-introduce-for_each_cpu_and_from.patch added to mm-nonmm-unstable branch
Message-Id: <20240110160742.21635C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: cpumask: introduce for_each_cpu_and_from()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     cpumask-introduce-for_each_cpu_and_from.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cpumask-introduce-for_each_cpu_and_from.patch

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
Subject: cpumask: introduce for_each_cpu_and_from()
Date: Thu, 28 Dec 2023 12:09:28 -0800

Patch series "lib/group_cpus: rework grp_spread_init_one() and make it
O(1)", v4.

grp_spread_init_one() implementation is sub-optimal because it traverses
bitmaps from the beginning, instead of picking from the previous
iteration.

Fix it and use find_bit API where appropriate.  While here, optimize
cpumasks allocation and drop unneeded cpumask_empty() call.


This patch (of 9):

Similarly to for_each_cpu_and(), introduce a for_each_cpu_and_from(),
which is handy when it's needed to traverse 2 cpumasks or bitmaps,
starting from a given position.

Link: https://lkml.kernel.org/r/20231228200936.2475595-1-yury.norov@gmail.com
Link: https://lkml.kernel.org/r/20231228200936.2475595-2-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |   11 +++++++++++
 include/linux/find.h    |    3 +++
 2 files changed, 14 insertions(+)

--- a/include/linux/cpumask.h~cpumask-introduce-for_each_cpu_and_from
+++ a/include/linux/cpumask.h
@@ -333,6 +333,17 @@ unsigned int __pure cpumask_next_wrap(in
 	for_each_and_bit(cpu, cpumask_bits(mask1), cpumask_bits(mask2), small_cpumask_bits)
 
 /**
+ * for_each_cpu_and_from - iterate over every cpu in both masks starting from a given cpu
+ * @cpu: the (optionally unsigned) integer iterator
+ * @mask1: the first cpumask pointer
+ * @mask2: the second cpumask pointer
+ *
+ * After the loop, cpu is >= nr_cpu_ids.
+ */
+#define for_each_cpu_and_from(cpu, mask1, mask2)				\
+	for_each_and_bit_from(cpu, cpumask_bits(mask1), cpumask_bits(mask2), small_cpumask_bits)
+
+/**
  * for_each_cpu_andnot - iterate over every cpu present in one mask, excluding
  *			 those present in another.
  * @cpu: the (optionally unsigned) integer iterator
--- a/include/linux/find.h~cpumask-introduce-for_each_cpu_and_from
+++ a/include/linux/find.h
@@ -563,6 +563,9 @@ unsigned long find_next_bit_le(const voi
 	     (bit) = find_next_and_bit((addr1), (addr2), (size), (bit)), (bit) < (size);\
 	     (bit)++)
 
+#define for_each_and_bit_from(bit, addr1, addr2, size) \
+	for (; (bit) = find_next_and_bit((addr1), (addr2), (size), (bit)), (bit) < (size); (bit)++)
+
 #define for_each_andnot_bit(bit, addr1, addr2, size) \
 	for ((bit) = 0;									\
 	     (bit) = find_next_andnot_bit((addr1), (addr2), (size), (bit)), (bit) < (size);\
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

