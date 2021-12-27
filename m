Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A95C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 27 Dec 2021 00:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbhL0AIW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Dec 2021 19:08:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59986 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234845AbhL0AIV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Dec 2021 19:08:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CC70B80E61
        for <mm-commits@vger.kernel.org>; Mon, 27 Dec 2021 00:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E69C36AE8;
        Mon, 27 Dec 2021 00:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640563699;
        bh=RMoGAQ8nSluFnp8pMO6whM4bjUVSryD6jwG2hn2WVs8=;
        h=Date:From:To:Subject:From;
        b=Vbp5pBZwzwu0sWEQspw1xWlj7CHykKbK/zJgKA2iiJ8EuY754b6I7IofJ1Y1/Mwm+
         Ca3w4stqmR+hmzDaet+H4RsiM4gPUprSC/ulp97U3029PosiKMfMu1/gJelPPr25W6
         d73naDwNW0z3NTL/R3VF9qKRme4DIEJ4IV4XNQEU=
Date:   Sun, 26 Dec 2021 16:08:18 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vitaly.wool@konsulko.com, sjenning@redhat.com,
        Konrad.wilk@oracle.com, jgross@suse.com, hughd@google.com,
        geert@linux-m68k.org, ddstreet@ieee.org, hch@lst.de
Subject:  + frontswap-remove-frontswap_curr_pages.patch added to -mm
 tree
Message-ID: <20211227000818.wyNdD%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: frontswap: remove frontswap_curr_pages
has been added to the -mm tree.  Its filename is
     frontswap-remove-frontswap_curr_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/frontswap-remove-frontswap_curr_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/frontswap-remove-frontswap_curr_pages.patch

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

