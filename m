Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AD37C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 23:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiKHX7E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 18:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiKHX6Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 18:58:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1F438A5
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 15:58:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 416BB617E6
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 23:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968B7C433C1;
        Tue,  8 Nov 2022 23:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667951902;
        bh=Up6xOmJ1gcphR6Gavt2UVBZ3qIHcvwC+E2mL8fDQahs=;
        h=Date:To:From:Subject:From;
        b=G+I43DpmP+FwUJmJUEnxVYfNpWUxX3il76OK6wKQYpjjilHOTJilSJWxq4Wa2uf1J
         HYwTzXaZCzun2KX6i6m8c2s1shvN2l+AohdI2CCclJkcqBbV0zg2mv/xq/DgzAXbFa
         fEwyj5ELo2ayvUL0gNapPXbHjkVUED1CW75AAkfM=
Date:   Tue, 08 Nov 2022 15:58:22 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, ndesaulniers@google.com, mingo@redhat.com,
        masahiroy@kernel.org, keescook@chromium.org, elver@google.com,
        dvyukov@google.com, dave.hansen@linux.intel.com, bp@alien8.de,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] x86-traps-avoid-kmsan-bugs-originating-from-handle_bug.patch removed from -mm tree
Message-Id: <20221108235822.968B7C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86/traps: avoid KMSAN bugs originating from handle_bug()
has been removed from the -mm tree.  Its filename was
     x86-traps-avoid-kmsan-bugs-originating-from-handle_bug.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


