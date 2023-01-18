Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B0AC677F1
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 23:55:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjARXzq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 18:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjARXzk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 18:55:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8B520062
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 15:55:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDB5861913
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 23:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56532C433D2;
        Wed, 18 Jan 2023 23:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674086137;
        bh=TCLgEJjK4XciE732KnoT7L1RYDdlPnXfYfaGzKG9+Ac=;
        h=Date:To:From:Subject:From;
        b=TIEK83QIW5rkAoZN8Jrceti7mDgB65x8gJAyKQg7gtcHmoh8aH1/zh9WEVtCqGx2T
         vfz5k4+CJ70mdShLADiUmaTIi8s6iN3LC/gvNbRQ64MHz5V4SbAlSxBASIJcd621xh
         JAU+E3EkKN+7Bpd2t445BDRMoKoZieh0B9IpSe98=
Date:   Wed, 18 Jan 2023 15:55:36 -0800
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-uffd-detect-pgtable-allocation-failures-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20230118235537.56532C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-uffd-detect-pgtable-allocation-failures-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-uffd-detect-pgtable-allocation-failures-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-uffd-detect-pgtable-allocation-failures.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-uffd-detect-pgtable-allocation-failures-checkpatch-fixes
Date: Wed Jan  4 05:54:55 PM PST 2023

WARNING: Statements should start on a tabstop
#127: FILE: mm/mprotect.c:353:
+		  long err = 0;						\

WARNING: Statements should start on a tabstop
#128: FILE: mm/mprotect.c:354:
+		  if (unlikely(uffd_wp_protect_file(vma, cp_flags))) {	\

WARNING: suspect code indent for conditional statements (18, 26)
#128: FILE: mm/mprotect.c:354:
+		  if (unlikely(uffd_wp_protect_file(vma, cp_flags))) {	\
+			  low##_t *p = low##_alloc(vma->vm_mm, high, addr); \

ERROR: need consistent spacing around '*' (ctx:WxV)
#129: FILE: mm/mprotect.c:355:
+			  low##_t *p = low##_alloc(vma->vm_mm, high, addr); \
 			          ^

WARNING: Statements should start on a tabstop
#130: FILE: mm/mprotect.c:356:
+			  if (p == NULL)				\

WARNING: suspect code indent for conditional statements (26, 34)
#130: FILE: mm/mprotect.c:356:
+			  if (p == NULL)				\
+				  err = -ENOMEM;			\

total: 1 errors, 5 warnings, 219 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-uffd-detect-pgtable-allocation-failures.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mprotect.c~mm-uffd-detect-pgtable-allocation-failures-checkpatch-fixes
+++ a/mm/mprotect.c
@@ -350,14 +350,14 @@ uffd_wp_protect_file(struct vm_area_stru
  */
 #define  change_prepare(vma, high, low, addr, cp_flags)			\
 	  ({								\
-		  long err = 0;						\
-		  if (unlikely(uffd_wp_protect_file(vma, cp_flags))) {	\
-			  low##_t *p = low##_alloc(vma->vm_mm, high, addr); \
-			  if (p == NULL)				\
-				  err = -ENOMEM;			\
-		  }							\
-		  err;							\
-	  })
+		long err = 0;						\
+		if (unlikely(uffd_wp_protect_file(vma, cp_flags))) {	\
+			low##_t *p = low##_alloc(vma->vm_mm, high, addr); \
+			if (p == NULL)					\
+				err = -ENOMEM;				\
+		}							\
+		err;							\
+	})
 
 static inline long change_pmd_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, pud_t *pud, unsigned long addr,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close-checkpatch-fixes.patch
mm-uffd-detect-pgtable-allocation-failures.patch
mm-add-folio_add_new_anon_rmap-fix.patch
mm-remove-page_evictable-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch

