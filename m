Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 912F0C636D7
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbjBJA5q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:57:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbjBJA4L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:56:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5AE7095D
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77EE061C3D
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82B6C433D2;
        Fri, 10 Feb 2023 00:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990481;
        bh=TtmLltmXJ/8cMpeZcItcQfntSEd6o2ASXyP//a2SC+k=;
        h=Date:To:From:Subject:From;
        b=1WBQ5JbBtreSH8rw/GCrJMZLYmIWQtFtPYqMSrw6G7sJcHbHl+C22mV6Vjkg+tOej
         KGVI15JkyWjfuusFEIs6hVCJjVkAGbRArJrjgda8rJM27wh0qS+qFUxOP3LuVLKzsw
         5nDvu59HB6phT/hWpN3yh0MbVGGi0WhrkygNW/9I=
Date:   Thu, 09 Feb 2023 16:54:41 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, jhubbard@nvidia.com,
        imbrenda@linux.ibm.com, hch@infradead.org, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, jgg@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-remove-pin_user_pages_fast_only.patch removed from -mm tree
Message-Id: <20230210005441.C82B6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: remove pin_user_pages_fast_only()
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-pin_user_pages_fast_only.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm/gup: remove pin_user_pages_fast_only()
Date: Tue, 24 Jan 2023 16:34:31 -0400

Commit ed29c2691188 ("drm/i915: Fix userptr so we do not have to worry
about obj->mm.lock, v7.") removed the only caller, remove this dead code
too.

Link: https://lkml.kernel.org/r/10-v2-987e91b59705+36b-gup_tidy_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 --
 mm/gup.c           |   33 ---------------------------------
 2 files changed, 35 deletions(-)

--- a/include/linux/mm.h~mm-gup-remove-pin_user_pages_fast_only
+++ a/include/linux/mm.h
@@ -2261,8 +2261,6 @@ extern int mprotect_fixup(struct vma_ite
  */
 int get_user_pages_fast_only(unsigned long start, int nr_pages,
 			     unsigned int gup_flags, struct page **pages);
-int pin_user_pages_fast_only(unsigned long start, int nr_pages,
-			     unsigned int gup_flags, struct page **pages);
 
 static inline bool get_user_page_fast_only(unsigned long addr,
 			unsigned int gup_flags, struct page **pagep)
--- a/mm/gup.c~mm-gup-remove-pin_user_pages_fast_only
+++ a/mm/gup.c
@@ -3102,39 +3102,6 @@ int pin_user_pages_fast(unsigned long st
 }
 EXPORT_SYMBOL_GPL(pin_user_pages_fast);
 
-/*
- * This is the FOLL_PIN equivalent of get_user_pages_fast_only(). Behavior
- * is the same, except that this one sets FOLL_PIN instead of FOLL_GET.
- *
- * The API rules are the same, too: no negative values may be returned.
- */
-int pin_user_pages_fast_only(unsigned long start, int nr_pages,
-			     unsigned int gup_flags, struct page **pages)
-{
-	int nr_pinned;
-
-	/*
-	 * FOLL_FAST_ONLY is required in order to match the API description of
-	 * this routine: no fall back to regular ("slow") GUP.
-	 */
-	if (!is_valid_gup_args(pages, NULL, NULL, &gup_flags,
-			       FOLL_PIN | FOLL_FAST_ONLY))
-		return 0;
-
-	nr_pinned = internal_get_user_pages_fast(start, nr_pages, gup_flags,
-						 pages);
-	/*
-	 * This routine is not allowed to return negative values. However,
-	 * internal_get_user_pages_fast() *can* return -errno. Therefore,
-	 * correct for that here:
-	 */
-	if (nr_pinned < 0)
-		nr_pinned = 0;
-
-	return nr_pinned;
-}
-EXPORT_SYMBOL_GPL(pin_user_pages_fast_only);
-
 /**
  * pin_user_pages_remote() - pin pages of a remote process
  *
_

Patches currently in -mm which might be from jgg@nvidia.com are


