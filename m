Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE8C9C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87905601FD
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhBZAvR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:51:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:35758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231270AbhBZAvQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:51:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E16E4601FD;
        Fri, 26 Feb 2021 00:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614300636;
        bh=3b0ZbxSncW+QDoUnkGWvkqIwXpkGEsroz3unkjaDml4=;
        h=Date:From:To:Subject:From;
        b=L3rduFu51xobpDBGTkwsLiqQk8DGzr4yDbId033/hNKQXoKqDiM64HphI/z0zAT/j
         gGLqK4zztHOqld+ucQ7dLn+0Spv7ZH+1JmIPC+DndbT/Cp8oRebgnMCbcvivheqMlh
         gyIoY2PkNDMKaOMBRTKT0S4pFX37015LDvGgO6jU=
Date:   Thu, 25 Feb 2021 16:50:35 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, glider@google.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, vinmenon@codeaurora.org,
        vjitta@codeaurora.org, ylal@codeaurora.org
Subject:  [folded-merged]
 lib-stackdepot-add-support-to-disable-stack-depot-fix.patch removed from
 -mm tree
Message-ID: <20210226005035.wMolcHgNk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib-stackdepot-add-support-to-disable-stack-depot-fix
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-add-support-to-disable-stack-depot-fix.patch

This patch was dropped because it was folded into lib-stackdepot-add-support-to-disable-stack-depot.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-stackdepot-add-support-to-disable-stack-depot-fix

fix CONFIG_STACKDEPOT=n build

main.c:(.init.text+0x4c1): undefined reference to `stack_depot_init'

Cc: Alexander Potapenko <glider@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Yogesh Lal <ylal@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stackdepot.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/include/linux/stackdepot.h~lib-stackdepot-add-support-to-disable-stack-depot-fix
+++ a/include/linux/stackdepot.h
@@ -21,5 +21,13 @@ unsigned int stack_depot_fetch(depot_sta
 
 unsigned int filter_irq_stacks(unsigned long *entries, unsigned int nr_entries);
 
+#ifdef CONFIG_STACKDEPOT
 int stack_depot_init(void);
+#else
+static inline int stack_depot_init(void)
+{
+	return 0;
+}
+#endif	/* CONFIG_STACKDEPOT */
+
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-stackdepot-add-support-to-disable-stack-depot.patch
seq_file-document-how-per-entry-resources-are-managed-fix.patch
initramfs-panic-with-memory-information-fix.patch
mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

