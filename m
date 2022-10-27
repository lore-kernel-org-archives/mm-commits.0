Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E85DECAAA1
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 18:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234884AbiJ0SpU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 14:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235994AbiJ0SpS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 14:45:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB5F248F2
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 11:45:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 431E7B8275D
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 18:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F34C433C1;
        Thu, 27 Oct 2022 18:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666896314;
        bh=aDADYe+vcTCW+YaN4+9lBEH3mTC6NPYv2fN6id3Lzco=;
        h=Date:To:From:Subject:From;
        b=RJC3g++MxBV0zBgajfqcq7P8hBozp7aeZgnA4+HcL1VJmnPHaXiitvmjmibSd3FG7
         fg+AWe9pMRGGQJk5WdX1SOVvyszcxwLq6K16i7djFw9ZelI6EECF7JrC7627uXEmlq
         NXzklFf+dSVbeZZL7/2bvh7F1GUfjxtlx8TDi9os=
Date:   Thu, 27 Oct 2022 11:45:12 -0700
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-pointer-to-pointer-use-in-mas_alloc_nodes.patch added to mm-hotfixes-unstable branch
Message-Id: <20221027184513.D0F34C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: remove pointer to pointer use in mas_alloc_nodes()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-remove-pointer-to-pointer-use-in-mas_alloc_nodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-pointer-to-pointer-use-in-mas_alloc_nodes.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: remove pointer to pointer use in mas_alloc_nodes()
Date: Wed, 26 Oct 2022 15:13:29 +0000

There is a more direct and cleaner way of implementing the same functional
code.  Remove the confusing and unnecessary use of pointers here.

Link: https://lkml.kernel.org/r/20221026151241.4031117-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/maple_tree.c~maple_tree-remove-pointer-to-pointer-use-in-mas_alloc_nodes
+++ a/lib/maple_tree.c
@@ -1209,7 +1209,6 @@ done:
 static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
 {
 	struct maple_alloc *node;
-	struct maple_alloc **nodep = &mas->alloc;
 	unsigned long allocated = mas_allocated(mas);
 	unsigned long success = allocated;
 	unsigned int requested = mas_alloc_req(mas);
@@ -1263,8 +1262,7 @@ static inline void mas_alloc_nodes(struc
 			node->node_count--;
 
 		success += count;
-		nodep = &node->slot[0];
-		node = *nodep;
+		node = node->slot[0];
 		requested -= count;
 	}
 	mas->alloc->total = success;
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

mmap-fix-remap_file_pages-regression.patch
maple_tree-remove-pointer-to-pointer-use-in-mas_alloc_nodes.patch
maple_tree-fix-mas_find_rev-comment.patch
maple_tree-update-copyright-dates-for-test-code.patch

