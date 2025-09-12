Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6623527CCF2
	for <mm-commits@vger.kernel.org>; Fri, 12 Sep 2025 23:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757718906; cv=none; b=H91Apb5tZznq7uqPGUF/cN09rlixhPsv2yiglNsOeJ+pRMbEHYpq+cdVKA3w6SH3uYrTXxFvkhsrmo2NKw3Fwnts5KNPS8OEpc3OkQs6oLiGMQMkhy9hJZTt1b5SIs6ZEGSUVNlamCjKoLSDKLyOT2X65ox8Gmqia3FQHMsStlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757718906; c=relaxed/simple;
	bh=Bw+ghoxPkRFALCGh5hpn3UngCIZqAtF5J4zZb8qkMxk=;
	h=Date:To:From:Subject:Message-Id; b=LmP0CarDPfPh3R5FSqB0vxNWFQpAG4X6qk6WlBwHnStE+kbdZ15+sJtctBgrPjqb4+hJvoTdS+47lTtkdh+fSGYJNF2JWXcNiZL0CxVNXM3F3HJp7GYif4qDwSdXK+C7jrmU6/kRoMzZWa6x6c4Nmd2HhbZ+Eswxi61z5kZzcEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HFoJpg7H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HFoJpg7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009F6C4CEF1;
	Fri, 12 Sep 2025 23:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757718906;
	bh=Bw+ghoxPkRFALCGh5hpn3UngCIZqAtF5J4zZb8qkMxk=;
	h=Date:To:From:Subject:From;
	b=HFoJpg7HwP/TtFuDVheZEsYGpiUDU8S8j3/S00wgjxBddDCEeMjJl61QcMYWef4dL
	 ymj8sZ1ooFgHkUAw+5X2O7I+QTgM+bS7C17p6rntStUjlmM3QbaFye9sMQtp1pWFyg
	 ddbZC6kPIHjADe6tG4GgVXxT/3+iuIOadE7LTSxg=
Date: Fri, 12 Sep 2025 16:15:05 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-ability-to-take-further-action-in-vm_area_desc-fix.patch added to mm-unstable branch
Message-Id: <20250912231506.009F6C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nommu fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-ability-to-take-further-action-in-vm_area_desc-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-ability-to-take-further-action-in-vm_area_desc-fix.patch

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
Subject: nommu fix
Date: Fri, 12 Sep 2025 10:56:39 +0100

Link: https://lkml.kernel.org/r/3f7a0972-50da-453c-a0cf-73001e9ba835@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 66 insertions(+), 2 deletions(-)

--- a/mm/util.c~mm-add-ability-to-take-further-action-in-vm_area_desc-fix
+++ a/mm/util.c
@@ -1302,6 +1302,7 @@ struct page **mmap_action_mixedmap_pages
 }
 EXPORT_SYMBOL(mmap_action_mixedmap_pages);
 
