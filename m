Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2655ECCA486
	for <mm-commits@archiver.kernel.org>; Fri,  3 Jun 2022 18:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbiFCSQ4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Jun 2022 14:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348507AbiFCSQp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2022 14:16:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7BE64D2F
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 11:04:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71F29B82189
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 18:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ABA2C385A9;
        Fri,  3 Jun 2022 18:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654279453;
        bh=xuRJJD03Tig9tbqsJ8QdMviCao6pt/kSrvL+E6YDy6c=;
        h=Date:To:From:Subject:From;
        b=PlAHxkn+fXGZSpe9dNdVSyarUoPE39f8fPs91yzZCaql7wc+ja5al6552FYPcaXi1
         RE/s4I071HVAK8+QkCkuxpHQyZLC2mnJ7pgsUaxaCJLvUAcF9hyleLCHhEOE1c2thv
         Z6f7Bn7tBJBka1mRdJWmgSGiRLlHpMtNH88u130M=
Date:   Fri, 03 Jun 2022 11:04:12 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, riteshh@linux.ibm.com, rgoldwyn@suse.de,
        rgoldwyn@suse.com, naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        jane.chu@oracle.com, hch@lst.de, djwong@kernel.org,
        david@fromorbit.com, dan.j.williams@intel.com,
        dan.j.wiliams@intel.com, ruansy.fnst@fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fsdax-set-a-cow-flag-when-associate-reflink-mappings.patch added to mm-unstable branch
Message-Id: <20220603180413.2ABA2C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fsdax: set a CoW flag when associate reflink mappings
has been added to the -mm mm-unstable branch.  Its filename is
     fsdax-set-a-cow-flag-when-associate-reflink-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsdax-set-a-cow-flag-when-associate-reflink-mappings.patch

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
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: fsdax: set a CoW flag when associate reflink mappings
Date: Fri, 3 Jun 2022 13:37:31 +0800

Introduce a PAGE_MAPPING_DAX_COW flag to support association with CoW file
mappings.  In this case, since the dax-rmap has already took the
responsibility to look up for shared files by given dax page, the
page->mapping is no longer to used for rmap but for marking that this dax
page is shared.  And to make sure disassociation works fine, we use
page->index as refcount, and clear page->mapping to the initial state when
page->index is decreased to 0.

With the help of this new flag, it is able to distinguish normal case and
CoW case, and keep the warning in normal case.

Link: https://lkml.kernel.org/r/20220603053738.1218681-8-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.wiliams@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Ritesh Harjani <riteshh@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c                   |   50 ++++++++++++++++++++++++++++-------
 include/linux/page-flags.h |    6 ++++
 2 files changed, 47 insertions(+), 9 deletions(-)

--- a/fs/dax.c~fsdax-set-a-cow-flag-when-associate-reflink-mappings
+++ a/fs/dax.c
@@ -334,13 +334,35 @@ static unsigned long dax_end_pfn(void *e
 	for (pfn = dax_to_pfn(entry); \
 			pfn < dax_end_pfn(entry); pfn++)
 
+static inline bool dax_mapping_is_cow(struct address_space *mapping)
+{
+	return (unsigned long)mapping == PAGE_MAPPING_DAX_COW;
+}
+
 /*
- * TODO: for reflink+dax we need a way to associate a single page with
- * multiple address_space instances at different linear_page_index()
- * offsets.
+ * Set the page->mapping with FS_DAX_MAPPING_COW flag, increase the refcount.
+ */
+static inline void dax_mapping_set_cow(struct page *page)
+{
+	if ((uintptr_t)page->mapping != PAGE_MAPPING_DAX_COW) {
+		/*
+		 * Reset the index if the page was already mapped
+		 * regularly before.
+		 */
+		if (page->mapping)
+			page->index = 1;
+		page->mapping = (void *)PAGE_MAPPING_DAX_COW;
+	}
+	page->index++;
+}
+
+/*
+ * When it is called in dax_insert_entry(), the cow flag will indicate that
+ * whether this entry is shared by multiple files.  If so, set the page->mapping
+ * FS_DAX_MAPPING_COW, and use page->index as refcount.
  */
 static void dax_associate_entry(void *entry, struct address_space *mapping,
-		struct vm_area_struct *vma, unsigned long address)
+		struct vm_area_struct *vma, unsigned long address, bool cow)
 {
 	unsigned long size = dax_entry_size(entry), pfn, index;
 	int i = 0;
@@ -352,9 +374,13 @@ static void dax_associate_entry(void *en
 	for_each_mapped_pfn(entry, pfn) {
 		struct page *page = pfn_to_page(pfn);
 
-		WARN_ON_ONCE(page->mapping);
-		page->mapping = mapping;
-		page->index = index + i++;
+		if (cow) {
+			dax_mapping_set_cow(page);
+		} else {
+			WARN_ON_ONCE(page->mapping);
+			page->mapping = mapping;
+			page->index = index + i++;
+		}
 	}
 }
 
@@ -370,7 +396,12 @@ static void dax_disassociate_entry(void
 		struct page *page = pfn_to_page(pfn);
 
 		WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
-		WARN_ON_ONCE(page->mapping && page->mapping != mapping);
+		if (dax_mapping_is_cow(page->mapping)) {
+			/* keep the CoW flag if this page is still shared */
+			if (page->index-- > 0)
+				continue;
+		} else
+			WARN_ON_ONCE(page->mapping && page->mapping != mapping);
 		page->mapping = NULL;
 		page->index = 0;
 	}
@@ -830,7 +861,8 @@ static void *dax_insert_entry(struct xa_
 		void *old;
 
 		dax_disassociate_entry(entry, mapping, false);
-		dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address);
+		dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address,
+				false);
 		/*
 		 * Only swap our new entry into the page cache if the current
 		 * entry is a zero page or an empty entry.  If a normal PTE or
--- a/include/linux/page-flags.h~fsdax-set-a-cow-flag-when-associate-reflink-mappings
+++ a/include/linux/page-flags.h
@@ -650,6 +650,12 @@ __PAGEFLAG(Reported, reported, PF_NO_COM
 #define PAGE_MAPPING_KSM	(PAGE_MAPPING_ANON | PAGE_MAPPING_MOVABLE)
 #define PAGE_MAPPING_FLAGS	(PAGE_MAPPING_ANON | PAGE_MAPPING_MOVABLE)
 
+/*
+ * Different with flags above, this flag is used only for fsdax mode.  It
+ * indicates that this page->mapping is now under reflink case.
+ */
+#define PAGE_MAPPING_DAX_COW	0x1
+
 static __always_inline bool folio_mapping_flags(struct folio *folio)
 {
 	return ((unsigned long)folio->mapping & PAGE_MAPPING_FLAGS) != 0;
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are

dax-introduce-holder-for-dax_device.patch
mm-factor-helpers-for-memory_failure_dev_pagemap.patch
pagemappmem-introduce-memory_failure.patch
fsdax-introduce-dax_lock_mapping_entry.patch
mm-introduce-mf_dax_kill_procs-for-fsdax-case.patch
xfs-implement-notify_failure-for-xfs.patch
fsdax-set-a-cow-flag-when-associate-reflink-mappings.patch
fsdax-output-address-in-dax_iomap_pfn-and-rename-it.patch
fsdax-introduce-dax_iomap_cow_copy.patch
fsdax-replace-mmap-entry-in-case-of-cow.patch
fsdax-add-dax_iomap_cow_copy-for-dax-zero.patch
fsdax-dedup-file-range-to-use-a-compare-function.patch
xfs-support-cow-in-fsdax-mode.patch
xfs-add-dax-dedupe-support.patch

