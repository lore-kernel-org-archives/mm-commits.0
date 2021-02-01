Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D224C433DB
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:43:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69ADA64ECB
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbhBAXnV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Feb 2021 18:43:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhBAXnT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Feb 2021 18:43:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2F1D64EC6;
        Mon,  1 Feb 2021 23:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612222959;
        bh=DpYGooEL2GTbXsn5GY7+vk6TU7syLoxYWit/F6D3ICM=;
        h=Date:From:To:Subject:From;
        b=WepnrLzZ00jX9LJemHOyUxdyDmXDe5hmnQIKMVdbh7+QFdg+/rSDfkOJBzKBkWWMv
         zddCLzbLwa6jp+lMqkCtAkr+uD1KmatoOPei0ngCKoslm9v2t/LZ84r4jn9HJAv5Ek
         AqWuWhOW0dx+ybAG7LDHfHKZhOGyOKgL2W+MZhWY=
Date:   Mon, 01 Feb 2021 15:42:37 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vjitta@codeaurora.org
Subject:  +
 lib-stackdepot-add-support-to-disable-stack-depot-fix-2.patch added to -mm
 tree
Message-ID: <20210201234237.BT8U6el08%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: stackdepot: fix ignoring return value warning
has been added to the -mm tree.  Its filename is
     lib-stackdepot-add-support-to-disable-stack-depot-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-stackdepot-add-support-to-disable-stack-depot-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-stackdepot-add-support-to-disable-stack-depot-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vijayanand Jitta <vjitta@codeaurora.org>
Subject: lib: stackdepot: fix ignoring return value warning

Fix the below ignoring return value warning for kstrtobool in
is_stack_depot_disabled function.

lib/stackdepot.c: In function 'is_stack_depot_disabled':
lib/stackdepot.c:154:2: warning: ignoring return value of 'kstrtobool'
declared with attribute 'warn_unused_result' [-Wunused-result]

Link: https://lkml.kernel.org/r/1612163048-28026-1-git-send-email-vjitta@codeaurora.org
Fixes: b9779abb09a8 ("lib: stackdepot: add support to disable stack depot")
Signed-off-by: Vijayanand Jitta <vjitta@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepot-add-support-to-disable-stack-depot-fix-2
+++ a/lib/stackdepot.c
@@ -151,8 +151,10 @@ static struct stack_record **stack_table
 
 static int __init is_stack_depot_disabled(char *str)
 {
-	kstrtobool(str, &stack_depot_disable);
-	if (stack_depot_disable) {
+	int ret;
+
+	ret = kstrtobool(str, &stack_depot_disable);
+	if (!ret && stack_depot_disable) {
 		pr_info("Stack Depot is disabled\n");
 		stack_table = NULL;
 	}
_

Patches currently in -mm which might be from vjitta@codeaurora.org are

lib-stackdepot-add-support-to-disable-stack-depot.patch
lib-stackdepot-add-support-to-disable-stack-depot-fix-2.patch

