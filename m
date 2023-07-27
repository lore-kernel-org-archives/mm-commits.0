Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68601C0015E
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 18:21:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjG0SVF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 14:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjG0SVE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 14:21:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABE32D64
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 11:21:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 968CE61F13
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 18:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E7DC433C7;
        Thu, 27 Jul 2023 18:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690482063;
        bh=BhttiL+ISrhbXYvru1kw9hJHTIJzRfyCW+Bb9LZW/ZY=;
        h=Date:To:From:Subject:From;
        b=W4iWMYUKY4aXzCBX3bScQHFr8P5S7ScknnD5PdYMxh0z6+ebG3Hl4tp9pSc3kYFoD
         QpJ/vS2Qf1FaPqpsdlsWwnGBp11mAFr2VO+zLfu8Z3vi4o+2miflSFJw/5icQj8lLN
         zhFb5w+Cl1NCqDgPRpIcOCF+vpsRM+A9Bp8+x0Ik=
Date:   Thu, 27 Jul 2023 11:21:01 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, peterx@redhat.com,
        liubo254@huawei.com, hughd@google.com, david@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] smaps-fix-the-abnormal-memory-statistics-obtained-through-proc-pid-smaps-fix.patch removed from -mm tree
Message-Id: <20230727182102.E6E7DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: smaps-fix-the-abnormal-memory-statistics-obtained-through-proc-pid-smaps-fix
has been removed from the -mm tree.  Its filename was
     smaps-fix-the-abnormal-memory-statistics-obtained-through-proc-pid-smaps-fix.patch

This patch was dropped because it was folded into smaps-fix-the-abnormal-memory-statistics-obtained-through-proc-pid-smaps.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: smaps-fix-the-abnormal-memory-statistics-obtained-through-proc-pid-smaps-fix
Date: Wed Jul 26 12:14:31 PM PDT 2023

tweak comment and code layout

Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: liubo <liubo254@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/proc/task_mmu.c~smaps-fix-the-abnormal-memory-statistics-obtained-through-proc-pid-smaps-fix
+++ a/fs/proc/task_mmu.c
@@ -587,10 +587,12 @@ static void smaps_pmd_entry(pmd_t *pmd,
 	bool migration = false;
 
 	if (pmd_present(*pmd)) {
-		/* FOLL_DUMP will return -EFAULT on huge zero page
-		 * FOLL_FORCE follow a PROT_NONE mapped page
+		/*
+		 * FOLL_DUMP: return -EFAULT on huge zero page
+		 * FOLL_FORCE: follow a PROT_NONE mapped page
 		 */
-		page = follow_trans_huge_pmd(vma, addr, pmd, FOLL_DUMP | FOLL_FORCE);
+		page = follow_trans_huge_pmd(vma, addr, pmd,
+					     FOLL_DUMP | FOLL_FORCE);
 	} else if (unlikely(thp_migration_supported() && is_swap_pmd(*pmd))) {
 		swp_entry_t entry = pmd_to_swp_entry(*pmd);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

smaps-fix-the-abnormal-memory-statistics-obtained-through-proc-pid-smaps.patch
mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch
fs-buffer-clean-up-block_commit_write-fix.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch
mm-make-pte_marker_swapin_error-more-general-fix.patch
mm-kfence-allocate-kfence_metadata-at-runtime-fix.patch
acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes.patch
signal-print-comm-and-exe-name-on-fatal-signals-fix.patch

