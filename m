Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B885BC433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BF2F64F1F
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbhBZAiC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:38:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:57832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231960AbhBZAiB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:38:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E957264F1B;
        Fri, 26 Feb 2021 00:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614299841;
        bh=eL44/pdEs9iRG/xpl5AcW5p8zONCrcfLELV5ae19Z5c=;
        h=Date:From:To:Subject:From;
        b=vQxuMCBBckyJPDH27G4MwfFVfiTH9W1Vc3QUmsckMsladkPDYl1YFH+Sm2eZY2DDS
         grElxZATFSbZO4nOHkW0aZhftr5dI5hW2Z78Jts32t+usDOEuE15gqChChVQyyVm+V
         0i1lDG3gq1YxnYj80PbQZmCEKozWZ97iIIIOm88c=
Date:   Thu, 25 Feb 2021 16:37:20 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [folded-merged]
 mm-filemap-add-mapping_seek_hole_data-fix.patch removed from -mm tree
Message-ID: <20210226003720.pVLqFshOC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fix mm-filemap-add-mapping_seek_hole_data.patch
has been removed from the -mm tree.  Its filename was
     mm-filemap-add-mapping_seek_hole_data-fix.patch

This patch was dropped because it was folded into mm-filemap-add-mapping_seek_hole_data.patch

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fix mm-filemap-add-mapping_seek_hole_data.patch

Link: https://lkml.kernel.org/r/20201124041507.28996-4-willy@infradead.org

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-add-mapping_seek_hole_data-fix
+++ a/mm/filemap.c
@@ -2608,7 +2608,8 @@ loff_t mapping_seek_hole_data(struct add
 		if (page_seek_match(page, seek_data))
 			goto unlock;
 		start = pos + seek_page_size(&xas, page);
-		put_page(page);
+		if (!xa_is_value(page))
+			put_page(page);
 	}
 	rcu_read_unlock();
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-pagecache-tagged-lookups-return-only-head-pages.patch
mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch
mm-swap-optimise-get_shadow_from_swap_cache.patch
mm-add-fgp_entry.patch
mm-filemap-rename-find_get_entry-to-mapping_get_entry.patch
mm-filemap-add-helper-for-finding-pages.patch
mm-filemap-add-mapping_seek_hole_data.patch
iomap-use-mapping_seek_hole_data.patch
mm-add-and-use-find_lock_entries.patch
mm-add-and-use-find_lock_entries-fix.patch
mm-add-an-end-parameter-to-find_get_entries.patch
mm-add-an-end-parameter-to-pagevec_lookup_entries.patch
mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch
mm-pass-pvec-directly-to-find_get_entries.patch
mm-remove-pagevec_lookup_entries.patch