+#ifdef CONFIG_MMU
 /**
  * mmap_action_prepare - Perform preparatory setup for an VMA descriptor
  * action which need to be performed.
@@ -1313,7 +1314,7 @@ EXPORT_SYMBOL(mmap_action_mixedmap_pages
  * it wishes to perform.
  */
 void mmap_action_prepare(struct mmap_action *action,
-			     struct vm_area_desc *desc)
+			struct vm_area_desc *desc)
 {
 	switch (action->type) {
 	case MMAP_NOTHING:
@@ -1342,7 +1343,7 @@ EXPORT_SYMBOL(mmap_action_prepare);
  * Return: 0 on success, or error, at which point the VMA will be unmapped.
  */
 int mmap_action_complete(struct mmap_action *action,
-			     struct vm_area_struct *vma)
+			struct vm_area_struct *vma)
 {
 	int err = 0;
 
@@ -1424,6 +1425,69 @@ int mmap_action_complete(struct mmap_act
 	return 0;
 }
 EXPORT_SYMBOL(mmap_action_complete);
+#else
+void mmap_action_prepare(struct mmap_action *action,
+			struct vm_area_desc *desc)
+{
+	switch (action->type) {
+	case MMAP_NOTHING:
+	case MMAP_CUSTOM_ACTION:
+		break;
+	case MMAP_REMAP_PFN:
+	case MMAP_INSERT_MIXED:
+	case MMAP_INSERT_MIXED_PAGES:
+		WARN_ON_ONCE(1); /* nommu cannot handle these. */
+		break;
+	}
+}
+EXPORT_SYMBOL(mmap_action_prepare);
+
+int mmap_action_complete(struct mmap_action *action,
+			struct vm_area_struct *vma)
+{
+	int err = 0;
+
+	switch (action->type) {
+	case MMAP_NOTHING:
+		break;
+	case MMAP_REMAP_PFN:
+	case MMAP_INSERT_MIXED:
+	case MMAP_INSERT_MIXED_PAGES:
+		WARN_ON_ONCE(1); /* nommu cannot handle these. */
+
+		break;
+	case MMAP_CUSTOM_ACTION:
+		err = action->custom.action_hook(vma);
+		break;
+	}
+
+	/*
+	* If an error occurs, unmap the VMA altogether and return an error. We
+	* only clear the newly allocated VMA, since this function is only
+	* invoked if we do NOT merge, so we only clean up the VMA we created.
+	*/
+	if (err) {
+		const size_t len = vma_pages(vma) << PAGE_SHIFT;
+
+		do_munmap(current->mm, vma->vm_start, len, NULL);
+
+		if (action->error_hook) {
+			/* We may want to filter the error. */
+			err = action->error_hook(err);
+
+			/* The caller should not clear the error. */
+			VM_WARN_ON_ONCE(!err);
+		}
+		return err;
+	}
+
+	if (action->success_hook)
+		err = action->success_hook(vma);
+
+	return 0;
+}
+EXPORT_SYMBOL(mmap_action_complete);
+#endif
 
 #ifdef CONFIG_MMU
 /**
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-jann-horn-as-rmap-reviewer.patch
mm-add-bitmap-mm-flags-field.patch
mm-add-bitmap-mm-flags-field-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors.patch
mm-convert-prctl-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors-fix.patch
mm-convert-uprobes-to-mm_flags_-accessors.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags-fix.patch
mm-correct-sign-extension-issue-in-mmf_-flag-masks.patch
mm-correct-sign-extension-issue-in-mmf_-flag-masks-fix.patch
mm-update-fork-mm-flags-initialisation-to-use-bitmap.patch
mm-convert-remaining-users-to-mm_flags_-accessors.patch
mm-replace-mm-flags-with-bitmap-entirely-and-set-to-64-bits.patch
mm-specify-separate-file-and-vm_file-params-in-vm_area_desc.patch
mm-do-not-assume-file-==-vma-vm_file-in-compat_vma_mmap_prepare.patch
mm-shmem-update-shmem-to-use-mmap_prepare.patch
device-dax-update-devdax-to-use-mmap_prepare.patch
mm-add-vma_desc_size-vma_desc_pages-helpers.patch
relay-update-relay-to-use-mmap_prepare.patch
mm-vma-rename-__mmap_prepare-function-to-avoid-confusion.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete.patch
mm-introduce-io_remap_pfn_range_.patch
mm-add-ability-to-take-further-action-in-vm_area_desc.patch
mm-add-ability-to-take-further-action-in-vm_area_desc-fix.patch
doc-update-porting-vfs-documentation-for-mmap_prepare-actions.patch
mm-hugetlbfs-update-hugetlbfs-to-use-mmap_prepare.patch
mm-update-mem-char-driver-to-use-mmap_prepare.patch
mm-update-resctl-to-use-mmap_prepare.patch
mm-update-cramfs-to-use-mmap_prepare.patch
fs-proc-add-the-proc_mmap_prepare-hook-for-procfs.patch
fs-proc-update-vmcore-to-use-proc_mmap_prepare.patch
kcov-update-kcov-to-use-mmap_prepare.patch

