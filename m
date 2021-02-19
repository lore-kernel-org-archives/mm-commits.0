Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E68C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 19 Feb 2021 21:06:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E60864E67
	for <mm-commits@archiver.kernel.org>; Fri, 19 Feb 2021 21:06:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhBSVGQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Feb 2021 16:06:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:45118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229553AbhBSVGO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Feb 2021 16:06:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AAB56148E;
        Fri, 19 Feb 2021 21:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613768733;
        bh=cnfVSHXL7U/adQ1/jSIAWe5p8BuKGuw/7hzYtL0djyw=;
        h=Date:From:To:Subject:From;
        b=TSTeEc2fz60cU4HgWVCfPMGeUKyy98RQo3b+ZAo0/2/Xezd/eImseuWXKwzJdwH09
         VyqNJyNEmUpgdaplgMHIHAQYlZTzF5SxARgzcFFdzWigxPh8RgDSwaqhmeurCTlHwW
         rrom8Tfhr7YbbKM5fQJGaRG/dPlVdsMkotUzAmRk=
Date:   Fri, 19 Feb 2021 13:05:32 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com, nathan@kernel.org,
        willy@infradead.org
Subject:  [to-be-updated] mm-gfp-add-kernel-doc-for-gfp_t.patch
 removed from -mm tree
Message-ID: <20210219210532.tnvl5%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gfp: add kernel-doc for gfp_t
has been removed from the -mm tree.  Its filename was
     mm-gfp-add-kernel-doc-for-gfp_t.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/gfp: add kernel-doc for gfp_t

The generated html will link to the definition of the gfp_t automatically
once we define it.  Move the one-paragraph overview of GFP flags from the
documentation directory into gfp.h and pull gfp.h into the documentation.

Link: https://lkml.kernel.org/r/20210215204909.3824509-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/mm-api.rst |    7 ++-----
 include/linux/gfp.h               |   11 +++++++++++
 2 files changed, 13 insertions(+), 5 deletions(-)

--- a/Documentation/core-api/mm-api.rst~mm-gfp-add-kernel-doc-for-gfp_t
+++ a/Documentation/core-api/mm-api.rst
@@ -19,11 +19,8 @@ User Space Memory Access
 Memory Allocation Controls
 ==========================
 
-Functions which need to allocate memory often use GFP flags to express
-how that memory should be allocated. The GFP acronym stands for "get
-free pages", the underlying memory allocation function. Not every GFP
-flag is allowed to every function which may allocate memory. Most
-users will want to use a plain ``GFP_KERNEL``.
+.. kernel-doc:: include/linux/gfp.h
+   :internal:
 
 .. kernel-doc:: include/linux/gfp.h
    :doc: Page mobility and placement hints
--- a/include/linux/gfp.h~mm-gfp-add-kernel-doc-for-gfp_t
+++ a/include/linux/gfp.h
@@ -8,6 +8,17 @@
 #include <linux/linkage.h>
 #include <linux/topology.h>
 
+/**
+ * typedef gfp_t - Memory allocation flags.
+ *
+ * GFP flags are commonly used throughout Linux to indicate how memory
+ * should be allocated.  The GFP acronym stands for "get free pages",
+ * the underlying memory allocation function.  Not every GFP flag is
+ * supported by every function which may allocate memory.  Most users
+ * will want to use a plain ``GFP_KERNEL``.
+ */
+typedef unsigned int __bitwise gfp_t;	// repeated here for kernel-doc
+
 struct vm_area_struct;
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are

mm-debug-improve-memcg-debugging.patch
mm-filemap-rename-generic_file_buffered_read-subfunctions.patch
mm-filemap-remove-dynamically-allocated-array-from-filemap_read.patch
mm-filemap-convert-filemap_get_pages-to-take-a-pagevec.patch
mm-filemap-use-head-pages-in-generic_file_buffered_read.patch
mm-filemap-pass-a-sleep-state-to-put_and_wait_on_page_locked.patch
mm-filemap-support-readpage-splitting-a-page.patch
mm-filemap-inline-__wait_on_page_locked_async-into-caller.patch
mm-filemap-dont-call-readpage-if-iocb_waitq-is-set.patch
mm-filemap-change-filemap_read_page-calling-conventions.patch
mm-filemap-change-filemap_create_page-calling-conventions.patch
mm-filemap-convert-filemap_update_page-to-return-an-errno.patch
mm-filemap-move-the-iocb-checks-into-filemap_update_page.patch
mm-filemap-add-filemap_range_uptodate.patch
mm-filemap-add-filemap_range_uptodate-fix.patch
mm-filemap-split-filemap_readahead-out-of-filemap_get_pages.patch
mm-filemap-restructure-filemap_get_pages.patch
mm-filemap-dont-relock-the-page-after-calling-readpage.patch
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

