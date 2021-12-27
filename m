Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30DE4C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 27 Dec 2021 00:08:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234853AbhL0AIY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Dec 2021 19:08:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60034 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234845AbhL0AIY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Dec 2021 19:08:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55828B80E65
        for <mm-commits@vger.kernel.org>; Mon, 27 Dec 2021 00:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA066C36AE8;
        Mon, 27 Dec 2021 00:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640563702;
        bh=Klb3TYSwWx2zqWu8s3c39NRbE2YPJWmqX1itVG9T6A4=;
        h=Date:From:To:Subject:From;
        b=TQOIkUUFDY24DI7wFChbfSRxMfynJAi5NLPljeCO8KVzjQ8sUvq2DOUpcDRt+iDIa
         RnTmHEd+l9tgm0mcSxPo2O2C3XDZnFe5lk+/ME6XCKhUp6vl23u8SP5rCFjAGkxIIG
         1TWn6d67sXMadwxyzxtua+0edZxAbqKpbqWVFE8k=
Date:   Sun, 26 Dec 2021 16:08:21 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vitaly.wool@konsulko.com, sjenning@redhat.com,
        Konrad.wilk@oracle.com, jgross@suse.com, hughd@google.com,
        geert@linux-m68k.org, ddstreet@ieee.org, hch@lst.de
Subject:  + frontswap-simplify-frontswap_init.patch added to -mm tree
Message-ID: <20211227000821.E2L4z%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: frontswap: simplify frontswap_init
has been added to the -mm tree.  Its filename is
     frontswap-simplify-frontswap_init.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/frontswap-simplify-frontswap_init.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/frontswap-simplify-frontswap_init.patch

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
Subject: frontswap: simplify frontswap_init

Just use IS_ENABLED() and remove the __frontswap_init indirection.
Also remove the unused export.

Link: https://lkml.kernel.org/r/20211224062246.1258487-7-hch@lst.de
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

 include/linux/frontswap.h |    9 +--------
 mm/frontswap.c            |    3 +--
 mm/swapfile.c             |    3 ++-
 3 files changed, 4 insertions(+), 11 deletions(-)

--- a/include/linux/frontswap.h~frontswap-simplify-frontswap_init
+++ a/include/linux/frontswap.h
@@ -26,7 +26,7 @@ struct frontswap_ops {
 extern void frontswap_register_ops(struct frontswap_ops *ops);
 
 extern bool __frontswap_test(struct swap_info_struct *, pgoff_t);
-extern void __frontswap_init(unsigned type, unsigned long *map);
+extern void frontswap_init(unsigned type, unsigned long *map);
 extern int __frontswap_store(struct page *page);
 extern int __frontswap_load(struct page *page);
 extern void __frontswap_invalidate_page(unsigned, pgoff_t);
@@ -107,11 +107,4 @@ static inline void frontswap_invalidate_
 		__frontswap_invalidate_area(type);
 }
 
-static inline void frontswap_init(unsigned type, unsigned long *map)
-{
-#ifdef CONFIG_FRONTSWAP
-	__frontswap_init(type, map);
-#endif
-}
-
 #endif /* _LINUX_FRONTSWAP_H */
--- a/mm/frontswap.c~frontswap-simplify-frontswap_init
+++ a/mm/frontswap.c
@@ -156,7 +156,7 @@ EXPORT_SYMBOL(frontswap_register_ops);
 /*
  * Called when a swap device is swapon'd.
  */
-void __frontswap_init(unsigned type, unsigned long *map)
+void frontswap_init(unsigned type, unsigned long *map)
 {
 	struct swap_info_struct *sis = swap_info[type];
 	struct frontswap_ops *ops;
@@ -179,7 +179,6 @@ void __frontswap_init(unsigned type, uns
 	for_each_frontswap_ops(ops)
 		ops->init(type);
 }
-EXPORT_SYMBOL(__frontswap_init);
 
 bool __frontswap_test(struct swap_info_struct *sis,
 				pgoff_t offset)
--- a/mm/swapfile.c~frontswap-simplify-frontswap_init
+++ a/mm/swapfile.c
@@ -2463,7 +2463,8 @@ static void enable_swap_info(struct swap
 				struct swap_cluster_info *cluster_info,
 				unsigned long *frontswap_map)
 {
-	frontswap_init(p->type, frontswap_map);
+	if (IS_ENABLED(CONFIG_FRONTSWAP))
+		frontswap_init(p->type, frontswap_map);
 	spin_lock(&swap_lock);
 	spin_lock(&p->lock);
 	setup_swap_info(p, prio, swap_map, cluster_info);
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

