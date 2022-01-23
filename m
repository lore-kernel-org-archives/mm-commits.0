Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8817FC433FE
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240518AbiAWX6p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:58:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53178 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235363AbiAWX6o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:58:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 976DE61207
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBCFC340E3;
        Sun, 23 Jan 2022 23:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982324;
        bh=L3SIFRx1xII7kztq4qU85EGn3bhXEcbootELeq+HD8E=;
        h=Date:From:To:Subject:From;
        b=YYm149nMdaIfLZgDK6NKGR9Upzzxl0uo9XD36RO7EyKfnxRBwZAmt6h4AC/XIkULP
         UoUH9cXHIqbYcIAxiaWj97rr+G/YaGjH/8TXE3ONZALc07POIHatXs8VFLPn7Aoltg
         kqLpCYJzHez4cOJ07qC04YvqP6ev8RtMs4GYaREs=
Date:   Sun, 23 Jan 2022 15:58:43 -0800
From:   akpm@linux-foundation.org
To:     ddstreet@ieee.org, geert@linux-m68k.org, hch@lst.de,
        hughd@google.com, jgross@suse.com, Konrad.wilk@oracle.com,
        mm-commits@vger.kernel.org, sjenning@redhat.com,
        vitaly.wool@konsulko.com, willy@infradead.org
Subject:  [merged] frontswap-remove-the-frontswap-exports.patch
 removed from -mm tree
Message-ID: <20220123235843.X4zhb38M7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: frontswap: remove the frontswap exports
has been removed from the -mm tree.  Its filename was
     frontswap-remove-the-frontswap-exports.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: frontswap: remove the frontswap exports

None of the frontswap API is called from modular code.

Link: https://lkml.kernel.org/r/20211224062246.1258487-8-hch@lst.de
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

 mm/frontswap.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/frontswap.c~frontswap-remove-the-frontswap-exports
+++ a/mm/frontswap.c
@@ -151,7 +151,6 @@ void frontswap_register_ops(struct front
 		}
 	}
 }
-EXPORT_SYMBOL(frontswap_register_ops);
 
 /*
  * Called when a swap device is swapon'd.
@@ -187,7 +186,6 @@ bool __frontswap_test(struct swap_info_s
 		return test_bit(offset, sis->frontswap_map);
 	return false;
 }
-EXPORT_SYMBOL(__frontswap_test);
 
 static inline void __frontswap_set(struct swap_info_struct *sis,
 				   pgoff_t offset)
@@ -250,7 +248,6 @@ int __frontswap_store(struct page *page)
 
 	return ret;
 }
-EXPORT_SYMBOL(__frontswap_store);
 
 /*
  * "Get" data from frontswap associated with swaptype and offset that were
@@ -283,7 +280,6 @@ int __frontswap_load(struct page *page)
 		inc_frontswap_loads();
 	return ret;
 }
-EXPORT_SYMBOL(__frontswap_load);
 
 /*
  * Invalidate any data from frontswap associated with the specified swaptype
@@ -305,7 +301,6 @@ void __frontswap_invalidate_page(unsigne
 	__frontswap_clear(sis, offset);
 	inc_frontswap_invalidates();
 }
-EXPORT_SYMBOL(__frontswap_invalidate_page);
 
 /*
  * Invalidate all data from frontswap associated with all offsets for the
@@ -327,7 +322,6 @@ void __frontswap_invalidate_area(unsigne
 	atomic_set(&sis->frontswap_pages, 0);
 	bitmap_zero(sis->frontswap_map, sis->max);
 }
-EXPORT_SYMBOL(__frontswap_invalidate_area);
 
 static int __init init_frontswap(void)
 {
_

Patches currently in -mm which might be from hch@lst.de are


