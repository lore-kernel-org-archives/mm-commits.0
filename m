Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A5EFA3740
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 18:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235514AbiJ0Sh3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 14:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234875AbiJ0Sh2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 14:37:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3206D92F5C
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 11:37:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C302B62444
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 18:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075F5C433C1;
        Thu, 27 Oct 2022 18:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666895846;
        bh=NLZHsj1aNzz7319GoicNWsfx9hzLWqiiPt0aBWV+tek=;
        h=Date:To:From:Subject:From;
        b=Y7S5Bsu0GgJtL8TSibbVay5vt0ZKejrPb6CwAZYsowMwJ9CucWdjtbqce2qJ93q1c
         7eLMcgNcSl2EKn6Rj6vqXk8252YKJdI/b30+a0QOL83VMMEAagvYR5DhVfdeu3e8zN
         UJIC+SSrtdo7Mpg/8cKOq9YiT+qMBxRO+shdElCQ=
Date:   Thu, 27 Oct 2022 11:37:24 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        Liam.Howlett@oracle.com, lukas.bulwahn@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-maple_tree-remove-unneeded-initialization-in-mtree_range_walk.patch added to mm-hotfixes-unstable branch
Message-Id: <20221027183726.075F5C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: maple_tree: remove unneeded initialization in mtree_range_walk()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-maple_tree-remove-unneeded-initialization-in-mtree_range_walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-maple_tree-remove-unneeded-initialization-in-mtree_range_walk.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: lib: maple_tree: remove unneeded initialization in mtree_range_walk()
Date: Wed, 26 Oct 2022 14:00:29 +0200

Before the do-while loop in mtree_range_walk(), the variables next, min,
max need to be initialized.  The variables last, prev_min and prev_max are
set within the loop body before they are eventually used after exiting the
loop body.

As it is a do-while loop, the loop body is executed at least once, so the
variables last, prev_min and prev_max do not need to be initialized before
the loop body.

Remove unneeded initialization of last and prev_min.

The needless initialization was reported by clang-analyzer as Dead Stores.

As the compiler already identifies these assignments as unneeded, it
optimizes the assignments away.  Hence:

No functional change. No change in object code.

Link: https://lkml.kernel.org/r/20221026120029.12555-2-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/maple_tree.c~lib-maple_tree-remove-unneeded-initialization-in-mtree_range_walk
+++ a/lib/maple_tree.c
@@ -2903,8 +2903,8 @@ static inline void *mtree_range_walk(str
 	unsigned long max, min;
 	unsigned long prev_max, prev_min;
 
-	last = next = mas->node;
-	prev_min = min = mas->min;
+	next = mas->node;
+	min = mas->min;
 	max = mas->max;
 	do {
 		offset = 0;
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

lib-maple_tree-remove-unneeded-initialization-in-mtree_range_walk.patch
mm-shmem-remove-unneeded-assignments-in-shmem_get_folio_gfp.patch

