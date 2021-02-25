Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EF17C433E6
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFE5764F3C
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbhBYTbG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:31:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:36920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234554AbhBYT16 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:27:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC5FB64F92;
        Thu, 25 Feb 2021 19:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280585;
        bh=q7Tjv15UBUhA/v5NChddYnHn673rCwqOJVkHZDHRHJI=;
        h=Date:From:To:Subject:From;
        b=Te9EPJAPthnfi59QvrMYw/E4P43o59AXRkF17ALJIBN++bARkFb9I00M3gyyt4gmX
         SY0orn6+ddoNoStapJl9cb23FA38w2diyXCIAOziiW6wyJWGkrb1/JdQtrmC9sauZU
         XfwiYaFbt/ridU4X+Hn09L8jbWLSK3OYyXkHvmD8=
Date:   Thu, 25 Feb 2021 11:16:24 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, nathan@kernel.org, rppt@linux.ibm.com,
        willy@infradead.org
Subject:  [merged] mm-gfp-add-kernel-doc-for-gfp_t.patch removed
 from -mm tree
Message-ID: <20210225191624.FQMl_t_tz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gfp: add kernel-doc for gfp_t
has been removed from the -mm tree.  Its filename was
     mm-gfp-add-kernel-doc-for-gfp_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/gfp: add kernel-doc for gfp_t

The generated html will link to the definition of the gfp_t automatically
once we define it.  Move the one-paragraph overview of GFP flags from the
documentation directory into gfp.h and pull gfp.h into the documentation.

This generates warnings with clang
(https://lkml.kernel.org/r/20210219195509.GA59987@24bbad8f3778), so
use a #if 0 to hide it from the compiler for now.

Link: https://lkml.kernel.org/r/20210215204909.3824509-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20210220003049.GZ2858050@casper.infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/mm-api.rst |    7 ++-----
 include/linux/gfp.h               |   14 ++++++++++++++
 2 files changed, 16 insertions(+), 5 deletions(-)

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
@@ -8,6 +8,20 @@
 #include <linux/linkage.h>
 #include <linux/topology.h>
 
+/* The typedef is in types.h but we want the documentation here */
+#if 0
+/**
+ * typedef gfp_t - Memory allocation flags.
+ *
+ * GFP flags are commonly used throughout Linux to indicate how memory
+ * should be allocated.  The GFP acronym stands for get_free_pages(),
+ * the underlying memory allocation function.  Not every GFP flag is
+ * supported by every function which may allocate memory.  Most users
+ * will want to use a plain ``GFP_KERNEL``.
+ */
+typedef unsigned int __bitwise gfp_t;
+#endif
+
 struct vm_area_struct;
 
 /*
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

