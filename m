Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D9F1DA3A
	for <mm-commits@vger.kernel.org>; Mon,  8 Apr 2024 19:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712603911; cv=none; b=fc7XmxBNpaIMwv6Ogjd4FyZyR1WAGS4sQ8Pfw4uP3a0wesHG0Jg166dAv3fr68rq2q+glQqG+MBhyKTr4j1ZanA67f+yJdCExNKdp1uYeiF+kCeDKGZAPDLmXJTYiUyu44l80jWFCjC6Fw/6bfDMuAj/pwtHS3gJWnnx86rhB50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712603911; c=relaxed/simple;
	bh=QF1w1ywubL8wxF5Vo11FTK79G1aYyXNMhykdQNIfBkE=;
	h=Date:To:From:Subject:Message-Id; b=VTLV06FF+HXAO1/SSlZZnHf34exJZmGMD54jK22134kPS0NLtwwNVe6fZYocmtoGUj1uuz+EGxqne16cvMLv7Mfwf49k+bIIPia74wqDPrVFJ0gVWUzJW/H6qXH/3y1H8rMwguCfewe2Y/ySstcZKattCaDRow3dlWFJ+j5X2BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mR7ZSCSH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mR7ZSCSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EADC433C7;
	Mon,  8 Apr 2024 19:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712603911;
	bh=QF1w1ywubL8wxF5Vo11FTK79G1aYyXNMhykdQNIfBkE=;
	h=Date:To:From:Subject:From;
	b=mR7ZSCSHpflS5qGqLiMaroBtAo94xKapVVFm6Lyicti7RMFj1KMIt4Z8dXZya1j8E
	 vKJrMZepSMPFDdjXJl6rhcV87lRL2pElRkwqQbipKBJT73zBAB40jrDJjIBCe8mrXA
	 t+tf+DYfSscSXwjSPHG++maIgWlI0bSXCuw5iOnY=
Date: Mon, 08 Apr 2024 12:18:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,lstoakes@gmail.com,Liam.Howlett@oracle.com,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-make-accountable_mapping-return-bool.patch added to mm-unstable branch
Message-Id: <20240408191830.E7EADC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmap: make accountable_mapping return bool
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-make-accountable_mapping-return-bool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-make-accountable_mapping-return-bool.patch

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
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/mmap: make accountable_mapping return bool
Date: Sun, 7 Apr 2024 14:38:43 +0800

accountable_mapping can return bool,so we change it

Link: https://lkml.kernel.org/r/20240407063843.804274-1-gehao@kylinos.cn
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mm-mmap-make-accountable_mapping-return-bool
+++ a/mm/mmap.c
@@ -1549,14 +1549,14 @@ bool vma_wants_writenotify(struct vm_are
  * We account for memory if it's a private writeable mapping,
  * not hugepages and VM_NORESERVE wasn't set.
  */
-static inline int accountable_mapping(struct file *file, vm_flags_t vm_flags)
+static inline bool accountable_mapping(struct file *file, vm_flags_t vm_flags)
 {
 	/*
 	 * hugetlb has its own accounting separate from the core VM
 	 * VM_HUGETLB may not be set yet so we cannot check for that flag.
 	 */
 	if (file && is_file_hugepages(file))
-		return 0;
+		return false;
 
 	return (vm_flags & (VM_NORESERVE | VM_SHARED | VM_WRITE)) == VM_WRITE;
 }
_

Patches currently in -mm which might be from gehao@kylinos.cn are

mm-page-flags-make-__pagemovable-return-bool.patch
mm-page-flags-make-pagemappingflags-return-bool.patch
mm-mmap-make-vma_wants_writenotify-return-bool.patch
mm-mmap-make-accountable_mapping-return-bool.patch

