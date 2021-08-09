Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A81AFC4338F
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 18:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D31961040
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 18:49:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235300AbhHISto (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Aug 2021 14:49:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235268AbhHIStn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 9 Aug 2021 14:49:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D89D60EE7;
        Mon,  9 Aug 2021 18:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628534962;
        bh=d+j7xiQcnHWzQpFhnnvRnCZOW007ZuuHIJpf4R2HwZU=;
        h=Date:From:To:Subject:From;
        b=HSJV+jiVAT7rNMXsV6LRbUk2DbZR5egEjugCm5KhHF6uCe7YMxM3od8gtddbwavjB
         JTSBr7n2Bo7hU9FdPWeNDynvD65bEa/gayzYfMfdiPuKa7AfEH4Hz9eMlDFcK38/sj
         EDjqlzTOjyA2uIH8ZEGbmgnaoSxsr7Hqv4Ge/U2g=
Date:   Mon, 09 Aug 2021 11:49:22 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rth@twiddle.net, mattst88@gmail.com,
        ink@jurassic.park.msu.ru, airlied@linux.ie, rdunlap@infradead.org
Subject:  + alpha-agp-make-empty-macros-use-do-while-0-style.patch
 added to -mm tree
Message-ID: <20210809184922.029iE%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: agp: make empty macros use do-while-0 style
has been added to the -mm tree.  Its filename is
     alpha-agp-make-empty-macros-use-do-while-0-style.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/alpha-agp-make-empty-macros-use-do-while-0-style.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/alpha-agp-make-empty-macros-use-do-while-0-style.patch

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
Subject: alpha: agp: make empty macros use do-while-0 style

Copy these macros from ia64/include/asm/agp.h to avoid the
"empty-body" in 'if' statment warning.

drivers/char/agp/generic.c: In function 'agp_generic_destroy_page':
../drivers/char/agp/generic.c:1265:42: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]
 1265 |                 unmap_page_from_agp(page);

Link: https://lkml.kernel.org/r/20210809030822.20658-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/agp.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/alpha/include/asm/agp.h~alpha-agp-make-empty-macros-use-do-while-0-style
+++ a/arch/alpha/include/asm/agp.h
@@ -6,8 +6,8 @@
 
 /* dummy for now */
 
-#define map_page_into_agp(page) 
-#define unmap_page_from_agp(page) 
+#define map_page_into_agp(page)		do { } while (0)
+#define unmap_page_from_agp(page)	do { } while (0)
 #define flush_agp_cache() mb()
 
 /* GATT allocation. Returns/accepts GATT kernel virtual address. */
_

Patches currently in -mm which might be from rdunlap@infradead.org are

alpha-agp-make-empty-macros-use-do-while-0-style.patch
lib-dump_stack-correct-kernel-doc-notation.patch
lib-iov_iterc-fix-kernel-doc-warnings.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix.patch
scripts-check_extable-fix-typo-in-user-error-message.patch

