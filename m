Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D8F23A103
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836977; cv=none; b=rAXraqNI2kkyGav7q4nIeMBpgg5yMRpJBhwSXmKkmIhwEmC3w1LnM3Lty3AfA6HR9iUicgyQ9Av6xRVvxOr46LnwlQOTJWJAov54Q1YkHD3hDQ8/iDFgKJv+9/ViBDP/3MEwE8ZpJpAzQo0nidjPfT+ej9AEcry8kpsPXFMRtCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836977; c=relaxed/simple;
	bh=Rk9gf2/u6V972qRWaxQiHlu56BNbD2iZO84v28LH+30=;
	h=Date:To:From:Subject:Message-Id; b=pVULikEw2JX4LlkDihqAf5vqwMZ/JPiXQXjHO3EiL6BHnaBZ36QHhUKtaKj+dO6NStK8BIcSlrmzKqXXGbMGkJBsc/9kUD5RkHidSndacKR2UwMgE3HqynSZTQ++uxxENRzHJ/v31mdzU30Vz8UT5TdBZzVyDswQGAFhEa4hlMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LB5+jHMp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LB5+jHMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B59C4CEDD;
	Tue, 14 Jan 2025 06:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836977;
	bh=Rk9gf2/u6V972qRWaxQiHlu56BNbD2iZO84v28LH+30=;
	h=Date:To:From:Subject:From;
	b=LB5+jHMppxeU/uNVHYyTDK8cotoRbFjI8kjSXCcT70zizPWoahyjPAZj4op+5M9e2
	 GUCDCU5itSxioauQ7Aoaxgac2R1Ow+e3uTnBGrqTMB7wlixnYwtMvl4zTa4VoaxzsN
	 nIrzujUfNJo19In2Tqm6A2phY6RoyTYtEZI4vL/4=
Date: Mon, 13 Jan 2025 22:42:56 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,Liam.Howlett@Oracle.com,kees@kernel.org,jannh@google.com,jack@suse.cz,ebiederm@xmission.com,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch removed from -mm tree
Message-Id: <20250114064257.48B59C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: abstract get_arg_page() stack expansion and mmap read lock
has been removed from the -mm tree.  Its filename was
     mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: abstract get_arg_page() stack expansion and mmap read lock
Date: Tue, 3 Dec 2024 18:05:10 +0000

Right now fs/exec.c invokes expand_downwards(), an otherwise internal
implementation detail of the VMA logic in order to ensure that an arg page
can be obtained by get_user_pages_remote().

In order to be able to move the stack expansion logic into mm/vma.c to
make it available to userland testing we need to find an alternative
approach here.

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
@@ -3324,6 +3324,8 @@ extern int __vm_enough_memory(struct mm_
 extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
 extern void exit_mmap(struct mm_struct *);
 int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift);
+bool mmap_read_lock_maybe_expand(struct mm_struct *mm, struct vm_area_struct *vma,
+				 unsigned long addr, bool write);
 
 static inline int check_data_rlimit(unsigned long rlim,
 				    unsigned long new,
@@ -3437,9 +3439,6 @@ extern unsigned long stack_guard_gap;
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

mips-vdso-prefer-do_mmap-to-mmap_region.patch
mm-make-mmap_region-internal.patch

