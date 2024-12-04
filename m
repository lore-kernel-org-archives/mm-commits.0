Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E537F623
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 00:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733272831; cv=none; b=b5HpHJvzLxBMdb60k5i3BRhDc4AlTgoc2/6FXzARxc6/ZNACz+FUcb8wsOSVcq9jkSCw5/ZWTjSSdE1BtfiC2B7mjT5mYqQgrP5GbISFrWf/Bl0SukyobiLxVWPJCAIFyk0SpeT7Cr946WDBjfSQibmJUXBPhhIJjRmmvhVLwQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733272831; c=relaxed/simple;
	bh=BqylNGlb0BIGS1Vibv7r121SdsTLpH69bPe8qHfi7xI=;
	h=Date:To:From:Subject:Message-Id; b=WIBgPDwsPEMNE4Ljshyd8gUhqp6wSfzaPvjqKHvnVgNusLTdxgDIQeKQTDpIroPF7mTY2n/ocNLJj1fYM3AFTsArXS52fw5XXlAQGGhWP7eQ78YA24RPyOmjSzU3WdqFstwmsqHeL5IIns6o/GfejoSTFkcW05R4fnym1lFWymg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yAEsuFxC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yAEsuFxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C5BC4CEDF;
	Wed,  4 Dec 2024 00:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733272830;
	bh=BqylNGlb0BIGS1Vibv7r121SdsTLpH69bPe8qHfi7xI=;
	h=Date:To:From:Subject:From;
	b=yAEsuFxCidbSWsJ0wI5U5ewBqprAK5kQjzFPj2V2jImjlqvQ2CAqZe01i/vZfGzXu
	 j/znZhsFvMUesGCSUmQX/NIpJSWv6oA9qivSbMvO45Y0cPm84BGmn75uCDU6LPjHpY
	 RaBjXAmcNiUP79tj5ZS56MHyG2sFhMpIHleI09Os=
Date: Tue, 03 Dec 2024 16:40:29 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,Liam.Howlett@Oracle.com,kees@kernel.org,jannh@google.com,jack@suse.cz,ebiederm@xmission.com,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch added to mm-unstable branch
Message-Id: <20241204004030.50C5BC4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: abstract get_arg_page() stack expansion and mmap read lock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: abstract get_arg_page() stack expansion and mmap read lock
Date: Tue, 3 Dec 2024 18:05:10 +0000

Right now fs/exec.c invokes expand_downwards(), an otherwise internal
implementation detail of the VMA logic in order to ensure that an arg page
can be obtained by get_user_pages_remote().

In order to be able to move the stack expansion logic into mm/vma.c in
order to make it available to userland testing we need to find an
alternative approach here.

We do so by providing the mmap_read_lock_maybe_expand() function which
also helpfully documents what get_arg_page() is doing here and adds an
additional check against VM_GROWSDOWN to make explicit that the stack
expansion logic is only invoked when the VMA is indeed a downward-growing
stack.

This allows expand_downwards() to become a static function.

Importantly, the VMA referenced by mmap_read_maybe_expand() must NOT be
currently user-visible in any way, that is place within an rmap or VMA
tree.  It must be a newly allocated VMA.

This is the case when exec invokes this function.

Link: https://lkml.kernel.org/r/5295d1c70c58e6aa63d14be68d4e1de9fa1c8e6d.1733248985.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c          |   14 ++---------
 include/linux/mm.h |    5 +--
 mm/mmap.c          |   54 ++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 58 insertions(+), 15 deletions(-)

