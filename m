Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 383D0CCA480
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbiGRAdM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232819AbiGRAc7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:32:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252B714027
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83139B80E27
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32008C3411E;
        Mon, 18 Jul 2022 00:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104361;
        bh=LH0ROOBsim4hWUEnU4mXJeZIw9ZZKM4j7aDSR96q324=;
        h=Date:To:From:Subject:From;
        b=SrlycEO7O944ZpXrdHgN+qjTjyNPmQXMXmSv3/jMZ32MTmhWJVq3KQCufrpQaZF5y
         1E/DadLh9cscGAfm3YSVncjycR97Nl+0BCwSqhStstniNNbejPes4qzmxenY0+Tz8V
         zU03FobYs8LAyc/rEm6uMLgVS0Ho7Al/kjNSxFGg=
Date:   Sun, 17 Jul 2022 17:32:40 -0700
To:     mm-commits@vger.kernel.org, yury.norov@gmail.com,
        vschneid@redhat.com, tglx@linutronix.de, peterz@infradead.org,
        mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org,
        elver@google.com, dave.hansen@linux.intel.com, bp@alien8.de,
        andriy.shevchenko@linux.intel.com, sander@svanheule.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] cpumask-add-up-optimised-for_each__cpu-versions.patch removed from -mm tree
Message-Id: <20220718003241.32008C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: cpumask: add UP optimised for_each_*_cpu versions
has been removed from the -mm tree.  Its filename was
     cpumask-add-up-optimised-for_each__cpu-versions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sander Vanheule <sander@svanheule.net>
Subject: cpumask: add UP optimised for_each_*_cpu versions
Date: Sat, 2 Jul 2022 18:08:27 +0200

On uniprocessor builds, the following loops will always run over a mask
that contains one enabled CPU (cpu0):

    - for_each_possible_cpu
    - for_each_online_cpu
    - for_each_present_cpu

Provide uniprocessor-specific macros for these loops, that always run
exactly once.

Link: https://lkml.kernel.org/r/3a92869b902a075b97be5d1452c9c6badbbff0df.1656777646.git.sander@svanheule.net
Signed-off-by: Sander Vanheule <sander@svanheule.net>
Acked-by: Yury Norov <yury.norov@gmail.com>
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

 include/linux/cpumask.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/linux/cpumask.h~cpumask-add-up-optimised-for_each__cpu-versions
+++ a/include/linux/cpumask.h
@@ -811,9 +811,16 @@ extern const DECLARE_BITMAP(cpu_all_bits
 /* First bits of cpu_bit_bitmap are in fact unset. */
 #define cpu_none_mask to_cpumask(cpu_bit_bitmap[0])
 
+#if NR_CPUS == 1
+/* Uniprocessor: the possible/online/present masks are always "1" */
+#define for_each_possible_cpu(cpu)	for ((cpu) = 0; (cpu) < 1; (cpu)++)
+#define for_each_online_cpu(cpu)	for ((cpu) = 0; (cpu) < 1; (cpu)++)
+#define for_each_present_cpu(cpu)	for ((cpu) = 0; (cpu) < 1; (cpu)++)
+#else
 #define for_each_possible_cpu(cpu) for_each_cpu((cpu), cpu_possible_mask)
 #define for_each_online_cpu(cpu)   for_each_cpu((cpu), cpu_online_mask)
 #define for_each_present_cpu(cpu)  for_each_cpu((cpu), cpu_present_mask)
+#endif
 
 /* Wrappers for arch boot code to manipulate normally-constant masks */
 void init_cpu_present(const struct cpumask *src);
_

Patches currently in -mm which might be from sander@svanheule.net are


