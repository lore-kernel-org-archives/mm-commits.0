Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0723644D4
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 16:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768234458; cv=none; b=SkKWQCuSsZM5zTwmqOyjdmJTmW++q3AuLd1TuyR+Ihrg6NGrRVIIxj+oFhqvlkednNghVKR9M9hl67RGpUISPwOM2NprStrZzFqGomfGyyYd5FThTLyAqDbWqW6JAXwtoP3R8h4Q0ntkfWdy5q3mCqJOEc4v1Un0z2XpDuj071I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768234458; c=relaxed/simple;
	bh=KT9xYY2uu+6PPTEJuXtvOxsHFZNZp0AHoIrWiLE27UY=;
	h=Date:To:From:Subject:Message-Id; b=RoKSvqmnav3okoKodrQIx3/+y/7MkxWD4iURlHx9PK24sScFzSoQPMkcNm208ljJX6QjJ4conk9My/USgDmVhCRl0m48aMwCWXTLG9IXd9CuhV/X6IUWxDLjZeKwFgcSwS8BCzMrKOGCl+2JZbFQbGHnK3Uw1fbqz1B8ed0Djio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t8Qm+74k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t8Qm+74k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D922FC2BC9E;
	Mon, 12 Jan 2026 16:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768234458;
	bh=KT9xYY2uu+6PPTEJuXtvOxsHFZNZp0AHoIrWiLE27UY=;
	h=Date:To:From:Subject:From;
	b=t8Qm+74k/anNV3gcD9/uX8dITHanrvjiXRDh0ISJ0vCYRUip1xM9Geb48oJsA4qf7
	 L+SQaTXdxS2OFzeDOZRNUcUOSP0vz5ieY0O3L+C5lPZRon7Kq1SiTfh2pkGWIQkfVe
	 PkyMzdh1xYMsSaycxJgmxeZzNWQIS95CBXO0Xylg=
Date: Mon, 12 Jan 2026 08:14:17 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,pfalcato@suse.de,liam.howlett@oracle.com,jgg@ziepe.ca,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-do-not-leak-memory-when-mmap_prepare-swaps-the-file.patch added to mm-hotfixes-unstable branch
Message-Id: <20260112161417.D922FC2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: do not leak memory when .mmap_prepare swaps the file
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vma-do-not-leak-memory-when-mmap_prepare-swaps-the-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-do-not-leak-memory-when-mmap_prepare-swaps-the-file.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: do not leak memory when .mmap_prepare swaps the file
Date: Mon, 12 Jan 2026 15:51:43 +0000

The current implementation of mmap() is set up such that a struct file
object is obtained for the input fd in ksys_mmap_pgoff() via fget(), and
its reference count decremented at the end of the function via.  fput().

If a merge can be achieved, we are fine to simply decrement the refcount
on the file.  Otherwise, in __mmap_new_file_vma(), we increment the
reference count on the file via get_file() such that the fput() in
ksys_mmap_pgoff() does not free the now-referenced file object.

The introduction of the f_op->mmap_prepare hook changes things, as it
becomes possible for a driver to replace the file object right at the
beginning of the mmap operation.

The current implementation is buggy if this happens because it
unconditionally calls get_file() on the mapping's file whether or not it
was replaced (and thus whether or not its reference count will be
decremented at the end of ksys_mmap_pgoff()).

This results in a memory leak, and was exposed in commit ab04945f91bc
("mm: update mem char driver to use mmap_prepare").

This patch solves the problem by explicitly tracking whether we actually
need to call get_file() on the file or not, and only doing so if required.

Link: https://lkml.kernel.org/r/20260112155143.661284-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Fixes: ab04945f91bc ("mm: update mem char driver to use mmap_prepare")
Reported-by: syzbot+bf5de69ebb4bdf86f59f@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6964a92b.050a0220.eaf7.008a.GAE@google.com/
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/vma.c~mm-vma-do-not-leak-memory-when-mmap_prepare-swaps-the-file
+++ a/mm/vma.c
@@ -37,6 +37,8 @@ struct mmap_state {
 	bool check_ksm_early :1;
 	/* If we map new, hold the file rmap lock on mapping. */
 	bool hold_file_rmap_lock :1;
+	/* If .mmap_prepare changed the file, we don't need to pin. */
+	bool file_doesnt_need_get :1;
 };
 
 #define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, vm_flags_, file_) \
@@ -2450,7 +2452,9 @@ static int __mmap_new_file_vma(struct mm
 	struct vma_iterator *vmi = map->vmi;
 	int error;
 
-	vma->vm_file = get_file(map->file);
+	vma->vm_file = map->file;
+	if (!map->file_doesnt_need_get)
+		get_file(map->file);
 
 	if (!map->file->f_op->mmap)
 		return 0;
@@ -2638,7 +2642,10 @@ static int call_mmap_prepare(struct mmap
 
 	/* Update fields permitted to be changed. */
 	map->pgoff = desc->pgoff;
-	map->file = desc->vm_file;
+	if (desc->vm_file != map->file) {
+		map->file_doesnt_need_get = true;
+		map->file = desc->vm_file;
+	}
 	map->vm_flags = desc->vm_flags;
 	map->page_prot = desc->page_prot;
 	/* User-defined fields. */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-fix-anon_vma-uaf-on-mremap-faulted-unfaulted-merge.patch
tools-testing-selftests-add-tests-for-tgt-src-mremap-merges.patch
mm-vma-enforce-vma-fork-limit-on-unfaultedfaulted-mremap-merge-too.patch
tools-testing-selftests-add-forked-un-faulted-vma-merge-tests.patch
tools-testing-selftests-fix-gup_longterm-for-unknown-fs.patch
mm-vma-do-not-leak-memory-when-mmap_prepare-swaps-the-file.patch
mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts.patch
mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink.patch
mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap.patch
mm-rmap-remove-anon_vma_merge-function.patch
mm-rmap-make-anon_vma-functions-internal.patch
mm-mmap_lock-add-vma_is_attached-helper.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible-fix.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone-fix.patch

