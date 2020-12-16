Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF3CC2BBCD
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7D9A233FB
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgLPRMT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:12:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:33414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbgLPRMT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:12:19 -0500
Date:   Wed, 16 Dec 2020 09:11:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138698;
        bh=YJMRlsp+z9EoZlNZs3dOOvLzXTIUNUS9QoE1XWaJIYM=;
        h=From:To:Subject:From;
        b=XxnCE6tLogEdKRIxiUszqo/5cIqtVzpqePl4+Rk0O9oVO+czPXre5E42VKES/dzgz
         iwmaIHbsdfxRUjsjCjNZH8oM1DMgpfDUBTmQB7PkjP1D1b0gFJ/tJb39si91fq1d/f
         RMptuzvPO2qBNq/CjeYUZBQBT+gD7eVU6RoD7rDI=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, keescook@chromium.org,
        mm-commits@vger.kernel.org, zou_wei@huawei.com
Subject:  [merged]
 lib-ubsanc-mark-type_check_kinds-with-static-keyword.patch removed from -mm
 tree
Message-ID: <20201216171138.RxDd1DoAO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/ubsan.c: mark type_check_kinds with static keyword
has been removed from the -mm tree.  Its filename was
     lib-ubsanc-mark-type_check_kinds-with-static-keyword.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zou Wei <zou_wei@huawei.com>
Subject: lib/ubsan.c: mark type_check_kinds with static keyword

Fix the following sparse warning:

lib/ubsan.c:20:12: warning: symbol 'type_check_kinds' was not declared. Should it be static?

[akpm@linux-foundation.org: make it `static const char * const' while we're in there]
Link: https://lkml.kernel.org/r/1607602638-79584-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/ubsan.c~lib-ubsanc-mark-type_check_kinds-with-static-keyword
+++ a/lib/ubsan.c
@@ -17,7 +17,7 @@
 
 #include "ubsan.h"
 
-const char *type_check_kinds[] = {
+static const char * const type_check_kinds[] = {
 	"load of",
 	"store to",
 	"reference binding to",
_

Patches currently in -mm which might be from zou_wei@huawei.com are


