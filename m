Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B2EAC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233478AbiAVGOx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbiAVGOv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:14:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9FDC06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 22:14:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1557FB81FD1
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FECC340E0;
        Sat, 22 Jan 2022 06:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642832088;
        bh=AsHBooWHWaXz7asNte+ZumkuczqBnp3RTdF4dfL5n48=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AaduvZ9yizwggmQHgJiTFAGcX40h5lKqUcgVN+nRMHLQeFjwsIzLxlSisU70Tie00
         B4hydT2m88tlTijni0v70U4Ah/AtfGJgxSScoD0Is0hHl4XqAfICOfc7Kq1NP5HMIm
         0PrXwKzoSo0lsgDO/4u1BtThlGArqDzWNVBhg0Tg=
Date:   Fri, 21 Jan 2022 22:14:47 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ddstreet@ieee.org, geert@linux-m68k.org,
        hch@lst.de, hughd@google.com, jgross@suse.com,
        Konrad.wilk@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sjenning@redhat.com,
        torvalds@linux-foundation.org, vitaly.wool@konsulko.com,
        willy@infradead.org
Subject:  [patch 61/69] frontswap: remove frontswap_curr_pages
Message-ID: <20220122061447.tDcXDq3S7%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: frontswap: remove frontswap_curr_pages

frontswap_curr_pages is never called, so remove it.

Link: https://lkml.kernel.org/r/20211224062246.1258487-6-hch@lst.de
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

 include/linux/frontswap.h |    1 -
 mm/frontswap.c            |   28 ----------------------------
 2 files changed, 29 deletions(-)

--- a/include/linux/frontswap.h~frontswap-remove-frontswap_curr_pages
+++ a/include/linux/frontswap.h
@@ -24,7 +24,6 @@ struct frontswap_ops {
 };
 
 extern void frontswap_register_ops(struct frontswap_ops *ops);
-extern unsigned long frontswap_curr_pages(void);
 
 extern bool __frontswap_test(struct swap_info_struct *, pgoff_t);
 extern void __frontswap_init(unsigned type, unsigned long *map);
--- a/mm/frontswap.c~frontswap-remove-frontswap_curr_pages
+++ a/mm/frontswap.c
@@ -330,34 +330,6 @@ void __frontswap_invalidate_area(unsigne
 }
 EXPORT_SYMBOL(__frontswap_invalidate_area);
 
-static unsigned long __frontswap_curr_pages(void)
-{
-	unsigned long totalpages = 0;
-	struct swap_info_struct *si = NULL;
-
-	assert_spin_locked(&swap_lock);
-	plist_for_each_entry(si, &swap_active_head, list)
-		totalpages += atomic_read(&si->frontswap_pages);
-	return totalpages;
-}
-
-/*
- * Count and return the number of frontswap pages across all
- * swap devices.  This is exported so that backend drivers can
- * determine current usage without reading debugfs.
- */
-unsigned long frontswap_curr_pages(void)
-{
-	unsigned long totalpages = 0;
-
-	spin_lock(&swap_lock);
-	totalpages = __frontswap_curr_pages();
-	spin_unlock(&swap_lock);
-
-	return totalpages;
-}
-EXPORT_SYMBOL(frontswap_curr_pages);
-
 static int __init init_frontswap(void)
 {
 #ifdef CONFIG_DEBUG_FS
_
