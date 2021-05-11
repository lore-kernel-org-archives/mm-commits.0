Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58657C433ED
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 00:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B7DA6143B
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 00:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhEKANL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 20:13:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229628AbhEKANL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 20:13:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95D14611BE;
        Tue, 11 May 2021 00:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620691925;
        bh=mX3+yMOULmuj5WW8rwg7GndSrvOGulZcS+J+i46ytDc=;
        h=Date:From:To:Subject:From;
        b=FBdZIC6iyE5e1rhmGlc+AXwsydfMlSJE/QbR7tJq50VGRaMiUtVhsMXkQIIoJMuLQ
         j3rYfFC/HGRNSv8TuHlX482gGvh0daVcDxlprZ+gS+oV8xziwG1xsrMh5g6MTKdlZL
         IFEqYE8oC05f//hqIAe8QLOciOSR7SpViLzk/aks=
Date:   Mon, 10 May 2021 17:12:04 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?ksm-revert-use-get=5Fksm=5Fpage=5Fnolock-to-get-ksm-page-in-?=
 =?US-ASCII?Q?remove=5Frmap=5Fitem=5Ffrom=5Ftree.patch?= added to -mm tree
Message-ID: <20210511001204.XE0o7Drwk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: revert "use GET_KSM_PAGE_NOLOCK to get ksm page in remove_rmap_item_from_tree()"
has been added to the -mm tree.  Its filename is
     ksm-revert-use-get_ksm_page_nolock-to-get-ksm-page-in-remove_rmap_item_from_tree.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ksm-revert-use-get_ksm_page_nolock-to-get-ksm-page-in-remove_rmap_item_from_tree.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ksm-revert-use-get_ksm_page_nolock-to-get-ksm-page-in-remove_rmap_item_from_tree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ksm-revert-use-get_ksm_page_nolock-to-get-ksm-page-in-remove_rmap_item_from_tree.patch

