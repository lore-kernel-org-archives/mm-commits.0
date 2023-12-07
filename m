Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CDB4C4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 22:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444099AbjLGWT6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Dec 2023 17:19:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444112AbjLGWTw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2023 17:19:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8221715
        for <mm-commits@vger.kernel.org>; Thu,  7 Dec 2023 14:19:59 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F73C433C8;
        Thu,  7 Dec 2023 22:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701987599;
        bh=d4fgaeesyZNg+CHAiTmZHHJ7vDGQvfhPYc7Ak8Eyq9k=;
        h=Date:To:From:Subject:From;
        b=AolrR5TsqtiIykQWSUJZFsySoD7UVY52g3ZNNu9s7LpIkAjBQ9olr2kMeJ3VRtNeT
         j7fnDh6ncYt769q2Mu85M+QG/z0aYKb4zANKEtS1x4LmEbn4gheKeYJKYJeDaNd3TB
         XN7dYkfoF2lFXaypxyzN4KK5KOnQzi+TBzwSK0Ag=
Date:   Thu, 07 Dec 2023 14:19:58 -0800
To:     mm-commits@vger.kernel.org, stephen.smalley.work@gmail.com,
        peterz@infradead.org, paul@paul-moore.com, omosnace@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-vma-heap-bounds-checking.patch added to mm-hotfixes-unstable branch
Message-Id: <20231207221959.09F73C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix VMA heap bounds checking
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-vma-heap-bounds-checking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-vma-heap-bounds-checking.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: fix VMA heap bounds checking
Date: Thu, 7 Dec 2023 23:25:25 +0800

After converting selinux to VMA heap check helper, the gcl triggers an
execheap SELinux denial, which is caused by a changed logic check.

Previously selinux only checked that the VMA range was within the VMA heap
range, and the implementation checks the intersection between the two
ranges, but the corner case (vm_end=start_brk, brk=vm_start) isn't handled
correctly.

Since commit 11250fd12eb8 ("mm: factor out VMA stack and heap checks") was
only a function extraction, it seems that the issue was introduced by
commit 0db0c01b53a1 ("procfs: fix /proc/<pid>/maps heap check").  Let's
fix above corner cases, meanwhile, correct the wrong indentation of the
stack and heap check helpers.

Fixes: 11250fd12eb8 ("mm: factor out VMA stack and heap checks")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reported-by: Ondrej Mosnacek <omosnace@redhat.com>
Closes: https://lore.kernel.org/selinux/CAFqZXNv0SVT0fkOK6neP9AXbj3nxJ61JAY4+zJzvxqJaeuhbFw@mail.gmail.com/
Tested-by: Ondrej Mosnacek <omosnace@redhat.com>
Link: https://lkml.kernel.org/r/20231207152525.2607420-1-wangkefeng.wang@huawei.com
Cc: David Hildenbrand <david@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~mm-fix-vma-heap-bounds-checking
+++ a/include/linux/mm.h
@@ -886,8 +886,8 @@ static inline bool vma_is_anonymous(stru
  */
 static inline bool vma_is_initial_heap(const struct vm_area_struct *vma)
 {
-       return vma->vm_start <= vma->vm_mm->brk &&
-		vma->vm_end >= vma->vm_mm->start_brk;
+	return vma->vm_start < vma->vm_mm->brk &&
+		vma->vm_end > vma->vm_mm->start_brk;
 }
 
 /*
@@ -901,8 +901,8 @@ static inline bool vma_is_initial_stack(
 	 * its "stack".  It's not even well-defined for programs written
 	 * languages like Go.
 	 */
-       return vma->vm_start <= vma->vm_mm->start_stack &&
-	       vma->vm_end >= vma->vm_mm->start_stack;
+	return vma->vm_start <= vma->vm_mm->start_stack &&
+		vma->vm_end >= vma->vm_mm->start_stack;
 }
 
 static inline bool vma_is_temporary_stack(struct vm_area_struct *vma)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-fix-vma-heap-bounds-checking.patch
mm-ksm-use-more-folio-api-in-ksm_might_need_to_copy.patch
mm-memory-use-a-folio-in-validate_page_before_insert.patch
mm-memory-rename-page_copy_prealloc-to-folio_prealloc.patch
mm-memory-use-a-folio-in-do_cow_fault.patch
mm-memory-use-folio_prealloc-in-wp_page_copy.patch
mm-huge_memory-use-more-folio-api-in-__split_huge_page_tail.patch

