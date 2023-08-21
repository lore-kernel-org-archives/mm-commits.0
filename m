Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5061AEE49A6
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbjHUUmG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjHUUlD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:41:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18D6180
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2B85614EC
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DEAC433C7;
        Mon, 21 Aug 2023 20:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650442;
        bh=KTEaLsidK8C8+nlwmLaMY3aMf1NPoJbeeLsHcjaymzo=;
        h=Date:To:From:Subject:From;
        b=XHRG1DLu6uqHuXO8R3Ra8SrYis+6nZ2/nPkSXLU78n4UhjkTCl9XOAmMOxElWevpK
         og4Fh83QJuFpTO4dhRhUD08uyNmbObQmByssyjLjCZ4oSB9WdVFS1OGdHTzOacM8YA
         F8TY4uarE/6okSkvElxhO/6sh2Fh/MH+m1q62olU=
Date:   Mon, 21 Aug 2023 13:40:41 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-use-helper-macro-llist_for_each_entry_safe.patch removed from -mm tree
Message-Id: <20230821204042.14DEAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: use helper macro llist_for_each_entry_safe()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-use-helper-macro-llist_for_each_entry_safe.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memory-failure: use helper macro llist_for_each_entry_safe()
Date: Mon, 7 Aug 2023 19:41:25 +0800

It's more convenient to use helper macro llist_for_each_entry_safe().
No functional change intended.

Link: https://lkml.kernel.org/r/20230807114125.3440802-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-use-helper-macro-llist_for_each_entry_safe
+++ a/mm/memory-failure.c
@@ -1868,13 +1868,12 @@ bool is_raw_hwpoison_page_in_hugepage(st
 
 static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
 {
-	struct llist_node *t, *tnode, *head;
+	struct llist_node *head;
+	struct raw_hwp_page *p, *next;
 	unsigned long count = 0;
 
 	head = llist_del_all(raw_hwp_list_head(folio));
-	llist_for_each_safe(tnode, t, head) {
-		struct raw_hwp_page *p = container_of(tnode, struct raw_hwp_page, node);
-
+	llist_for_each_entry_safe(p, next, head, node) {
 		if (move_flag)
 			SetPageHWPoison(p->page);
 		else
@@ -1889,7 +1888,7 @@ static int folio_set_hugetlb_hwpoison(st
 {
 	struct llist_head *head;
 	struct raw_hwp_page *raw_hwp;
-	struct llist_node *t, *tnode;
+	struct raw_hwp_page *p, *next;
 	int ret = folio_test_set_hwpoison(folio) ? -EHWPOISON : 0;
 
 	/*
@@ -1900,9 +1899,7 @@ static int folio_set_hugetlb_hwpoison(st
 	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
 		return -EHWPOISON;
 	head = raw_hwp_list_head(folio);
-	llist_for_each_safe(tnode, t, head->first) {
-		struct raw_hwp_page *p = container_of(tnode, struct raw_hwp_page, node);
-
+	llist_for_each_entry_safe(p, next, head->first, node) {
 		if (p->page == page)
 			return -EHWPOISON;
 	}
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-add-pageoffline-check.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch

