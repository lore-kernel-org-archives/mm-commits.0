Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2952EC433FE
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 23:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbiKHX65 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 18:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiKHX6Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 18:58:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FE8BE0
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 15:58:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFF63B81CC8
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 23:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549F3C433B5;
        Tue,  8 Nov 2022 23:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667951901;
        bh=Z2S08Cd5wk51N/RsHqY2Gex1eeLhpfRytyROJTR3TYY=;
        h=Date:To:From:Subject:From;
        b=AsmbpfI9e3VCqz6MTP126W3NR3YodX9EmtlVOo9OvytWx4hZWpglCcBTksCUQWXUG
         5iL0QgJypQgkS/UoA+HPC/yhanAh2UUoslBdyrUr+HYDO30BEOIreZDC3QM4NJ+BiI
         xvczEWXcYJuLPRcZGH2+znO2UtAOFYaO7to4vb1Y=
Date:   Tue, 08 Nov 2022 15:58:20 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, ndesaulniers@google.com, mingo@redhat.com,
        masahiroy@kernel.org, keescook@chromium.org, elver@google.com,
        dvyukov@google.com, dave.hansen@linux.intel.com, bp@alien8.de,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kmsan-make-sure-preempt_rt-is-off.patch removed from -mm tree
Message-Id: <20221108235821.549F3C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kmsan: make sure PREEMPT_RT is off
has been removed from the -mm tree.  Its filename was
     kmsan-make-sure-preempt_rt-is-off.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kmsan: make sure PREEMPT_RT is off
Date: Wed, 2 Nov 2022 12:06:10 +0100

As pointed out by Peter Zijlstra, __msan_poison_alloca() does not play
well with IRQ code when PREEMPT_RT is on, because in that mode even
GFP_ATOMIC allocations cannot be performed.

Fixing this would require making stackdepot completely lockless, which is
quite challenging and may be excessive for the time being.

Instead, make sure KMSAN is incompatible with PREEMPT_RT, like other debug
configs are.

Link: https://lkml.kernel.org/r/20221102110611.1085175-4-glider@google.com
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

 lib/Kconfig.kmsan |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Kconfig.kmsan~kmsan-make-sure-preempt_rt-is-off
+++ a/lib/Kconfig.kmsan
@@ -12,6 +12,7 @@ config KMSAN
 	bool "KMSAN: detector of uninitialized values use"
 	depends on HAVE_ARCH_KMSAN && HAVE_KMSAN_COMPILER
 	depends on SLUB && DEBUG_KERNEL && !KASAN && !KCSAN
+	depends on !PREEMPT_RT
 	select STACKDEPOT
 	select STACKDEPOT_ALWAYS_INIT
 	help
_

Patches currently in -mm which might be from glider@google.com are


