Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45D530C37A
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 20:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780430835; cv=none; b=sMlwRBKtt0WzEDLNoh13FGjlNBs9GlApLVrAwIZiWOP1T9YqIDe5RtrAMIzaPayEBygGWytTUyGEfwLzOGCx2FLMOnGsbMpSXEGGXMlg/f7bb9qXfaUMijTfqCTPpQUye6pr7+KyODp/ycJIgGfzSXpLv26z5G8kKrOFOjmS3ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780430835; c=relaxed/simple;
	bh=1WhNsRfOPNliikwheciZymNNBd9a7W/ZCJAQK9Epc6U=;
	h=Date:To:From:Subject:Message-Id; b=MNt2sfNHfg885OU9jwQb+U2W8+2e6NiPUcFPmvTSRZOKoqUb/tNBb3jTq3iVvlbJDajAuWJR/2HhItAszeB8QgkfqCSxetXOiua5vBd0FoeutCM0+U8niQOUN5naQG9+Sf50X1GF05fPO2X5RcPM/o90osBgNx3TBqhW/gtM0Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HmwMIE4g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HmwMIE4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7CE1F00893;
	Tue,  2 Jun 2026 20:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780430834;
	bh=s5eI3+1WHWtxFSk1O/og280K0/rwydKbb14sXTuGIHg=;
	h=Date:To:From:Subject;
	b=HmwMIE4ggd3CKslpIbMpMYIfV28fs+B//wMI5kXOvKdlxQsDaqzsA4Y11sTEbFSYC
	 Mu3OgEEkDVlqEt8Ds7HII4n5uMROyZ0iQJOcI+KV06ojwbJpcnWzLzLb8WfvkwEeRm
	 ZW1I/2IwCd/+wGnmDBhZx1rBC0hHhZ4qCaQDiR5U=
Date: Tue, 02 Jun 2026 13:07:13 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vma-eliminate-mmap_action-error_hook-introduce-error_filter.patch removed from -mm tree
Message-Id: <20260602200714.3B7CE1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: eliminate mmap_action->error_hook, introduce error_filter
has been removed from the -mm tree.  Its filename was
     mm-vma-eliminate-mmap_action-error_hook-introduce-error_filter.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/vma: eliminate mmap_action->error_hook, introduce error_filter
Date: Fri, 22 May 2026 17:00:11 +0100

Rather than providing a hook, simplify things by providing the ability to
filter errors.  This allows us to more carefully validate the value
provided and thus ensure only a valid error code is specified, and
simplifies the interface.

This way, we eliminate all hooks but mmap_prepare and allow only mmap
actions to be specified (which core mm controls).

This significantly improves robustness and eliminates any unnecessary code
duplication in driver mmap hooks.

We also update the /dev/mem logic (the only user) to use
mmap_action->error_filter instead.

Link: https://lore.kernel.org/e770b28427937057fa953ac380a134b24acd8bb4.1779462249.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c              |    8 +-------
 include/linux/mm_types.h        |    9 +++------
 mm/util.c                       |   29 +++++++++++++++++++++--------
 tools/testing/vma/include/dup.h |    9 +++------
 4 files changed, 28 insertions(+), 27 deletions(-)

--- a/drivers/char/mem.c~mm-vma-eliminate-mmap_action-error_hook-introduce-error_filter
+++ a/drivers/char/mem.c
@@ -322,11 +322,6 @@ static const struct vm_operations_struct
 #endif
 };
 
-static int mmap_filter_error(int err)
-{
-	return -EAGAIN;
-}
-
 static int mmap_mem_prepare(struct vm_area_desc *desc)
 {
 	struct file *file = desc->file;
@@ -362,8 +357,7 @@ static int mmap_mem_prepare(struct vm_ar
 
 	/* Remap-pfn-range will mark the range with the I/O flag. */
 	mmap_action_remap_full(desc, desc->pgoff);
-	/* We filter remap errors to -EAGAIN. */
-	desc->action.error_hook = mmap_filter_error;
+	desc->action.error_filter = -EAGAIN;
 
 	return 0;
 }
--- a/include/linux/mm_types.h~mm-vma-eliminate-mmap_action-error_hook-introduce-error_filter
+++ a/include/linux/mm_types.h
@@ -844,13 +844,10 @@ struct mmap_action {
 	enum mmap_action_type type;
 
 	/*
-	 * If specified, this hook is invoked when an error occurred when
-	 * attempting the selected action.
-	 *
-	 * The hook can return an error code in order to filter the error, but
-	 * it is not valid to clear the error here.
+	 * If non-zero, filter errors that arise from mmap actions such that we
+	 * return error_filter instead. Only valid error codes may be specified.
 	 */
-	int (*error_hook)(int err);
+	int error_filter;
 
 	/*
 	 * This should be set in rare instances where the operation required
--- a/mm/util.c~mm-vma-eliminate-mmap_action-error_hook-introduce-error_filter
+++ a/mm/util.c
@@ -1414,16 +1414,22 @@ static int mmap_action_finish(struct vm_
 	 */
 	len = vma_pages(vma) << PAGE_SHIFT;
 	do_munmap(current->mm, vma->vm_start, len, NULL);
-	if (action->error_hook) {
-		/* We may want to filter the error. */
-		err = action->error_hook(err);
-		/* The caller should not clear the error. */
-		VM_WARN_ON_ONCE(!err);
-	}
-	return err;
+
+	return action->error_filter ?: err;
 }
 
 #ifdef CONFIG_MMU
+
+static int check_mmap_action(struct mmap_action *action)
+{
+	const unsigned long filter = action->error_filter;
+
+	if (WARN_ON_ONCE(filter && !IS_ERR_VALUE(filter)))
+		return -EINVAL;
+
+	return 0;
+}
+
 /**
  * mmap_action_prepare - Perform preparatory setup for an VMA descriptor
  * action which need to be performed.
@@ -1433,7 +1439,14 @@ static int mmap_action_finish(struct vm_
  */
 int mmap_action_prepare(struct vm_area_desc *desc)
 {
-	switch (desc->action.type) {
+	struct mmap_action *action = &desc->action;
+	int err;
+
+	err = check_mmap_action(action);
+	if (err)
+		return err;
+
+	switch (action->type) {
 	case MMAP_NOTHING:
 		return 0;
 	case MMAP_REMAP_PFN:
--- a/tools/testing/vma/include/dup.h~mm-vma-eliminate-mmap_action-error_hook-introduce-error_filter
+++ a/tools/testing/vma/include/dup.h
@@ -483,13 +483,10 @@ struct mmap_action {
 	enum mmap_action_type type;
 
 	/*
-	 * If specified, this hook is invoked when an error occurred when
-	 * attempting the selection action.
-	 *
-	 * The hook can return an error code in order to filter the error, but
-	 * it is not valid to clear the error here.
+	 * If non-zero, filter errors that arise from mmap actions such that we
+	 * return error_filter instead. Only valid error codes may be specified.
 	 */
-	int (*error_hook)(int err);
+	int error_filter;
 
 	/*
 	 * This should be set in rare instances where the operation required
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-huge_memory-use-correct-flags-for-device-private-pmd-entry.patch

