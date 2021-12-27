Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3137C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 27 Dec 2021 00:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234849AbhL0AIR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Dec 2021 19:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234845AbhL0AIQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Dec 2021 19:08:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508F5C06173E
        for <mm-commits@vger.kernel.org>; Sun, 26 Dec 2021 16:08:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 756C0B80E60
        for <mm-commits@vger.kernel.org>; Mon, 27 Dec 2021 00:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C695BC36AE8;
        Mon, 27 Dec 2021 00:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640563693;
        bh=eG1xRgbRhqTbgNsoobzOVIA15ERBOKae1/oxI9MMqC8=;
        h=Date:From:To:Subject:From;
        b=QaO68wGNzaCtxFkgk5Gc3c4gBovgJmsR29MifYbmm+Vbqov64ZtRk+at4LIkBQ+pz
         RxsrtUnSwVDLewGBXHRIucNDnv2EKhAOedlaRnAEE0trKV5kSq5tZr4geFOM7RMjdp
         H7Uuj0COGW/pFykbPG67lsi+vOYImgGHMtZ11WDo=
Date:   Sun, 26 Dec 2021 16:08:12 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vitaly.wool@konsulko.com, sjenning@redhat.com,
        Konrad.wilk@oracle.com, jgross@suse.com, hughd@google.com,
        geert@linux-m68k.org, ddstreet@ieee.org, hch@lst.de
Subject:  + frontswap-remove-frontswap_tmem_exclusive_gets.patch
 added to -mm tree
Message-ID: <20211227000812.UrjRT%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: frontswap: remove frontswap_tmem_exclusive_gets
has been added to the -mm tree.  Its filename is
     frontswap-remove-frontswap_tmem_exclusive_gets.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/frontswap-remove-frontswap_tmem_exclusive_gets.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/frontswap-remove-frontswap_tmem_exclusive_gets.patch

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

