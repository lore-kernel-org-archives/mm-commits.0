Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B607C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  2 Nov 2022 21:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiKBVNT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Nov 2022 17:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiKBVNR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Nov 2022 17:13:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157B7DFDE
        for <mm-commits@vger.kernel.org>; Wed,  2 Nov 2022 14:13:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1BEFB82485
        for <mm-commits@vger.kernel.org>; Wed,  2 Nov 2022 21:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB75C433D6;
        Wed,  2 Nov 2022 21:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667423594;
        bh=+GS7IjcJxJosrzsjvsSWsezRo000TkcXg4rcncQjPlk=;
        h=Date:To:From:Subject:From;
        b=0IR3TXvPOXeAqUovnJmVT5QQ9Yx8dJZgJeofBSLZIblPjMuMg4cG2QJMIZaN1DuWc
         CgK2qJC560pDjt8AWg62v+IAqZLOrO8inLBMQHMc2b7NjDy1pXTQ95RXtF3/Zdt6j4
         legIy0BuD18SrMVFwimLbJzFPqImT2BFuTUQ8Suo=
Date:   Wed, 02 Nov 2022 14:13:13 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, ndesaulniers@google.com, mingo@redhat.com,
        masahiroy@kernel.org, keescook@chromium.org, elver@google.com,
        dvyukov@google.com, dave.hansen@linux.intel.com, bp@alien8.de,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kconfigdebug-ensure-early-check-for-kmsan-in-config_kmsan_warn.patch added to mm-hotfixes-unstable branch
Message-Id: <20221102211314.4DB75C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Kconfig.debug: ensure early check for KMSAN in CONFIG_KMSAN_WARN
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kconfigdebug-ensure-early-check-for-kmsan-in-config_kmsan_warn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kconfigdebug-ensure-early-check-for-kmsan-in-config_kmsan_warn.patch

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
Subject: Kconfig.debug: ensure early check for KMSAN in CONFIG_KMSAN_WARN
Date: Wed, 2 Nov 2022 12:06:09 +0100

As pointed out by Masahiro Yamada, Kconfig picks up the first default
entry which has true 'if' condition.  Hence, the previously added check
for KMSAN was never used, because it followed the checks for 64BIT and
!64BIT.

Put KMSAN check before others to ensure it is always applied.

Link: https://lkml.kernel.org/r/20221102110611.1085175-3-glider@google.com
Link: https://github.com/google/kmsan/issues/89
Link: https://lore.kernel.org/linux-mm/20221024212144.2852069-3-glider@google.com/
Fixes: 921757bc9b61 ("Kconfig.debug: disable CONFIG_FRAME_WARN for KMSAN by default")
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.debug~kconfigdebug-ensure-early-check-for-kmsan-in-config_kmsan_warn
+++ a/lib/Kconfig.debug
@@ -395,12 +395,12 @@ endif # DEBUG_INFO
 config FRAME_WARN
 	int "Warn for stack frames larger than"
 	range 0 8192
+	default 0 if KMSAN
 	default 2048 if GCC_PLUGIN_LATENT_ENTROPY
 	default 2048 if PARISC
 	default 1536 if (!64BIT && XTENSA)
 	default 1024 if !64BIT
 	default 2048 if 64BIT
-	default 0 if KMSAN
 	help
 	  Tell the compiler to warn at build time for stack frames larger than this.
 	  Setting this too low will cause a lot of warnings.
_

Patches currently in -mm which might be from glider@google.com are

kmsan-core-kmsan_in_runtime-should-return-true-in-nmi-context.patch
x86-uaccess-instrument-copy_from_user_nmi.patch
kconfigdebug-ensure-early-check-for-kmsan-in-config_kmsan_warn.patch
kmsan-make-sure-preempt_rt-is-off.patch
x86-traps-avoid-kmsan-bugs-originating-from-handle_bug.patch

