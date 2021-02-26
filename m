Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0801CC433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1C5E64F27
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhBZBTF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:19:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:50830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229791AbhBZBSz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:18:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A35364F10;
        Fri, 26 Feb 2021 01:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302295;
        bh=iDV7BnBVMMrnHFyoTPMHuskWrc47E75txaG7wS0TInY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nwD6OUshflTBp4upBAlNP0pg6gGnWKTWp5EuxIk3ntiORs8PtjgIvLg8hzYOOFDlc
         23Wux5kgzvciaM6KMI1LQLIANjt2g+JP7At2MeIoQCDj37YtUjS9jjDWCHRdg3/QEE
         AY7o8ke5NX3kFAA074Obi0X9Mtrf8MNcvg9qkhBI=
Date:   Thu, 25 Feb 2021 17:18:13 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ddstreet@ieee.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        sjenning@redhat.com, sjennings@variantweb.net,
        torvalds@linux-foundation.org, vitaly.wool@konsulko.com,
        weijie.yang@samsung.com
Subject:  [patch 046/118] mm: zswap: clean up confusing comment
Message-ID: <20210226011813.NE7U5GTqD%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm: zswap: clean up confusing comment

Correct wording and change one duplicated word (it) to "it is".

Link: https://lkml.kernel.org/r/20201221042848.13980-1-rdunlap@infradead.org
Fixes: 0ab0abcf5115 ("mm/zswap: refactor the get/put routines")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Weijie Yang <weijie.yang@samsung.com>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/zswap.c~mm-zswap-clean-up-confusing-comment
+++ a/mm/zswap.c
@@ -1022,10 +1022,10 @@ static int zswap_writeback_entry(struct
 
 	/*
 	* if we get here due to ZSWAP_SWAPCACHE_EXIST
-	* a load may happening concurrently
-	* it is safe and okay to not free the entry
+	* a load may be happening concurrently.
+	* it is safe and okay to not free the entry.
 	* if we free the entry in the following put
-	* it it either okay to return !0
+	* it is also okay to return !0
 	*/
 fail:
 	spin_lock(&tree->lock);
_
