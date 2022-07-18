Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D00FCCA481
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbiGRAcj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232644AbiGRAcg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:32:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A851E13D5D
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF57D60FAF
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF92C3411E;
        Mon, 18 Jul 2022 00:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104350;
        bh=bFr9HVLutcxNdS2G7tgRgXXeqwzgHH4a16tPwLirb10=;
        h=Date:To:From:Subject:From;
        b=xq/90pgM91onE3QY+tkgBHhwwkxYH5YgZlNH2TPIY7trzEszj7LVJCZL0EXyOFi3I
         zpmCJi0QsRrE2hJ6dQWUFAw/3vF+MHRrSPXCynVI5fynKQ6rIkf13aSg3KC6AUGkWc
         DzxXswtfRBh16qPegblv1/u7W597MWEuSCtaxL00=
Date:   Sun, 17 Jul 2022 17:32:29 -0700
To:     mm-commits@vger.kernel.org, colin.i.king@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-ts_bmc-remove-redundant-store-to-variable-consumed-after-addition.patch removed from -mm tree
Message-Id: <20220718003230.4AF92C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/ts_bm.c: remove redundant store to variable consumed after addition
has been removed from the -mm tree.  Its filename was
     lib-ts_bmc-remove-redundant-store-to-variable-consumed-after-addition.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: lib/ts_bm.c: remove redundant store to variable consumed after addition
Date: Mon, 4 Jul 2022 22:53:25 +0100

There is no need to store the result of the addition back to variable
consumed after the addition.  The store is redundant, replace += with just
+

Cleans up clang scan build warning: lib/ts_bm.c:83:11: warning: Although
the value stored to 'consumed' is used in the enclosing expression, the
value is never actually read from 'consumed' [deadcode.DeadStores]

Link: https://lkml.kernel.org/r/20220704215325.600993-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ts_bm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/ts_bm.c~lib-ts_bmc-remove-redundant-store-to-variable-consumed-after-addition
+++ a/lib/ts_bm.c
@@ -80,7 +80,7 @@ static unsigned int bm_find(struct ts_co
 
 			/* London calling... */
 			DEBUGP("found!\n");
-			return consumed += (shift-(bm->patlen-1));
+			return consumed + (shift-(bm->patlen-1));
 
 next:			bs = bm->bad_shift[text[shift-i]];
 
_

Patches currently in -mm which might be from colin.i.king@gmail.com are


