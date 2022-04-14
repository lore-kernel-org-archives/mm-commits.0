Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47198C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 14 Apr 2022 05:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbiDNFbN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Apr 2022 01:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiDNFbM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Apr 2022 01:31:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF38631902
        for <mm-commits@vger.kernel.org>; Wed, 13 Apr 2022 22:28:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AB83B82088
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 05:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABA5C385A5;
        Thu, 14 Apr 2022 05:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649914126;
        bh=Jo2r60SSG9C/z3HvWlflwjYPEbePGQNcOs3s6gWBVss=;
        h=Date:To:From:Subject:From;
        b=YnSDDU7Ae4iB6VniirdPPCXwHOggD6i4jfXKI1OwMZYEw4kXF8uO36i8UdNIRDnr2
         73eu6A8mN39UmY8DMqvTtRewGZyaxqywwfTvQHC059D/h3SMxPd8IyFWOAuEni7n58
         uav1d+FtaerYMmW+iRPkdU2JrKBpSaUiFviZygIg=
Date:   Wed, 13 Apr 2022 22:28:45 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mglru-vs-maple-tree.patch added to -mm tree
Message-Id: <20220414052846.1ABA5C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mglru-vs-maple-tree
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
Subject: mglru-vs-maple-tree

nasty, but it compiles

Cc: Yu Zhao <yuzhao@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
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

