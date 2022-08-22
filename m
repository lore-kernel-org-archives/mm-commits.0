Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C83FC28D13
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 19:22:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237365AbiHVTW1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237410AbiHVTVU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 15:21:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA2DCE12
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 12:21:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A7D4B8105A
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 19:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3D9C433C1;
        Mon, 22 Aug 2022 19:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661196076;
        bh=ZOorx41XLJWkzwv3RdhiVp5XDcI9j6dh1xBxqPnvS+M=;
        h=Date:To:From:Subject:From;
        b=FAR+VJ8yDSTdZh6o5RnEP24R8pcqnMOeCJr3fBR8fhuCXHk3lm9HTXYa6nsLK93A9
         /x9UsBnTk0oo9lVNKNDz9Hu99w3D2WrnfTVeOcmEe5Wr1HyV5vCa0ous60t9KCQsUz
         lDw4Vo/gdz1ZTPHET+yUiUBk+RuxEF2O+hLisRBA=
Date:   Mon, 22 Aug 2022 12:21:15 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, will@kernel.org,
        vbabka@suse.cz, svens@linux.ibm.com, sj@kernel.org,
        Liam.Howlett@Oracle.com, dhowells@redhat.com, david@redhat.com,
        catalin.marinas@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-use-vma-iterator.patch added to mm-unstable branch
Message-Id: <20220822192116.2E3D9C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fork: use VMA iterator
has been added to the -mm mm-unstable branch.  Its filename is
     fork-use-vma-iterator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-use-vma-iterator.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fork: use VMA iterator
Date: Mon, 22 Aug 2022 15:06:27 +0000

The VMA iterator is faster than the linked list and removing the linked
list will shrink the vm_area_struct.

Link: https://lkml.kernel.org/r/20220822150128.1562046-50-Liam.Howlett@oracle.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/kernel/fork.c~fork-use-vma-iterator
+++ a/kernel/fork.c
@@ -1301,13 +1301,16 @@ int replace_mm_exe_file(struct mm_struct
 	/* Forbid mm->exe_file change if old file still mapped. */
 	old_exe_file = get_mm_exe_file(mm);
 	if (old_exe_file) {
+		VMA_ITERATOR(vmi, mm, 0);
 		mmap_read_lock(mm);
-		for (vma = mm->mmap; vma && !ret; vma = vma->vm_next) {
+		for_each_vma(vmi, vma) {
 			if (!vma->vm_file)
 				continue;
 			if (path_equal(&vma->vm_file->f_path,
-				       &old_exe_file->f_path))
+				       &old_exe_file->f_path)) {
 				ret = -EBUSY;
+				break;
+			}
 		}
 		mmap_read_unlock(mm);
 		fput(old_exe_file);
_

Patches currently in -mm which might be from willy@infradead.org are

support-highmem-pages-in-vmap_pages_range_noflush.patch
mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch

