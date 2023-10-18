Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD277CDB482
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235249AbjJRVhv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235352AbjJRVg6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36ECD7F
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:36:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA98C433C9;
        Wed, 18 Oct 2023 21:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664977;
        bh=g9Lf0H2fXE9IPCajs68hWTyJGdrGPQG5U7AgBW97xVg=;
        h=Date:To:From:Subject:From;
        b=FDA7/9NNKalGRF+krD9vWBZRGPDhElIqSC1iyXcUbVJOozjMt8pV3yNT16iy12bpv
         eGVKJMi327uMDj2GJgFsHLdsKSdgZL1qYtraHgt0Jum3b5V6j3UKNmvDfaqXI7sswp
         /AbfXNb1oQc2odSOgwiOJq3RlEA7D6wOL9+ihs9M=
Date:   Wed, 18 Oct 2023 14:36:16 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, muchun.song@linux.dev,
        mike.kravetz@oracle.com, luto@kernel.org, jack@suse.cz,
        hughd@google.com, brauner@kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-perform-the-mapping_map_writable-check-after-call_mmap.patch removed from -mm tree
Message-Id: <20231018213617.6EA98C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: perform the mapping_map_writable() check after call_mmap()
has been removed from the -mm tree.  Its filename was
     mm-perform-the-mapping_map_writable-check-after-call_mmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: perform the mapping_map_writable() check after call_mmap()
Date: Thu, 12 Oct 2023 18:04:30 +0100

In order for a F_SEAL_WRITE sealed memfd mapping to have an opportunity to
clear VM_MAYWRITE, we must be able to invoke the appropriate
vm_ops->mmap() handler to do so.  We would otherwise fail the
mapping_map_writable() check before we had the opportunity to avoid it.

This patch moves this check after the call_mmap() invocation.  Only memfd
actively denies write access causing a potential failure here (in
memfd_add_seals()), so there should be no impact on non-memfd cases.

This patch makes the userland-visible change that MAP_SHARED, PROT_READ
mappings of an F_SEAL_WRITE sealed memfd mapping will now succeed.

There is a delicate situation with cleanup paths assuming that a writable
mapping must have occurred in circumstances where it may now not have.  In
order to ensure we do not accidentally mark a writable file unwritable by
mistake, we explicitly track whether we have a writable mapping and unmap
only if we do.

[lstoakes@gmail.com: do not set writable_file_mapping in inappropriate case]
  Link: https://lkml.kernel.org/r/c9eb4cc6-7db4-4c2b-838d-43a0b319a4f0@lucifer.local
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217238
Link: https://lkml.kernel.org/r/55e413d20678a1bb4c7cce889062bbb07b0df892.1697116581.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/mm/mmap.c~mm-perform-the-mapping_map_writable-check-after-call_mmap
+++ a/mm/mmap.c
@@ -2752,6 +2752,7 @@ unsigned long mmap_region(struct file *f
 	unsigned long charged = 0;
 	unsigned long end = addr + len;
 	unsigned long merge_start = addr, merge_end = end;
+	bool writable_file_mapping = false;
 	pgoff_t vm_pgoff;
 	int error;
 	VMA_ITERATOR(vmi, mm, addr);
@@ -2846,17 +2847,19 @@ cannot_expand:
 	vma->vm_pgoff = pgoff;
 
 	if (file) {
-		if (is_shared_maywrite(vm_flags)) {
-			error = mapping_map_writable(file->f_mapping);
-			if (error)
-				goto free_vma;
-		}
-
 		vma->vm_file = get_file(file);
 		error = call_mmap(file, vma);
 		if (error)
 			goto unmap_and_free_vma;
 
+		if (vma_is_shared_maywrite(vma)) {
+			error = mapping_map_writable(file->f_mapping);
+			if (error)
+				goto close_and_free_vma;
+
+			writable_file_mapping = true;
+		}
+
 		/*
 		 * Expansion is handled above, merging is handled below.
 		 * Drivers should not alter the address of the VMA.
@@ -2937,7 +2940,7 @@ cannot_expand:
 
 	/* Once vma denies write, undo our temporary denial count */
 unmap_writable:
-	if (file && is_shared_maywrite(vm_flags))
+	if (writable_file_mapping)
 		mapping_unmap_writable(file->f_mapping);
 	file = vma->vm_file;
 	ksm_add_vma(vma);
@@ -2985,7 +2988,7 @@ unmap_and_free_vma:
 		unmap_region(mm, &vmi.mas, vma, prev, next, vma->vm_start,
 			     vma->vm_end, vma->vm_end, true);
 	}
-	if (file && is_shared_maywrite(vm_flags))
+	if (writable_file_mapping)
 		mapping_unmap_writable(file->f_mapping);
 free_vma:
 	vm_area_free(vma);
_

Patches currently in -mm which might be from lstoakes@gmail.com are


