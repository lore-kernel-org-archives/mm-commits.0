Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D35C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  2 Nov 2022 21:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiKBVNO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Nov 2022 17:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiKBVNN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Nov 2022 17:13:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CCFDFBF
        for <mm-commits@vger.kernel.org>; Wed,  2 Nov 2022 14:13:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D5CCB8250D
        for <mm-commits@vger.kernel.org>; Wed,  2 Nov 2022 21:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F228C433D6;
        Wed,  2 Nov 2022 21:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667423590;
        bh=3BTuaX+6DLaC+6erQEKYBhrdYdYTWlUxHobuTpid+ZA=;
        h=Date:To:From:Subject:From;
        b=boV1whdGjrCjBIh3/i5fs0KBSfhJ+Vpc64Fsv4XZzayRuZlltM3A44QelPwqsG5SV
         4PIwyBJnTbK7m3WrX5meqcJ7GZgg1PDExYXckaxU+0eqNMCVUNnPKKl6C03Q3DwKRQ
         wdOyS6w6wUin3gTwPolY6wh95i6S+43j2rrLb4TE=
Date:   Wed, 02 Nov 2022 14:13:09 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, ndesaulniers@google.com, mingo@redhat.com,
        masahiroy@kernel.org, keescook@chromium.org, elver@google.com,
        dvyukov@google.com, dave.hansen@linux.intel.com, bp@alien8.de,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-core-kmsan_in_runtime-should-return-true-in-nmi-context.patch added to mm-hotfixes-unstable branch
Message-Id: <20221102211310.0F228C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kmsan: core: kmsan_in_runtime() should return true in NMI context
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kmsan-core-kmsan_in_runtime-should-return-true-in-nmi-context.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-core-kmsan_in_runtime-should-return-true-in-nmi-context.patch

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
Subject: kmsan: core: kmsan_in_runtime() should return true in NMI context
Date: Wed, 2 Nov 2022 12:06:07 +0100

Without that, every call to __msan_poison_alloca() in NMI may end up
allocating memory, which is NMI-unsafe.

Link: https://lkml.kernel.org/r/20221102110611.1085175-1-glider@google.com
Link: https://lore.kernel.org/lkml/20221025221755.3810809-1-glider@google.com/
Signed-off-by: Alexander Potapenko <glider@google.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/kmsan.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/kmsan/kmsan.h~kmsan-core-kmsan_in_runtime-should-return-true-in-nmi-context
+++ a/mm/kmsan/kmsan.h
@@ -124,6 +124,8 @@ static __always_inline bool kmsan_in_run
 {
 	if ((hardirq_count() >> HARDIRQ_SHIFT) > 1)
 		return true;
+	if (in_nmi())
+		return true;
 	return kmsan_get_context()->kmsan_in_runtime;
 }
 
_

Patches currently in -mm which might be from glider@google.com are

kmsan-core-kmsan_in_runtime-should-return-true-in-nmi-context.patch
x86-uaccess-instrument-copy_from_user_nmi.patch
kconfigdebug-ensure-early-check-for-kmsan-in-config_kmsan_warn.patch
kmsan-make-sure-preempt_rt-is-off.patch
x86-traps-avoid-kmsan-bugs-originating-from-handle_bug.patch

