Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70DC8C4320A
	for <mm-commits@archiver.kernel.org>; Sat, 14 Aug 2021 22:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58BC960F9F
	for <mm-commits@archiver.kernel.org>; Sat, 14 Aug 2021 22:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbhHNWRy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Aug 2021 18:17:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233276AbhHNWRx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 14 Aug 2021 18:17:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9300D60EE0;
        Sat, 14 Aug 2021 22:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628979444;
        bh=jb7axzOujKtXZkU9o/9280pz6hRcwJ9kaDPO7aeqlzc=;
        h=Date:From:To:Subject:From;
        b=ll1Ci9W4EBrJPfIccSu3VyMzl8R5eeJB+KqkvoweSBzIjdu0bnuiFaxakmOWOGeU7
         BaDqewvNZWn2Wz5G8wJmIfrkSJyfDz04YxiuZalp8yYOL1akXx9Ttto0XsWvL9V6dG
         hlcN0btKLdiQqI0tAvSIkCGfcJJXFqjemOsF4YLk=
Date:   Sat, 14 Aug 2021 15:17:24 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wsa+renesas@sang-engineering.com,
        will@kernel.org, ulf.hansson@linaro.org, lkp@intel.com,
        jolsa@redhat.com, dennis@kernel.org,
        andriy.shevchenko@linux.intel.com, alobakin@pm.me,
        aklimov@redhat.com, yury.norov@gmail.com
Subject:  + cpumask-use-find_first_and_bit.patch added to -mm tree
Message-ID: <20210814221724.Z3Yy_%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cpumask: use find_first_and_bit()
has been added to the -mm tree.  Its filename is
     cpumask-use-find_first_and_bit.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/cpumask-use-find_first_and_bit.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/cpumask-use-find_first_and_bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: cpumask: use find_first_and_bit()

Now we have an efficient implementation for find_first_and_bit(), so
switch cpumask to use it where appropriate.

Link: https://lkml.kernel.org/r/20210814211713.180533-7-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Alexey Klimov <aklimov@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

--- a/include/linux/cpumask.h~cpumask-use-find_first_and_bit
+++ a/include/linux/cpumask.h
@@ -123,6 +123,12 @@ static inline unsigned int cpumask_first
 	return 0;
 }
 
+static inline unsigned int cpumask_first_and(const struct cpumask *srcp1,
+					     const struct cpumask *srcp2)
+{
+	return 0;
+}
+
 static inline unsigned int cpumask_last(const struct cpumask *srcp)
 {
 	return 0;
@@ -167,7 +173,7 @@ static inline unsigned int cpumask_local
 
 static inline int cpumask_any_and_distribute(const struct cpumask *src1p,
 					     const struct cpumask *src2p) {
-	return cpumask_next_and(-1, src1p, src2p);
+	return cpumask_first_and(src1p, src2p);
 }
 
 static inline int cpumask_any_distribute(const struct cpumask *srcp)
@@ -196,6 +202,19 @@ static inline unsigned int cpumask_first
 }
 
 /**
+ * cpumask_first_and - return the first cpu from *srcp1 & *srcp2
+ * @src1p: the first input
+ * @src2p: the second input
+ *
+ * Returns >= nr_cpu_ids if no cpus set in both.  See also cpumask_next_and().
+ */
+static inline
+unsigned int cpumask_first_and(const struct cpumask *srcp1, const struct cpumask *srcp2)
+{
+	return find_first_and_bit(cpumask_bits(srcp1), cpumask_bits(srcp2), nr_cpumask_bits);
+}
+
+/**
  * cpumask_last - get the last CPU in a cpumask
  * @srcp:	- the cpumask pointer
  *
@@ -586,15 +605,6 @@ static inline void cpumask_copy(struct c
 #define cpumask_any(srcp) cpumask_first(srcp)
 
 /**
- * cpumask_first_and - return the first cpu from *srcp1 & *srcp2
- * @src1p: the first input
- * @src2p: the second input
- *
- * Returns >= nr_cpu_ids if no cpus set in both.  See also cpumask_next_and().
- */
-#define cpumask_first_and(src1p, src2p) cpumask_next_and(-1, (src1p), (src2p))
-
-/**
  * cpumask_any_and - pick a "random" cpu from *mask1 & *mask2
  * @mask1: the first input cpumask
  * @mask2: the second input cpumask
_

Patches currently in -mm which might be from yury.norov@gmail.com are

bitops-protect-find_first_zero_bit-properly.patch
bitops-move-find_bit__le-functions-from-leh-to-findh.patch
include-move-findh-from-asm_generic-to-linux.patch
arch-remove-generic_find_first_bit-entirely.patch
lib-add-find_first_and_bit.patch
cpumask-use-find_first_and_bit.patch
all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate.patch
tools-sync-tools-bitmap-with-mother-linux.patch
cpumask-replace-cpumask_next_-with-cpumask_first_-where-appropriate.patch
include-linux-move-for_each_bit-macros-from-bitopsh-to-findh.patch
find-micro-optimize-for_each_setclear_bit.patch
replace-for_each__bit_from-with-for_each__bit-where-appropriate.patch
mm-percpu-micro-optimize-pcpu_is_populated.patch
bitmap-unify-find_bit-operations.patch
lib-bitmap-add-performance-test-for-bitmap_print_to_pagebuf.patch
vsprintf-rework-bitmap_list_string.patch

