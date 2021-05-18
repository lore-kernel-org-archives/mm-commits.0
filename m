Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 732EEC433B4
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 18:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5512561350
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 18:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345312AbhERS0j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 May 2021 14:26:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242486AbhERS0i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 May 2021 14:26:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FFB960FF2;
        Tue, 18 May 2021 18:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621362320;
        bh=fFsSgIh9qxyqQS2IBgzUDlaPyPjdIOWpv6BoOuNDxfk=;
        h=Date:From:To:Subject:From;
        b=0dDar/US1vq8zA+WcbBqDcnCImD/XI6KW0t4iE6zKY76Jtmo2LRpdF+mePzknbvmT
         8KJPULVqlgghN0I+XW7Ru8yjYMCrJ6T31XDwphbgMtG9qJTc6FyA9gQ1M+9oMzxW5V
         M55SjrJ3p/7QSN79qav0tKQn4Bx8vLOcK55+X40Y=
Date:   Tue, 18 May 2021 11:25:20 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?ksm-revert-use-get=5Fksm=5Fpage=5Fnolock-to-get-ksm-page-in-?=
 =?US-ASCII?Q?remove=5Frmap=5Fitem=5Ffrom=5Ftree.patch?= removed from -mm
 tree
Message-ID: <20210518182520.VUhGztqrZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: revert "use GET_KSM_PAGE_NOLOCK to get ksm page in remove_rmap_item_from_tree()"
has been removed from the -mm tree.  Its filename was
     ksm-revert-use-get_ksm_page_nolock-to-get-ksm-page-in-remove_rmap_item_from_tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: ksm: revert "use GET_KSM_PAGE_NOLOCK to get ksm page in remove_rmap_item_from_tree()"

This reverts commit 3e96b6a2e9ad929a3230a22f4d64a74671a0720b.  General
Protection Fault in rmap_walk_ksm() under memory pressure:
remove_rmap_item_from_tree() needs to take page lock, of course.

Link: https://lkml.kernel.org/r/alpine.LSU.2.11.2105092253500.1127@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/ksm.c~ksm-revert-use-get_ksm_page_nolock-to-get-ksm-page-in-remove_rmap_item_from_tree
+++ a/mm/ksm.c
@@ -776,11 +776,12 @@ static void remove_rmap_item_from_tree(s
 		struct page *page;
 
 		stable_node = rmap_item->head;
-		page = get_ksm_page(stable_node, GET_KSM_PAGE_NOLOCK);
+		page = get_ksm_page(stable_node, GET_KSM_PAGE_LOCK);
 		if (!page)
 			goto out;
 
 		hlist_del(&rmap_item->hlist);
+		unlock_page(page);
 		put_page(page);
 
 		if (!hlist_empty(&stable_node->hlist))
_

Patches currently in -mm which might be from hughd@google.com are


