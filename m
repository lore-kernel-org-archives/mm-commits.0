Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE7FEC433E6
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63BD864F22
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhBZBXO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:23:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:53344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230063AbhBZBWe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:22:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9A9064F27;
        Fri, 26 Feb 2021 01:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302492;
        bh=+AVAnkueL+La1x3r/MEipm3fensULqxSe/sRfk6AYJY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ioIeH0O84PoUZfDELcTO++G5KlTcu0iBwtVC8c/P1zNdr6L08oSa7BnwPn746KQ5C
         jusEGOR83eIMogblrecF2sVmzcULJwHXklfsuBSCvFwV9ya4s1inqfAOCoIUVkgzLb
         hFjqhp1TDfT9vKaTKoEzLQLeZk851tOr+3Boqt7Y=
Date:   Thu, 25 Feb 2021 17:21:31 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vjitta@codeaurora.org
Subject:  [patch 096/118] lib: stackdepot: fix ignoring return
 value warning
Message-ID: <20210226012131.hmqwehXgW%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
