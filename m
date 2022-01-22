Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E38CC433FE
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233151AbiAVGO5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:14:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44872 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233499AbiAVGOx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:14:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A996160FB6
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5774C004E1;
        Sat, 22 Jan 2022 06:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642832092;
        bh=08c+sz7thFz+5YS6FjBYUmgMvPxISU1wCf/VeduGZe0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BDTOQpedoawepFkNu9jhJOMWBXBim7rgreEUQMEcHKZPyGGz72GVNDejvD4XMwdeu
         1uBo8UPPNCkFSKy6koUpmchLtDCVofFTuTrmBB5OAq+lMaLhMHV0SrWWBYYkvDr5dR
         +rE1WdLk+kI5nS0P9DGW6VWL6ksbzWjNyWPhdrLo=
Date:   Fri, 21 Jan 2022 22:14:51 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ddstreet@ieee.org, geert@linux-m68k.org,
        hch@lst.de, hughd@google.com, jgross@suse.com,
        Konrad.wilk@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sjenning@redhat.com,
        torvalds@linux-foundation.org, vitaly.wool@konsulko.com,
        willy@infradead.org
Subject:  [patch 62/69] frontswap: simplify frontswap_init
Message-ID: <20220122061451.xtrCwshPY%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
