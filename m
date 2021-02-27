Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA2CDC4332E
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EB5464F1F
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhB0Cdj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:33:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:52722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230155AbhB0CdD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:33:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9011D64F1F;
        Sat, 27 Feb 2021 02:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393153;
        bh=3Uqh9dhmefHqaUlAAqhFjuOev/eL7+i/pBg5GldqwWM=;
        h=Date:From:To:Subject:From;
        b=b6iIBHIbGtuop0scOEr4Bo6WFgsKm+Uqw3prcQJYoe/NpL0VRfBa3gGCqOGccNk0d
         8atO2xozo/64uaKgXf/XwGvBpiHYQy1G6rd+4cK0sHIHBFALflPWjnxn8TU84zt1ne
         3k73vq5aQZ3r8/pjO7fTw9YJjVyOKexs6JoyrCbQ=
Date:   Fri, 26 Feb 2021 18:32:33 -0800
From:   akpm@linux-foundation.org
To:     guilak@linux.vnet.ibm.com, masahiroy@kernel.org,
        mchehab@kernel.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, rlrevell@joe-job.com
Subject:  [merged]
 init-versionc-remove-version_linux_version_code-symbol.patch removed from
 -mm tree
Message-ID: <20210227023233.6accEAwRk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init/version.c: remove Version_<LINUX_VERSION_CODE> symbol
has been removed from the -mm tree.  Its filename was
     init-versionc-remove-version_linux_version_code-symbol.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masahiro Yamada <masahiroy@kernel.org>
Subject: init/version.c: remove Version_<LINUX_VERSION_CODE> symbol

This code hunk creates a Version_<LINUX_VERSION_CODE> symbol if
CONFIG_KALLSYMS is disabled.  For example, building the kernel v5.10 for
allnoconfig creates the following symbol:

  $ nm vmlinux | grep Version_
  c116b028 B Version_330240

There is no in-tree user of this symbol.

Commit 197dcffc8ba0 ("init/version.c: define version_string only if
CONFIG_KALLSYMS is not defined") mentions that Version_* is only used
with ksymoops.

However, a commit in the pre-git era [1] had added the statement,
"ksymoops is useless on 2.6.  Please use the Oops in its original format".

That statement existed until commit 4eb9241127a0 ("Documentation:
admin-guide: update bug-hunting.rst") finally removed the stale
ksymoops information.

This symbol is no longer needed.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/history/history.git/commit/?id=ad68b2f085f5c79e4759ca2d13947b3c885ee831

Link: https://lkml.kernel.org/r/20210120033452.2895170-1-masahiroy@kernel.org
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Daniel Guilak <guilak@linux.vnet.ibm.com>
Cc: Lee Revell <rlrevell@joe-job.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/version.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/init/version.c~init-versionc-remove-version_linux_version_code-symbol
+++ a/init/version.c
@@ -16,14 +16,6 @@
 #include <linux/version.h>
 #include <linux/proc_ns.h>
 
-#ifndef CONFIG_KALLSYMS
-#define version(a) Version_ ## a
-#define version_string(a) version(a)
-
-extern int version_string(LINUX_VERSION_CODE);
-int version_string(LINUX_VERSION_CODE);
-#endif
-
 struct uts_namespace init_uts_ns = {
 	.ns.count = REFCOUNT_INIT(2),
 	.name = {
_

Patches currently in -mm which might be from masahiroy@kernel.org are

init-kconfig-make-compile_test-depend-on-has_iomem.patch

