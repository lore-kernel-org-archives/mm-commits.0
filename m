Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ECBAC433DB
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA6A5227BF
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbhAXBpZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:45:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:49102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726288AbhAXBpZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:45:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 194F7227BF;
        Sun, 24 Jan 2021 01:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611452684;
        bh=rGFu7+WycOAPJ37M9Nvv89hLGK8W9aSOKoX0VfYXOz0=;
        h=Date:From:To:Subject:From;
        b=CeKAPr/cHNzxDaH6rfH+awtIE+HzJf1TDnT0Raj0Io5dNjyNlZ1tWoS5C0KGAho8t
         zII0GFpQpW13RCB88Y4KFvxxI6cOKVEdv9MfwqEZNiqt1mmhtIprWXoy2zMZjP+O1U
         WLFFJGHNIHS9f+7RjqcGJ5ucXxK+PIuv/sA4Lqus=
Date:   Sat, 23 Jan 2021 17:44:43 -0800
From:   akpm@linux-foundation.org
To:     joe@perches.com, kuba@kernel.org, mm-commits@vger.kernel.org
Subject:  +
 checkpatch-add-kmalloc_array_node-to-unnecessary-oom-message-check.patch
 added to -mm tree
Message-ID: <20210124014443.qfl5Adcrt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add kmalloc_array_node to unnecessary OOM message check
has been added to the -mm tree.  Its filename is
     checkpatch-add-kmalloc_array_node-to-unnecessary-oom-message-check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-kmalloc_array_node-to-unnecessary-oom-message-check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-kmalloc_array_node-to-unnecessary-oom-message-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add kmalloc_array_node to unnecessary OOM message check

commit 5799b255c491 ("include/linux/slab.h: add kmalloc_array_node() and
kcalloc_node()") was added in 2017.  Update the unnecessary OOM message
test to include it.

Link: https://lkml.kernel.org/r/b9dc4a808b1518e08ab8761480d9872e5d18e7cd.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-add-kmalloc_array_node-to-unnecessary-oom-message-check
+++ a/scripts/checkpatch.pl
@@ -487,7 +487,7 @@ our $logFunctions = qr{(?x:
 
 our $allocFunctions = qr{(?x:
 	(?:(?:devm_)?
-		(?:kv|k|v)[czm]alloc(?:_node|_array)? |
+		(?:kv|k|v)[czm]alloc(?:_array)?(?:_node)? |
 		kstrdup(?:_const)? |
 		kmemdup(?:_nul)?) |
 	(?:\w+)?alloc_skb(?:_ip_align)? |
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-blank-line-after-declaration-test.patch
checkpatch-prefer-ftrace-over-function-entry-exit-printks.patch
checkpatch-improve-typecast_int_constant-test-message.patch
checkpatch-add-kmalloc_array_node-to-unnecessary-oom-message-check.patch

