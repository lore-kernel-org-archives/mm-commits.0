Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D27C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Jun 2022 01:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237867AbiFHBKt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Jun 2022 21:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1585269AbiFGXt3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2022 19:49:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66C927852A
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 15:32:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7ABDB82461
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 22:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B8FC3411C;
        Tue,  7 Jun 2022 22:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654641134;
        bh=k20VtQ+O+tNfnH3qLR7wQrY0dpgmBkNgICnLSsIq2VI=;
        h=Date:To:From:Subject:From;
        b=SqeoXF8B72N6dv1BV3GG3rr+T3NjpaFPZfaclTGDFl8eX3jPAVdtiY2ENot9x3ekn
         d1544yVPJJd44avYTExsq1ZWZNI8I5ljETrAgjLrfVTUG+U7si7ltEvWJssnXeIBmk
         g5hzo1BQKmGjoUIz26auE4DwVG5MNnvzCdiHcjeo=
Date:   Tue, 07 Jun 2022 15:32:13 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, hch@infradead.org,
        bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-invoke-classify_va_fit_type-in-adjust_va_to_fit_type.patch added to mm-unstable branch
Message-Id: <20220607223214.57B8FC3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: invoke classify_va_fit_type() in adjust_va_to_fit_type()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-invoke-classify_va_fit_type-in-adjust_va_to_fit_type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-invoke-classify_va_fit_type-in-adjust_va_to_fit_type.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc: invoke classify_va_fit_type() in adjust_va_to_fit_type()
Date: Tue, 7 Jun 2022 18:59:55 +0800

Patch series "Cleanup patches of vmalloc", v2.

Some cleanup patches found when reading vmalloc code.


This patch (of 4):

adjust_va_to_fit_type() checks all values of passed in fit type, including
NOTHING_FIT in the else branch.  However, the check of NOTHING_FIT has
been done inside adjust_va_to_fit_type() and before it's called in all
call sites.

In fact, both of these functions are coupled tightly, since
classify_va_fit_type() is doing the preparation work for
adjust_va_to_fit_type().  So putting invocation of classify_va_fit_type()
inside adjust_va_to_fit_type() can simplify code logic and the redundant
check of NOTHING_FIT issue will go away.

Link: https://lkml.kernel.org/r/20220607105958.382076-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20220607105958.382076-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Suggested-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-invoke-classify_va_fit_type-in-adjust_va_to_fit_type
+++ a/mm/vmalloc.c
@@ -1335,10 +1335,10 @@ classify_va_fit_type(struct vmap_area *v
 
 static __always_inline int
 adjust_va_to_fit_type(struct vmap_area *va,
-	unsigned long nva_start_addr, unsigned long size,
-	enum fit_type type)
+	unsigned long nva_start_addr, unsigned long size)
 {
 	struct vmap_area *lva = NULL;
+	enum fit_type type = classify_va_fit_type(va, nva_start_addr, size);
 
 	if (type == FL_FIT_TYPE) {
 		/*
@@ -1444,7 +1444,6 @@ __alloc_vmap_area(unsigned long size, un
 	bool adjust_search_size = true;
 	unsigned long nva_start_addr;
 	struct vmap_area *va;
-	enum fit_type type;
 	int ret;
 
 	/*
@@ -1472,14 +1471,9 @@ __alloc_vmap_area(unsigned long size, un
 	if (nva_start_addr + size > vend)
 		return vend;
 
-	/* Classify what we have found. */
-	type = classify_va_fit_type(va, nva_start_addr, size);
-	if (WARN_ON_ONCE(type == NOTHING_FIT))
-		return vend;
-
 	/* Update the free vmap_area. */
-	ret = adjust_va_to_fit_type(va, nva_start_addr, size, type);
-	if (ret)
+	ret = adjust_va_to_fit_type(va, nva_start_addr, size);
+	if (WARN_ON_ONCE(ret))
 		return vend;
 
 #if DEBUG_AUGMENT_LOWEST_MATCH_CHECK
@@ -3734,7 +3728,6 @@ struct vm_struct **pcpu_get_vm_areas(con
 	int area, area2, last_area, term_area;
 	unsigned long base, start, size, end, last_end, orig_start, orig_end;
 	bool purged = false;
-	enum fit_type type;
 
 	/* verify parameters and allocate data structures */
 	BUG_ON(offset_in_page(align) || !is_power_of_2(align));
@@ -3845,15 +3838,11 @@ retry:
 			/* It is a BUG(), but trigger recovery instead. */
 			goto recovery;
 
-		type = classify_va_fit_type(va, start, size);
-		if (WARN_ON_ONCE(type == NOTHING_FIT))
+		ret = adjust_va_to_fit_type(va, start, size);
+		if (WARN_ON_ONCE(unlikely(ret)))
 			/* It is a BUG(), but trigger recovery instead. */
 			goto recovery;
 
-		ret = adjust_va_to_fit_type(va, start, size, type);
-		if (unlikely(ret))
-			goto recovery;
-
 		/* Allocated area. */
 		va = vas[area];
 		va->va_start = start;
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmalloc-invoke-classify_va_fit_type-in-adjust_va_to_fit_type.patch
mm-vmalloc-remove-the-redundant-boundary-check.patch
mm-vmalloc-fix-typo-in-local-variable-name.patch
mm-vmalloc-add-code-comment-for-find_vmap_area_exceed_addr.patch

