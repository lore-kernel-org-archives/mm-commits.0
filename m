Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B10BC433DB
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 23:27:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E92AA64F06
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 23:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhCOX0a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 19:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231236AbhCOX0V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 19:26:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F091464F5C;
        Mon, 15 Mar 2021 23:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615850781;
        bh=oVPENfLUYALrt/kNZ1peDqXlJBq/sIKWpzyShERsdJw=;
        h=Date:From:To:Subject:From;
        b=japxfzLu44WY0mWz62mbT7erARwaklfh3q4FM9UCKleFYpnRe9AL1+5TBxpMksrn8
         YXkUnNcIvj4xeNs5LEhvTZ0f/PYa+xgZirrtJjx1lcHtcKUW7tSnD4tt/qpGo+wj9p
         EKQ1/laO81P7H+2OFYqH4V5Enx0BLM+Xb8EAfKu4=
Date:   Mon, 15 Mar 2021 16:26:20 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mm-commits@vger.kernel.org,
        vishal.l.verma@intel.com, willy@infradead.org
Subject:  + dax-account-dax-entries-as-nrpages.patch added to -mm
 tree
Message-ID: <20210315232620.KFiB-aZaX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dax: account DAX entries as nrpages
has been added to the -mm tree.  Its filename is
     dax-account-dax-entries-as-nrpages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/dax-account-dax-entries-as-nrpages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/dax-account-dax-entries-as-nrpages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: dax: account DAX entries as nrpages

Simplify mapping_needs_writeback() by accounting DAX entries as pages
instead of exceptional entries.

Link: https://lkml.kernel.org/r/20201026151849.24232-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Vishal Verma <vishal.l.verma@intel.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c     |    6 +++---
 mm/filemap.c |    3 ---
 2 files changed, 3 insertions(+), 6 deletions(-)

--- a/fs/dax.c~dax-account-dax-entries-as-nrpages
+++ a/fs/dax.c
@@ -525,7 +525,7 @@ retry:
 		dax_disassociate_entry(entry, mapping, false);
 		xas_store(xas, NULL);	/* undo the PMD join */
 		dax_wake_entry(xas, entry, true);
-		mapping->nrexceptional--;
+		mapping->nrpages -= PG_PMD_NR;
 		entry = NULL;
 		xas_set(xas, index);
 	}
@@ -541,7 +541,7 @@ retry:
 		dax_lock_entry(xas, entry);
 		if (xas_error(xas))
 			goto out_unlock;
-		mapping->nrexceptional++;
+		mapping->nrpages += 1UL << order;
 	}
 
 out_unlock:
@@ -661,7 +661,7 @@ static int __dax_invalidate_entry(struct
 		goto out;
 	dax_disassociate_entry(entry, mapping, trunc);
 	xas_store(&xas, NULL);
-	mapping->nrexceptional--;
+	mapping->nrpages -= 1UL << dax_entry_order(entry);
 	ret = 1;
 out:
 	put_unlocked_entry(&xas, entry);
--- a/mm/filemap.c~dax-account-dax-entries-as-nrpages
+++ a/mm/filemap.c
@@ -618,9 +618,6 @@ EXPORT_SYMBOL(filemap_fdatawait_keep_err
 /* Returns true if writeback might be needed or already in progress. */
 static bool mapping_needs_writeback(struct address_space *mapping)
 {
-	if (dax_mapping(mapping))
-		return mapping->nrexceptional;
-
 	return mapping->nrpages;
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-filemap-use-filemap_read_page-in-filemap_fault.patch
mm-filemap-drop-check-for-truncated-page-after-i-o.patch
mm-introduce-and-use-mapping_empty.patch
mm-stop-accounting-shadow-entries.patch
dax-account-dax-entries-as-nrpages.patch
mm-remove-nrexceptional-from-inode.patch
mm-page_alloc-rename-alloc_mask-to-alloc_gfp.patch
mm-page_alloc-rename-gfp_mask-to-gfp.patch
mm-page_alloc-combine-__alloc_pages-and-__alloc_pages_nodemask.patch
mm-mempolicy-rename-alloc_pages_current-to-alloc_pages.patch
mm-mempolicy-rewrite-alloc_pages-documentation.patch
mm-mempolicy-rewrite-alloc_pages_vma-documentation.patch
mm-mempolicy-fix-mpol_misplaced-kernel-doc.patch
include-remove-pagemaph-from-blkdevh.patch

