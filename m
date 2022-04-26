Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8971C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 00:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbiDZALU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 20:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiDZALU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 20:11:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2B4120126
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 17:08:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00B08B81BB1
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 00:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BF5C385A7;
        Tue, 26 Apr 2022 00:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650931691;
        bh=VlnTPL7qa9u6TfKSsNVw8yNYBZ7Yo1sXwJD8vb1ope4=;
        h=Date:To:From:Subject:From;
        b=tragkmS8JvN6BZKJWzU0o8O9o5amqpiGylWDpk8c9GgSCCoMPDPkhElnwUIGB1zfB
         n37r7/3NEA6x0aUfLG9UPsB7Cvn5u73QS5VlCriZd6sdQf3ZTmhqQAPMG7B/AHhzfc
         EsyZGfCJBafiElAdJOdM/sPTCgKNN3dq8vNIcQTc=
Date:   Mon, 25 Apr 2022 17:08:10 -0700
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        naoya.horiguchi@nec.com, bp@alien8.de, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-failure-add-new-memory-failure-message-mf_msg_huge_zero.patch removed from -mm tree
Message-Id: <20220426000811.99BF5C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: add new memory failure message MF_MSG_HUGE_ZERO
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-add-new-memory-failure-message-mf_msg_huge_zero.patch

This patch was dropped because an updated version will be merged

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