--- a/fs/exec.c~mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock
+++ a/fs/exec.c
@@ -205,18 +205,10 @@ static struct page *get_arg_page(struct
 	/*
 	 * Avoid relying on expanding the stack down in GUP (which
 	 * does not work for STACK_GROWSUP anyway), and just do it
-	 * by hand ahead of time.
+	 * ahead of time.
 	 */
-	if (write && pos < vma->vm_start) {
-		mmap_write_lock(mm);
-		ret = expand_downwards(vma, pos);
-		if (unlikely(ret < 0)) {
-			mmap_write_unlock(mm);
-			return NULL;
-		}
-		mmap_write_downgrade(mm);
-	} else
-		mmap_read_lock(mm);
+	if (!mmap_read_lock_maybe_expand(mm, vma, pos, write))
+		return NULL;
 
 	/*
 	 * We are doing an exec().  'current' is the process
--- a/include/linux/mm.h~mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock
+++ a/include/linux/mm.h
@@ -3313,6 +3313,8 @@ extern int __vm_enough_memory(struct mm_
 extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
 extern void exit_mmap(struct mm_struct *);
 int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift);
+bool mmap_read_lock_maybe_expand(struct mm_struct *mm, struct vm_area_struct *vma,
+				 unsigned long addr, bool write);
 
 static inline int check_data_rlimit(unsigned long rlim,
 				    unsigned long new,
@@ -3426,9 +3428,6 @@ extern unsigned long stack_guard_gap;
 int expand_stack_locked(struct vm_area_struct *vma, unsigned long address);
 struct vm_area_struct *expand_stack(struct mm_struct * mm, unsigned long addr);
 
-/* CONFIG_STACK_GROWSUP still needs to grow downwards at some places */
-int expand_downwards(struct vm_area_struct *vma, unsigned long address);
-
 /* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
 extern struct vm_area_struct * find_vma(struct mm_struct * mm, unsigned long addr);
 extern struct vm_area_struct * find_vma_prev(struct mm_struct * mm, unsigned long addr,
--- a/mm/mmap.c~mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock
+++ a/mm/mmap.c
@@ -1009,7 +1009,7 @@ static int expand_upwards(struct vm_area
  * vma is the first one with address < vma->vm_start.  Have to extend vma.
  * mmap_lock held for writing.
  */
-int expand_downwards(struct vm_area_struct *vma, unsigned long address)
+static int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *prev;
@@ -1940,3 +1940,55 @@ int relocate_vma_down(struct vm_area_str
 	/* Shrink the vma to just the new range */
 	return vma_shrink(&vmi, vma, new_start, new_end, vma->vm_pgoff);
 }
+
+#ifdef CONFIG_MMU
+/*
+ * Obtain a read lock on mm->mmap_lock, if the specified address is below the
+ * start of the VMA, the intent is to perform a write, and it is a
+ * downward-growing stack, then attempt to expand the stack to contain it.
+ *
+ * This function is intended only for obtaining an argument page from an ELF
+ * image, and is almost certainly NOT what you want to use for any other
+ * purpose.
+ *
+ * IMPORTANT - VMA fields are accessed without an mmap lock being held, so the
+ * VMA referenced must not be linked in any user-visible tree, i.e. it must be a
+ * new VMA being mapped.
+ *
+ * The function assumes that addr is either contained within the VMA or below
+ * it, and makes no attempt to validate this value beyond that.
+ *
+ * Returns true if the read lock was obtained and a stack was perhaps expanded,
+ * false if the stack expansion failed.
+ *
+ * On stack expansion the function temporarily acquires an mmap write lock
+ * before downgrading it.
+ */
+bool mmap_read_lock_maybe_expand(struct mm_struct *mm,
+				 struct vm_area_struct *new_vma,
+				 unsigned long addr, bool write)
+{
+	if (!write || addr >= new_vma->vm_start) {
+		mmap_read_lock(mm);
+		return true;
+	}
+
+	if (!(new_vma->vm_flags & VM_GROWSDOWN))
+		return false;
+
+	mmap_write_lock(mm);
+	if (expand_downwards(new_vma, addr)) {
+		mmap_write_unlock(mm);
+		return false;
+	}
+
+	mmap_write_downgrade(mm);
+	return true;
+}
+#else
+bool mmap_read_lock_maybe_expand(struct mm_struct *mm, struct vm_area_struct *vma,
+				 unsigned long addr, bool write)
+{
+	return false;
+}
+#endif
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
mm-correct-typo-in-mmap_state-macro.patch
docs-mm-add-vma-locks-documentation.patch
mm-vma-move-brk-internals-to-mm-vmac.patch
mm-vma-move-unmapped_area-internals-to-mm-vmac.patch
mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch
mm-vma-move-stack-expansion-logic-to-mm-vmac.patch
mm-vma-move-__vm_munmap-to-mm-vmac.patch

