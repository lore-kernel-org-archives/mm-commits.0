Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C9DBEE49A6
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:40:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbjHUUk7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbjHUUk1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFE9C7
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4260C649CB
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF41C433C8;
        Mon, 21 Aug 2023 20:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650396;
        bh=ozJY5eE1i2j5gRnNIW03ljO2VtAo0BktrAEGQFWDAIY=;
        h=Date:To:From:Subject:From;
        b=ljDoeNblC5Xt5mXpXwQzL1Jq1vWuwLtYIR9MJ4ofs0hw/0gd1PICUQCmYzZpHDIn2
         0X52aOol7MwPL21HHZxJWPaav2Q4kinn0ocsg2Si461/kmYfzP99PWNAm/eWlOJX5s
         dqxv2/kp7ROsiEGXyLojj8rKgtdk63zyFXYCjp9o=
Date:   Mon, 21 Aug 2023 13:39:56 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, ruanjinjie@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-z3fold-use-helper-function-put_z3fold_locked-and-put_z3fold_locked_list.patch removed from -mm tree
Message-Id: <20230821203956.9BF41C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/z3fold: use helper function put_z3fold_locked() and put_z3fold_locked_list()
has been removed from the -mm tree.  Its filename was
     mm-z3fold-use-helper-function-put_z3fold_locked-and-put_z3fold_locked_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ruan Jinjie <ruanjinjie@huawei.com>
Subject: mm/z3fold: use helper function put_z3fold_locked() and put_z3fold_locked_list()
Date: Thu, 3 Aug 2023 19:38:23 +0800

This code is already duplicated six times, use helper function
put_z3fold_locked() to release z3fold page instead of open code it to help
improve code readability a bit.  And add put_z3fold_locked_list() helper
function to be consistent with it.  No functional change involved.

Link: https://lkml.kernel.org/r/20230803113824.886413-1-ruanjinjie@huawei.com
Signed-off-by: Ruan Jinjie <ruanjinjie@huawei.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-use-helper-function-put_z3fold_locked-and-put_z3fold_locked_list
+++ a/mm/z3fold.c
@@ -480,6 +480,16 @@ static void release_z3fold_page_locked_l
 	__release_z3fold_page(zhdr, true);
 }
 
+static inline int put_z3fold_locked(struct z3fold_header *zhdr)
+{
+	return kref_put(&zhdr->refcount, release_z3fold_page_locked);
+}
+
+static inline int put_z3fold_locked_list(struct z3fold_header *zhdr)
+{
+	return kref_put(&zhdr->refcount, release_z3fold_page_locked_list);
+}
+
 static void free_pages_work(struct work_struct *w)
 {
 	struct z3fold_pool *pool = container_of(w, struct z3fold_pool, work);
@@ -666,7 +676,7 @@ static struct z3fold_header *compact_sin
 	return new_zhdr;
 
 out_fail:
-	if (new_zhdr && !kref_put(&new_zhdr->refcount, release_z3fold_page_locked)) {
+	if (new_zhdr && !put_z3fold_locked(new_zhdr)) {
 		add_to_unbuddied(pool, new_zhdr);
 		z3fold_page_unlock(new_zhdr);
 	}
@@ -741,7 +751,7 @@ static void do_compact_page(struct z3fol
 	list_del_init(&zhdr->buddy);
 	spin_unlock(&pool->lock);
 
-	if (kref_put(&zhdr->refcount, release_z3fold_page_locked))
+	if (put_z3fold_locked(zhdr))
 		return;
 
 	if (test_bit(PAGE_STALE, &page->private) ||
@@ -752,7 +762,7 @@ static void do_compact_page(struct z3fol
 
 	if (!zhdr->foreign_handles && buddy_single(zhdr) &&
 	    zhdr->mapped_count == 0 && compact_single_buddy(zhdr)) {
-		if (!kref_put(&zhdr->refcount, release_z3fold_page_locked)) {
+		if (!put_z3fold_locked(zhdr)) {
 			clear_bit(PAGE_CLAIMED, &page->private);
 			z3fold_page_unlock(zhdr);
 		}
@@ -878,7 +888,7 @@ lookup:
 	return zhdr;
 
 out_fail:
-	if (!kref_put(&zhdr->refcount, release_z3fold_page_locked)) {
+	if (!put_z3fold_locked(zhdr)) {
 		add_to_unbuddied(pool, zhdr);
 		z3fold_page_unlock(zhdr);
 	}
@@ -1012,8 +1022,7 @@ retry:
 		if (zhdr) {
 			bud = get_free_buddy(zhdr, chunks);
 			if (bud == HEADLESS) {
-				if (!kref_put(&zhdr->refcount,
-					     release_z3fold_page_locked))
+				if (!put_z3fold_locked(zhdr))
 					z3fold_page_unlock(zhdr);
 				pr_err("No free chunks in unbuddied\n");
 				WARN_ON(1);
@@ -1129,7 +1138,7 @@ static void z3fold_free(struct z3fold_po
 
 	if (!page_claimed)
 		free_handle(handle, zhdr);
-	if (kref_put(&zhdr->refcount, release_z3fold_page_locked_list))
+	if (put_z3fold_locked_list(zhdr))
 		return;
 	if (page_claimed) {
 		/* the page has not been claimed by us */
@@ -1346,7 +1355,7 @@ static void z3fold_page_putback(struct p
 	if (!list_empty(&zhdr->buddy))
 		list_del_init(&zhdr->buddy);
 	INIT_LIST_HEAD(&page->lru);
-	if (kref_put(&zhdr->refcount, release_z3fold_page_locked))
+	if (put_z3fold_locked(zhdr))
 		return;
 	if (list_empty(&zhdr->buddy))
 		add_to_unbuddied(pool, zhdr);
_

Patches currently in -mm which might be from ruanjinjie@huawei.com are


