Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E349C433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B37B613DD
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbhEEBdx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:33:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231705AbhEEBdx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:33:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E2E1613CB;
        Wed,  5 May 2021 01:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178377;
        bh=YQKncc8zJ+FulTs1lYRorDaeRAH2+rQNmJWjJHTiYDY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LQualH9ZPLEwuHbaa/nqg7mNhHkWtlMnhacfGNXDb0nFHMxRuR1c6MgYoo/CK36/c
         rqztIo+beyL3J094P5AUdB/wdBaNIBxWxnkAfEIaqkrf4PNoHCvseWtSkQetdQQQgO
         hC9EkyNE7vNrV6nPBbnevmoVkxErD5aFYk3ClS2w=
Date:   Tue, 04 May 2021 18:32:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 005/143] mm: remove nrexceptional from inode:
 remove BUG_ON
Message-ID: <20210505013257.HZsCu951B%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hugh Dickins <hughd@google.com>
Subject: mm: remove nrexceptional from inode: remove BUG_ON

clear_inode()'s BUG_ON(!mapping_empty(&inode->i_data)) is unsafe: we know
of two ways in which nodes can and do (on rare occasions) get left behind.
Until those are fixed, do not BUG_ON() nor even WARN_ON().  Yes, this
will then leak those nodes (or the next user of the struct inode may use
them); but this has been happening for years, and the new
BUG_ON(!mapping_empty) was only guilty of revealing that.  A proper fix
will follow, but no hurry.

Link: https://lkml.kernel.org/r/alpine.LSU.2.11.2104292229380.16080@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/inode.c~mm-remove-nrexceptional-from-inode-remove-bug_on
+++ a/fs/inode.c
@@ -529,7 +529,14 @@ void clear_inode(struct inode *inode)
 	 */
 	xa_lock_irq(&inode->i_data.i_pages);
 	BUG_ON(inode->i_data.nrpages);
-	BUG_ON(!mapping_empty(&inode->i_data));
+	/*
+	 * Almost always, mapping_empty(&inode->i_data) here; but there are
+	 * two known and long-standing ways in which nodes may get left behind
+	 * (when deep radix-tree node allocation failed partway; or when THP
+	 * collapse_file() failed). Until those two known cases are cleaned up,
+	 * or a cleanup function is called here, do not BUG_ON(!mapping_empty),
+	 * nor even WARN_ON(!mapping_empty).
+	 */
 	xa_unlock_irq(&inode->i_data.i_pages);
 	BUG_ON(!list_empty(&inode->i_data.private_list));
 	BUG_ON(!(inode->i_state & I_FREEING));
_
