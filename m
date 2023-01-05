Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57BBEC46467
	for <mm-commits@archiver.kernel.org>; Thu,  5 Jan 2023 01:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjAEB4a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Jan 2023 20:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjAEB4O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2023 20:56:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8940F2F798
        for <mm-commits@vger.kernel.org>; Wed,  4 Jan 2023 17:56:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40117B81716
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 01:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93F4C433D2;
        Thu,  5 Jan 2023 01:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672883770;
        bh=8PaZlN3y0vVGlvplNN853Nclm/HH8ocs+icgt9/OO48=;
        h=Date:To:From:Subject:From;
        b=zru8uhvazeL68HwkZ7+qGOIbI5ra34l85h6RBk1qUjiGyqN1AvZ9MM57YsOBrILeH
         LcpfSwnXogLcp9SXrhX2I0VCnkVpr7cMtovV1EFPJa686PqiMGgbGDDJwi+N6DUCYS
         m1DGJTaQHML7pIppDT9QYh5mO3HF9kAFaiHdcko8=
Date:   Wed, 04 Jan 2023 17:56:09 -0800
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-uffd-detect-pgtable-allocation-failures-checkpatch-fixes.patch added to mm-unstable branch
Message-Id: <20230105015609.E93F4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-uffd-detect-pgtable-allocation-failures-checkpatch-fixes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-uffd-detect-pgtable-allocation-failures-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-uffd-detect-pgtable-allocation-failures-checkpatch-fixes.patch

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

 mm/mprotect.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

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

mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix.patch
mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes.patch
mm-memcontrol-deprecate-charge-moving-fix.patch
mm-swap-convert-deactivate_page-to-folio_deactivate-fix.patch
mm-uffd-detect-pgtable-allocation-failures-checkpatch-fixes.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch

