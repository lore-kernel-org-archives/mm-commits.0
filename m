Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 953A8C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 01:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F23B22285
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 01:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbgLWBCO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 20:02:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:54738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbgLWBCN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 20:02:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C94CE221F7;
        Wed, 23 Dec 2020 01:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608685293;
        bh=Uuv4JcCncY7uNAcQg2t3CtUnGIXd+Cvq/XEu6iDQg8U=;
        h=Date:From:To:Subject:From;
        b=JxTU4vmoQqmR+mD/ESU3r6az9I1hapI4fa1vGm6Hd4U2eHk4KPIdNn3W7uVBVN0Nh
         fZ0FwGlKUqprsr6oZSZ5EEBKqezuf2oUoYokkXa6tqBY2Szoaj5DxArH4nT2M/0l1H
         KoVQibM7UOleziKnLkb7pf1Lc4gqVWnpKozwVdgI=
Date:   Tue, 22 Dec 2020 17:01:32 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, weijie.yang@samsung.com,
        vitaly.wool@konsulko.com, sjennings@variantweb.net,
        sjenning@redhat.com, ddstreet@ieee.org, rdunlap@infradead.org
Subject:  + mm-zswap-clean-up-confusing-comment.patch added to -mm
 tree
Message-ID: <20201223010132.pew1O%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: zswap: clean up confusing comment
has been added to the -mm tree.  Its filename is
     mm-zswap-clean-up-confusing-comment.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-zswap-clean-up-confusing-comment.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-zswap-clean-up-confusing-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from rdunlap@infradead.org are

zlib-move-export_symbol-and-module_license-out-of-dfltcc_symsc.patch
mm-zswap-clean-up-confusing-comment.patch

