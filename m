Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AEEFC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 04:51:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiJUEv3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 00:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiJUEv1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 00:51:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01471E8B96
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 21:51:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CADCB82A64
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 04:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44432C433C1;
        Fri, 21 Oct 2022 04:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666327884;
        bh=Lirzx9ot4YAbPLkEjMCdrxqriKqsa2Goq/fNEcVMmKQ=;
        h=Date:To:From:Subject:From;
        b=EdAfGVz2XrNtYcDzJQ2OjfViUvsra67Gk8BMgzKhQfuQWq+mzD+pEGjpFNKECzR2L
         gY6xISOpVrQGFdWYOGgdtiWjxV33u8NfGDNINzGe8QVrTfardxnGQC+JKE5c5iosC/
         kJnnMXIk/sVYa3IsMmgNlXjd7ih7cc2Lzny/IGtM=
Date:   Thu, 20 Oct 2022 21:51:23 -0700
To:     mm-commits@vger.kernel.org, mingo@kernel.org, mhiramat@kernel.org,
        cuigaosheng1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ia64-kprobes-remove-orphan-declarations-from-arch-ia64-include-asm-kprobesh.patch added to mm-nonmm-unstable branch
Message-Id: <20221021045124.44432C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64/kprobes: remove orphan declarations from arch/ia64/include/asm/kprobes.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ia64-kprobes-remove-orphan-declarations-from-arch-ia64-include-asm-kprobesh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ia64-kprobes-remove-orphan-declarations-from-arch-ia64-include-asm-kprobesh.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

ia64-kprobes-remove-orphan-declarations-from-arch-ia64-include-asm-kprobesh.patch

