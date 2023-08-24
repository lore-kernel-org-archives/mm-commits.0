Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F411C727C0
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244140AbjHXXWi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244111AbjHXXWH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:22:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294CFA1
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:22:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2E0964FED
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039A4C433C7;
        Thu, 24 Aug 2023 23:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919324;
        bh=CAjPAtJsbcHz1ILe74dPPLfVdaGqzKyvi1TvGO0hxCM=;
        h=Date:To:From:Subject:From;
        b=i2v+lWefvGcVc4OtBt1S6KepiYL1IM/nQGHHioD+D7Z6VJhYbyuR1Pgf8AgsgeiDR
         dAWLCrqfq8c/kclf6xjuGSKuH9rA8EhiSc5VU4+56XC33TQhLaFag1lGbIOlCBz4mo
         8LR+OFrObjURSKxx6VJoBgjpXRoY52pwxuG4FZ8I=
Date:   Thu, 24 Aug 2023 16:22:03 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vitaly.wool@konsulko.com, sjenning@redhat.com, peterx@redhat.com,
        hughd@google.com, ddstreet@ieee.org, david@redhat.com,
        chrisl@kernel.org, catalin.marinas@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-use-dedicated-entry-for-swap-in-folio.patch removed from -mm tree
Message-Id: <20230824232204.039A4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: use dedicated entry for swap in folio
has been removed from the -mm tree.  Its filename was
     mm-swap-use-dedicated-entry-for-swap-in-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm/swap: use dedicated entry for swap in folio
Date: Mon, 21 Aug 2023 18:08:47 +0200

Let's stop working on the private field and use an explicit swap field. 
We have to move the swp_entry_t typedef.

Link: https://lkml.kernel.org/r/20230821160849.531668-3-david@redhat.com
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Chris Li <chrisl@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   23 +++++++++++++----------
 include/linux/swap.h     |    5 ++---
 2 files changed, 15 insertions(+), 13 deletions(-)

--- a/include/linux/mm_types.h~mm-swap-use-dedicated-entry-for-swap-in-folio
+++ a/include/linux/mm_types.h
@@ -248,6 +248,14 @@ static inline struct page *encoded_page_
 	return (struct page *)(~ENCODE_PAGE_BITS & (unsigned long)page);
 }
 
+/*
+ * A swap entry has to fit into a "unsigned long", as the entry is hidden
+ * in the "index" field of the swapper address space.
+ */
+typedef struct {
+	unsigned long val;
+} swp_entry_t;
+
 /**
  * struct folio - Represents a contiguous set of bytes.
  * @flags: Identical to the page flags.
@@ -258,7 +266,7 @@ static inline struct page *encoded_page_
  * @index: Offset within the file, in units of pages.  For anonymous memory,
  *    this is the index from the beginning of the mmap.
  * @private: Filesystem per-folio data (see folio_attach_private()).
- *    Used for swp_entry_t if folio_test_swapcache().
+ * @swap: Used for swp_entry_t if folio_test_swapcache().
  * @_mapcount: Do not access this member directly.  Use folio_mapcount() to
  *    find out how many times this folio is mapped by userspace.
  * @_refcount: Do not access this member directly.  Use folio_ref_count()
@@ -301,7 +309,10 @@ struct folio {
 			};
 			struct address_space *mapping;
 			pgoff_t index;
-			void *private;
+			union {
+				void *private;
+				swp_entry_t swap;
+			};
 			atomic_t _mapcount;
 			atomic_t _refcount;
 #ifdef CONFIG_MEMCG
@@ -1209,14 +1220,6 @@ enum tlb_flush_reason {
 	NR_TLB_FLUSH_REASONS,
 };
 
- /*
-  * A swap entry has to fit into a "unsigned long", as the entry is hidden
-  * in the "index" field of the swapper address space.
-  */
-typedef struct {
-	unsigned long val;
-} swp_entry_t;
-
 /**
  * enum fault_flag - Fault flag definitions.
  * @FAULT_FLAG_WRITE: Fault was a write fault.
--- a/include/linux/swap.h~mm-swap-use-dedicated-entry-for-swap-in-folio
+++ a/include/linux/swap.h
@@ -335,8 +335,7 @@ struct swap_info_struct {
 
 static inline swp_entry_t folio_swap_entry(struct folio *folio)
 {
-	swp_entry_t entry = { .val = page_private(&folio->page) };
-	return entry;
+	return folio->swap;
 }
 
 static inline swp_entry_t page_swap_entry(struct page *page)
@@ -350,7 +349,7 @@ static inline swp_entry_t page_swap_entr
 
 static inline void folio_set_swap_entry(struct folio *folio, swp_entry_t entry)
 {
-	folio->private = (void *)entry.val;
+	folio->swap = entry;
 }
 
 /* linux/mm/workingset.c */
_

Patches currently in -mm which might be from willy@infradead.org are


