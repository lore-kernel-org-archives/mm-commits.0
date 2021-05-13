Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F296DC433B4
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 21:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8C42613F5
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 21:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhEMVZ5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 17:25:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230252AbhEMVZ5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 17:25:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C39F5613C3;
        Thu, 13 May 2021 21:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620941086;
        bh=7dmH9f7zEP4Mlgq0NV/88lOkaO+fLuiz3oDAOFNvC8E=;
        h=Date:From:To:Subject:From;
        b=od5PeVgcmc/O0z/CiUTuVrqbTxU5MImq39ZZUXWcA58GsQ8lr+ZsxaKMZc0WecijC
         47rboeO9P8af2EDESFv6+adY2JepesMag9eOF+K6N7VRiwnIaLnOcOKTXXwaCcWSWr
         vm4zhYKuwFCfOAAG+mpUB6G0pD40yz+VAB4l3rII=
Date:   Thu, 13 May 2021 14:24:46 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  +
 module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-2.patch
 added to -mm tree
Message-ID: <20210513212446.UKWyO8wZS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buildid: fix build when CONFIG_MODULES is not set
has been added to the -mm tree.  Its filename is
     module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-2.patch

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

ia64-headers-drop-duplicated-words.patch
mm-slub-use-stackdepot-to-save-stack-trace-in-objects-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-2.patch

