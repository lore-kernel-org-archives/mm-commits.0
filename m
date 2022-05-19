Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C480FC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 16:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237900AbiESQ6d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 12:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234219AbiESQ63 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 12:58:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABDFB66
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 09:58:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A76CB8069E
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 16:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF27C385AA;
        Thu, 19 May 2022 16:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652979504;
        bh=LiAxngTfEg0NlBqeFZDeHoDYTZVTy0IWL6GF5iqsPWw=;
        h=Date:To:From:Subject:From;
        b=iXGOu1l2pG2HWETntTMHuyXqyIe/dRWS06qBd+slf/+Zt5sOowaGHrhgxqjP+tTX6
         mGUGKYYaaIYkOcCFUGwvH6XaDMxuJAQ6DlsbCdA8Rp0jgwkh7MHEtoqDTZr1ndeRVE
         GwajmgH8/UPxp6Syeb1mimmJDiKMm7oq9cao7nqI=
Date:   Thu, 19 May 2022 09:58:24 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix-4.patch added to mm-unstable branch
Message-Id: <20220519165824.BBF27C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix potential out of range offset on mas_next()/mas_prev()
has been added to the -mm mm-unstable branch.  Its filename is
     maple-tree-add-new-data-structure-fix-4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-add-new-data-structure-fix-4.patch

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
Subject: maple_tree: fix potential out of range offset on mas_next()/mas_prev()
Date: Thu, 19 May 2022 15:03:37 +0000

When going between next/prev, be more careful to stay within the nodes
range.

Link: https://lkml.kernel.org/r/20220519150304.1289636-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix-4
+++ a/lib/maple_tree.c
@@ -4628,8 +4628,10 @@ retry:
 	node = mas_mn(mas);
 	mt = mte_node_type(mas->node);
 	mas->offset++;
-	if (unlikely(mas->offset >= mt_slots[mt]))
+	if (unlikely(mas->offset >= mt_slots[mt])) {
+		mas->offset = mt_slots[mt] - 1;
 		goto next_node;
+	}
 
 	while (!mas_is_none(mas)) {
 		entry = mas_next_nentry(mas, node, limit, mt);
@@ -4687,6 +4689,9 @@ retry:
 	mn = mas_mn(mas);
 	mt = mte_node_type(mas->node);
 	offset = mas->offset - 1;
+	if (offset >= mt_slots[mt])
+		offset = mt_slots[mt] - 1;
+
 	slots = ma_slots(mn, mt);
 	pivots = ma_pivots(mn, mt);
 	if (offset == mt_pivots[mt])
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
maple-tree-add-new-data-structure-fix-3.patch
maple-tree-add-new-data-structure-fix-4.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
mm-start-tracking-vmas-with-maple-tree-fix-2.patch
mm-remove-the-vma-linked-list-fix.patch

