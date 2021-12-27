Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C86ACC433FE
	for <mm-commits@archiver.kernel.org>; Mon, 27 Dec 2021 00:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234858AbhL0AIi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Dec 2021 19:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234856AbhL0AIi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Dec 2021 19:08:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32DCC06173E
        for <mm-commits@vger.kernel.org>; Sun, 26 Dec 2021 16:08:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57BB7B80E69
        for <mm-commits@vger.kernel.org>; Mon, 27 Dec 2021 00:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9186C36AE8;
        Mon, 27 Dec 2021 00:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640563715;
        bh=lPJ4BNSsVO3Ed6bq4TXxUU7B8YaVXcup33HNwv53Ylc=;
        h=Date:From:To:Subject:From;
        b=lGtfgm0LWpg+blflX7x084+bcE67zhPP5e13KI24/SF+PIwAT+RkTtgNfgUOq/1Nl
         vNf+wx2d8ZuZpGGed3BrBjrO1ELOdCkLa92ylSQ5Q7MXqcjQTgeOFaAnECfctZMFOk
         ltV/riyq15xaKXdvMxjguAaWdEniJZZfPZRBVM4A=
Date:   Sun, 26 Dec 2021 16:08:34 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vitaly.wool@konsulko.com, sjenning@redhat.com,
        Konrad.wilk@oracle.com, jgross@suse.com, hughd@google.com,
        geert@linux-m68k.org, ddstreet@ieee.org, hch@lst.de
Subject:  + mm-mark-swap_lock-and-swap_active_head-static.patch added
 to -mm tree
Message-ID: <20211227000834.oE4Ph%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mark swap_lock and swap_active_head static
has been added to the -mm tree.  Its filename is
     mm-mark-swap_lock-and-swap_active_head-static.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mark-swap_lock-and-swap_active_head-static.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mark-swap_lock-and-swap_active_head-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-remove-cleancache.patch
frontswap-remove-frontswap_writethrough.patch
frontswap-remove-frontswap_tmem_exclusive_gets.patch
frontswap-remove-frontswap_shrink.patch
frontswap-remove-frontswap_curr_pages.patch
frontswap-simplify-frontswap_init.patch
frontswap-remove-the-frontswap-exports.patch
mm-simplify-try_to_unuse.patch
frontswap-remove-frontswap_test.patch
frontswap-simplify-frontswap_register_ops.patch
mm-mark-swap_lock-and-swap_active_head-static.patch
frontswap-remove-support-for-multiple-ops.patch
mm-hide-the-frontswap-kconfig-symbol.patch

