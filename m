Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 422D3C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 18:28:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349223AbiDASaT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Apr 2022 14:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351027AbiDASaQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Apr 2022 14:30:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0B9186FB8
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 11:28:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6C6760F6B
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 18:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ACC1C2BBE4;
        Fri,  1 Apr 2022 18:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648837705;
        bh=eZ2HMLynMVKisQsVjiOEKtM9S5co7bsJ7fU8NsRUXWc=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=Qo3YjzTmfsEl8NBXbhVSe65oFYnwDeVAFaa+4lcIIlnktxgj/P+T4ilE1ZRzKgX6b
         8j6xQVnG+20wlT9a6VGgPUU/E1BCXkIxpagEPOT+iO+smdXE5QzHiika80qdrqV4+s
         zhzWURIUtTvGLAL5XZCLl/JpxO/733T0lBBg8K8I=
Date:   Fri, 01 Apr 2022 11:28:24 -0700
To:     willy@infradead.org, sunhao.th@gmail.com, david@redhat.com,
        konishi.ryusuke@gmail.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220401112740.351496714b370467a92207a6@linux-foundation.org>
Subject: [patch 05/16] nilfs2: get rid of nilfs_mapping_init()
Message-Id: <20220401182825.3ACC1C2BBE4@smtp.kernel.org>
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
