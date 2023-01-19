Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A25A6C678DD
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjASBRt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbjASBPn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:15:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027B7689C6
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 962E461B23
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C75C433EF;
        Thu, 19 Jan 2023 01:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090897;
        bh=/Ux1fADewJqI2GgJwA2yrzO/eJzTEDmN0HD9Ca3w5Os=;
        h=Date:To:From:Subject:From;
        b=L92pQ6+fXjQkFxOAKYR8icloHklFiBOkMCiySvF6ytxUPEPon750EcgcORebZ/I3Y
         9l+GmKLAnNTzvblOYYjSRm05RJQ2ORhktkbB9RlzmKwuVBdXMA9Itvr4Qy6NQRPE6f
         Z0Lx9Lfnz3WXlhhlMstWczxH/1GA0pN5bdySyv+M=
Date:   Wed, 18 Jan 2023 17:14:56 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        vernon2gm@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-remove-extra-return-statement.patch removed from -mm tree
Message-Id: <20230119011457.01C75C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: remove extra return statement
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-extra-return-statement.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vernon Yang <vernon2gm@gmail.com>
Subject: maple_tree: remove extra return statement
Date: Wed, 21 Dec 2022 14:00:53 +0800

For functions with a return type of void, it is unnecessary to
add a reurn statement at the end of the function, so drop it.

Link: https://lkml.kernel.org/r/20221221060058.609003-3-vernon2gm@gmail.com
Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-extra-return-statement
+++ a/lib/maple_tree.c
@@ -1276,7 +1276,6 @@ nomem_one:
 	if (mas->alloc && !(((unsigned long)mas->alloc & 0x1)))
 		mas->alloc->total = success;
 	mas_set_err(mas, -ENOMEM);
-	return;
 }
 
 /*
@@ -4712,8 +4711,6 @@ retry:
 	mas_state_walk(mas);
 	if (mas_is_start(mas))
 		goto retry;
-
-	return;
 }
 
 /*
_

Patches currently in -mm which might be from vernon2gm@gmail.com are

maple_tree-remove-the-parameter-entry-of-mas_preallocate.patch
mm-mmap-fix-typo-in-comment.patch
maple_tree-fix-comment-of-mte_destroy_walk.patch
mm-mmap-fix-comment-of-unmapped_area_topdown.patch

