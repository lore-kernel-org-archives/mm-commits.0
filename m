Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CF7DCDB482
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbjJRVY3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjJRVY3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:24:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29709B
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:24:27 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F049C433C7;
        Wed, 18 Oct 2023 21:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664267;
        bh=6DqU51oVyJ+wS85orm1PI4ZRPzcZ+X2ts7r3YdCaciA=;
        h=Date:To:From:Subject:From;
        b=SFkhSO8jthp7/WTjSktqTuZWNkb/jmAIpUzElftpw6bP5706HewagBVP2ZZgNhGqv
         QC330zvrDvpl/n/nfRrrlX1r4q9aT3BY5sUxov/O/k6PljFskQbuudAb22l+mL0oGU
         UKSM0ZkGSrWFjeXex2ZDKpv2QZHrrmIWp/TMI7Mo=
Date:   Wed, 18 Oct 2023 14:24:26 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, muchun.song@linux.dev,
        mike.kravetz@oracle.com, luto@kernel.org, jack@suse.cz,
        hughd@google.com, brauner@kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-perform-the-mapping_map_writable-check-after-call_mmap-fix.patch removed from -mm tree
Message-Id: <20231018212427.5F049C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: perform the mapping_map_writable() check after call_mmap()
has been removed from the -mm tree.  Its filename was
     mm-perform-the-mapping_map_writable-check-after-call_mmap-fix.patch

This patch was dropped because it was folded into mm-perform-the-mapping_map_writable-check-after-call_mmap.patch

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: perform the mapping_map_writable() check after call_mmap()
Date: Mon, 16 Oct 2023 17:17:13 +0100

Do not set writable_file_mapping in an instance where it is not appropriate
to do so.

Link: https://lkml.kernel.org/r/c9eb4cc6-7db4-4c2b-838d-43a0b319a4f0@lucifer.local
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/mmap.c~mm-perform-the-mapping_map_writable-check-after-call_mmap-fix
+++ a/mm/mmap.c
@@ -2923,10 +2923,8 @@ cannot_expand:
 	mm->map_count++;
 	if (vma->vm_file) {
 		i_mmap_lock_write(vma->vm_file->f_mapping);
-		if (vma_is_shared_maywrite(vma)) {
+		if (vma_is_shared_maywrite(vma))
 			mapping_allow_writable(vma->vm_file->f_mapping);
-			writable_file_mapping = true;
-		}
 
 		flush_dcache_mmap_lock(vma->vm_file->f_mapping);
 		vma_interval_tree_insert(vma, &vma->vm_file->f_mapping->i_mmap);
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case.patch
mm-make-__access_remote_vm-static.patch
mm-gup-explicitly-define-and-check-internal-gup-flags-disallow-foll_touch.patch
mm-gup-make-failure-to-pin-an-error-if-foll_nowait-not-specified.patch
mm-gup-adapt-get_user_page_vma_remote-to-never-return-null.patch
mm-mprotect-allow-unfaulted-vmas-to-be-unaccounted-on-mprotect.patch
mm-move-vma_policy-and-anon_vma_name-decls-to-mm_typesh.patch
mm-abstract-the-vma_merge-split_vma-pattern-for-mprotect-et-al.patch
mm-make-vma_merge-and-split_vma-internal.patch
mm-abstract-merge-for-new-vmas-into-vma_merge_new_vma.patch
mm-abstract-vma-merge-and-extend-into-vma_merge_extend-helper.patch
mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch
mm-update-memfd-seal-write-check-to-include-f_seal_write.patch
mm-perform-the-mapping_map_writable-check-after-call_mmap.patch

