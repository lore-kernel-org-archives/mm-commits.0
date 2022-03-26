Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC8BC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 26 Mar 2022 03:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbiCZD0M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 23:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiCZD0D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 23:26:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F138715E899
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 20:24:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A130619A5
        for <mm-commits@vger.kernel.org>; Sat, 26 Mar 2022 03:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB30C004DD;
        Sat, 26 Mar 2022 03:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648265067;
        bh=LX++ND3tNWpAEf02ZX9B3wpuZ/+wua5zkd/+Dhqorpw=;
        h=Date:To:From:Subject:From;
        b=wz0Px0BQwwntEH4sffXOkGNW/PNN13rjARYdwftzNdoxkmOoOswQ4MjZHmAFg7xot
         oDLJI/45oJdMnaAz6VV7OrhD+CqPVbQlpc2L+8YW+FuwKVVd0BGFnU/Fcun9WwMygr
         Odqjuuu7pKkrwzgwpf95EdDSPA2/yiKGMobS+3i8=
Date:   Fri, 25 Mar 2022 20:24:26 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        sunhao.th@gmail.com, david@redhat.com, konishi.ryusuke@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-get-rid-of-nilfs_mapping_init.patch added to -mm tree
Message-Id: <20220326032426.DCB30C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: get rid of nilfs_mapping_init()
has been added to the -mm tree.  Its filename is
     nilfs2-get-rid-of-nilfs_mapping_init.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/nilfs2-get-rid-of-nilfs_mapping_init.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-get-rid-of-nilfs_mapping_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-lockdep-warnings-in-page-operations-for-btree-nodes.patch
nilfs2-fix-lockdep-warnings-during-disk-space-reclamation.patch
nilfs2-get-rid-of-nilfs_mapping_init.patch

