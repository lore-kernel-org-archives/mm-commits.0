Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AFF8C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 05:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C00F423EB4
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 05:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387788AbgLKF1c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Dec 2020 00:27:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391523AbgLKF10 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 11 Dec 2020 00:27:26 -0500
Date:   Thu, 10 Dec 2020 21:26:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607664405;
        bh=Ky5gjzEuxItoLq8ZI1CvhZS2ZQZU4oG2JVPbG/EZGns=;
        h=From:To:Subject:From;
        b=gfFrHAJN8rUMxdHikjEwGV+amaTCfiw8udAnMnmTotjl+fYn0XI8g0UaYixCjqODx
         TbtEfu2V6sszV+uqQOO+O54I0pTRjvt6yR+n5CnC9ytBUSoMuxFNj3t9zb0d/pFiIC
         X8IS08exJ79L9pV7q+IS61cqNQHW0hZ3f4/zpGAc=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zou_wei@huawei.com
Subject:  +
 lib-ubsanc-mark-type_check_kinds-with-static-keyword.patch added to -mm
 tree
Message-ID: <20201211052645.PgwRY43Ge%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/ubsan.c: mark type_check_kinds with static keyword
has been added to the -mm tree.  Its filename is
     lib-ubsanc-mark-type_check_kinds-with-static-keyword.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-ubsanc-mark-type_check_kinds-with-static-keyword.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-ubsanc-mark-type_check_kinds-with-static-keyword.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zou Wei <zou_wei@huawei.com>
Subject: lib/ubsan.c: mark type_check_kinds with static keyword

Fix the following sparse warning:

lib/ubsan.c:20:12: warning: symbol 'type_check_kinds' was not declared. Should it be static?

Link: https://lkml.kernel.org/r/1607602638-79584-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/ubsan.c~lib-ubsanc-mark-type_check_kinds-with-static-keyword
+++ a/lib/ubsan.c
@@ -17,7 +17,7 @@
 
 #include "ubsan.h"
 
-const char *type_check_kinds[] = {
+static const char *type_check_kinds[] = {
 	"load of",
 	"store to",
 	"reference binding to",
_

Patches currently in -mm which might be from zou_wei@huawei.com are

mm-page_alloc-mark-some-symbols-with-static-keyword.patch
lib-ubsanc-mark-type_check_kinds-with-static-keyword.patch

