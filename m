Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9792C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  2 Nov 2022 21:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbiKBVNd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Nov 2022 17:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiKBVNW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Nov 2022 17:13:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE64CE7
        for <mm-commits@vger.kernel.org>; Wed,  2 Nov 2022 14:13:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9F88B8250A
        for <mm-commits@vger.kernel.org>; Wed,  2 Nov 2022 21:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDCBC433C1;
        Wed,  2 Nov 2022 21:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667423598;
        bh=wfmr1v7XiqiSC8mvttsDJRdNj+JWXs2DB6iQfuzkWDg=;
        h=Date:To:From:Subject:From;
        b=EKZJjUdVHDWM2vH79NwySb+akSasegxrC9F+NhzSZRMjF+iSLX8CDhi45iLFRi5dQ
         5aaFi9jd/+4gRK22wfrWqjOXiBE2j38XcDkPdUbsp5mo3dAxucLeWEbFKxjOyNQhv7
         P8T3FQwdgXGrP14J6/i2FOqkTlk0SrVstqvgbMMk=
Date:   Wed, 02 Nov 2022 14:13:17 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, ndesaulniers@google.com, mingo@redhat.com,
        masahiroy@kernel.org, keescook@chromium.org, elver@google.com,
        dvyukov@google.com, dave.hansen@linux.intel.com, bp@alien8.de,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-traps-avoid-kmsan-bugs-originating-from-handle_bug.patch added to mm-hotfixes-unstable branch
Message-Id: <20221102211318.5FDCBC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/traps: avoid KMSAN bugs originating from handle_bug()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-traps-avoid-kmsan-bugs-originating-from-handle_bug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-traps-avoid-kmsan-bugs-originating-from-handle_bug.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Alexander Potapenko <glider@google.com>
Subject: x86/traps: avoid KMSAN bugs originating from handle_bug()
Date: Wed, 2 Nov 2022 12:06:11 +0100

There is a case in exc_invalid_op handler that is executed outside the
irqentry_enter()/irqentry_exit() region when an UD2 instruction is used to
encode a call to __warn().

In that case the `struct pt_regs` passed to the interrupt handler is never
unpoisoned by KMSAN (this is normally done in irqentry_enter()), which
leads to false positives inside handle_bug().

Use kmsan_unpoison_entry_regs() to explicitly unpoison those registers
before using them.

Link: https://lkml.kernel.org/r/20221102110611.1085175-5-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Marco Elver <elver@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/traps.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/x86/kernel/traps.c~x86-traps-avoid-kmsan-bugs-originating-from-handle_bug
+++ a/arch/x86/kernel/traps.c
@@ -15,6 +15,7 @@
 #include <linux/context_tracking.h>
 #include <linux/interrupt.h>
 #include <linux/kallsyms.h>
+#include <linux/kmsan.h>
 #include <linux/spinlock.h>
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
@@ -301,6 +302,12 @@ static noinstr bool handle_bug(struct pt
 {
 	bool handled = false;
 
+	/*
+	 * Normally @regs are unpoisoned by irqentry_enter(), but handle_bug()
+	 * is a rare case that uses @regs without passing them to
+	 * irqentry_enter().
+	 */
+	kmsan_unpoison_entry_regs(regs);
 	if (!is_valid_bugaddr(regs->ip))
 		return handled;
 
_

Patches currently in -mm which might be from glider@google.com are

kmsan-core-kmsan_in_runtime-should-return-true-in-nmi-context.patch
x86-uaccess-instrument-copy_from_user_nmi.patch
kconfigdebug-ensure-early-check-for-kmsan-in-config_kmsan_warn.patch
kmsan-make-sure-preempt_rt-is-off.patch
x86-traps-avoid-kmsan-bugs-originating-from-handle_bug.patch

