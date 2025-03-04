Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8172620EF
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 23:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741130161; cv=none; b=UUxGLX/9vwOoVdZ+0mKbVIc9H0HOprATSM/2bxmXWznlAZvJTdL5PfCXRQ4T66X2H8JOeljT/qiRPe9uRC7RDeD8wf6QJ3MB4XuVq/aZJPPWoL2ppIy/csOFaMcMcnkWcyKbTCXFp83KhXrFfAv24MH23zg14rHKYmzHgghIv3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741130161; c=relaxed/simple;
	bh=3hqBLrqfU1+fujMExqUHsmI49joMrjq4mp30Liu0UyI=;
	h=Date:To:From:Subject:Message-Id; b=izcAdTMzWgYLVdomDcrIAXqTEg2vtqcBoJDebJ8GOYS3Rjv1qHrNz1aqkHNGUD1TIB7Xv9+91AKeXfQnLRFA+QGvxmgjTaJlPzQaQVic0B6i6sUYQdgW7YXeWOFZJfPWwVD18ffnc1AZmipxTOFwP3q26o7Jsx6x1TrnHW93csE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e/hJrFm7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e/hJrFm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C76DC4CEE8;
	Tue,  4 Mar 2025 23:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741130161;
	bh=3hqBLrqfU1+fujMExqUHsmI49joMrjq4mp30Liu0UyI=;
	h=Date:To:From:Subject:From;
	b=e/hJrFm7lA9vhfmAjcl3cb2njVamOWQd9MUFI6yFAS+0RD0ln41IgtanARgcD3APS
	 CroJ/KPTPE9c4boqVnEdRHjgdSJa2s0xuzgpf02G0L7x2MGpiiWDM5XfJf9b436FKh
	 01uEBHkusNHtz/ldLLE6TgEkwHNWKYi7J4o9Ph+E=
Date: Tue, 04 Mar 2025 15:16:00 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-initial-refactor-of-move_vma-fix.patch added to mm-unstable branch
Message-Id: <20250304231601.0C76DC4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-mremap-initial-refactor-of-move_vma-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-initial-refactor-of-move_vma-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-initial-refactor-of-move_vma-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mremap-initial-refactor-of-move_vma-fix
Date: Tue Mar  4 03:14:08 PM PST 2025

fix uninitialized `err' in prep_move_vma()

Reported-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Closes: https://lkml.kernel.org/r/Z8d0d9N26JBGwi8N@google.com
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-initial-refactor-of-move_vma-fix
+++ a/mm/mremap.c
@@ -892,7 +892,7 @@ static void vrm_stat_account(struct vma_
 static unsigned long prep_move_vma(struct vma_remap_struct *vrm,
 				   unsigned long *vm_flags_ptr)
 {
-	unsigned long err;
+	unsigned long err = 0;
 	struct vm_area_struct *vma = vrm->vma;
 	unsigned long old_addr = vrm->addr;
 	unsigned long old_len = vrm->old_len;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix.patch
userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount-fix.patch
mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params-fix.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
mm-mremap-initial-refactor-of-move_vma-fix.patch
mm-mremap-thread-state-through-move-page-table-operation-fix.patch
mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch
signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch

