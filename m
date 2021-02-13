Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 932D1C433E0
	for <mm-commits@archiver.kernel.org>; Sat, 13 Feb 2021 04:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45A7860C3E
	for <mm-commits@archiver.kernel.org>; Sat, 13 Feb 2021 04:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhBMExh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Feb 2021 23:53:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232148AbhBMExg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Feb 2021 23:53:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 640A864E3B;
        Sat, 13 Feb 2021 04:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613191974;
        bh=V0+GvBZARs2BHNyHdAboWk8oJQqFt0z3Q2lQlguArZs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tsZemh7+ijJLZpmsWWfBNtxEpF4jhUXLsVPP4rEnyUOrZDlWsphyhrdSF8WcBKc/6
         AAEI9SA5p2LUDxQOnF4Eo50UzhaPpp/Pt4YNln1xaRJsKZzFC/oFRyeG+IBtT+IL75
         bo1uyOC5qRZTnTMc4BXnOvcSYfGorW3puCZGSEc8=
Date:   Fri, 12 Feb 2021 20:52:54 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, lkp@intel.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        ysato@users.sourceforge.jp
Subject:  [patch 6/6] h8300: fix PREEMPTION build, TI_PRE_COUNT
 undefined
Message-ID: <20210213045254.t7hAEyRSN%akpm@linux-foundation.org>
In-Reply-To: <20210212205206.f99cbe2e7e368c802a385104@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: h8300: fix PREEMPTION build, TI_PRE_COUNT undefined

Fix a build error for undefined 'TI_PRE_COUNT' by adding it to
asm-offsets.c.

h8300-linux-ld: arch/h8300/kernel/entry.o: in function `resume_kernel':
(.text+0x29a): undefined reference to `TI_PRE_COUNT'

Link: https://lkml.kernel.org/r/20210212021650.22740-1-rdunlap@infradead.org
Fixes: df2078b8daa7 ("h8300: Low level entry")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/asm-offsets.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/h8300/kernel/asm-offsets.c~h8300-fix-preemption-build-ti_pre_count-undefined
+++ a/arch/h8300/kernel/asm-offsets.c
@@ -63,6 +63,9 @@ int main(void)
 	OFFSET(TI_FLAGS, thread_info, flags);
 	OFFSET(TI_CPU, thread_info, cpu);
 	OFFSET(TI_PRE, thread_info, preempt_count);
+#ifdef CONFIG_PREEMPTION
+	DEFINE(TI_PRE_COUNT, offsetof(struct thread_info, preempt_count));
+#endif
 
 	return 0;
 }
_
