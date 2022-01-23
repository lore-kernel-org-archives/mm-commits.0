Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C27AC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235363AbiAWX67 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240521AbiAWX66 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:58:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B6CC06173B
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 15:58:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 440F8B80E44
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD857C340E3;
        Sun, 23 Jan 2022 23:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982336;
        bh=U6lYr6q9jG/Vh07WsbljVjLlsstfu4C7Lq4YNQftkIY=;
        h=Date:From:To:Subject:From;
        b=NLEBpJaufUgTxtGMIV3YiFtxMuLlpdOL9K/u48IoikXLjHp9J9Yl9x0LOCnLZRr25
         ijxKzf2Ln/KdPquNZJeIvGG2eY8c5HdxL1ZLgKHu0lLqJc5T3lFBQx/ROyCN4jZbyL
         tvCKivBMA6iyz3MYlL/IUTz5p0b2oyl+Os2NX/dU=
Date:   Sun, 23 Jan 2022 15:58:55 -0800
From:   akpm@linux-foundation.org
To:     ddstreet@ieee.org, geert@linux-m68k.org, hch@lst.de,
        hughd@google.com, jgross@suse.com, Konrad.wilk@oracle.com,
        mm-commits@vger.kernel.org, sjenning@redhat.com,
        vitaly.wool@konsulko.com, willy@infradead.org
Subject:  [merged]
 mm-mark-swap_lock-and-swap_active_head-static.patch removed from -mm tree
Message-ID: <20220123235855.1_Eysk1qK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mark swap_lock and swap_active_head static
has been removed from the -mm tree.  Its filename was
     mm-mark-swap_lock-and-swap_active_head-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: mark swap_lock and swap_active_head static

swap_lock and swap_active_head are only used in swapfile.c, so mark them
static.

Link: https://lkml.kernel.org/r/20211224062246.1258487-12-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Konrad Rzeszutek Wilk <Konrad.wilk@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapfile.h |    2 --
 mm/swapfile.c            |    4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/include/linux/swapfile.h~mm-mark-swap_lock-and-swap_active_head-static
+++ a/include/linux/swapfile.h
@@ -6,8 +6,6 @@
  * these were static in swapfile.c but frontswap.c needs them and we don't
  * want to expose them to the dozens of source files that include swap.h
  */
-extern spinlock_t swap_lock;
-extern struct plist_head swap_active_head;
 extern struct swap_info_struct *swap_info[];
 extern unsigned long generic_max_swapfile_size(void);
 extern unsigned long max_swapfile_size(void);
--- a/mm/swapfile.c~mm-mark-swap_lock-and-swap_active_head-static
+++ a/mm/swapfile.c
@@ -49,7 +49,7 @@ static bool swap_count_continued(struct
 				 unsigned char);
 static void free_swap_count_continuations(struct swap_info_struct *);
 
-DEFINE_SPINLOCK(swap_lock);
+static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
 atomic_long_t nr_swap_pages;
 /*
@@ -71,7 +71,7 @@ static const char Unused_offset[] = "Unu
  * all active swap_info_structs
  * protected with swap_lock, and ordered by priority.
  */
-PLIST_HEAD(swap_active_head);
+static PLIST_HEAD(swap_active_head);
 
 /*
  * all available (active, not full) swap_info_structs
_

Patches currently in -mm which might be from hch@lst.de are


