Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FBEDC4332F
	for <mm-commits@archiver.kernel.org>; Wed, 21 Dec 2022 21:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbiLUVON (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Dec 2022 16:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234901AbiLUVOK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2022 16:14:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C83BC2A
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 13:14:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC6D560C95
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 21:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D700C433EF;
        Wed, 21 Dec 2022 21:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671657244;
        bh=NKuqWriJ/ViMw363ooLFLPJ/4rIdYWcmXtYmyUwTrbo=;
        h=Date:To:From:Subject:From;
        b=oCCifrLC7WFBRw7Gvju/ilpDv2puXAfam+DKzo2rjWwfJCpHEAsEAicVn1ZgFIWaE
         pcN5JW4k9SCv6wlqQ7yI+wsYtBtQiScBEOIxMCkeTaHIo+BxqevAo7LP92CoPMs3ZZ
         zsho4V9MVvn8ceukTULqXIV9e5YjuN95aSP7kGdI=
Date:   Wed, 21 Dec 2022 13:14:03 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        vernon2gm@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-extra-return-statement.patch added to mm-unstable branch
Message-Id: <20221221211404.3D700C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: remove extra return statement
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-remove-extra-return-statement.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-extra-return-statement.patch

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

maple_tree-remove-extra-space-and-blank-line.patch
maple_tree-remove-extra-return-statement.patch
maple_tree-use-mt_node_max-instead-of-direct-operations-mt_max.patch
maple_tree-use-macro-ma_root_parent-instead-of-number.patch
maple_tree-remove-the-redundant-code.patch
maple_tree-refine-ma_state-init-from-mas_start.patch
maple_tree-refine-mab_calc_split-function.patch

