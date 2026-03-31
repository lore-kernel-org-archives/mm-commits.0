Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051362C0F81
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917788; cv=none; b=u3fLa/cXWATpFEzC9UHcjBYYUMeHnM9dick22COEgZ8Jw6itK9JJX/VkNJlKsx+44jtHva9DbWTCF6fJc0V/eNq8Sq+7xP//7wQXkrnZ7hJb9d6o0ZWH/bzyxOOEW+NvXqoGf4koVK6x3bFN8wintI8XjsEnQ9mPrY+mjdUA7D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917788; c=relaxed/simple;
	bh=PdPf/54ZKYA1VpR2JjKpDdbOUndihGL+DPpLeKZnCFU=;
	h=Date:To:From:Subject:Message-Id; b=nRLZyMvMnTC1vy1M7dyrvB2pmHioCxRzy/wEaJjJzceePhGQudA+JYtB+3FaM9U+M2aqitA1ovo+Efb/vb77pZLZa0Ene5gKSPf0boeLbNWfsE0nxS7ibCJfXY13H7F58d9rNwPLVWnDEMKMBTUUvKG0TjNb7KOpsr8g+wg0t/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FlxkSmXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FlxkSmXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6EDC4CEF7;
	Tue, 31 Mar 2026 00:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917787;
	bh=PdPf/54ZKYA1VpR2JjKpDdbOUndihGL+DPpLeKZnCFU=;
	h=Date:To:From:Subject:From;
	b=FlxkSmXPZN16BRE010nZaXSfHfvJn2JeJh+Nyn3vxATGDS/ds2PEYObw+fsQnAY0d
	 84XjcnQmJRSCHcwmzgv+dclex88prPsCaYogJGl0j5sG9B7r/Up9IOh8Jek4+QS6Ul
	 OxJCoiLN2E1vfMmYpFYox8Vs6hn0L6PXld7P9HCQ=
Date: Mon, 30 Mar 2026 17:43:07 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,viro@zeniv.linux.org.uk,vigneshr@ti.com,vbabka@kernel.org,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,richard@nod.at,pfalcato@suse.de,miquel.raynal@bootlin.com,mhocko@suse.com,mcoquelin.stm32@gmail.com,martin.petersen@oracle.com,marc.dionne@auristor.com,longli@microsoft.com,liam.howlett@oracle.com,kys@microsoft.com,jannh@google.com,jack@suse.cz,haiyangz@microsoft.com,gregkh@linuxfoundation.org,dhowells@redhat.com,decui@microsoft.com,david@kernel.org,corbet@lwn.net,clemens@ladisch.de,brauner@kernel.org,bostroesser@gmail.com,arnd@arndb.de,alexandre.torgue@foss.st.com,alexander.shishkin@linux.intel.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-switch-the-rmap-lock-held-option-off-in-compat-layer.patch removed from -mm tree
Message-Id: <20260331004307.CA6EDC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: switch the rmap lock held option off in compat layer
has been removed from the -mm tree.  Its filename was
     mm-switch-the-rmap-lock-held-option-off-in-compat-layer.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm: switch the rmap lock held option off in compat layer
Date: Fri, 20 Mar 2026 22:39:31 +0000

In the mmap_prepare compatibility layer, we don't need to hold the rmap
lock, as we are being called from an .mmap handler.

The .mmap_prepare hook, when invoked in the VMA logic, is called prior to
the VMA being instantiated, but the completion hook is called after the VMA
is linked into the maple tree, meaning rmap walkers can reach it.

The mmap hook does not link the VMA into the tree, so this cannot happen.

Therefore it's safe to simply disable this in the mmap_prepare
compatibility layer.

Also update VMA tests code to reflect current compatibility layer state.

[akpm@linux-foundation.org: fix comment typo, per Vlastimil]
Link: https://lkml.kernel.org/r/dda74230d26a1fcd79a3efab61fa4101dd1cac64.1774045440.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bodo Stroesser <bostroesser@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Long Li <longli@microsoft.com>
Cc: Marc Dionne <marc.dionne@auristor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Richard Weinberger <richard@nod.at>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c                       |    6 +++-
 tools/testing/vma/include/dup.h |   42 +++++++++++++++---------------
 2 files changed, 27 insertions(+), 21 deletions(-)

