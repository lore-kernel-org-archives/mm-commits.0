Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F02C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbiAVGOo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbiAVGOl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:14:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D751C06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 22:14:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A86AB81FD1
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D58FC004E1;
        Sat, 22 Jan 2022 06:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642832078;
        bh=NcU+KvV4kEHXMzxE/Nn0OZgrdG+PbDGgr9N4fBMnVYs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Nv7s9n0GM85+S0zMvbwFTrdOjt7m1whBMKMNJusmPx3K/5XxV2u6tcdAPbPgNF1eb
         A86kMY8nbh4I+i6BHPqZFKHD1S3rlAnY2DdfTp7T+xkGNwNzwF9lSMZmxRuPSqeYqY
         ZAtFNjs/gabwMKqE2tYCAPRBOElQe4PjiecTPcy0=
Date:   Fri, 21 Jan 2022 22:14:38 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ddstreet@ieee.org, geert@linux-m68k.org,
        hch@lst.de, hughd@google.com, jgross@suse.com,
        Konrad.wilk@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sjenning@redhat.com,
        torvalds@linux-foundation.org, vitaly.wool@konsulko.com,
        willy@infradead.org
Subject:  [patch 58/69] frontswap: remove frontswap_writethrough
Message-ID: <20220122061438.2hqERZ2Mb%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: frontswap: remove frontswap_writethrough

frontswap_writethrough is never called, so remove it.

Link: https://lkml.kernel.org/r/20211224062246.1258487-3-hch@lst.de
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

 Documentation/vm/frontswap.rst |    6 ------
 include/linux/frontswap.h      |    1 -
 mm/frontswap.c                 |   23 +----------------------
 3 files changed, 1 insertion(+), 29 deletions(-)

--- a/Documentation/vm/frontswap.rst~frontswap-remove-frontswap_writethrough
+++ a/Documentation/vm/frontswap.rst
@@ -39,12 +39,6 @@ a disk write and, if the data is later r
 If a store returns failure, transcendent memory has rejected the data, and the
 page can be written to swap as usual.
 
-If a backend chooses, frontswap can be configured as a "writethrough
-cache" by calling frontswap_writethrough().  In this mode, the reduction
-in swap device writes is lost (and also a non-trivial performance advantage)
-in order to allow the backend to arbitrarily "reclaim" space used to
-store frontswap pages to more completely manage its memory usage.
-
 Note that if a page is stored and the page already exists in transcendent memory
 (a "duplicate" store), either the store succeeds and the data is overwritten,
 or the store fails AND the page is invalidated.  This ensures stale data may
--- a/include/linux/frontswap.h~frontswap-remove-frontswap_writethrough
+++ a/include/linux/frontswap.h
@@ -26,7 +26,6 @@ struct frontswap_ops {
 extern void frontswap_register_ops(struct frontswap_ops *ops);
 extern void frontswap_shrink(unsigned long);
 extern unsigned long frontswap_curr_pages(void);
-extern void frontswap_writethrough(bool);
 #define FRONTSWAP_HAS_EXCLUSIVE_GETS
 extern void frontswap_tmem_exclusive_gets(bool);
 
--- a/mm/frontswap.c~frontswap-remove-frontswap_writethrough
+++ a/mm/frontswap.c
@@ -33,16 +33,6 @@ static struct frontswap_ops *frontswap_o
 	for ((ops) = frontswap_ops; (ops); (ops) = (ops)->next)
 
 /*
- * If enabled, frontswap_store will return failure even on success.  As
- * a result, the swap subsystem will always write the page to swap, in
- * effect converting frontswap into a writethrough cache.  In this mode,
- * there is no direct reduction in swap writes, but a frontswap backend
- * can unilaterally "reclaim" any pages in use with no data loss, thus
- * providing increases control over maximum memory usage due to frontswap.
- */
-static bool frontswap_writethrough_enabled __read_mostly;
-
-/*
  * If enabled, the underlying tmem implementation is capable of doing
  * exclusive gets, so frontswap_load, on a successful tmem_get must
  * mark the page as no longer in frontswap AND mark it dirty.
@@ -171,15 +161,6 @@ void frontswap_register_ops(struct front
 EXPORT_SYMBOL(frontswap_register_ops);
 
 /*
- * Enable/disable frontswap writethrough (see above).
- */
-void frontswap_writethrough(bool enable)
-{
-	frontswap_writethrough_enabled = enable;
-}
-EXPORT_SYMBOL(frontswap_writethrough);
-
-/*
  * Enable/disable frontswap exclusive gets (see above).
  */
 void frontswap_tmem_exclusive_gets(bool enable)
@@ -283,9 +264,7 @@ int __frontswap_store(struct page *page)
 	} else {
 		inc_frontswap_failed_stores();
 	}
-	if (frontswap_writethrough_enabled)
-		/* report failure so swap also writes to swap device */
-		ret = -1;
+
 	return ret;
 }
 EXPORT_SYMBOL(__frontswap_store);
_
