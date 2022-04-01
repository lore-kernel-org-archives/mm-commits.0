Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBD3C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 18:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349367AbiDASW6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Apr 2022 14:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349958AbiDASWy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Apr 2022 14:22:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44AA38198
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 11:21:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8001960BA8
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 18:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6190C340EE;
        Fri,  1 Apr 2022 18:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648837263;
        bh=eZ2HMLynMVKisQsVjiOEKtM9S5co7bsJ7fU8NsRUXWc=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=f3NvgHOmWoCd8IoOgY+Int/TbldLEjITe1go7JFL+ZcoGXIxD0ZPaKs1AzGRZfmpe
         iFeNNzyLRqy147hCoN7EYjErmVx4LBXGTjpWHjAYx3lXuDOnavnVEtEl8uhZtiSEiA
         05DvbzeXO5rzM4kTRKioxTwN1WJclmRtp6gcI6cg=
Date:   Fri, 01 Apr 2022 11:21:03 -0700
To:     willy@infradead.org, sunhao.th@gmail.com, david@redhat.com,
        konishi.ryusuke@gmail.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <l>
Subject: [patch 05/16] nilfs2: get rid of nilfs_mapping_init()
Message-Id: <20220401182103.D6190C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: get rid of nilfs_mapping_init()

After applying the lockdep warning fixes, nilfs_mapping_init() is no
longer used, so delete it.

Link: https://lkml.kernel.org/r/1647867427-30498-4-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hao Sun <sunhao.th@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c |    9 ---------
 fs/nilfs2/page.h |    1 -
 2 files changed, 10 deletions(-)

--- a/fs/nilfs2/page.c~nilfs2-get-rid-of-nilfs_mapping_init
+++ a/fs/nilfs2/page.c
@@ -436,15 +436,6 @@ unsigned int nilfs_page_count_clean_buff
 	return nc;
 }
 
-void nilfs_mapping_init(struct address_space *mapping, struct inode *inode)
-{
-	mapping->host = inode;
-	mapping->flags = 0;
-	mapping_set_gfp_mask(mapping, GFP_NOFS);
-	mapping->private_data = NULL;
-	mapping->a_ops = &empty_aops;
-}
-
 /*
  * NILFS2 needs clear_page_dirty() in the following two cases:
  *
--- a/fs/nilfs2/page.h~nilfs2-get-rid-of-nilfs_mapping_init
+++ a/fs/nilfs2/page.h
@@ -43,7 +43,6 @@ int nilfs_copy_dirty_pages(struct addres
 void nilfs_copy_back_pages(struct address_space *, struct address_space *);
 void nilfs_clear_dirty_page(struct page *, bool);
 void nilfs_clear_dirty_pages(struct address_space *, bool);
-void nilfs_mapping_init(struct address_space *mapping, struct inode *inode);
 unsigned int nilfs_page_count_clean_buffers(struct page *, unsigned int,
 					    unsigned int);
 unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
_
