Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F463876CD
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 21:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791410025; cv=none; b=HzxSQcWiCur3jZnySg99HKI9b4+VD/EpYWv4wTqc5dJJ2QlZqm7hNzj9MAzwcbWtsBgm0aelgISXyLBfkO0l99wliNkbxdW5XpRJ+/i8nT9JZepDWeYw2pFOQdbKRv2CU0U9H7WGUauxcw4jo8FWtxBX4W7Jae96bsaR9zdDrwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791410025; c=relaxed/simple;
	bh=fTpjGpcJcUWrlU8mAuGgi+4re5WuKQhp78oCEc4j86o=;
	h=Date:To:From:Subject:Message-Id; b=hNGsFewu460yBTu/PINKiYIu869kouwnWo16CP8PqsQU+9UU6ZnjLveUnsNzgLagqVKGYJMKWW+Oc/AWq5vvO4Cgjv5eo46RzL+d+9R6yQBNVlP1FA0nOgqQZsgT3tqLorEo2t5UT3UNn3g6V7QiNesnqPxybhE2Htluq/EEqyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AQdXtGie; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AQdXtGie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205801F000FF;
	Wed,  7 Oct 2026 21:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791410024;
	bh=AvGjDllzPnfHj+6FdSTeNdnqKP/nhTLQhpFK14XKDK0=;
	h=Date:To:From:Subject;
	b=AQdXtGie+2IPmzYHVeVS7tqrqCSH2YIhJcY78RJ85zlvtMe6sSHh5YUMb8fnLG3q5
	 lg8gMfXxeP+R2rn3P+H9T97IiGDeqiCWp94lZu243TvBbjrmsK1Mjufj3RZ6OqRbPR
	 XoPcb5jQeN9iEMnS99a3BhkAkScKWIqlv+Z19Cug=
Date: Wed, 07 Oct 2026 14:53:43 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,okerixx@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-consistently-validate-vma-state-after-mmap-hooks-fix.patch added to mm-unstable branch
Message-Id: <20261007215344.205801F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: keep the unlinked VMA off the file across unmap on mmap hook failure
has been added to the -mm mm-unstable branch.  Its filename is
     mm-consistently-validate-vma-state-after-mmap-hooks-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-consistently-validate-vma-state-after-mmap-hooks-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Oleg Keri <okerixx@gmail.com>
Subject: mm/vma: keep the unlinked VMA off the file across unmap on mmap hook failure
Date: Wed,  7 Oct 2026 21:47:08 +0200

Since commit 2ceb21171dd9 ("mm: consistently validate VMA state after
mmap[_prepare] hooks"), the mmap error path clears vma->vm_file only
after unmap_region(), so free_pgtables() unlinks the never-linked VMA
and drops i_mmap_writable. Once it goes negative, every later shared
writable mmap of that file fails with -EPERM until reboot.

Clear vm_file across unmap_region() only, so that free_pgtables() does
not unlink a VMA that was never linked to the file, and restore it for
vma_close(): when the hook succeeded and the validation failed, the
driver's close() still runs and may use vma->vm_file.

Link: https://lore.kernel.org/20261007194708.2009-1-okerixx@gmail.com
Fixes: 2ceb21171dd9 ("mm: consistently validate VMA state after mmap[_prepare] hooks")
Signed-off-by: Oleg Keri <okerixx@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
---

 mm/vma.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/vma.c~mm-consistently-validate-vma-state-after-mmap-hooks-fix
+++ a/mm/vma.c
@@ -2626,12 +2626,15 @@ static int __mmap_new_file_vma(struct mm
 	map->vm_file = vma->vm_file;
 
 	if (error) {
+		struct file *file = vma->vm_file;
 		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
 			    map->prev, map->next);
 
+		vma->vm_file = NULL;
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
 		unmap_region(&unmap);
+		vma->vm_file = file;
 		/* Only safe once unmapped. */
 		vma_close(vma);
 
_

Patches currently in -mm which might be from okerixx@gmail.com are

mm-consistently-validate-vma-state-after-mmap-hooks-fix.patch

