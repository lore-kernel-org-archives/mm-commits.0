Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A8BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 02:54:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbiEMCyP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 22:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376571AbiEMCyO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 22:54:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DB727EBA8
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 19:54:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45FADB82C29
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 02:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B19C34114;
        Fri, 13 May 2022 02:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652410450;
        bh=F7fZN6pf6Y4otC3bHfJpwN5nM7G7KccTYuYfa5LTBq0=;
        h=Date:To:From:Subject:From;
        b=rASw4CIvOF7mHNxKfUunXwUJAzr9PScQi2GfUvgkawXrhl6tdCiPxpoh7CRlnVvqE
         Gi1FD3RrRUsi467jlQJUdkxx6kioU8FaehZ9Jas5fAL03N9ea3VFVbxUnIOj+bymUO
         yqHMZ3rv53j/MkYiVFWX8TQmWd+8fU8aeriMqDPg=
Date:   Thu, 12 May 2022 19:54:10 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20220513025410.D5B19C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-check-against-orig_pte-for-finish_fault.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes

WARNING: braces {} are not necessary for single statement blocks
#52: FILE: mm/memory.c:4199:
+	if (vmf->flags & FAULT_FLAG_ORIG_PTE_VALID) {
+		return !pte_same(*vmf->pte, vmf->orig_pte);
+	}

total: 0 errors, 1 warnings, 59 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-check-against-orig_pte-for-finish_fault-fix.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memory.c~mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes
+++ a/mm/memory.c
@@ -4185,9 +4185,8 @@ void do_set_pte(struct vm_fault *vmf, st
 
 static bool vmf_pte_changed(struct vm_fault *vmf)
 {
-	if (vmf->flags & FAULT_FLAG_ORIG_PTE_VALID) {
+	if (vmf->flags & FAULT_FLAG_ORIG_PTE_VALID)
 		return !pte_same(*vmf->pte, vmf->orig_pte);
-	}
 
 	return !pte_none(*vmf->pte);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

assoc_array-fix-bug_on-during-garbage-collect-fix.patch
mm-check-against-orig_pte-for-finish_fault.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mm-convert-sysfs-input-to-bool-using-kstrtobool-fix.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-fix.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

