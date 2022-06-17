Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FCBC43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379810AbiFQCtg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379800AbiFQCtY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:49:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120C965406
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:49:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9939561D23
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED14EC34114;
        Fri, 17 Jun 2022 02:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434162;
        bh=CgtHiplCvwwva11Bof8TKAd67N2Qzqdgy8wqAsQceu0=;
        h=Date:To:From:Subject:From;
        b=ZUvCyRmGNw77BlcR9F27hztfCYqzKdXdZ4NwQmxTY8aqisEOcV1imdqzkoDQh7BN3
         ySAZdPw+b62WZUp5fSlgBN7yxwPnNSAckTyPuxklnh/17SroO1x6hxmtlvtfKURgjD
         /8xmn8uSqczGT8p+VG8ZhKv0KRCyr0hicT6tRjoY=
Date:   Thu, 16 Jun 2022 19:49:21 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, hch@infradead.org,
        bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-invoke-classify_va_fit_type-in-adjust_va_to_fit_type.patch removed from -mm tree
Message-Id: <20220617024921.ED14EC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc: invoke classify_va_fit_type() in adjust_va_to_fit_type()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-invoke-classify_va_fit_type-in-adjust_va_to_fit_type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3735,7 +3729,6 @@ struct vm_struct **pcpu_get_vm_areas(con
 	int area, area2, last_area, term_area;
 	unsigned long base, start, size, end, last_end, orig_start, orig_end;
 	bool purged = false;
-	enum fit_type type;
 
 	/* verify parameters and allocate data structures */
 	BUG_ON(offset_in_page(align) || !is_power_of_2(align));
@@ -3846,15 +3839,11 @@ retry:
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