--- a/mm/util.c~mm-switch-the-rmap-lock-held-option-off-in-compat-layer
+++ a/mm/util.c
@@ -1204,6 +1204,7 @@ int compat_vma_mmap(struct file *file, s
 
 		.action.type = MMAP_NOTHING, /* Default */
 	};
+	struct mmap_action *action = &desc.action;
 	int err;
 
 	err = vfs_mmap_prepare(file, &desc);
@@ -1214,8 +1215,11 @@ int compat_vma_mmap(struct file *file, s
 	if (err)
 		return err;
 
+	/* being invoked from .mmap means we don't have to enforce this. */
+	action->hide_from_rmap_until_complete = false;
+
 	set_vma_from_desc(vma, &desc);
-	err = mmap_action_complete(vma, &desc.action);
+	err = mmap_action_complete(vma, action);
 	if (err) {
 		const size_t len = vma_pages(vma) << PAGE_SHIFT;
 
--- a/tools/testing/vma/include/dup.h~mm-switch-the-rmap-lock-held-option-off-in-compat-layer
+++ a/tools/testing/vma/include/dup.h
@@ -1260,8 +1260,17 @@ static inline void vma_set_anonymous(str
 static inline void set_vma_from_desc(struct vm_area_struct *vma,
 		struct vm_area_desc *desc);
 
-static inline int __compat_vma_mmap(const struct file_operations *f_op,
-		struct file *file, struct vm_area_struct *vma)
+static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
+{
+	return file->f_op->mmap_prepare(desc);
+}
+
+static inline unsigned long vma_pages(struct vm_area_struct *vma)
+{
+	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+}
+
+static inline int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct vm_area_desc desc = {
 		.mm = vma->vm_mm,
@@ -1276,9 +1285,10 @@ static inline int __compat_vma_mmap(cons
 
 		.action.type = MMAP_NOTHING, /* Default */
 	};
+	struct mmap_action *action = &desc.action;
 	int err;
 
-	err = f_op->mmap_prepare(&desc);
+	err = vfs_mmap_prepare(file, &desc);
 	if (err)
 		return err;
 
@@ -1286,28 +1296,25 @@ static inline int __compat_vma_mmap(cons
 	if (err)
 		return err;
 
+	/* being invoked from .mmmap means we don't have to enforce this. */
+	action->hide_from_rmap_until_complete = false;
+
 	set_vma_from_desc(vma, &desc);
-	return mmap_action_complete(vma, &desc.action);
-}
+	err = mmap_action_complete(vma, action);
+	if (err) {
+		const size_t len = vma_pages(vma) << PAGE_SHIFT;
 
-static inline int compat_vma_mmap(struct file *file,
-		struct vm_area_struct *vma)
-{
-	return __compat_vma_mmap(file->f_op, file, vma);
+		do_munmap(current->mm, vma->vm_start, len, NULL);
+	}
+	return err;
 }
 
-
 static inline void vma_iter_init(struct vma_iterator *vmi,
 		struct mm_struct *mm, unsigned long addr)
 {
 	mas_init(&vmi->mas, &mm->mm_mt, addr);
 }
 
-static inline unsigned long vma_pages(struct vm_area_struct *vma)
-{
-	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
-}
-
 static inline void mmap_assert_locked(struct mm_struct *);
 static inline struct vm_area_struct *find_vma_intersection(struct mm_struct *mm,
 						unsigned long start_addr,
@@ -1477,11 +1484,6 @@ static inline int vfs_mmap(struct file *
 	return file->f_op->mmap(file, vma);
 }
 
-static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
-{
-	return file->f_op->mmap_prepare(desc);
-}
-
 static inline void vma_set_file(struct vm_area_struct *vma, struct file *file)
 {
 	/* Changing an anonymous vma with this is illegal */
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

