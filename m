Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10A20C43460
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6EB561181
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:27:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234159AbhDIU16 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 16:27:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233824AbhDIU16 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 16:27:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7899610A8;
        Fri,  9 Apr 2021 20:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618000065;
        bh=xSdAOEalDE+MzSeUP8Q8DSnNQTJEg6WUR9CPuoOPar8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XSp8yRitph7lvDT4yJN8Rpy4cGM3NGSaT9a8GcnXdz3Pgg9LtOIeUoyBCO/zISG0O
         +gQaly/gfbkBe+CLCKS2V1qwXM8f4vRVOi6oAL770VscXXITe0IXxIVY7Ll+60khX8
         3FCAuIijPuZUTZfvNkfm68/79AJawHwy1uu9FHo4=
Date:   Fri, 09 Apr 2021 13:27:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        jannh@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        tomi.p.sarvela@intel.com, torvalds@linux-foundation.org
Subject:  [patch 15/16] kfence, x86: fix preemptible warning on
 KPTI-enabled systems
Message-ID: <20210409202744.raBMoNOTx%akpm@linux-foundation.org>
In-Reply-To: <20210409132633.6855fc8fea1b3905ea1bb4be@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
