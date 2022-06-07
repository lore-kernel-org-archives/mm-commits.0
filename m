Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C7E4C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Jun 2022 02:27:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbiFHC1p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Jun 2022 22:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446838AbiFHC0V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2022 22:26:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C4D13E22
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 15:42:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61D506164A
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 22:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B368FC3411C;
        Tue,  7 Jun 2022 22:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654641725;
        bh=UWYfV7bx1Fn7K6cunDbP5V9PqPDkXvX4wuQ0HtjkQVQ=;
        h=Date:To:From:Subject:From;
        b=bfi5atLCEu3ZGvjADJd59UxWHjW+TyxFn/NYwxmajvDX5MQ/HUXmPSD+GT1yQuzZ9
         xURCjqoK8J1wLJxYIH33Y1rDbtQrQ45qD7ZPpsGd6Yh2NvIEknf0hjd82lkW75Jp/B
         1oTQNUvxOQJeGv2Sor/0itwZA1D+d3km0LwI2P74=
Date:   Tue, 07 Jun 2022 15:42:05 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        oleksiy.avramchenko@sony.com, npiggin@gmail.com, hch@infradead.org,
        urezki@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-initialize-vas-list-node-after-unlink.patch added to mm-unstable branch
Message-Id: <20220607224205.B368FC3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: initialize VA's list node after unlink
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-initialize-vas-list-node-after-unlink.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-initialize-vas-list-node-after-unlink.patch

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

mm-vmalloc-make-link_va-unlink_va-common-to-different-rb_root.patch
mm-vmalloc-extend-__alloc_vmap_area-with-extra-arguments.patch
mm-vmalloc-initialize-vas-list-node-after-unlink.patch
mm-vmalloc-extend-__find_vmap_area-with-one-more-argument.patch
lib-test_vmalloc-switch-to-prandom_u32.patch

