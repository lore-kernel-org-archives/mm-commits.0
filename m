Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B95CDB474
	for <mm-commits@archiver.kernel.org>; Mon, 16 Oct 2023 22:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjJPWRP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Oct 2023 18:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjJPWRP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2023 18:17:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A3395
        for <mm-commits@vger.kernel.org>; Mon, 16 Oct 2023 15:17:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45541C433C7;
        Mon, 16 Oct 2023 22:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697494633;
        bh=2yx7zO1JnP0SwgXxEfZF4Rucd9On/ZPBD1mt/o7xfNE=;
        h=Date:To:From:Subject:From;
        b=0TlcykedED1br1QN7k/h6IS0zprn7k35n35LB+KumT9jj6kgF7gg/IInXEHIDGasz
         7ASrc8/q+51H39uP9BADUrYsfNPwnEvj6FPWkE4e07bgqfPSlkLdTh/z+cVOn6quyw
         yFWEhuZCtd2lvuHDWKLU1SUwcI5Jv/tZ4Z5AIAWw=
Date:   Mon, 16 Oct 2023 15:17:12 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, muchun.song@linux.dev,
        mike.kravetz@oracle.com, luto@kernel.org, jack@suse.cz,
        hughd@google.com, brauner@kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-perform-the-mapping_map_writable-check-after-call_mmap-fix.patch added to mm-unstable branch
Message-Id: <20231016221713.45541C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: perform the mapping_map_writable() check after call_mmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-perform-the-mapping_map_writable-check-after-call_mmap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-perform-the-mapping_map_writable-check-after-call_mmap-fix.patch

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
mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case-fix.patch
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
mm-perform-the-mapping_map_writable-check-after-call_mmap-fix.patch

