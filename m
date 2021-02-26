Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54589C433E6
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1261064F30
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbhBZBWf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:22:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:52400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhBZBVc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:21:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAAF264F33;
        Fri, 26 Feb 2021 01:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302468;
        bh=3AWE9fS2XGydhtf8F1l9OjR3mK9r6cTvv+qO/yeMJLI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=thV6qlKvJcy5r0GlJZsE6dMmh5aOv9JRqDglxe2EOCmxtMEyJlC6WZNfGLD58w/PW
         RaKovFKFPYsA8aHQAdNpzLqfwHkynzwjcH2alKP10CcaKDpLEx43RevdXXdpYBui5j
         qrG4pP7+P2IfN8bnNVAhWTGNuciF4W2xFqsqNMrY=
Date:   Thu, 25 Feb 2021 17:21:07 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hubert.jasudowicz@gmail.com,
        linux-mm@kvack.org, mikelley@microsoft.com,
        mm-commits@vger.kernel.org, mortonm@chromium.org,
        peterz@infradead.org, thomascedeno@google.com,
        torvalds@linux-foundation.org, xiang@kernel.org
Subject:  [patch 089/118] groups: simplify struct group_info
 allocation
Message-ID: <20210226012107.i2xRgetEx%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hubert Jasudowicz <hubert.jasudowicz@gmail.com>
Subject: groups: simplify struct group_info allocation

Combine kmalloc and vmalloc into a single call.  Use struct_size macro
instead of direct size calculation.

Link: https://lkml.kernel.org/r/ba9ba5beea9a44b7196c41a0d9528abd5f20dd2e.1611620846.git.hubert.jasudowicz@gmail.com
Signed-off-by: Hubert Jasudowicz <hubert.jasudowicz@gmail.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Micah Morton <mortonm@chromium.org>
Cc: Michael Kelley <mikelley@microsoft.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Thomas Cedeno <thomascedeno@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/groups.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/kernel/groups.c~groups-simplify-struct-group_info-allocation
+++ a/kernel/groups.c
@@ -15,12 +15,7 @@
 struct group_info *groups_alloc(int gidsetsize)
 {
 	struct group_info *gi;
-	unsigned int len;
-
-	len = sizeof(struct group_info) + sizeof(kgid_t) * gidsetsize;
-	gi = kmalloc(len, GFP_KERNEL_ACCOUNT|__GFP_NOWARN|__GFP_NORETRY);
-	if (!gi)
-		gi = __vmalloc(len, GFP_KERNEL_ACCOUNT);
+	gi = kvmalloc(struct_size(gi, gid, gidsetsize), GFP_KERNEL_ACCOUNT);
 	if (!gi)
 		return NULL;
 
_
