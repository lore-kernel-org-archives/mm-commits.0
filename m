Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB79DC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:32:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbiKOWcs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:32:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbiKOWcW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:32:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E5B5FCE
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:32:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA389B81A1C
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB36C433C1;
        Tue, 15 Nov 2022 22:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551538;
        bh=Pa+VNk67tPXfu7ARpixxqNjPrCiRDC5imV2WjBEjSac=;
        h=Date:To:From:Subject:From;
        b=UvIsi+hQKS3rlIkZ74QAhzzN+nuDC+868Two5ZvVsUWLejSctQHhmcI8M+XuuIpsV
         Ug6PUCBM8XP/MBpv7KoxSt5L9UuoXDO8kSh/Zre6t81M1HCf/SU5mqQcxJdAUEsHFT
         7WQ1JEZWmH2Gjt564a050ZOPq80Z6L3+tGXgmLYc=
Date:   Tue, 15 Nov 2022 14:32:18 -0800
To:     mm-commits@vger.kernel.org, mingo@kernel.org, mhiramat@kernel.org,
        cuigaosheng1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ia64-kprobes-remove-orphan-declarations-from-arch-ia64-include-asm-kprobesh.patch removed from -mm tree
Message-Id: <20221115223218.7FB36C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ia64/kprobes: remove orphan declarations from arch/ia64/include/asm/kprobes.h
has been removed from the -mm tree.  Its filename was
     ia64-kprobes-remove-orphan-declarations-from-arch-ia64-include-asm-kprobesh.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gaosheng Cui <cuigaosheng1@huawei.com>
Subject: ia64/kprobes: remove orphan declarations from arch/ia64/include/asm/kprobes.h
Date: Wed, 14 Sep 2022 20:47:07 +0800

flush_register_stack() and invalidate_stacked_regs() have been removed
since commit 0aeaf6b3a345 ("ia64/kprobes: Remove jprobe implementation"),
so remove them.

Link: https://lkml.kernel.org/r/20220914124707.1483471-1-cuigaosheng1@huawei.com
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/kprobes.h |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/ia64/include/asm/kprobes.h~ia64-kprobes-remove-orphan-declarations-from-arch-ia64-include-asm-kprobesh
+++ a/arch/ia64/include/asm/kprobes.h
@@ -110,8 +110,6 @@ extern int kprobe_fault_handler(struct p
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);
 
-extern void invalidate_stacked_regs(void);
-extern void flush_register_stack(void);
 extern void arch_remove_kprobe(struct kprobe *p);
 
 #endif /* CONFIG_KPROBES */
_

Patches currently in -mm which might be from cuigaosheng1@huawei.com are


