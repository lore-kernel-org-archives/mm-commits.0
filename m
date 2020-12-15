Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 492D9C3526E
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B51722D07
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgLOX7X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:59712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728258AbgLOXXb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:23:31 -0500
Date:   Tue, 15 Dec 2020 15:21:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074512;
        bh=tWMRR8Yf94PRnEheWpJd5XPZIJmlKyWfRAtqgp1vhPc=;
        h=From:To:Subject:From;
        b=o6kNLWf9IIeayf4Dm3j82h2SQ+O4hbBskTv1rp7QxssBrnvxU9T5E7iLRZoITqvdM
         VnyxN76GnBfjHQ7wMVO73DsplZ+f4eQGzj6Sqiu9aeH2RDYU1NudPtAmQpK6S8CVJs
         LG23LKdUSVCbAC0x21gw1W9v7W0FUY2rsOrKI/4s=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org
Subject:  [merged] mm-page-flags-fix-comment.patch removed from -mm
 tree
Message-ID: <20201215232152.anZgiLUM_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-flags: fix comment
has been removed from the -mm tree.  Its filename was
     mm-page-flags-fix-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page-flags: fix comment

We haven't had 'dontuse' flags since 2002.  Replace this obsolete warning
with a hopefully more useful one.

Link: https://lkml.kernel.org/r/20201027025823.3704-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/page-flags.h~mm-page-flags-fix-comment
+++ a/include/linux/page-flags.h
@@ -86,8 +86,7 @@
  */
 
 /*
- * Don't use the *_dontuse flags.  Use the macros.  Otherwise you'll break
- * locked- and dirty-page accounting.
+ * Don't use the pageflags directly.  Use the PageFoo macros.
  *
  * The page flags field is split into two parts, the main flags area
  * which extends from the low bits upwards, and the fields area which
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-pagecache-tagged-lookups-return-only-head-pages.patch
mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch
mm-swap-optimise-get_shadow_from_swap_cache.patch
mm-add-fgp_entry.patch
mm-filemap-rename-find_get_entry-to-mapping_get_entry.patch
mm-filemap-add-helper-for-finding-pages.patch
mm-filemap-add-helper-for-finding-pages-fix.patch
mm-filemap-add-mapping_seek_hole_data.patch
mm-filemap-add-mapping_seek_hole_data-fix.patch
iomap-use-mapping_seek_hole_data.patch
mm-add-and-use-find_lock_entries.patch
mm-add-and-use-find_lock_entries-fix.patch
mm-add-an-end-parameter-to-find_get_entries.patch
mm-add-an-end-parameter-to-pagevec_lookup_entries.patch
mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch
mm-pass-pvec-directly-to-find_get_entries.patch
mm-remove-pagevec_lookup_entries.patch

