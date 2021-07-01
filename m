Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE9FC11F69
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 833D261469
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238449AbhGABxF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:53:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238443AbhGABxE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:53:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F23B86105A;
        Thu,  1 Jul 2021 01:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104234;
        bh=J4cFi94OqIwcIG1fLpadUmpda5w2L840R4tDI0HI/z4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=K16hYQdLNhx72fLwE0EOAjGQxV83DZDpQASaLVA8aY0mFC4dq4MK4A0tg5MDWW6Sy
         Nz3o9V+DaLqrsZe5QLtERqQVBkn1gJUSlb3CT0Z6/DFelPY2vg8fRSdu8iO+rSxvRO
         usw348gLwyqCUAXjBxg82YR0fqE6KAgwvbh0BWwI=
Date:   Wed, 30 Jun 2021 18:50:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hdanton@sina.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vitaly.wool@konsulko.com
Subject:  [patch 063/192] mm/z3fold: remove unused function
 handle_to_z3fold_header()
Message-ID: <20210701015033.bZHcaN-yR%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/z3fold: remove unused function handle_to_z3fold_header()

handle_to_z3fold_header() is unused now.  So we can remove it.  As a
result, get_z3fold_header() becomes the only caller of
__get_z3fold_header() and the argument lock is always true.  Therefore we
could further fold the __get_z3fold_header() into get_z3fold_header() with
lock = true.

Link: https://lkml.kernel.org/r/20210619093151.1492174-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-remove-unused-function-handle_to_z3fold_header
+++ a/mm/z3fold.c
@@ -253,9 +253,8 @@ static inline void z3fold_page_unlock(st
 	spin_unlock(&zhdr->page_lock);
 }
 
-
-static inline struct z3fold_header *__get_z3fold_header(unsigned long handle,
-							bool lock)
+/* return locked z3fold page if it's not headless */
+static inline struct z3fold_header *get_z3fold_header(unsigned long handle)
 {
 	struct z3fold_buddy_slots *slots;
 	struct z3fold_header *zhdr;
@@ -269,13 +268,12 @@ static inline struct z3fold_header *__ge
 			read_lock(&slots->lock);
 			addr = *(unsigned long *)handle;
 			zhdr = (struct z3fold_header *)(addr & PAGE_MASK);
-			if (lock)
-				locked = z3fold_page_trylock(zhdr);
+			locked = z3fold_page_trylock(zhdr);
 			read_unlock(&slots->lock);
 			if (locked)
 				break;
 			cpu_relax();
-		} while (lock);
+		} while (true);
 	} else {
 		zhdr = (struct z3fold_header *)(handle & PAGE_MASK);
 	}
@@ -283,18 +281,6 @@ static inline struct z3fold_header *__ge
 	return zhdr;
 }
 
-/* Returns the z3fold page where a given handle is stored */
-static inline struct z3fold_header *handle_to_z3fold_header(unsigned long h)
-{
-	return __get_z3fold_header(h, false);
-}
-
-/* return locked z3fold page if it's not headless */
-static inline struct z3fold_header *get_z3fold_header(unsigned long h)
-{
-	return __get_z3fold_header(h, true);
-}
-
 static inline void put_z3fold_header(struct z3fold_header *zhdr)
 {
 	struct page *page = virt_to_page(zhdr);
_
