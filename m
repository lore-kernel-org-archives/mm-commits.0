Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F10AC4167D
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 22:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbiDYWYg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 18:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343710AbiDYWSZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 18:18:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513F42BF3
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 15:15:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1106B818FA
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 22:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561D0C385A4;
        Mon, 25 Apr 2022 22:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650924916;
        bh=JCQ7nutNHdz3/qeaB0C47PEArPywannYr92l5Y6P68o=;
        h=Date:To:From:Subject:From;
        b=mEox/wcqTayePDOQSM6MwqujcUdQ5I7+2U9bkQh47TKoyhN0KOLZxBtKBqnTTFgo4
         Fm/2hukZfX4Lz83o60NkTfPkpon1qRuljxl2s3V5bwaR+xuTwJuQ3X8YRupzSpKgZE
         cgtKj+88BQXw1DyMSbJ4/DkSvXM/H+1tUPpJl4X4=
Date:   Mon, 25 Apr 2022 15:15:15 -0700
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        naoya.horiguchi@nec.com, bp@alien8.de, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-add-new-memory-failure-message-mf_msg_huge_zero.patch added to -mm tree
Message-Id: <20220425221516.561D0C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: add new memory failure message MF_MSG_HUGE_ZERO
has been added to the -mm tree.  Its filename is
     mm-memory-failure-add-new-memory-failure-message-mf_msg_huge_zero.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failure-add-new-memory-failure-message-mf_msg_huge_zero.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failure-add-new-memory-failure-message-mf_msg_huge_zero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/memory-failure: add new memory failure message MF_MSG_HUGE_ZERO

Memory failure just gets ignored for global huge_zero_page even without a
split attempt.  But corresponding memory failure message
MF_MSG_UNSPLIT_THP is misleading as if the THP page could not be split
during memory failure handling.  This adds a new message MF_MSG_HUGE_ZERO
indicating that memory got ignored for being a huge zero page.

Link: https://lkml.kernel.org/r/20220425080306.1771480-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |    1 +
 include/ras/ras_event.h |    1 +
 mm/memory-failure.c     |    3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-memory-failure-add-new-memory-failure-message-mf_msg_huge_zero
+++ a/include/linux/mm.h
@@ -3275,6 +3275,7 @@ enum mf_action_page_type {
 	MF_MSG_SLAB,
 	MF_MSG_DIFFERENT_COMPOUND,
 	MF_MSG_HUGE,
+	MF_MSG_HUGE_ZERO,
 	MF_MSG_FREE_HUGE,
 	MF_MSG_NON_PMD_HUGE,
 	MF_MSG_UNMAP_FAILED,
--- a/include/ras/ras_event.h~mm-memory-failure-add-new-memory-failure-message-mf_msg_huge_zero
+++ a/include/ras/ras_event.h
@@ -359,6 +359,7 @@ TRACE_EVENT(aer_event,
 	EM ( MF_MSG_SLAB, "kernel slab page" )				\
 	EM ( MF_MSG_DIFFERENT_COMPOUND, "different compound page after locking" ) \
 	EM ( MF_MSG_HUGE, "huge page" )					\
+	EM ( MF_MSG_HUGE_ZERO, "huge zero page" )			\
 	EM ( MF_MSG_FREE_HUGE, "free huge page" )			\
 	EM ( MF_MSG_NON_PMD_HUGE, "non-pmd-sized huge page" )		\
 	EM ( MF_MSG_UNMAP_FAILED, "unmapping failed page" )		\
--- a/mm/memory-failure.c~mm-memory-failure-add-new-memory-failure-message-mf_msg_huge_zero
+++ a/mm/memory-failure.c
@@ -719,6 +719,7 @@ static const char * const action_page_ty
 	[MF_MSG_SLAB]			= "kernel slab page",
 	[MF_MSG_DIFFERENT_COMPOUND]	= "different compound page after locking",
 	[MF_MSG_HUGE]			= "huge page",
+	[MF_MSG_HUGE_ZERO]		= "huge zero page",
 	[MF_MSG_FREE_HUGE]		= "free huge page",
 	[MF_MSG_NON_PMD_HUGE]		= "non-pmd-sized huge page",
 	[MF_MSG_UNMAP_FAILED]		= "unmapping failed page",
@@ -1859,7 +1860,7 @@ try_again:
 		 * TODO: Handle memory failure of huge_zero_page thoroughly.
 		 */
 		if (is_huge_zero_page(hpage)) {
-			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
+			action_result(pfn, MF_MSG_HUGE_ZERO, MF_IGNORED);
 			res = -EBUSY;
 			goto unlock_mutex;
 		}
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-drop-protection_map-usage.patch
mm-mmap-clarify-protection_map-indices.patch
mm-mmap-add-new-config-arch_has_vm_get_page_prot.patch
powerpc-mm-enable-arch_has_vm_get_page_prot.patch
arm64-mm-enable-arch_has_vm_get_page_prot.patch
sparc-mm-enable-arch_has_vm_get_page_prot.patch
mm-mmap-drop-arch_filter_pgprot.patch
mm-mmap-drop-arch_vm_get_page_pgprot.patch
mm-memory-failure-add-new-memory-failure-message-mf_msg_huge_zero.patch

