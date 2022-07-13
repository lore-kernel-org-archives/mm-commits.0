Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1F33C43334
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jul 2022 17:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbiGMR6k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jul 2022 13:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiGMR6j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2022 13:58:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3706E5F42
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 10:58:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFE41B820DB
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 17:58:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6466FC3411E;
        Wed, 13 Jul 2022 17:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657735115;
        bh=tlLPMDBaBI2+YpHu1+CgYoqAGjdmbRJGj2kcZm5h0Cw=;
        h=Date:To:From:Subject:From;
        b=Qx+A+gwoNG3RVsucexxGbJZXCjjYBXLcL9awEeNREAgcvotchEoxx3wYeC/TVfC+/
         ITWpLOlkZO3ZKRSgX5yOfBZkuZ8ioKmSSZbW9+DDINY39IcAHE8BmN2bumZ/UwL+5X
         xG/OmIiF52FzOhZc66nj6+MH9XCSPVS1i15B9eFI=
Date:   Wed, 13 Jul 2022 10:58:34 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        agordeev@linux.ibm.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix-5.patch added to mm-unstable branch
Message-Id: <20220713175835.6466FC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix mas_empty_area_rev() search exhaustion at root node
has been added to the -mm mm-unstable branch.  Its filename is
     maple-tree-add-new-data-structure-fix-5.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-add-new-data-structure-fix-5.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: fix mas_empty_area_rev() search exhaustion at root node
Date: Tue, 12 Jul 2022 01:50:36 +0000

When the possibilities of finding a gap are exhausted at the root node,
the error code was not returned which results in returning a range that
is currently occupied.  Add the necessary check for the error code and
return to the caller.

Link: https://lkml.kernel.org/r/20220712014957.4064879-1-Liam.Howlett@oracle.com
Fixes: d0aac5e48048 (Maple Tree: add new data structure)
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Alexander Gordeev <agordeev@linux.ibm.com>
Tested-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix-5
+++ a/lib/maple_tree.c
@@ -5287,6 +5287,9 @@ int mas_empty_area_rev(struct ma_state *
 		}
 	}
 
+	if (mas_is_err(mas))
+		return xa_err(mas->node);
+
 	if (unlikely(mas->offset == MAPLE_NODE_SLOTS))
 		return -EBUSY;
 
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

android-binder-fix-lockdep-check-on-clearing-vma.patch
maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
maple-tree-add-new-data-structure-fix-3.patch
maple-tree-add-new-data-structure-fix-4.patch
maple-tree-add-new-data-structure-fix-5.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix-2.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix-3.patch
mm-mmap-change-do_brk_flags-to-expand-existing-vma-and-add-do_brk_munmap-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix.patch
mm-remove-the-vma-linked-list-fix-3.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

