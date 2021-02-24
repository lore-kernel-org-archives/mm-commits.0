Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E0B7C4332B
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 649A764E09
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234908AbhBXUKy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:10:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235375AbhBXUKA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:10:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B673064F29;
        Wed, 24 Feb 2021 20:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197360;
        bh=mGAFGdaR52V6BaIhJsDW3FXyc08uLOqLChpprmUAP84=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PDQlptvDZAWHJbqr0flF2JsUFimYkU5hChqe9n+VHD+xYp3YtgAIgUAxZNgIJcLQ4
         HooujY02gKUTNCgu5FXp/AgtS0fG002BK/FlKDKLYWBHqQYdrZivTOevKxaMJP3lEb
         SZMPJ0KpqxzjEgOkg+/0kgqPYsQpiPXdwWe9328Q=
Date:   Wed, 24 Feb 2021 12:09:19 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vitaly.wool@konsulko.com
Subject:  [patch 153/173] z3fold: remove unused attribute for
 release_z3fold_page
Message-ID: <20210224200919.5JDaZHvvd%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: z3fold: remove unused attribute for release_z3fold_page

Since commit dcf5aedb24f8 ("z3fold: stricter locking and more careful
reclaim"), release_z3fold_page() is used again.  So we can drop the unused
attribute safely.

Link: https://lkml.kernel.org/r/20210120084008.58432-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/z3fold.c~z3fold-remove-unused-attribute-for-release_z3fold_page
+++ a/mm/z3fold.c
@@ -541,8 +541,7 @@ static void __release_z3fold_page(struct
 	spin_unlock(&pool->stale_lock);
 }
 
-static void __attribute__((__unused__))
-			release_z3fold_page(struct kref *ref)
+static void release_z3fold_page(struct kref *ref)
 {
 	struct z3fold_header *zhdr = container_of(ref, struct z3fold_header,
 						refcount);
_
