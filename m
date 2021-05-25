Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 381AAC47087
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 23:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C0E1613F5
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 23:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbhEYXP6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 May 2021 19:15:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229610AbhEYXP4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 May 2021 19:15:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2E2A6128B;
        Tue, 25 May 2021 23:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621984463;
        bh=RK1SJb37vgpL1zIRrJE8+69Iaz7IqMUrBPf7vPHcOpo=;
        h=Date:From:To:Subject:From;
        b=rSwllfagls4c1vZEyi/4z554p5DRmB8e3ixbzmxFtvlRqC8hivmrIUMAKcoDeYRS4
         ASIJvN+AQVfeSIMgXTTgdabvH17mvC/BfEa6ivrCqW5SqawNpkFjF++8wyepH2wpj1
         NcR5KbOBkwYX7TPTfMfunntw6OMwUGu4mE7h0uTg=
Date:   Tue, 25 May 2021 16:14:23 -0700
From:   akpm@linux-foundation.org
To:     cuibixuan@huawei.com, hulkci@huawei.com,
        mm-commits@vger.kernel.org, swboyd@chromium.org
Subject:  +
 =?US-ASCII?Q?module-add-printk-formats-to-add-module-build-id-to-stack?=
 =?US-ASCII?Q?traces-fix-fix-fix.patch?= added to -mm tree
Message-ID: <20210525231423.VGiRQhpf3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: module: fix build error when CONFIG_SYSFS is disabled
has been added to the -mm tree.  Its filename is
     module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bixuan Cui <cuibixuan@huawei.com>
Subject: module: fix build error when CONFIG_SYSFS is disabled

Fix build error when disable CONFIG_SYSFS:
kernel/module.c:2805:8: error: implicit declaration of function `sect_empty'; did you mean `desc_empty'? [-Werror=implicit-function-declaration]
 2805 |   if (!sect_empty(sechdr) && sechdr->sh_type == SHT_NOTE &&

Link: https://lkml.kernel.org/r/20210525105049.34804-1-cuibixuan@huawei.com
Fixes: 9ee6682aa528 ("module: add printk formats to add module build ID to stacktraces")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/kernel/module.c~module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix-fix
+++ a/kernel/module.c
@@ -1462,6 +1462,13 @@ resolve_symbol_wait(struct module *mod,
 	return ksym;
 }
 
+#ifdef CONFIG_KALLSYMS
+static inline bool sect_empty(const Elf_Shdr *sect)
+{
+	return !(sect->sh_flags & SHF_ALLOC) || sect->sh_size == 0;
+}
+#endif
+
 /*
  * /sys/module/foo/sections stuff
  * J. Corbet <corbet@lwn.net>
@@ -1469,11 +1476,6 @@ resolve_symbol_wait(struct module *mod,
 #ifdef CONFIG_SYSFS
 
 #ifdef CONFIG_KALLSYMS
-static inline bool sect_empty(const Elf_Shdr *sect)
-{
-	return !(sect->sh_flags & SHF_ALLOC) || sect->sh_size == 0;
-}
-
 struct module_sect_attr {
 	struct bin_attribute battr;
 	unsigned long address;
_

Patches currently in -mm which might be from cuibixuan@huawei.com are

module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix-fix.patch

