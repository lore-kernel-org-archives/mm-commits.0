Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 584E8C761A6
	for <mm-commits@archiver.kernel.org>; Tue,  4 Apr 2023 20:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236130AbjDDUZK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Apr 2023 16:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjDDUZE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Apr 2023 16:25:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4B61991
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 13:25:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77179636F7
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 20:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC83DC433EF;
        Tue,  4 Apr 2023 20:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680639902;
        bh=fvazRCIyKeq4dKUVyzb68Sgp3IbNkq/Ua+wJeXx3XzM=;
        h=Date:To:From:Subject:From;
        b=KkgantJpoqRHt3008YnNUUVuPC2CpczF/gv0G6DKAoyidSlv7A0J2Q0j6aFlUO/bn
         4SZ4uMwnfLzQpjieEFvOGMpV8ZzhEEGtwF1nWtenWicZA1zvWFqoWsqaJ4IF0mXIhl
         QKJrjq1vawwFZ1ErYK4tQ9QfVCf7JxUqZdh77SG4=
Date:   Tue, 04 Apr 2023 13:25:02 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-get-wrong-data_end-in-mtree_lookup_walk.patch added to mm-unstable branch
Message-Id: <20230404202502.CC83DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix get wrong data_end in mtree_lookup_walk()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-fix-get-wrong-data_end-in-mtree_lookup_walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-get-wrong-data_end-in-mtree_lookup_walk.patch

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
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: fix get wrong data_end in mtree_lookup_walk()
Date: Tue, 14 Mar 2023 20:42:01 +0800

Patch series "Some fixes and cleanup for maple tree", v2.

Some fixes and clean up for maple tree.


This patch (of 3):

if (likely(offset > end))
	max = pivots[offset];

The above code should be changed to if (likely(offset < end)), which is
correct.  This affects the correctness of ma_data_end().  Now it seems
that the final result will not be wrong, but it is best to change it. 
This patch does not change the code as above, because it simplifies the
code by the way.

Link: https://lkml.kernel.org/r/20230314124203.91572-1-zhangpeng.00@bytedance.com
Link: https://lkml.kernel.org/r/20230314124203.91572-2-zhangpeng.00@bytedance.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-get-wrong-data_end-in-mtree_lookup_walk
+++ a/lib/maple_tree.c
@@ -3941,18 +3941,13 @@ static inline void *mtree_lookup_walk(st
 		end = ma_data_end(node, type, pivots, max);
 		if (unlikely(ma_dead_node(node)))
 			goto dead_node;
-
-		if (pivots[offset] >= mas->index)
-			goto next;
-
 		do {
-			offset++;
-		} while ((offset < end) && (pivots[offset] < mas->index));
-
-		if (likely(offset > end))
-			max = pivots[offset];
+			if (pivots[offset] >= mas->index) {
+				max = pivots[offset];
+				break;
+			}
+		} while (++offset < end);
 
-next:
 		slots = ma_slots(node, type);
 		next = mt_slot(mas->tree, slots, offset);
 		if (unlikely(ma_dead_node(node)))
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

mm-kfence-improve-the-performance-of-__kfence_alloc-and-__kfence_free.patch
maple_tree-fix-get-wrong-data_end-in-mtree_lookup_walk.patch
maple_tree-simplify-mas_wr_node_walk.patch
maple_tree-fix-a-potential-concurrency-bug-in-rcu-mode.patch

