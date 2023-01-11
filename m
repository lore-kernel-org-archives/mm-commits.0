Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB95C54EBC
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 01:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234881AbjAKBLO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 20:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234969AbjAKBLN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 20:11:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DA4B44
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 17:11:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A5D4619B0
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 01:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B698BC433A8;
        Wed, 11 Jan 2023 01:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673399470;
        bh=ajIKrprKzsVOKGyCk/gzDI+wqdMa6C4vicnG/gUXP20=;
        h=Date:To:From:Subject:From;
        b=ps0U358ExGTRVm6epSi/3e1XW1RPatDcu/ftCLqGRr4loXCveqIYDkLuTI2hr/L2w
         rSMJTVdYNvDdLFf+gzPgPlQoTx70Q5CEQ2AA0btgsKbTlttPhKqOBgLuAHPGjDKY3C
         C1mTxVxO2yRCk7Dpdvsj2IjZNfTmwy04NRTOLv/Y=
Date:   Tue, 10 Jan 2023 17:11:09 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] maple_tree-fix-handle-of-invalidated-state-in-mas_wr_store_setup.patch removed from -mm tree
Message-Id: <20230111011110.B698BC433A8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: fix handle of invalidated state in mas_wr_store_setup()
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-handle-of-invalidated-state-in-mas_wr_store_setup.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: fix handle of invalidated state in mas_wr_store_setup()
Date: Mon, 9 Jan 2023 16:55:42 +0000

If an invalidated maple state is encountered during write, reset the maple
state to MAS_START.  This will result in a re-walk of the tree to the
correct location for the write.

Link: https://lore.kernel.org/all/20230107020126.1627-1-sj@kernel.org/
Link: https://lkml.kernel.org/r/20230109165455.647400-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: SeongJae Park <sj@kernel.org>
Tested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/maple_tree.c~maple_tree-fix-handle-of-invalidated-state-in-mas_wr_store_setup
+++ a/lib/maple_tree.c
@@ -5610,6 +5610,9 @@ static inline void mte_destroy_walk(stru
 
 static void mas_wr_store_setup(struct ma_wr_state *wr_mas)
 {
+	if (unlikely(mas_is_paused(wr_mas->mas)))
+		mas_reset(wr_mas->mas);
+
 	if (!mas_is_start(wr_mas->mas)) {
 		if (mas_is_none(wr_mas->mas)) {
 			mas_reset(wr_mas->mas);
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

nommu-fix-memory-leak-in-do_mmap-error-path.patch
nommu-fix-do_munmap-error-path.patch
nommu-fix-split_vma-map_count-error.patch
maple_tree-remove-gfp_zero-from-kmem_cache_alloc-and-kmem_cache_alloc_bulk.patch

