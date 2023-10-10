Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B1E7CD68E2
	for <mm-commits@archiver.kernel.org>; Tue, 10 Oct 2023 00:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379269AbjJJAwv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Oct 2023 20:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379293AbjJJAwk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Oct 2023 20:52:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C82FB6
        for <mm-commits@vger.kernel.org>; Mon,  9 Oct 2023 17:52:38 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C062C433C7;
        Tue, 10 Oct 2023 00:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696899157;
        bh=irz2H+XwVh5EpIvbYeS/Dge7bwowGreCo2q/PtiO/nw=;
        h=Date:To:From:Subject:From;
        b=1vgwB5nSamdWxXBhujUgXPsHogS9Jueu4IMCYbdWT6MIFaVOcwi5T6ih+Kzn3MXlw
         nwN+Xcwrqfs9F9cEkXa7rNn7oNje0iqf3ge9WaaWywV3YjRT6BuXksJrcPeVmQ3eAN
         cz3iWOOMwl41jqDhR7RvVuQ6kq6XAXgSz9Y/RSDk=
Date:   Mon, 09 Oct 2023 17:52:21 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, muchun.song@linux.dev,
        mike.kravetz@oracle.com, luto@kernel.org, jack@suse.cz,
        hughd@google.com, brauner@kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-enforce-the-mapping_map_writable-check-after-call_mmap.patch added to mm-unstable branch
Message-Id: <20231010005235.8C062C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: enforce the mapping_map_writable() check after call_mmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-enforce-the-mapping_map_writable-check-after-call_mmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-enforce-the-mapping_map_writable-check-after-call_mmap.patch

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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: enforce the mapping_map_writable() check after call_mmap()
Date: Sat, 7 Oct 2023 21:51:01 +0100

In order for an F_SEAL_WRITE sealed memfd mapping to have an opportunity
to clear VM_MAYWRITE in seal_check_write() we must be able to invoke
either the shmem_mmap() or hugetlbfs_file_mmap() f_ops->mmap() handler to
do so.

We would otherwise fail the mapping_map_writable() check before we had the
opportunity to clear VM_MAYWRITE.

However, the existing logic in mmap_region() performs this check BEFORE
calling call_mmap() (which invokes file->f_ops->mmap()).  We must enforce
this check AFTER the function call.

In order to avoid any risk of breaking call_mmap() handlers which assume
this will have been done first, we continue to mark the file writable
first, simply deferring enforcement of it failing until afterwards.

This enables mmap(..., PROT_READ, MAP_SHARED, fd, 0) mappings for memfd's
sealed via F_SEAL_WRITE to succeed, whereas previously they were not
permitted.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217238
Link: https://lkml.kernel.org/r/d2748bc4077b53c60bcb06fccaf976cb2afee345.1696709413.git.lstoakes@gmail.com
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

 mm/mmap.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/mm/mmap.c~mm-enforce-the-mapping_map_writable-check-after-call_mmap
+++ a/mm/mmap.c
@@ -2845,11 +2845,10 @@ cannot_expand:
 	vma->vm_pgoff = pgoff;
 
 	if (file) {
-		if (is_shared_maywrite(vm_flags)) {
-			error = mapping_map_writable(file->f_mapping);
-			if (error)
-				goto free_vma;
-		}
+		int writable_error = 0;
+
+		if (vma_is_shared_maywrite(vma))
+			writable_error = mapping_map_writable(file->f_mapping);
 
 		vma->vm_file = get_file(file);
 		error = call_mmap(file, vma);
@@ -2857,6 +2856,15 @@ cannot_expand:
 			goto unmap_and_free_vma;
 
 		/*
+		 * call_mmap() may have changed VMA flags, so retry this check
+		 * if it failed before.
+		 */
+		if (writable_error && vma_is_shared_maywrite(vma)) {
+			error = writable_error;
+			goto close_and_free_vma;
+		}
+
+		/*
 		 * Expansion is handled above, merging is handled below.
 		 * Drivers should not alter the address of the VMA.
 		 */
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case.patch
mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case-fix.patch
mm-make-__access_remote_vm-static.patch
mm-gup-explicitly-define-and-check-internal-gup-flags-disallow-foll_touch.patch
mm-gup-make-failure-to-pin-an-error-if-foll_nowait-not-specified.patch
mm-gup-adapt-get_user_page_vma_remote-to-never-return-null.patch
mm-move-vma_policy-and-anon_vma_name-decls-to-mm_typesh.patch
mm-abstract-the-vma_merge-split_vma-pattern-for-mprotect-et-al.patch
mm-make-vma_merge-and-split_vma-internal.patch
mm-abstract-merge-for-new-vmas-into-vma_merge_new_vma.patch
mm-abstract-vma-merge-and-extend-into-vma_merge_extend-helper.patch
mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch
mm-update-memfd-seal-write-check-to-include-f_seal_write.patch
mm-enforce-the-mapping_map_writable-check-after-call_mmap.patch

