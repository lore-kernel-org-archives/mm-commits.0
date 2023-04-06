Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0360FC7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234842AbjDFDEV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235139AbjDFDEE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:04:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727739742
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:03:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B29C62D65
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640F0C433D2;
        Thu,  6 Apr 2023 03:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750226;
        bh=So41nFp7K9VYlRZgXlKUuONhgO8k7Ko/BCmnlTyOmb8=;
        h=Date:To:From:Subject:From;
        b=RxUUUEqHzyMs3H6ezRUfWSle4xiIO/0raF6F2XcpvHyfWwcNv0SnbAwWjqnFcmt4g
         5lF8naAUc/0rMihNGtnCkPGr7S6wLp9Mt5izBj9eTZDJEdahPxNycutkvte06RYdjU
         6/OftHbfDmSHxgZqfpQy6IonTOhi4G/5AOZ+2G/0=
Date:   Wed, 05 Apr 2023 20:03:45 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-prevent-pagefault-handler-from-racing-with-mmu_notifier-registration.patch removed from -mm tree
Message-Id: <20230406030346.640F0C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: prevent pagefault handler from racing with mmu_notifier registration
has been removed from the -mm tree.  Its filename was
     mm-mmap-prevent-pagefault-handler-from-racing-with-mmu_notifier-registration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/mmap: prevent pagefault handler from racing with mmu_notifier registration
Date: Mon, 27 Feb 2023 09:36:20 -0800

Page fault handlers might need to fire MMU notifications while a new
notifier is being registered.  Modify mm_take_all_locks to write-lock all
VMAs and prevent this race with page fault handlers that would hold VMA
locks.  VMAs are locked before i_mmap_rwsem and anon_vma to keep the same
locking order as in page fault handlers.

Link: https://lkml.kernel.org/r/20230227173632.3292573-22-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/mmap.c~mm-mmap-prevent-pagefault-handler-from-racing-with-mmu_notifier-registration
+++ a/mm/mmap.c
@@ -3494,6 +3494,7 @@ static void vm_lock_mapping(struct mm_st
  * of mm/rmap.c:
  *   - all hugetlbfs_i_mmap_rwsem_key locks (aka mapping->i_mmap_rwsem for
  *     hugetlb mapping);
+ *   - all vmas marked locked
  *   - all i_mmap_rwsem locks;
  *   - all anon_vma->rwseml
  *
@@ -3519,6 +3520,13 @@ int mm_take_all_locks(struct mm_struct *
 	mas_for_each(&mas, vma, ULONG_MAX) {
 		if (signal_pending(current))
 			goto out_unlock;
+		vma_start_write(vma);
+	}
+
+	mas_set(&mas, 0);
+	mas_for_each(&mas, vma, ULONG_MAX) {
+		if (signal_pending(current))
+			goto out_unlock;
 		if (vma->vm_file && vma->vm_file->f_mapping &&
 				is_vm_hugetlb_page(vma))
 			vm_lock_mapping(mm, vma->vm_file->f_mapping);
@@ -3605,6 +3613,7 @@ void mm_drop_all_locks(struct mm_struct
 		if (vma->vm_file && vma->vm_file->f_mapping)
 			vm_unlock_mapping(vma->vm_file->f_mapping);
 	}
+	vma_end_write_all(mm);
 
 	mutex_unlock(&mm_all_locks_mutex);
 }
_

Patches currently in -mm which might be from surenb@google.com are


