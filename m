Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71A1EB64DB
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jun 2023 20:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjFNUFX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jun 2023 16:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235333AbjFNUFW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Jun 2023 16:05:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46728B5
        for <mm-commits@vger.kernel.org>; Wed, 14 Jun 2023 13:05:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6F3D60A16
        for <mm-commits@vger.kernel.org>; Wed, 14 Jun 2023 20:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6FFC433C8;
        Wed, 14 Jun 2023 20:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686773120;
        bh=soaPElsSL2epCGZORE1umO9oJn7UdeweFKYfsyoyUS0=;
        h=Date:To:From:Subject:From;
        b=JQ+zdQuZ5l/TieR3WBrEYgGZgu9eBE72z3ig880h2XrPfdMfWJUjmCxsb7faliCQj
         CVxvR+Id+Kz8ksgVxgljADn66CcjGxZVUUJZvKEHtb2XHhAge5ug+TmHzEezoPSRkU
         AAB5rqHp9jUdUt1cdWmqCHSNNAR41A/ksi0ZlYsY=
Date:   Wed, 14 Jun 2023 13:05:19 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmzone-introduce-folio_migratetype.patch added to mm-unstable branch
Message-Id: <20230614200520.3A6FFC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmzone: introduce folio_migratetype()
has been added to the -mm mm-unstable branch.  Its filename is
     mmzone-introduce-folio_migratetype.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmzone-introduce-folio_migratetype.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mmzone: introduce folio_migratetype()
Date: Tue, 13 Jun 2023 19:13:09 -0700

Introduce folio_migratetype() as a folio equivalent for
get_pageblock_migratetype().  This function intends to return the
migratetype the folio is located in, hence the name choice.

Link: https://lkml.kernel.org/r/20230614021312.34085-3-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/mmzone.h~mmzone-introduce-folio_migratetype
+++ a/include/linux/mmzone.h
@@ -105,6 +105,9 @@ extern int page_group_by_mobility_disabl
 #define get_pageblock_migratetype(page)					\
 	get_pfnblock_flags_mask(page, page_to_pfn(page), MIGRATETYPE_MASK)
 
+#define folio_migratetype(folio)				\
+	get_pfnblock_flags_mask(&folio->page, folio_pfn(folio),		\
+			MIGRATETYPE_MASK)
 struct free_area {
 	struct list_head	free_list[MIGRATE_TYPES];
 	unsigned long		nr_free;
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

afs-fix-dangling-folio-ref-counts-in-writeback.patch
afs-fix-waiting-for-writeback-then-skipping-folio.patch
mmzone-introduce-folio_is_zone_movable.patch
mmzone-introduce-folio_migratetype.patch
mm-gup_testc-convert-verify_dma_pinned-to-us-folios.patch
mm-gupc-reorganize-try_get_folio.patch
mm-remove-is_longterm_pinnable_page-and-reimplement-folio_is_longterm_pinnable.patch

