Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD270C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  2 Nov 2022 21:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbiKBVNT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Nov 2022 17:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiKBVNR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Nov 2022 17:13:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3DA3DF24
        for <mm-commits@vger.kernel.org>; Wed,  2 Nov 2022 14:13:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8956FB8250C
        for <mm-commits@vger.kernel.org>; Wed,  2 Nov 2022 21:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267C9C433C1;
        Wed,  2 Nov 2022 21:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667423592;
        bh=mYuL3z3WYy4sjaulmbWsYsg4Q/hpdtSWx2qY3xmzPLc=;
        h=Date:To:From:Subject:From;
        b=KwDg0D6k2jahz05L/ymhfvFzISO23+H+q4OpRc6UAhJeE1bEDmDM9CGKuIP5XXEYE
         qp05VZUYEESgC3LB3SeI9KBC0PohizLyYU1++NOhPK44FR2/EMifhfWQOrXI94NBU/
         MhXFG13lqMirKMCT+jByDkUArgDD1IFVq6AeBHlE=
Date:   Wed, 02 Nov 2022 14:13:11 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, ndesaulniers@google.com, mingo@redhat.com,
        masahiroy@kernel.org, keescook@chromium.org, elver@google.com,
        dvyukov@google.com, dave.hansen@linux.intel.com, bp@alien8.de,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-uaccess-instrument-copy_from_user_nmi.patch added to mm-hotfixes-unstable branch
Message-Id: <20221102211312.267C9C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/uaccess: instrument copy_from_user_nmi()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-uaccess-instrument-copy_from_user_nmi.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-uaccess-instrument-copy_from_user_nmi.patch

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
Subject: x86/uaccess: instrument copy_from_user_nmi()
Date: Wed, 2 Nov 2022 12:06:08 +0100

Make sure usercopy hooks from linux/instrumented.h are invoked for
copy_from_user_nmi().  This fixes KMSAN false positives reported when
dumping opcodes for a stack trace.

Link: https://lkml.kernel.org/r/20221102110611.1085175-2-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Marco Elver <elver@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/lib/usercopy.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/lib/usercopy.c~x86-uaccess-instrument-copy_from_user_nmi
+++ a/arch/x86/lib/usercopy.c
@@ -6,6 +6,7 @@
 
 #include <linux/uaccess.h>
 #include <linux/export.h>
+#include <linux/instrumented.h>
 
 #include <asm/tlbflush.h>
 
@@ -44,7 +45,9 @@ copy_from_user_nmi(void *to, const void
 	 * called from other contexts.
 	 */
 	pagefault_disable();
+	instrument_copy_from_user_before(to, from, n);
 	ret = raw_copy_from_user(to, from, n);
+	instrument_copy_from_user_after(to, from, n, ret);
 	pagefault_enable();
 
 	return ret;
_

Patches currently in -mm which might be from glider@google.com are

kmsan-core-kmsan_in_runtime-should-return-true-in-nmi-context.patch
x86-uaccess-instrument-copy_from_user_nmi.patch
kconfigdebug-ensure-early-check-for-kmsan-in-config_kmsan_warn.patch
kmsan-make-sure-preempt_rt-is-off.patch
x86-traps-avoid-kmsan-bugs-originating-from-handle_bug.patch

