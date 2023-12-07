Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D52FC4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 21:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbjLGVqi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Dec 2023 16:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbjLGVqh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2023 16:46:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83523171C
        for <mm-commits@vger.kernel.org>; Thu,  7 Dec 2023 13:46:43 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4E4C433C7;
        Thu,  7 Dec 2023 21:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701985603;
        bh=oosofNOpabHq7q3StquclezLjJ9A5fE8bSVdpP35qC4=;
        h=Date:To:From:Subject:From;
        b=cK55eWM3TBtngJGdwZ7TfVtGgNdypdZQTvciCTXMNfPApiHUx7jyzKGbiHZnjzqn6
         qdaiZE3shGKoULyPsCU3BNbAfCUY+592tBRIXrYVm6zIIpKVfGjBnFC7858iY7SqyS
         67vfdVEpNUr760N4CVk7e5EzMMHvyDtFMZnMe3JA=
Date:   Thu, 07 Dec 2023 13:46:41 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        ming.lei@redhat.com, linux@rasmusvillemoes.dk,
        andriy.shevchenko@linux.intel.com, yury.norov@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + cpumask-introduce-for_each_cpu_and_from.patch added to mm-nonmm-unstable branch
Message-Id: <20231207214643.1B4E4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


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
Date: Thu, 7 Dec 2023 12:38:55 -0800

Patch series "lib/group_cpus: rework grp_spread_init_one() and make it
O(1)", v2.

grp_spread_init_one() implementation is sub-optimal because it traverses
bitmaps from the beginning, instead of picking from the previous
iteration.

Fix it and use find_bit API where appropriate.  While here, optimize
cpumasks allocation and drop unneeded cpumask_empty() call.


This patch (of 6):

Similarly to for_each_cpu_and(), introduce a for_each_cpu_and_from(),
which is handy when it's needed to traverse 2 cpumasks or bitmaps,
starting from a given position.

Link: https://lkml.kernel.org/r/20231207203900.859776-1-yury.norov@gmail.com
Link: https://lkml.kernel.org/r/20231207203900.859776-2-yury.norov@gmail.com
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
lib-group_cpus-relax-atomicity-requirement-in-grp_spread_init_one.patch
lib-group_cpus-optimize-inner-loop-in-grp_spread_init_one.patch
lib-group_cpus-optimize-outer-loop-in-grp_spread_init_one.patch
lib-cgroup_cpusc-dont-zero-cpumasks-in-group_cpus_evenly-on-allocation.patch
lib-group_cpusc-drop-unneeded-cpumask_empty-call-in-__group_cpus_evenly.patch

