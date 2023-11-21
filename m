Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CED4C61D97
	for <mm-commits@archiver.kernel.org>; Tue, 21 Nov 2023 23:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjKUXBw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Nov 2023 18:01:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234736AbjKUXBw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2023 18:01:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6218590
        for <mm-commits@vger.kernel.org>; Tue, 21 Nov 2023 15:01:47 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000CDC433C8;
        Tue, 21 Nov 2023 23:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700607707;
        bh=XE2dATS3YPZixBonCIsOqz4WLl+JYCQIcOYfq2HMxTI=;
        h=Date:To:From:Subject:From;
        b=w990NDv998JhqX9W1scbap6vmPr6XgXHf1laer7ol9xyDGe5Dvjb825eINJmNisRc
         O4JR28d/tzVofjKdZ5ZTQs7ToAQgjXrp3209PUdKSPl3ZCkjinAjSkyA/BWiOrD7H7
         uB0c+L497fUMKo1lC029QoiPSr6AIso+ti5Per6I=
Date:   Tue, 21 Nov 2023 15:01:46 -0800
To:     mm-commits@vger.kernel.org, vishal.moola@gmail.com,
        hca@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + pgtable-fix-s390-ptdesc-field-comments.patch added to mm-unstable branch
Message-Id: <20231121230147.000CDC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: pgtable: fix s390 ptdesc field comments
has been added to the -mm mm-unstable branch.  Its filename is
     pgtable-fix-s390-ptdesc-field-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pgtable-fix-s390-ptdesc-field-comments.patch

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
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: pgtable: fix s390 ptdesc field comments
Date: Tue, 21 Nov 2023 20:43:49 +0100

Patch series "minor ptdesc updates", v3.


This patch (of 2):

Since commit d08d4e7cd6bf ("s390/mm: use full 4KB page for 2KB PTE") there
is no fragmented page tracking on s390.  Fix the corresponding comments.

Link: https://lkml.kernel.org/r/cover.1700594815.git.agordeev@linux.ibm.com
Link: https://lkml.kernel.org/r/2eead241f3a45bed26c7911cf66bded1e35670b8.1700594815.git.agordeev@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mm_types.h~pgtable-fix-s390-ptdesc-field-comments
+++ a/include/linux/mm_types.h
@@ -401,11 +401,11 @@ FOLIO_MATCH(compound_head, _head_2a);
  * @pmd_huge_pte:     Protected by ptdesc->ptl, used for THPs.
  * @__page_mapping:   Aliases with page->mapping. Unused for page tables.
  * @pt_mm:            Used for x86 pgds.
- * @pt_frag_refcount: For fragmented page table tracking. Powerpc and s390 only.
+ * @pt_frag_refcount: For fragmented page table tracking. Powerpc only.
  * @_pt_pad_2:        Padding to ensure proper alignment.
  * @ptl:              Lock for the page table.
  * @__page_type:      Same as page->page_type. Unused for page tables.
- * @_refcount:        Same as page refcount. Used for s390 page tables.
+ * @_refcount:        Same as page refcount.
  * @pt_memcg_data:    Memcg data. Tracked for page tables here.
  *
  * This struct overlays struct page for now. Do not modify without a good
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are

pgtable-fix-s390-ptdesc-field-comments.patch
pgtable-rename-ptdesc-_refcount-field-to-__page_refcount.patch

