Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A1ACC7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbjDFDE7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235112AbjDFDEO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:04:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBE79EC3
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:04:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49B7D6412C
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E34BC433EF;
        Thu,  6 Apr 2023 03:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750239;
        bh=F3X+5bLKVnuTTdDX+bP3tqfNV2+ZMMNganACRG9RUzk=;
        h=Date:To:From:Subject:From;
        b=zxxPWQkks1GgtkkmnKNayaKnAUKjcWeJl9b4kYrDhORodSQ9TX82mkfrMZ2lf76kv
         AfnIP2xPDuPi+O9RsMiQUSFQUYYfal8VVe9aoCyDF5FKB6XN1AucE8Y+aPKCp8ONLY
         nbSv+gKt4lbRzLG8tkDTcNKXQHpAtZYczDgDlGc8=
Date:   Wed, 05 Apr 2023 20:03:59 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-free-vm_area_struct-without-call_rcu-in-exit_mmap.patch removed from -mm tree
Message-Id: <20230406030359.9E34BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: free vm_area_struct without call_rcu in exit_mmap
has been removed from the -mm tree.  Its filename was
     mm-mmap-free-vm_area_struct-without-call_rcu-in-exit_mmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/mmap: free vm_area_struct without call_rcu in exit_mmap
Date: Mon, 27 Feb 2023 09:36:31 -0800

call_rcu() can take a long time when callback offloading is enabled.  Its
use in the vm_area_free can cause regressions in the exit path when
multiple VMAs are being freed.

Because exit_mmap() is called only after the last mm user drops its
refcount, the page fault handlers can't be racing with it.  Any other
possible user like oom-reaper or process_mrelease are already synchronized
using mmap_lock.  Therefore exit_mmap() can free VMAs directly, without
the use of call_rcu().

Expose __vm_area_free() and use it from exit_mmap() to avoid possible
call_rcu() floods and performance regressions caused by it.

Link: https://lkml.kernel.org/r/20230227173632.3292573-33-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 kernel/fork.c      |    2 +-
 mm/mmap.c          |   11 +++++++----
 3 files changed, 10 insertions(+), 5 deletions(-)

--- a/include/linux/mm.h~mm-mmap-free-vm_area_struct-without-call_rcu-in-exit_mmap
+++ a/include/linux/mm.h
@@ -257,6 +257,8 @@ void setup_initial_init_mm(void *start_c
 struct vm_area_struct *vm_area_alloc(struct mm_struct *);
 struct vm_area_struct *vm_area_dup(struct vm_area_struct *);
 void vm_area_free(struct vm_area_struct *);
+/* Use only if VMA has no other users */
+void __vm_area_free(struct vm_area_struct *vma);
 
 #ifndef CONFIG_MMU
 extern struct rb_root nommu_region_tree;
--- a/kernel/fork.c~mm-mmap-free-vm_area_struct-without-call_rcu-in-exit_mmap
+++ a/kernel/fork.c
@@ -480,7 +480,7 @@ struct vm_area_struct *vm_area_dup(struc
 	return new;
 }
 
-static void __vm_area_free(struct vm_area_struct *vma)
+void __vm_area_free(struct vm_area_struct *vma)
 {
 	free_anon_vma_name(vma);
 	kmem_cache_free(vm_area_cachep, vma);
--- a/mm/mmap.c~mm-mmap-free-vm_area_struct-without-call_rcu-in-exit_mmap
+++ a/mm/mmap.c
@@ -133,7 +133,7 @@ void unlink_file_vma(struct vm_area_stru
 /*
  * Close a vm structure and free it.
  */
-static void remove_vma(struct vm_area_struct *vma)
+static void remove_vma(struct vm_area_struct *vma, bool unreachable)
 {
 	might_sleep();
 	if (vma->vm_ops && vma->vm_ops->close)
@@ -141,7 +141,10 @@ static void remove_vma(struct vm_area_st
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	mpol_put(vma_policy(vma));
-	vm_area_free(vma);
+	if (unreachable)
+		__vm_area_free(vma);
+	else
+		vm_area_free(vma);
 }
 
 static inline struct vm_area_struct *vma_prev_limit(struct vma_iterator *vmi,
@@ -2145,7 +2148,7 @@ static inline void remove_mt(struct mm_s
 		if (vma->vm_flags & VM_ACCOUNT)
 			nr_accounted += nrpages;
 		vm_stat_account(mm, vma->vm_flags, -nrpages);
-		remove_vma(vma);
+		remove_vma(vma, false);
 	}
 	vm_unacct_memory(nr_accounted);
 	validate_mm(mm);
@@ -3078,7 +3081,7 @@ void exit_mmap(struct mm_struct *mm)
 	do {
 		if (vma->vm_flags & VM_ACCOUNT)
 			nr_accounted += vma_pages(vma);
-		remove_vma(vma);
+		remove_vma(vma, true);
 		count++;
 		cond_resched();
 	} while ((vma = mas_find(&mas, ULONG_MAX)) != NULL);
_

Patches currently in -mm which might be from surenb@google.com are


