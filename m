Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92688C433FE
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbiAVGOr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233475AbiAVGOp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:14:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5FA1C06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 22:14:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83065B82100
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2FCC004E1;
        Sat, 22 Jan 2022 06:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642832082;
        bh=wV+2n0iYc7yFLX2ypalYtnppH93hu6tM/wxkaNzRc/E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wC+daJrzuoj72YRIKFXTU8lnfACqpNqPI+ETPsr+TvW4TNNgWg8s6lfpZgpBj8uZS
         Ggiccu2aaMQVznv3cCpwjwqktGS5yz4czkiT01WRiHgBsry7Ai53xtxTaTMpR9JU4y
         jhfllZDykRotA71w9yyz5NmsVhyLx/E6ZDEW3oGI=
Date:   Fri, 21 Jan 2022 22:14:41 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ddstreet@ieee.org, geert@linux-m68k.org,
        hch@lst.de, hughd@google.com, jgross@suse.com,
        Konrad.wilk@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sjenning@redhat.com,
        torvalds@linux-foundation.org, vitaly.wool@konsulko.com,
        willy@infradead.org
Subject:  [patch 59/69] frontswap: remove
 frontswap_tmem_exclusive_gets
Message-ID: <20220122061441.za9VTEB0f%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: frontswap: remove frontswap_tmem_exclusive_gets

frontswap_tmem_exclusive_gets is never called, so remove it.

Link: https://lkml.kernel.org/r/20211224062246.1258487-4-hch@lst.de
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

 include/linux/frontswap.h |    2 --
 mm/frontswap.c            |   23 +----------------------
 2 files changed, 1 insertion(+), 24 deletions(-)

--- a/include/linux/frontswap.h~frontswap-remove-frontswap_tmem_exclusive_gets
+++ a/include/linux/frontswap.h
@@ -26,8 +26,6 @@ struct frontswap_ops {
 extern void frontswap_register_ops(struct frontswap_ops *ops);
 extern void frontswap_shrink(unsigned long);
 extern unsigned long frontswap_curr_pages(void);
-#define FRONTSWAP_HAS_EXCLUSIVE_GETS
-extern void frontswap_tmem_exclusive_gets(bool);
 
 extern bool __frontswap_test(struct swap_info_struct *, pgoff_t);
 extern void __frontswap_init(unsigned type, unsigned long *map);
--- a/mm/frontswap.c~frontswap-remove-frontswap_tmem_exclusive_gets
+++ a/mm/frontswap.c
@@ -32,13 +32,6 @@ static struct frontswap_ops *frontswap_o
 #define for_each_frontswap_ops(ops)		\
 	for ((ops) = frontswap_ops; (ops); (ops) = (ops)->next)
 
-/*
- * If enabled, the underlying tmem implementation is capable of doing
- * exclusive gets, so frontswap_load, on a successful tmem_get must
- * mark the page as no longer in frontswap AND mark it dirty.
- */
-static bool frontswap_tmem_exclusive_gets_enabled __read_mostly;
-
 #ifdef CONFIG_DEBUG_FS
 /*
  * Counters available via /sys/kernel/debug/frontswap (if debugfs is
@@ -161,15 +154,6 @@ void frontswap_register_ops(struct front
 EXPORT_SYMBOL(frontswap_register_ops);
 
 /*
- * Enable/disable frontswap exclusive gets (see above).
- */
-void frontswap_tmem_exclusive_gets(bool enable)
-{
-	frontswap_tmem_exclusive_gets_enabled = enable;
-}
-EXPORT_SYMBOL(frontswap_tmem_exclusive_gets);
-
-/*
  * Called when a swap device is swapon'd.
  */
 void __frontswap_init(unsigned type, unsigned long *map)
@@ -296,13 +280,8 @@ int __frontswap_load(struct page *page)
 		if (!ret) /* successful load */
 			break;
 	}
-	if (ret == 0) {
+	if (ret == 0)
 		inc_frontswap_loads();
-		if (frontswap_tmem_exclusive_gets_enabled) {
-			SetPageDirty(page);
-			__frontswap_clear(sis, offset);
-		}
-	}
 	return ret;
 }
 EXPORT_SYMBOL(__frontswap_load);
_
