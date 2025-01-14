Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C701823A103
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836979; cv=none; b=l8M5dLSLraSK/GLhkFsmFnhCAuBWQE5dureCtrwnZUBXHNswUjsMlgb1GsDR9H6Svb1dM22uUS0yNBhr1ecu9xm6qt5HC8PyrNNY/RQgG/eXo61TGuK06AiTkEJayRr1yPI+FhvqQ6pwfao8ZhlNKfWhPHa6ksgoLB/ZQZcKOZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836979; c=relaxed/simple;
	bh=/ZcpiZR0sRs/5tA30cEWf3Zik5DfzAG2qFas2MYRB7Q=;
	h=Date:To:From:Subject:Message-Id; b=sA1j1kd/T2X129qWOuHWps49gyCDYRes7hiiLhtptlY9wGRDIMfCaDd0uFNwixs2NdXgb3CjMAs4/NRdlyVm9khAt6mVH6pHtl2Asi/bn4VQRkVNwEDQWg1dsMdaL+y38IC3hz0vVOQqrRgROOUmvpUKhsTzGZJPDSc0OVZgci8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zxHZWeSI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zxHZWeSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99ECBC4CEDD;
	Tue, 14 Jan 2025 06:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836979;
	bh=/ZcpiZR0sRs/5tA30cEWf3Zik5DfzAG2qFas2MYRB7Q=;
	h=Date:To:From:Subject:From;
	b=zxHZWeSIYFclk9rBL9cWHZkqzf2MDDh0WOUGZKvJpLhbialRTaweoaPACG1KAZItF
	 25aaU48TAzY0+mPZTAd1FZPBezwcbEuRFo1eLmGNUg75pUsH+C5UYRbV31cyht9145
	 O3t9207FF0c04QvxplvhuKpgk6CErHEVDomrqKqI=
Date: Mon, 13 Jan 2025 22:42:59 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,Liam.Howlett@Oracle.com,kees@kernel.org,jannh@google.com,jack@suse.cz,ebiederm@xmission.com,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-move-__vm_munmap-to-mm-vmac.patch removed from -mm tree
Message-Id: <20250114064259.99ECBC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: move __vm_munmap() to mm/vma.c
has been removed from the -mm tree.  Its filename was
     mm-vma-move-__vm_munmap-to-mm-vmac.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: move __vm_munmap() to mm/vma.c
Date: Tue, 3 Dec 2024 18:05:12 +0000

This was arbitrarily left in mmap.c it makes no sense being there, move it
to vma.c to render it testable.

Link: https://lkml.kernel.org/r/5e5e81807c54dfbe363edb2d431eb3d7a37fcdba.1733248985.git.lorenzo.stoakes@oracle.com
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

 mm/mmap.c                        |   18 ------------------
 mm/vma.c                         |   18 ++++++++++++++++++
 mm/vma.h                         |    2 ++
 tools/testing/vma/vma_internal.h |    9 +++++++++
 4 files changed, 29 insertions(+), 18 deletions(-)

--- a/mm/mmap.c~mm-vma-move-__vm_munmap-to-mm-vmac
+++ a/mm/mmap.c
@@ -1044,24 +1044,6 @@ unsigned long mmap_region(struct file *f
 	return ret;
 }
 
-static int __vm_munmap(unsigned long start, size_t len, bool unlock)
-{
-	int ret;
-	struct mm_struct *mm = current->mm;
-	LIST_HEAD(uf);
-	VMA_ITERATOR(vmi, mm, start);
-
-	if (mmap_write_lock_killable(mm))
-		return -EINTR;
-
-	ret = do_vmi_munmap(&vmi, mm, start, len, &uf, unlock);
-	if (ret || !unlock)
-		mmap_write_unlock(mm);
-
-	userfaultfd_unmap_complete(mm, &uf);
-	return ret;
-}
-
 int vm_munmap(unsigned long start, size_t len)
 {
 	return __vm_munmap(start, len, false);
--- a/mm/vma.c~mm-vma-move-__vm_munmap-to-mm-vmac
+++ a/mm/vma.c
@@ -2877,3 +2877,21 @@ int expand_downwards(struct vm_area_stru
 	validate_mm(mm);
 	return error;
 }
+
+int __vm_munmap(unsigned long start, size_t len, bool unlock)
+{
+	int ret;
+	struct mm_struct *mm = current->mm;
+	LIST_HEAD(uf);
+	VMA_ITERATOR(vmi, mm, start);
+
+	if (mmap_write_lock_killable(mm))
+		return -EINTR;
+
+	ret = do_vmi_munmap(&vmi, mm, start, len, &uf, unlock);
+	if (ret || !unlock)
+		mmap_write_unlock(mm);
+
+	userfaultfd_unmap_complete(mm, &uf);
+	return ret;
+}
--- a/mm/vma.h~mm-vma-move-__vm_munmap-to-mm-vmac
+++ a/mm/vma.h
@@ -478,4 +478,6 @@ int expand_upwards(struct vm_area_struct
 
 int expand_downwards(struct vm_area_struct *vma, unsigned long address);
 
+int __vm_munmap(unsigned long start, size_t len, bool unlock);
+
 #endif	/* __MM_VMA_H */
--- a/tools/testing/vma/vma_internal.h~mm-vma-move-__vm_munmap-to-mm-vmac
+++ a/tools/testing/vma/vma_internal.h
@@ -906,6 +906,11 @@ static inline void mmap_write_unlock(str
 {
 }
 
+static inline int mmap_write_lock_killable(struct mm_struct *)
+{
+	return 0;
+}
+
 static inline bool can_modify_mm(struct mm_struct *mm,
 				 unsigned long start,
 				 unsigned long end)
@@ -1175,5 +1180,9 @@ static inline int anon_vma_prepare(struc
 	return __anon_vma_prepare(vma);
 }
 
+static inline void userfaultfd_unmap_complete(struct mm_struct *mm,
+					      struct list_head *uf)
+{
+}
 
 #endif	/* __MM_VMA_INTERNAL_H */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mips-vdso-prefer-do_mmap-to-mmap_region.patch
mm-make-mmap_region-internal.patch

