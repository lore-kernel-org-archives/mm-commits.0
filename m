Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0DB3C07E9B
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D519E61CCB
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhGHAfC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 20:35:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230000AbhGHAfC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 20:35:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BEC661CAC;
        Thu,  8 Jul 2021 00:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625704340;
        bh=gAt2gbgoUw/jCltSL7pBSk+tI+NBLJERcJXi7lwehdI=;
        h=Date:From:To:Subject:From;
        b=s0hgX+bswQkLfjGFbgKop5i06z/NbP96n7cArL4dWtJgCWhOy/BtqR7s7m6VovsmN
         Bj8ecNxQCovF16g1pdMiJ0Sey05CiAaXQ/vKKK8l0lkwqULxH7g6IgN8M4oJ+Eb6G/
         zIZTDFx2yFzBSWEMo6Q/1OhMOvDUkJ9R+m0ZZmf8=
Date:   Wed, 07 Jul 2021 17:32:19 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, swboyd@chromium.org, jeyu@kernel.org,
        hulkci@huawei.com, cuibixuan@huawei.com
Subject:  [folded-merged]
 =?us-ascii?Q?module-add-printk-formats-to-add-module-build-id-to-stack?=
 =?us-ascii?Q?traces-fix-fix-fix.patch?= removed from -mm tree
Message-ID: <20210708003219.aVef7%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: module: fix build error when CONFIG_SYSFS is disabled
has been removed from the -mm tree.  Its filename was
     module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix-fix.patch

This patch was dropped because it was folded into module-add-printk-formats-to-add-module-build-id-to-stacktraces.patch

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
Acked-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/kernel/module.c~module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix-fix
+++ a/kernel/module.c
@@ -1466,6 +1466,13 @@ resolve_symbol_wait(struct module *mod,
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
@@ -1473,11 +1480,6 @@ resolve_symbol_wait(struct module *mod,
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

module-add-printk-formats-to-add-module-build-id-to-stacktraces.patch

