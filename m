Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FFE3C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 20:09:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5549361206
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 20:09:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhJRUMH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Oct 2021 16:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231246AbhJRUMG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 Oct 2021 16:12:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B384611EF;
        Mon, 18 Oct 2021 20:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634587795;
        bh=WCSi9dS/JwbxS2a/7pyq5s1pfK4YHyGWQJ80XLoMNfg=;
        h=Date:From:To:Subject:From;
        b=fR9ANd5NHTFUx3Rrd1E9IGKXaUlYSA/baylwNoa2VRJ1KWbQtDF+kPUp9B30Bh4G2
         xsnynrIQDwR0+mXleppJ/IPgX6PRoGYAwFSbtihsJwgkwmBljAkZHR1fmuFSQU5J3O
         1Y/dAKOPeRHl8tp6kL7JeRtUtvGZ89AmZgAg3E2o=
Date:   Mon, 18 Oct 2021 13:09:54 -0700
From:   akpm@linux-foundation.org
To:     jiasheng@iscas.ac.cn, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [nacked] xarray-fix-xa_to_node-by-adding-xa_is_node.patch
 removed from -mm tree
Message-ID: <20211018200954.IGhCIWg0o%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: XArray: fix xa_to_node by adding xa_is_node
has been removed from the -mm tree.  Its filename was
     xarray-fix-xa_to_node-by-adding-xa_is_node.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: XArray: fix xa_to_node by adding xa_is_node

Directly using xa_to_node may lead to the compulsory type conversion of
unknown type,which is unsafe.  So it might be better that adding
xa_is_node before.

Link: https://lkml.kernel.org/r/1634028170-1753612-1-git-send-email-jiasheng@iscas.ac.cn
Fixes: 58d6ea3 ("xarray: Add XArray unconditional store operations")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_xarray.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/lib/test_xarray.c~xarray-fix-xa_to_node-by-adding-xa_is_node
+++ a/lib/test_xarray.c
@@ -606,8 +606,10 @@ static noinline void check_multi_store(s
 	XA_BUG_ON(xa, xa_load(xa, 1) != xa_mk_value(0));
 	XA_BUG_ON(xa, xa_load(xa, 2) != NULL);
 	rcu_read_lock();
-	XA_BUG_ON(xa, xa_to_node(xa_head(xa))->count != 2);
-	XA_BUG_ON(xa, xa_to_node(xa_head(xa))->nr_values != 2);
+	if (xa_is_node(xa_head(xa))) {
+		XA_BUG_ON(xa, xa_to_node(xa_head(xa))->count != 2);
+		XA_BUG_ON(xa, xa_to_node(xa_head(xa))->nr_values != 2);
+	}
 	rcu_read_unlock();
 
 	/* Storing adjacent to the value does not alter the value */
_

Patches currently in -mm which might be from jiasheng@iscas.ac.cn are


