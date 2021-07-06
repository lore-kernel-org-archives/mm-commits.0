Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C3CC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E63B61C7F
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhGFTVU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:21:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231740AbhGFTVU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:21:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CE5861C7F;
        Tue,  6 Jul 2021 19:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599120;
        bh=jjP/EC5k3nSINnDMy8fzJ9+ZpMEm5IRtQsE0DYTr5h8=;
        h=Date:From:To:Subject:From;
        b=JmyHkuzLjTTAHPkfUujmQv0YXjXB7i8oojvnYi1XrGOWjvlermenaxju+v3sZSGUo
         LNRUUZs6Y7/tocAxN7HUjKR/+JoPbRi6JUuM9sWPbtWu75MR7Bjj3gsk+K+M+09JmU
         LxbsvMdORkKmYv4x7GwoX7Evb3c5Ok+rRvk3QvXQ=
Date:   Tue, 06 Jul 2021 12:18:40 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        vitaly.wool@konsulko.com
Subject:  [merged]
 mm-z3fold-remove-unused-function-handle_to_z3fold_header.patch removed from
 -mm tree
Message-ID: <20210706191840.TD2ZL5N8H%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold: remove unused function handle_to_z3fold_header()
has been removed from the -mm tree.  Its filename was
     mm-z3fold-remove-unused-function-handle_to_z3fold_header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

