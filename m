Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4586C433E0
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79B8C64F21
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhB0CdV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:33:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:52962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230090AbhB0Ccl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:32:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A3C364F2D;
        Sat, 27 Feb 2021 02:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393128;
        bh=vsDIpp2MkFewfr+2XsUiaJ/CLhcDRpnpmP+dzTP3LB4=;
        h=Date:From:To:Subject:From;
        b=LFfh0D7/iWhd2xnLOoa3SdWFLvf9aoC8aVXBCOMB/PZGyCaFNlUF+SfYHwpZpYD3a
         pG17qV2D80sSZHk3P3zHVrbqvb5H2jmD106oDXrE4PtPm4jiPaaNKnHocwWEGSoGvN
         KtArerPGydYgBIlN/MQdaI6VvfD9SeomZjWnyOXk=
Date:   Fri, 26 Feb 2021 18:32:08 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vjitta@codeaurora.org
Subject:  [merged]
 lib-stackdepot-add-support-to-disable-stack-depot-fix-2.patch removed from
 -mm tree
Message-ID: <20210227023208.8B5ho-6HN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: stackdepot: fix ignoring return value warning
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-add-support-to-disable-stack-depot-fix-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


