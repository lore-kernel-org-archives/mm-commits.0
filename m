Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF9BC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 19:58:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C52E8610C7
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 19:58:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhJRUAo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Oct 2021 16:00:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231971AbhJRUAm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 Oct 2021 16:00:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB49B61038;
        Mon, 18 Oct 2021 19:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634587110;
        bh=mppQ+s50PDz4PBgTuAK7Ofm25Onppvdj26Clc+ZEi6M=;
        h=Date:From:To:Subject:From;
        b=rVlVhM1BcRQx9fSuAsKJ+XsXKRpVzsaQQkyzXURUT3Vl6vpG8gn9FAireXFfjXjBY
         2BSBKxO3TihYof/5Pi43nBxHvV0WJ+cvsBqDSlIlhqdmDcvDi2bQRC5JMbQE4Xa5T8
         qqui31lx5YoC/viFleggIxEqnXcx1Mw9NPKXLzOE=
Date:   Mon, 18 Oct 2021 12:58:30 -0700
From:   akpm@linux-foundation.org
To:     jiasheng@iscas.ac.cn, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  + xarray-fix-xa_to_node-by-adding-xa_is_node.patch added
 to -mm tree
Message-ID: <20211018195830.FrL-KFZEo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: XArray: fix xa_to_node by adding xa_is_node
has been added to the -mm tree.  Its filename is
     xarray-fix-xa_to_node-by-adding-xa_is_node.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/xarray-fix-xa_to_node-by-adding-xa_is_node.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/xarray-fix-xa_to_node-by-adding-xa_is_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

xarray-fix-xa_to_node-by-adding-xa_is_node.patch

