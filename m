Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B88E7CCA473
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbiGDBKO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbiGDBJw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:09:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426416307
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:09:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D469C611FA
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A87C341C7;
        Mon,  4 Jul 2022 01:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896990;
        bh=TPx5TUciK/K5NxBBHjxNKtdTD4nVnYDT+ulL0dpgU0E=;
        h=Date:To:From:Subject:From;
        b=rrLL2nfKYpvzmtXa5HYeOUmnCcA4zqcTHs9LafdmK5byBEH+OvlTG3oXyEOiiVjrh
         TS0nphebP2WMjeDRJXVRY/mR+ovB5Q9XOMzIGSdbRIQhAbcuZhYkc5WPR4K7+kfrWC
         /GwoHEnoPbxkO2qvqugZeCgjyCQJGzgpCdzdW2QI=
Date:   Sun, 03 Jul 2022 18:09:49 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        oleksiy.avramchenko@sony.com, npiggin@gmail.com, hch@infradead.org,
        bhe@redhat.com, urezki@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-initialize-vas-list-node-after-unlink.patch removed from -mm tree
Message-Id: <20220704010950.37A87C341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc: initialize VA's list node after unlink
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-initialize-vas-list-node-after-unlink.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: initialize VA's list node after unlink
Date: Tue, 7 Jun 2022 11:34:47 +0200

A vmap_area can travel between different places.  For example
attached/detached to/from different rb-trees.  In order to prevent fancy
bugs, initialize a VA's list node after it is removed from the list, so it
pairs with VA's rb_node which is also initialized.

There is no functional change as a result of this patch.

Link: https://lkml.kernel.org/r/20220607093449.3100-4-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-initialize-vas-list-node-after-unlink
+++ a/mm/vmalloc.c
@@ -977,7 +977,7 @@ __unlink_va(struct vmap_area *va, struct
 	else
 		rb_erase(&va->rb_node, root);
 
-	list_del(&va->list);
+	list_del_init(&va->list);
 	RB_CLEAR_NODE(&va->rb_node);
 }
 
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-extend-__find_vmap_area-with-one-more-argument.patch
lib-test_vmalloc-switch-to-prandom_u32.patch

