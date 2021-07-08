Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C59ADC07E9B
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A76CC61C91
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:32:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbhGHAe6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 20:34:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230000AbhGHAe5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 20:34:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 112DC61CAC;
        Thu,  8 Jul 2021 00:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625704336;
        bh=7pbLsJdmeuv7Hdwz5OYlq20MlvKh77v797iMD383Ago=;
        h=Date:From:To:Subject:From;
        b=1GLmsfy7vXzu+HpsO+kSjGLRf3cOnkpO8sFbhex7PAtT7zB7lvZ2fV5lbtf4MqUqr
         6jV8JAIjsIzmfOKHzV0vQ9qOVVEN0YWh5juvQ1Qfiwi5QV/i2xlLhRgQ1mcxXoXpEV
         txDRh5oZI941yDwkdaa3BM+Ja2nnprTiFHqrg8pg=
Date:   Wed, 07 Jul 2021 17:32:15 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [folded-merged]
 module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-2.patch
 removed from -mm tree
Message-ID: <20210708003215.lu_cV%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buildid: fix build when CONFIG_MODULES is not set
has been removed from the -mm tree.  Its filename was
     module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-2.patch

This patch was dropped because it was folded into module-add-printk-formats-to-add-module-build-id-to-stacktraces.patch

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: buildid: fix build when CONFIG_MODULES is not set

Omit the static_assert() when CONFIG_MODULES is not set/enabled.
Fixes these build errors:

../kernel/kallsyms.c: In function `__sprint_symbol':
../include/linux/kernel.h:53:43: error: dereferencing pointer to incomplete type `struct module'
 #define typeof_member(T, m) typeof(((T*)0)->m)
                                           ^
../include/linux/build_bug.h:78:41: error: static assertion failed: "sizeof(typeof_member(struct module, build_id)) == 20"
 #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
                                         ^
../kernel/kallsyms.c:454:4: note: in expansion of macro `static_assert'
    static_assert(sizeof(typeof_member(struct module, build_id)) == 20);
    ^~~~~~~~~~~~~

Link: https://lkml.kernel.org/r/20210513171510.20328-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kallsyms.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/kallsyms.c~module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-2
+++ a/kernel/kallsyms.c
@@ -451,7 +451,9 @@ static int __sprint_symbol(char *buffer,
 #if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
 		if (add_buildid && buildid) {
 			/* build ID should match length of sprintf */
+#if IS_ENABLED(CONFIG_MODULES)
 			static_assert(sizeof(typeof_member(struct module, build_id)) == 20);
+#endif
 			len += sprintf(buffer + len, " %20phN", buildid);
 		}
 #endif
_

Patches currently in -mm which might be from rdunlap@infradead.org are

module-add-printk-formats-to-add-module-build-id-to-stacktraces.patch

