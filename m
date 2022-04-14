Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B7CEC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 14 Apr 2022 20:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244641AbiDNVBl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Apr 2022 17:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239824AbiDNVBj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Apr 2022 17:01:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD105ED92E
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 13:59:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 362A5CE2BB6
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 20:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966A5C385A5;
        Thu, 14 Apr 2022 20:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649969950;
        bh=Prb4d9a8779mc1uECHaeZR8EkPHOMQcxEwaHULp1eBk=;
        h=Date:To:From:Subject:From;
        b=ZGewMuXrrAXWgQewGus9aP3PMWlwKHhOyHMqxeoYuCyVDDF71JPq1uzm6Lzj9ilD4
         yAeI9m0JSkvE1rhyrPteY6FI+6xIrSFjjxszpcOdbX9TgkQC3JaoKjomeA0IXoiUCb
         LMBlv7qQZO3otojNdp3hzMZCPU/Vj8bq0+SSAh6w=
Date:   Thu, 14 Apr 2022 13:59:09 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch added to -mm tree
Message-Id: <20220414205910.966A5C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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


--- a/mm/memory.c~mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes
+++ a/mm/memory.c
@@ -4196,9 +4196,8 @@ void do_set_pte(struct vm_fault *vmf, st
 
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

revert-fs-binfmt_elf-fix-pt_load-p_align-values-for-loaders.patch
revert-fs-binfmt_elf-use-pt_load-p_align-values-for-static-pie.patch
mm.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-shmem-make-shmem_init-return-void-fix.patch
mm-khugepaged-introduce-khugepaged_enter_vma-helper-vs-maple-tree.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mglru-vs-maple-tree.patch
mm-vmscan-fix-comment-for-current_may_throttle-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

