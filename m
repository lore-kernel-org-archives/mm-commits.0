Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80556C678DC
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbjASBRu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjASBPy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:15:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609C869B3B
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D3D5B81D7E
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E65C433F0;
        Thu, 19 Jan 2023 01:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090899;
        bh=nqoIWfIq2oQWqfSe/ZwhNj4Dfn3hPNmx/HV+N+cOAb8=;
        h=Date:To:From:Subject:From;
        b=v6pcn31xk89CjRno0bGsk+GlPyy0IVsqR1/cEwA0KCizhB4Szh6coWcaLDuSglaS/
         XZpncXodb+NX4AYT1mc+Pasy8yycG6wyeTnjv81kIhMt0A528oQFQLc99C2Fa2+oMf
         ldhf2ZljtRfR9P07muMqs0pt00G7T3BuE8/vukGM=
Date:   Wed, 18 Jan 2023 17:14:59 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        vernon2gm@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-use-macro-ma_root_parent-instead-of-number.patch removed from -mm tree
Message-Id: <20230119011459.C1E65C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: use macro MA_ROOT_PARENT instead of number
has been removed from the -mm tree.  Its filename was
     maple_tree-use-macro-ma_root_parent-instead-of-number.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

maple_tree-remove-the-parameter-entry-of-mas_preallocate.patch
mm-mmap-fix-typo-in-comment.patch
maple_tree-fix-comment-of-mte_destroy_walk.patch
mm-mmap-fix-comment-of-unmapped_area_topdown.patch

