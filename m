Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF6AFC4707F
	for <mm-commits@archiver.kernel.org>; Thu, 27 May 2021 23:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E9DF613D4
	for <mm-commits@archiver.kernel.org>; Thu, 27 May 2021 23:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbhE0Xls (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 May 2021 19:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhE0Xlr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 27 May 2021 19:41:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB2AB613BA;
        Thu, 27 May 2021 23:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622158813;
        bh=XTD5+njEVwH8FzluhyOmbhznah5zjwxrYw1+14qfcMI=;
        h=Date:From:To:Subject:From;
        b=TaZ59+ZItUmjYaXAED+j0Ca61sEl9FQk3b/DQ1rJbctSREnwCofWGs2NbMMrgocrK
         rttGcbY2XW3WtnaiEM7vVN4T54Vw0cgW7POP1Ly6qdjeIMBnQtr8REE3fhaFyspjkQ
         tnKqCs0L5OaNjCrmsXPVxAPK6RVd/OkvEKUashSY=
Date:   Thu, 27 May 2021 16:40:13 -0700
From:   akpm@linux-foundation.org
To:     elver@google.com, mm-commits@vger.kernel.org, ojeda@kernel.org,
        peterz@infradead.org
Subject:  +
 =?US-ASCII?Q?kcov-add-=5F=5Fno=5Fsanitize=5Fcoverage-to-fix-noinstr-fo?=
 =?US-ASCII?Q?r-all-architectures-v3.patch?= added to -mm tree
Message-ID: <20210527234013.bRhy0Vc1Z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: add __no_sanitize_coverage to fix noinstr for all architectures
has been added to the -mm tree.  Its filename is
     kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures-v3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures-v3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kcov: add __no_sanitize_coverage to fix noinstr for all architectures

add comment explaining __has_feature() in Clang

Link: https://lkml.kernel.org/r/20210527194448.3470080-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-clang.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/linux/compiler-clang.h~kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures-v3
+++ a/include/linux/compiler-clang.h
@@ -13,6 +13,12 @@
 /* all clang versions usable with the kernel support KASAN ABI version 5 */
 #define KASAN_ABI_VERSION 5
 
+/*
+ * Note: Checking __has_feature(*_sanitizer) is only true if the feature is
+ * enabled. Therefore it is not required to additionally check defined(CONFIG_*)
+ * to avoid adding redundant attributes in other configurations.
+ */
+
 #if __has_feature(address_sanitizer) || __has_feature(hwaddress_sanitizer)
 /* Emulate GCC's __SANITIZE_ADDRESS__ flag */
 #define __SANITIZE_ADDRESS__
_

Patches currently in -mm which might be from elver@google.com are

kfence-use-task_idle-when-awaiting-allocation.patch
mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time-fix.patch
printk-introduce-dump_stack_lvl-fix.patch
kfence-unconditionally-use-unbound-work-queue.patch
kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures.patch
kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures-v2.patch
kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures-v3.patch

