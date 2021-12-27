Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CF03C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 27 Dec 2021 00:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbhL0AIN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Dec 2021 19:08:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59906 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234845AbhL0AIM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Dec 2021 19:08:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8012BB80E5F
        for <mm-commits@vger.kernel.org>; Mon, 27 Dec 2021 00:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7036C36AE9;
        Mon, 27 Dec 2021 00:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640563690;
        bh=a7H8ZcV5LLuFWSBMjg+XGOvIR1RFm/1GSYuKh32NEl8=;
        h=Date:From:To:Subject:From;
        b=x2lUUBb1SbdsfZhbbW5oMtHNQjCzoe5akKpM17/XKYz1k67LRG5la2yWoaCvl1CF4
         Edi95p+cCXTcixep6jzyvJKVAyNCFzhBzeTYbBveFiA3ri5q34eNjn5ZIosYnw6lLc
         R+dWPxqfj46eIqVIyPgWRHYooHjyReVOCA8LatSo=
Date:   Sun, 26 Dec 2021 16:08:09 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vitaly.wool@konsulko.com, sjenning@redhat.com,
        Konrad.wilk@oracle.com, jgross@suse.com, hughd@google.com,
        geert@linux-m68k.org, ddstreet@ieee.org, hch@lst.de
Subject:  + frontswap-remove-frontswap_writethrough.patch added to
 -mm tree
Message-ID: <20211227000809.dgC7R%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: frontswap: remove frontswap_writethrough
has been added to the -mm tree.  Its filename is
     frontswap-remove-frontswap_writethrough.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/frontswap-remove-frontswap_writethrough.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/frontswap-remove-frontswap_writethrough.patch

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

