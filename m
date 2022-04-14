Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C943C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 14 Apr 2022 05:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239332AbiDNFaJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Apr 2022 01:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbiDNFaJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Apr 2022 01:30:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E13C930570
        for <mm-commits@vger.kernel.org>; Wed, 13 Apr 2022 22:27:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4631161E33
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 05:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A67C385A5;
        Thu, 14 Apr 2022 05:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649914064;
        bh=AM2yqNqiQAJGY05jCn8s5e0eqhIy7p3nxXjmg0TMtqw=;
        h=Date:To:From:Subject:From;
        b=n1bGr28nsq8t+HNl0tCRRljAr8SAEZB38DFss5nuFx8CubcYbREJhW9Ku07BRl5SI
         1UdGwW5rrGxYz+e2UtHOLMOqcKmIhudLYgaCbRYl0OWBEc8W1IWzobxJ2TFZZ/5L0J
         XC/Z4CgkPzcZdyOjJYfkg8/FZ6ax/YGP+G5QRJhg=
Date:   Wed, 13 Apr 2022 22:27:43 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mglru-vs-maple-tree.patch added to -mm tree
Message-Id: <20220414052744.90A67C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: a
has been added to the -mm tree.  Its filename is
     mglru-vs-maple-tree.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mglru-vs-maple-tree.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mglru-vs-maple-tree.patch

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
Subject: a

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mglru-vs-maple-tree
+++ a/mm/vmscan.c
@@ -3704,7 +3704,7 @@ static bool get_next_vma(struct mm_walk
 
 	while (walk->vma) {
 		if (next >= walk->vma->vm_end) {
-			walk->vma = walk->vma->vm_next;
+			walk->vma = find_vma(walk->mm, walk->vma->vm_end);
 			continue;
 		}
 
@@ -3712,7 +3712,7 @@ static bool get_next_vma(struct mm_walk
 			return false;
 
 		if (should_skip_vma(walk->vma->vm_start, walk->vma->vm_end, walk)) {
-			walk->vma = walk->vma->vm_next;
+			walk->vma = find_vma(walk->mm, walk->vma->vm_end);
 			continue;
 		}
 
@@ -4062,7 +4062,7 @@ static void walk_mm(struct lruvec *lruve
 		/* the caller might be holding the lock for write */
 		if (mmap_read_trylock(mm)) {
 			unsigned long start = walk->next_addr;
-			unsigned long end = mm->highest_vm_end;
+			unsigned long end = TASK_SIZE;
 
 			err = walk_page_range(mm, start, end, &mm_walk_ops, walk);
 
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
mglru-vs-maple-tree.patch

