Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 877E7C5479D
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 21:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbjAKVaq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 16:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235480AbjAKVao (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 16:30:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A00180
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 13:30:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4ACB4B81D70
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 21:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BD7C433EF;
        Wed, 11 Jan 2023 21:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673472639;
        bh=O3I0IfaSIlGqCi9oGvoKOJgSlk0eAAHOaIMKfE3W0sY=;
        h=Date:To:From:Subject:From;
        b=GPcLhGGlCPe/c0YUukbrV8RqaEp8OhHU/NxGUksmb5i5LD3xNm3Vv5jHXr+f2tw+8
         FV9HuApw+p2of1it8dUUN7bnEewKrw4FMiu0cSz8Vla8DX1NnxWLZSYgzzfhfo1MKT
         h7rGDUbk136wcgk/VYoGSRB4eUUapNo0tjx2HxnQ=
Date:   Wed, 11 Jan 2023 13:30:39 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        Liam.Howlett@oracle.com, vernon2gm@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-fix-comment-of-unmapped_area_topdown.patch added to mm-unstable branch
Message-Id: <20230111213039.D6BD7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: fix comment of unmapped_area{_topdown}
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-fix-comment-of-unmapped_area_topdown.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-fix-comment-of-unmapped_area_topdown.patch

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
Subject: mm/mmap: fix comment of unmapped_area{_topdown}
Date: Wed, 11 Jan 2023 21:20:36 +0800

The low_limit of unmapped area information is inclusive, and the
hight_limit is not, so make symbol to be [ instead of (.

And replace hight_limit to high_limit.

Link: https://lkml.kernel.org/r/20230111132036.801404-1-vernon2gm@gmail.com
Fixes: 3499a13168da ("mm/mmap: use maple tree for unmapped_area{_topdown}")
Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/mmap.c~mm-mmap-fix-comment-of-unmapped_area_topdown
+++ a/mm/mmap.c
@@ -1558,8 +1558,8 @@ static inline int accountable_mapping(st
  * the correct alignment and offset, all from @info. Note: current->mm is used
  * for the search.
  *
- * @info: The unmapped area information including the range (low_limit -
- * hight_limit), the alignment offset and mask.
+ * @info: The unmapped area information including the range [low_limit -
+ * high_limit), the alignment offset and mask.
  *
  * Return: A memory address or -ENOMEM.
  */
@@ -1585,11 +1585,11 @@ static unsigned long unmapped_area(struc
 
 /**
  * unmapped_area_topdown() - Find an area between the low_limit and the
- * high_limit with * the correct alignment and offset at the highest available
+ * high_limit with the correct alignment and offset at the highest available
  * address, all from @info. Note: current->mm is used for the search.
  *
- * @info: The unmapped area information including the range (low_limit -
- * hight_limit), the alignment offset and mask.
+ * @info: The unmapped area information including the range [low_limit -
+ * high_limit), the alignment offset and mask.
  *
  * Return: A memory address or -ENOMEM.
  */
_

Patches currently in -mm which might be from vernon2gm@gmail.com are

maple_tree-remove-extra-space-and-blank-line.patch
maple_tree-remove-extra-return-statement.patch
maple_tree-use-mt_node_max-instead-of-direct-operations-mt_max.patch
maple_tree-use-macro-ma_root_parent-instead-of-number.patch
maple_tree-remove-the-redundant-code.patch
maple_tree-refine-ma_state-init-from-mas_start.patch
maple_tree-refine-mab_calc_split-function.patch
maple_tree-remove-the-parameter-entry-of-mas_preallocate.patch
mm-mmap-fix-typo-in-comment.patch
maple_tree-fix-comment-of-mte_destroy_walk.patch
mm-mmap-fix-comment-of-unmapped_area_topdown.patch

