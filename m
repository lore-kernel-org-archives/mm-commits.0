Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A77C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 12 Feb 2021 20:11:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DA8E64DF2
	for <mm-commits@archiver.kernel.org>; Fri, 12 Feb 2021 20:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhBLULp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Feb 2021 15:11:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:50742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229583AbhBLULp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Feb 2021 15:11:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCE0364DF2;
        Fri, 12 Feb 2021 20:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613160664;
        bh=w2lXZy5eQxm9QK9Q8ukZZhBiBAbK+Dw2JludpTM2LmU=;
        h=Date:From:To:Subject:From;
        b=eX0u8YfwOmocpHukM+gEKkucIXgdTyiZjBYjczqwFcFDJPTfTiJZFle4HVpp+GpRq
         upJNhkSWDQEj5J1VhHCVSNXujWtenhCoFaHnosXdk+NLPEk751AFneMt4xEip4+62N
         ijPcH4k5sykfVhgsVmxVQx5Q3PEfvSHtm6NgVYyU=
Date:   Fri, 12 Feb 2021 12:11:04 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        tglx@linutronix.de, lkp@intel.com, rdunlap@infradead.org
Subject:  + h8300-fix-preemption-build-ti_pre_count-undefined.patch
 added to -mm tree
Message-ID: <20210212201104.7GhRp%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: h8300: fix PREEMPTION build, TI_PRE_COUNT undefined
has been added to the -mm tree.  Its filename is
     h8300-fix-preemption-build-ti_pre_count-undefined.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/h8300-fix-preemption-build-ti_pre_count-undefined.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/h8300-fix-preemption-build-ti_pre_count-undefined.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from rdunlap@infradead.org are

h8300-fix-preemption-build-ti_pre_count-undefined.patch
hexagon-remove-config_experimental-from-defconfigs.patch
ntfs-layouth-delete-duplicated-words.patch
fs-delete-repeated-words-in-comments.patch
mm-zswap-clean-up-confusing-comment.patch
alpha-remove-config_experimental-from-defconfigs.patch
include-linux-remove-repeated-words.patch
kernel-delete-repeated-words-in-comments.patch

