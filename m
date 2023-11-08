Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A611AC4332F
	for <mm-commits@archiver.kernel.org>; Wed,  8 Nov 2023 21:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjKHVaC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Nov 2023 16:30:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjKHVaB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Nov 2023 16:30:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C78A2588
        for <mm-commits@vger.kernel.org>; Wed,  8 Nov 2023 13:29:59 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91B5C433C8;
        Wed,  8 Nov 2023 21:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699478998;
        bh=hOTFHBjRmGzCHzUu2RuoE6R//iowLPuIKbliZF8FXjA=;
        h=Date:To:From:Subject:From;
        b=JIxF0f+Urs0AyKEhm982UopWFa+BOK3Uno7MEjrlkeXrcWfE4jfrti4OFKMOVBeMJ
         +h1MLZwaYUSAT+KW5svP54SMUjd03M9Be9ND95xQD9WZ5i2DeLmulr6L64A4U/DAr2
         aU3Sh1pUWCYZaY39czluPvwTB7V7U+s7rs+Geulw=
Date:   Wed, 08 Nov 2023 13:29:58 -0800
To:     mm-commits@vger.kernel.org, sfrench@samba.org, dhowells@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-test_set_page_writeback.patch added to mm-unstable branch
Message-Id: <20231108212958.C91B5C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove test_set_page_writeback()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-test_set_page_writeback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-test_set_page_writeback.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove test_set_page_writeback()
Date: Wed, 8 Nov 2023 20:46:02 +0000

Patch series "Make folio_start_writeback return void".

Most of the folio flag-setting functions return void. 
folio_start_writeback is gratuitously different; the only two filesystems
that do anything with the return value emit debug messages if it's already
set, and we can (and should) do that internally without bothering the
filesystem to do it.


This patch (of 4):

There are no more callers of this wrapper.

Link: https://lkml.kernel.org/r/20231108204605.745109-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20231108204605.745109-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-test_set_page_writeback
+++ a/include/linux/page-flags.h
@@ -780,11 +780,6 @@ bool set_page_writeback(struct page *pag
 #define folio_start_writeback_keepwrite(folio)	\
 	__folio_start_writeback(folio, true)
 
-static inline bool test_set_page_writeback(struct page *page)
-{
-	return set_page_writeback(page);
-}
-
 static __always_inline bool folio_test_head(struct folio *folio)
 {
 	return test_bit(PG_head, folio_flags(folio, FOLIO_PF_ANY));
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios.patch
mm-convert-__do_fault-to-use-a-folio.patch
mm-use-mapping_evict_folio-in-truncate_error_page.patch
mm-convert-soft_offline_in_use_page-to-use-a-folio.patch
mm-convert-isolate_page-to-mf_isolate_folio.patch
mm-remove-invalidate_inode_page.patch
mm-remove-test_set_page_writeback.patch
afs-do-not-test-the-return-value-of-folio_start_writeback.patch
smb-do-not-test-the-return-value-of-folio_start_writeback.patch
mm-return-void-from-folio_start_writeback-and-related-functions.patch

