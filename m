Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8992C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 05:00:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEDAD619D6
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 05:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbhCaFAR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 01:00:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233668AbhCaE7m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 00:59:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3C6761998;
        Wed, 31 Mar 2021 04:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617166780;
        bh=DKv+diKUoxt/Qf5j00bZssWzkDfVtGHLjo66TLwsAMI=;
        h=Date:From:To:Subject:From;
        b=nYHtuiMGPFglD67MnUFRMT/uYN81BM7pOUMlQch3lbGSUY3F+bVdkFaxWbR0q1eT4
         dEj6FDZZC3UWrZEgOgQKOFuTZV5OBDTgjkHHGlLF+l3I4erfemW6gEFmCMEIbSL6x0
         PzFfy00/TfHjonKsTQcq7o+xz2arhfGxmaegoz+M=
Date:   Tue, 30 Mar 2021 21:59:39 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, jannh@google.com, mm-commits@vger.kernel.org,
        tomi.p.sarvela@intel.com
Subject:  +
 kfence-x86-fix-preemptible-warning-on-kpti-enabled-systems.patch added to
 -mm tree
Message-ID: <20210331045939.8xvpMnmlP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence, x86: fix preemptible warning on KPTI-enabled systems
has been added to the -mm tree.  Its filename is
     kfence-x86-fix-preemptible-warning-on-kpti-enabled-systems.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-x86-fix-preemptible-warning-on-kpti-enabled-systems.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-x86-fix-preemptible-warning-on-kpti-enabled-systems.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence, x86: fix preemptible warning on KPTI-enabled systems

On systems with KPTI enabled, we can currently observe the following
warning:

  BUG: using smp_processor_id() in preemptible
  caller is invalidate_user_asid+0x13/0x50
  CPU: 6 PID: 1075 Comm: dmesg Not tainted 5.12.0-rc4-gda4a2b1a5479-kfence_1+ #1
  Hardware name: Hewlett-Packard HP Pro 3500 Series/2ABF, BIOS 8.11 10/24/2012
  Call Trace:
   dump_stack+0x7f/0xad
   check_preemption_disabled+0xc8/0xd0
   invalidate_user_asid+0x13/0x50
   flush_tlb_one_kernel+0x5/0x20
   kfence_protect+0x56/0x80
   ...

While it normally makes sense to require preemption to be off, so that the
expected CPU's TLB is flushed and not another, in our case it really is
best-effort (see comments in kfence_protect_page()).

Avoid the warning by disabling preemption around flush_tlb_one_kernel().

Link: https://lore.kernel.org/lkml/YGIDBAboELGgMgXy@elver.google.com/
Link: https://lkml.kernel.org/r/20210330065737.652669-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Tomi Sarvela <tomi.p.sarvela@intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/kfence.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/kfence.h~kfence-x86-fix-preemptible-warning-on-kpti-enabled-systems
+++ a/arch/x86/include/asm/kfence.h
@@ -56,8 +56,13 @@ static inline bool kfence_protect_page(u
 	else
 		set_pte(pte, __pte(pte_val(*pte) | _PAGE_PRESENT));
 
-	/* Flush this CPU's TLB. */
+	/*
+	 * Flush this CPU's TLB, assuming whoever did the allocation/free is
+	 * likely to continue running on this CPU.
+	 */
+	preempt_disable();
 	flush_tlb_one_kernel(addr);
+	preempt_enable();
 	return true;
 }
 
_

Patches currently in -mm which might be from elver@google.com are

kfence-x86-fix-preemptible-warning-on-kpti-enabled-systems.patch
kfence-zero-guard-page-after-out-of-bounds-access.patch

