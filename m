Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B157C05027
	for <mm-commits@archiver.kernel.org>; Sat, 21 Jan 2023 01:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjAUBGN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 20:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjAUBGM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 20:06:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AED26ACA2
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2023 17:06:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AC40B829E7
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 01:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CCFC4339C;
        Sat, 21 Jan 2023 01:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674263169;
        bh=KmHGlj1P0lP1K0emSPhV/6KPJQAO8n4nm9RYYwvhMDk=;
        h=Date:To:From:Subject:From;
        b=OvXYIoWdx3FQ3hMxnsFfUkq/bPuwSx21jt+jkSLRa4/bheLrZ0CRLrLrQHOnNKn7q
         a4PWoNYzERQm0DVis+IHHR9FwfDPwHimANJZEuk0T4nmzWvhQKyLvGG1jZMQZfDo8F
         2hGnKkVsJOv97Djf9gkuJxMhjj/UBXiuGPLstwkU=
Date:   Fri, 20 Jan 2023 17:06:08 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-handle-of-invalidated-state-in-mas_wr_store_setup.patch added to mm-unstable branch
Message-Id: <20230121010608.E5CCFC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix handle of invalidated state in mas_wr_store_setup()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-fix-handle-of-invalidated-state-in-mas_wr_store_setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-handle-of-invalidated-state-in-mas_wr_store_setup.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: fix handle of invalidated state in mas_wr_store_setup()
Date: Fri, 20 Jan 2023 11:26:06 -0500

If an invalidated maple state is encountered during write, reset the maple
state to MAS_START.  This will result in a re-walk of the tree to the
correct location for the write.

Link: https://lore.kernel.org/all/20230107020126.1627-1-sj@kernel.org/
Link: https://lkml.kernel.org/r/20230120162650.984577-6-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/maple_tree.c~maple_tree-fix-handle-of-invalidated-state-in-mas_wr_store_setup
+++ a/lib/maple_tree.c
@@ -5608,6 +5608,9 @@ static inline void mte_destroy_walk(stru
 
 static void mas_wr_store_setup(struct ma_wr_state *wr_mas)
 {
+	if (unlikely(mas_is_paused(wr_mas->mas)))
+		mas_reset(wr_mas->mas);
+
 	if (!mas_is_start(wr_mas->mas)) {
 		if (mas_is_none(wr_mas->mas)) {
 			mas_reset(wr_mas->mas);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-fix-handle-of-invalidated-state-in-mas_wr_store_setup.patch
maple_tree-fix-mas_prev-and-mas_find-state-handling.patch
nommu-pass-through-vma-iterator-to-shrink_vma.patch
mm-damon-vaddr-testh-stop-using-vma_mas_store-for-maple-tree-store.patch
mm-mremap-convert-vma_adjust-to-vma_expand.patch

