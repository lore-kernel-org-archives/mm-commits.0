Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF4FC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21310206CB
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhA0Csl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jan 2021 21:48:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:60210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390340AbhAZTq7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 26 Jan 2021 14:46:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51B9F221FC;
        Tue, 26 Jan 2021 19:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611690378;
        bh=oidb4E6nncVTtjmMwOyYtG12PF5U+lwUY4QXsRpvxUU=;
        h=Date:From:To:Subject:From;
        b=eYO6gBX2qObHxeFwWsXTwtCiTP76gKNLO99x2bIYLn4JGpEguM26Vw0FDCJRGhZ0t
         ef5td53W+/r91fqfvWfPvCEi3qxRlqXm5gvvdwriOm4t5/0eQ71xinEWUTGq+wKPPZ
         rE6HOd8lth0esCYWO2Wgnx1pYhD+lvlTS2bJR9Bs=
Date:   Tue, 26 Jan 2021 11:46:17 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        catalin.marinas@arm.com, dvyukov@google.com, glider@google.com,
        leonro@mellanox.com, mark.rutland@arm.com,
        mm-commits@vger.kernel.org, naresh.kamboju@linaro.org,
        paulmck@kernel.org, vincenzo.frascino@arm.com, will@kernel.org
Subject:  + kasan-add-explicit-preconditions-to-kasan_report.patch
 added to -mm tree
Message-ID: <20210126194617.D_MCPYFZF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add explicit preconditions to kasan_report()
has been added to the -mm tree.  Its filename is
     kasan-add-explicit-preconditions-to-kasan_report.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-add-explicit-preconditions-to-kasan_report.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-add-explicit-preconditions-to-kasan_report.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: kasan: add explicit preconditions to kasan_report()

Patch series "kasan: Fix metadata detection for KASAN_HW_TAGS", v5.

With the introduction of KASAN_HW_TAGS, kasan_report() currently assumes
that every location in memory has valid metadata associated.  This is due
to the fact that addr_has_metadata() returns always true.

As a consequence of this, an invalid address (e.g.  NULL pointer address)
passed to kasan_report() when KASAN_HW_TAGS is enabled, leads to a kernel
panic.

Example below, based on arm64:

 ==================================================================
 BUG: KASAN: invalid-access in 0x0
 Read at addr 0000000000000000 by task swapper/0/1
 Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
 Mem abort info:
   ESR = 0x96000004
   EC = 0x25: DABT (current EL), IL = 32 bits
   SET = 0, FnV = 0
   EA = 0, S1PTW = 0
 Data abort info:
   ISV = 0, ISS = 0x00000004
   CM = 0, WnR = 0

...

 Call trace:
  mte_get_mem_tag+0x24/0x40
  kasan_report+0x1a4/0x410
  alsa_sound_last_init+0x8c/0xa4
  do_one_initcall+0x50/0x1b0
  kernel_init_freeable+0x1d4/0x23c
  kernel_init+0x14/0x118
  ret_from_fork+0x10/0x34
 Code: d65f03c0 9000f021 f9428021 b6cfff61 (d9600000)
 ---[ end trace 377c8bb45bdd3a1a ]---
 hrtimer: interrupt took 48694256 ns
 note: swapper/0[1] exited with preempt_count 1
 Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
 SMP: stopping secondary CPUs
 Kernel Offset: 0x35abaf140000 from 0xffff800010000000
 PHYS_OFFSET: 0x40000000
 CPU features: 0x0a7e0152,61c0a030
 Memory Limit: none
 ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b ]---

This series fixes the behavior of addr_has_metadata() that now returns
true only when the address is valid.


This patch (of 2):

With the introduction of KASAN_HW_TAGS, kasan_report() accesses the
metadata only when addr_has_metadata() succeeds.

Add a comment to make sure that the preconditions to the function are
explicitly clarified.

Link: https://lkml.kernel.org/r/20210126134409.47894-1-vincenzo.frascino@arm.com
Link: https://lkml.kernel.org/r/20210126134409.47894-2-vincenzo.frascino@arm.com
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Leon Romanovsky <leonro@mellanox.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/linux/kasan.h~kasan-add-explicit-preconditions-to-kasan_report
+++ a/include/linux/kasan.h
@@ -333,6 +333,13 @@ static inline void *kasan_reset_tag(cons
 	return (void *)arch_kasan_reset_tag(addr);
 }
 
+/**
+ * kasan_report - print a report about a bad memory access detected by KASAN
+ * @addr: address of the bad access
+ * @size: size of the bad access
+ * @is_write: whether the bad access is a write or a read
+ * @ip: instruction pointer for the accessibility check or the bad access itself
+ */
 bool kasan_report(unsigned long addr, size_t size,
 		bool is_write, unsigned long ip);
 
_

Patches currently in -mm which might be from vincenzo.frascino@arm.com are

kasan-add-explicit-preconditions-to-kasan_report.patch
kasan-make-addr_has_metadata-return-true-for-valid-addresses.patch

