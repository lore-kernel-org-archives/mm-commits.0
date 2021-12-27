Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 954B0C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 27 Dec 2021 00:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbhL0AIg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Dec 2021 19:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234845AbhL0AIb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Dec 2021 19:08:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C83CC06173E
        for <mm-commits@vger.kernel.org>; Sun, 26 Dec 2021 16:08:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEA8960E9C
        for <mm-commits@vger.kernel.org>; Mon, 27 Dec 2021 00:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C499CC36AE8;
        Mon, 27 Dec 2021 00:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640563710;
        bh=+g6EKiNYdlwfPqJjcZga1rpNVbshRzZudTDF0O9aOgs=;
        h=Date:From:To:Subject:From;
        b=qI64gyze6jEd+1ghE4pRzrJaplBXG+6nmKV8EwVE0p7nEUGBY22XNydOz12CsBGon
         8tUuXqibgTXzHsYJa3bGFpSp1IiLVcoEepJk1edSqHnMZZRgXODZlqlluGIfswb3hq
         4si79E3qZ9rXeBpTN5H2vo/2eQRQViW93i5ab89I=
Date:   Sun, 26 Dec 2021 16:08:29 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vitaly.wool@konsulko.com, sjenning@redhat.com,
        Konrad.wilk@oracle.com, jgross@suse.com, hughd@google.com,
        geert@linux-m68k.org, ddstreet@ieee.org, hch@lst.de
Subject:  + frontswap-remove-frontswap_test.patch added to -mm tree
Message-ID: <20211227000829.wRBRo%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: frontswap: remove frontswap_test
has been added to the -mm tree.  Its filename is
     frontswap-remove-frontswap_test.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/frontswap-remove-frontswap_test.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/frontswap-remove-frontswap_test.patch

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
Subject: frontswap: remove frontswap_test

frontswap_test is unused now, remove it.

Link: https://lkml.kernel.org/r/20211224062246.1258487-10-hch@lst.de
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

 include/linux/frontswap.h |   11 -----------
 mm/frontswap.c            |    2 +-
 2 files changed, 1 insertion(+), 12 deletions(-)

--- a/include/linux/frontswap.h~frontswap-remove-frontswap_test
+++ a/include/linux/frontswap.h
@@ -18,7 +18,6 @@ struct frontswap_ops {
 
 extern void frontswap_register_ops(struct frontswap_ops *ops);
 
-extern bool __frontswap_test(struct swap_info_struct *, pgoff_t);
 extern void frontswap_init(unsigned type, unsigned long *map);
 extern int __frontswap_store(struct page *page);
 extern int __frontswap_load(struct page *page);
@@ -33,11 +32,6 @@ static inline bool frontswap_enabled(voi
 	return static_branch_unlikely(&frontswap_enabled_key);
 }
 
-static inline bool frontswap_test(struct swap_info_struct *sis, pgoff_t offset)
-{
-	return __frontswap_test(sis, offset);
-}
-
 static inline void frontswap_map_set(struct swap_info_struct *p,
 				     unsigned long *map)
 {
@@ -55,11 +49,6 @@ static inline bool frontswap_enabled(voi
 {
 	return false;
 }
-
-static inline bool frontswap_test(struct swap_info_struct *sis, pgoff_t offset)
-{
-	return false;
-}
 
 static inline void frontswap_map_set(struct swap_info_struct *p,
 				     unsigned long *map)
--- a/mm/frontswap.c~frontswap-remove-frontswap_test
+++ a/mm/frontswap.c
@@ -179,7 +179,7 @@ void frontswap_init(unsigned type, unsig
 		ops->init(type);
 }
 
-bool __frontswap_test(struct swap_info_struct *sis,
+static bool __frontswap_test(struct swap_info_struct *sis,
 				pgoff_t offset)
 {
 	if (sis->frontswap_map)
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

