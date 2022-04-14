Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5242BC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 14 Apr 2022 04:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239813AbiDNERD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Apr 2022 00:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239815AbiDNERC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Apr 2022 00:17:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC07124087
        for <mm-commits@vger.kernel.org>; Wed, 13 Apr 2022 21:14:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63F9161DBF
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 04:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D2AC385A1;
        Thu, 14 Apr 2022 04:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649909674;
        bh=uktMuhd3+mSKy3fT1JSMY9sbN11vsk+uXoHBLslyvrM=;
        h=Date:To:From:Subject:From;
        b=JdTAkkWL1rzxLT22gJJRroIbiYW2qMZtsBJwVj2cUSIOXAYe4qCT24NGvqblTDKth
         DkEZyiI2uIiRhW/4P9g5k3+xo+LjHtTfnJ2B+YySZ/GSRry8VQuMhryJ94B9swaru6
         CNLqfVbIEkbxfvhSwJWHeH4VcerY+xNxi8SZ4Uec=
Date:   Wed, 13 Apr 2022 21:14:33 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-introduce-khugepaged_enter_vma-helper-vs-maple-tree.patch added to -mm tree
Message-Id: <20220414041434.B4D2AC385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-khugepaged-introduce-khugepaged_enter_vma-helper-vs-maple-tree
has been added to the -mm tree.  Its filename is
     mm-khugepaged-introduce-khugepaged_enter_vma-helper-vs-maple-tree.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-khugepaged-introduce-khugepaged_enter_vma-helper-vs-maple-tree.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-khugepaged-introduce-khugepaged_enter_vma-helper-vs-maple-tree.patch

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
Subject: mm-khugepaged-introduce-khugepaged_enter_vma-helper-vs-maple-tree

Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mm-khugepaged-introduce-khugepaged_enter_vma-helper-vs-maple-tree
+++ a/mm/mmap.c
@@ -2580,7 +2580,7 @@ unsigned long mmap_region(struct file *f
 	/* Actually expand, if possible */
 	if (vma &&
 	    !vma_expand(&mas, vma, merge_start, merge_end, vm_pgoff, next)) {
-		khugepaged_enter_vma_merge(vma, vm_flags);
+		khugepaged_enter_vma(vma, vm_flags);
 		goto expanded;
 	}
 
@@ -2995,7 +2995,7 @@ static int do_brk_flags(struct ma_state
 			anon_vma_interval_tree_post_update_vma(vma);
 			anon_vma_unlock_write(vma->anon_vma);
 		}
-		khugepaged_enter_vma_merge(vma, flags);
+		khugepaged_enter_vma(vma, flags);
 		goto out;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-fs-binfmt_elf-fix-pt_load-p_align-values-for-loaders.patch
revert-fs-binfmt_elf-use-pt_load-p_align-values-for-static-pie.patch
mm.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-shmem-make-shmem_init-return-void-fix.patch
mm-khugepaged-introduce-khugepaged_enter_vma-helper-vs-maple-tree.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

