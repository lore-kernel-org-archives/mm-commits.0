Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D03D0C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA8DF6100C
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhEHWrE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:47:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhEHWrD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:47:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83D8C613C5;
        Sat,  8 May 2021 22:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513961;
        bh=xlsMvXaQdsb0iWwBi3ZV9wBLTTdgo32D0gI8aZSwF+U=;
        h=Date:From:To:Subject:From;
        b=HyEuFfnAhPaqXKEVUlDQTJYilVqiBZ4+3wI9ADPGlkxm2RTHFBdl//f5h040QWvog
         4HO78oVTR/QdxF3GI2zSIPSbaeXrzLIdgWyPUUtWFjbLOEdmaochKrwOd9Jx4qeNBK
         bETQzfCgeFeybB9WDX1832SeN8RfPJdZ+ML7uZBc=
Date:   Sat, 08 May 2021 15:46:01 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mm-commits@vger.kernel.org,
        vishal.l.verma@intel.com, willy@infradead.org
Subject:  [merged] dax-account-dax-entries-as-nrpages.patch removed
 from -mm tree
Message-ID: <20210508224601.g6c8d7xTi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dax: account DAX entries as nrpages
has been removed from the -mm tree.  Its filename was
     dax-account-dax-entries-as-nrpages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


