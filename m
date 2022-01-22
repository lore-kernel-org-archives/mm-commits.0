Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52298C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbiAVGPL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233484AbiAVGPL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:15:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FA4C06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 22:15:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B811DB820FE
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09239C340E4;
        Sat, 22 Jan 2022 06:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642832108;
        bh=UGLNdrZxiweLcJpohTqmdPSk289/22nfc2ysBkOSbhQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=whRpb9Rf2MNXMsY9cwFt744Y+82Uye4ce8uSI387f6R89yuUssO/3caN+tVR8nghI
         ofcunWnXzi+IEsY+iyAMrhb06YT29Bz4DGqbQCodrQaJ3lZGj/MpzkAvgcmzR9ZuUG
         /PUcTU7lJmIayLO4/VDyrLifplfz73XSbwm9ss2s=
Date:   Fri, 21 Jan 2022 22:15:07 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ddstreet@ieee.org, geert@linux-m68k.org,
        hch@lst.de, hughd@google.com, jgross@suse.com,
        Konrad.wilk@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sjenning@redhat.com,
        torvalds@linux-foundation.org, vitaly.wool@konsulko.com,
        willy@infradead.org
Subject:  [patch 67/69] mm: mark swap_lock and swap_active_head
 static
Message-ID: <20220122061507.g8juJ_8I0%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
