Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC667C43461
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF3AD61423
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbhEEBjb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:39:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231440AbhEEBjb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:39:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A556961421;
        Wed,  5 May 2021 01:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178715;
        bh=L4/Ngs6pT20pHztlKJIs23d9hcmDGIOqz1PeGMRSAxk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PBh6W8Rrphqf3nHG4xwlmjEb1RuZtAPPpFr1BwInSM2QyG34JFWyhamu+6lIX4Yun
         uJT+56UrtvmB4tqmdkdc5D52ozi4U/IpGEQI/OgPbSEllJJWiq9j1qw4SwaQUob3E6
         rt7KHsY/0a+pteV9Jkz/mSQyZ47IiebUhCbSxr8g=
Date:   Tue, 04 May 2021 18:38:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, unixbhaskar@gmail.com,
        willy@infradead.org
Subject:  [patch 109/143] mm/util.c: fix typo
Message-ID: <20210505013835.TNp7GMyVf%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: mm/util.c: fix typo

s/condtion/condition/

Link: https://lkml.kernel.org/r/20210317033439.3429411-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/util.c~mm-typo-fix-in-the-file-utilc
+++ a/mm/util.c
@@ -765,7 +765,7 @@ int overcommit_policy_handler(struct ctl
 	 * The deviation of sync_overcommit_as could be big with loose policy
 	 * like OVERCOMMIT_ALWAYS/OVERCOMMIT_GUESS. When changing policy to
 	 * strict OVERCOMMIT_NEVER, we need to reduce the deviation to comply
-	 * with the strict "NEVER", and to avoid possible race condtion (even
+	 * with the strict "NEVER", and to avoid possible race condition (even
 	 * though user usually won't too frequently do the switching to policy
 	 * OVERCOMMIT_NEVER), the switch is done in the following order:
 	 *	1. changing the batch
_
