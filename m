Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA6EBC07E95
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:09:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7DA7611BF
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhGHBML (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 21:12:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230148AbhGHBMK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 21:12:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 068B160BD3;
        Thu,  8 Jul 2021 01:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625706568;
        bh=DXvXhYbO3HjQDt85yKqre7Otf62nPSqrdc2J57kZmis=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NjijErjRypEe5n77HIl5ShPglHMT22hxySEQHa7OsQtt2yw18GhL7U41RvZHUyG96
         nAp2MMFC6yBcpmeuUip/pdKO3vlIisXe4f6/JluCZ9ONbYINMDAB3lRL7jXX2xuyHz
         hZGzgx1nfAHDt9/KEIE0f20WDph8CRYgsIFwU0yQ=
Date:   Wed, 07 Jul 2021 18:09:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        ast@kernel.org, bhe@redhat.com, bp@alien8.de,
        catalin.marinas@arm.com, dyoung@redhat.com, evgreen@chromium.org,
        hsinyi@chromium.org, jeyu@kernel.org, jolsa@kernel.org,
        khlebnikov@yandex-team.ru, linux-mm@kvack.org,
        linux@rasmusvillemoes.dk, mingo@redhat.com,
        mm-commits@vger.kernel.org, pmladek@suse.com, rostedt@goodmis.org,
        sashal@kernel.org, sergey.senozhatsky@gmail.com,
        swboyd@chromium.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vgoyal@redhat.com, will@kernel.org,
        willy@infradead.org
Subject:  [patch 37/54] x86/dumpstack: use %pSb/%pBb for backtrace
 printing
Message-ID: <20210708010927.q7HSqwnZw%akpm@linux-foundation.org>
In-Reply-To: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>
Subject: x86/dumpstack: use %pSb/%pBb for backtrace printing

Let's use the new printk formats to print the stacktrace entries when
printing a backtrace to the kernel logs.  This will include any module's
build ID[1] in it so that offline/crash debugging can easily locate the
debuginfo for a module via something like debuginfod[2].

Link: https://lkml.kernel.org/r/20210511003845.2429846-8-swboyd@chromium.org
Link: https://fedoraproject.org/wiki/Releases/FeatureBuildId [1]
Link: https://sourceware.org/elfutils/Debuginfod.html [2]
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Evan Green <evgreen@chromium.org>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/dumpstack.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/dumpstack.c~x86-dumpstack-use-%psb-%pbb-for-backtrace-printing
+++ a/arch/x86/kernel/dumpstack.c
@@ -69,7 +69,7 @@ static void printk_stack_address(unsigne
 				 const char *log_lvl)
 {
 	touch_nmi_watchdog();
-	printk("%s %s%pB\n", log_lvl, reliable ? "" : "? ", (void *)address);
+	printk("%s %s%pBb\n", log_lvl, reliable ? "" : "? ", (void *)address);
 }
 
 static int copy_code(struct pt_regs *regs, u8 *buf, unsigned long src,
_
