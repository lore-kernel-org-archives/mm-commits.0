Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 946FCC10F1B
	for <mm-commits@archiver.kernel.org>; Wed, 21 Dec 2022 21:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234872AbiLUVOY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Dec 2022 16:14:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234930AbiLUVOM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2022 16:14:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B931E3F4
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 13:14:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDAE861956
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 21:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230D9C433D2;
        Wed, 21 Dec 2022 21:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671657248;
        bh=h07JS9m1ROXiIQHI7OzNF6p8MG84v+a5dbxNotIlcnE=;
        h=Date:To:From:Subject:From;
        b=0UZnQc6uHI6go/GtV9Y3WbnRae+HGH8QAX+blReGl7GZMzfUURlK7768SokdvBUcu
         tztC5XjOraF19H6uPV8ldJdNEbS5Vu1whizrc7bZKhO6CNLuKEqVl7CKXFieEnyOiK
         ZyHdtmlZc1b7VEP4eXtvSeOlQAgIcCGH4D20w+Jw=
Date:   Wed, 21 Dec 2022 13:14:07 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        vernon2gm@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-use-macro-ma_root_parent-instead-of-number.patch added to mm-unstable branch
Message-Id: <20221221211408.230D9C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: use macro MA_ROOT_PARENT instead of number
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-use-macro-ma_root_parent-instead-of-number.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-use-macro-ma_root_parent-instead-of-number.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Vernon Yang <vernon2gm@gmail.com>
Subject: maple_tree: use macro MA_ROOT_PARENT instead of number
Date: Wed, 21 Dec 2022 14:00:55 +0800

When you need to compare whether node->parent is parent of the
root node, using macro MA_ROOT_PARENT is easier to understand
and for better readability.

Link: https://lkml.kernel.org/r/20221221060058.609003-5-vernon2gm@gmail.com
Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-use-macro-ma_root_parent-instead-of-number
+++ a/lib/maple_tree.c
@@ -503,8 +503,7 @@ static inline unsigned int mte_parent_sl
 {
 	unsigned long val = (unsigned long)mte_to_node(enode)->parent;
 
-	/* Root. */
-	if (val & 1)
+	if (val & MA_ROOT_PARENT)
 		return 0;
 
 	/*
_

Patches currently in -mm which might be from vernon2gm@gmail.com are

maple_tree-remove-extra-space-and-blank-line.patch
maple_tree-remove-extra-return-statement.patch
maple_tree-use-mt_node_max-instead-of-direct-operations-mt_max.patch
maple_tree-use-macro-ma_root_parent-instead-of-number.patch
maple_tree-remove-the-redundant-code.patch
maple_tree-refine-ma_state-init-from-mas_start.patch
maple_tree-refine-mab_calc_split-function.patch

