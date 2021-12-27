Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 886C8C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 27 Dec 2021 00:08:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234854AbhL0AI2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Dec 2021 19:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234845AbhL0AI1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Dec 2021 19:08:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4B1C06173E
        for <mm-commits@vger.kernel.org>; Sun, 26 Dec 2021 16:08:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6605BB80E66
        for <mm-commits@vger.kernel.org>; Mon, 27 Dec 2021 00:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA23BC36AE8;
        Mon, 27 Dec 2021 00:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640563705;
        bh=k2rwWegcCX43do/FYFj4AcJJXd6ApEh4XjuoB3Fo/JA=;
        h=Date:From:To:Subject:From;
        b=PqoVutIj7Xssk+6D49SC91Sh+4bJ81keLpe6S8lNsI863QkQfsXq9XfZYKB5F+tRs
         Fl0bPdGAB4rKJM8VyE+PFjYPDQvG8hI1TnZLb/gkBuHEZplwmq2IgC1N4Qf+DlASbi
         75qP1nyBE6RzNtlRL/3wanCZaoYPJBGrsMKusx7Y=
Date:   Sun, 26 Dec 2021 16:08:24 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vitaly.wool@konsulko.com, sjenning@redhat.com,
        Konrad.wilk@oracle.com, jgross@suse.com, hughd@google.com,
        geert@linux-m68k.org, ddstreet@ieee.org, hch@lst.de
Subject:  + frontswap-remove-the-frontswap-exports.patch added to -mm
 tree
Message-ID: <20211227000824.NGCp5%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: frontswap: remove the frontswap exports
has been added to the -mm tree.  Its filename is
     frontswap-remove-the-frontswap-exports.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/frontswap-remove-the-frontswap-exports.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/frontswap-remove-the-frontswap-exports.patch

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

