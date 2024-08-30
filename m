Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2861BF31D
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 22:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725055870; cv=none; b=p4+6RX+RVle4PpG48Qa8II8gzOCI2NLv4kG55LkmReM9TW2n2RP/kK9onySPK/0Cts0AQ6xLThjlDnOUEATUZkErGvXpZAY/DCAx0VqAW3izSRCh1KyJrE8g7r09ccUWv3rmeIXSoa8JL96Estha7BcXyeXPNE87slmAYTTjiIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725055870; c=relaxed/simple;
	bh=LabDIICmJT4fWaElZ9Jg3wu1knmNjeDpJ3TMWy8oJLo=;
	h=Date:To:From:Subject:Message-Id; b=D64CpH7QkGWZJnJHnAPoE4uUynh+QiDHW4jzKq1FD26931+t8u/aKe5ER100p6I+0D5cw+dHK52qjswelBzpDoUzySk++HLR9FkDPTScTIzmhLX22dqcv03ekZebaKua2rhrWSJ0dv/BxoCwMlncAGq1jtEd7iB/II9ojgK7dKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SDHGi4sB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SDHGi4sB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6BF9C4CEC2;
	Fri, 30 Aug 2024 22:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725055869;
	bh=LabDIICmJT4fWaElZ9Jg3wu1knmNjeDpJ3TMWy8oJLo=;
	h=Date:To:From:Subject:From;
	b=SDHGi4sB/x5+/62aTM8KicfnbjAQgkg6JnzH5nbaQrs+mqlG11Z4vgRTFcOzL5PXL
	 rUovT/JrS0O+AmtoxmzAJA4GJ05dTFcVRm34iBFk/1ViwZyw3NbEz2hOyq4L5R1e+6
	 vE/Kxi/nkVDohpXSYRpVTQTbOTAUDXJpdav8Vy0c=
Date: Fri, 30 Aug 2024 15:11:08 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-inline-munmap-operation-in-mmap_region.patch added to mm-unstable branch
Message-Id: <20240830221108.E6BF9C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: inline munmap operation in mmap_region()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-inline-munmap-operation-in-mmap_region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-inline-munmap-operation-in-mmap_region.patch

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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/vma: inline munmap operation in mmap_region()
Date: Fri, 30 Aug 2024 00:00:48 -0400

mmap_region is already passed sanitized addr and len, so change the call
to do_vmi_munmap() to do_vmi_align_munmap() and inline the other checks.

The inlining of the function and checks is an intermediate step in the
series so future patches are easier to follow.

Link: https://lkml.kernel.org/r/20240830040101.822209-9-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/mmap.c~mm-vma-inline-munmap-operation-in-mmap_region
+++ a/mm/mmap.c
@@ -1388,12 +1388,15 @@ unsigned long mmap_region(struct file *f
 			return -ENOMEM;
 	}
 
-	/* Unmap any existing mapping in the area */
-	error = do_vmi_munmap(&vmi, mm, addr, len, uf, false);
-	if (error == -EPERM)
-		return error;
-	else if (error)
-		return -ENOMEM;
+	/* Find the first overlapping VMA */
+	vma = vma_find(&vmi, end);
+	if (vma) {
+		/* Unmap any existing mapping in the area */
+		error = do_vmi_align_munmap(&vmi, vma, mm, addr, end, uf, false);
+		if (error)
+			return error;
+		vma = NULL;
+	}
 
 	/*
 	 * Private writable mapping: check memory availability
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple_tree-remove-rcu_read_lock-from-mt_validate.patch
mm-vma-correctly-position-vma_iterator-in-__split_vma.patch
mm-vma-introduce-abort_munmap_vmas.patch
mm-vma-introduce-vmi_complete_munmap_vmas.patch
mm-vma-extract-the-gathering-of-vmas-from-do_vmi_align_munmap.patch
mm-vma-introduce-vma_munmap_struct-for-use-in-munmap-operations.patch
mm-vma-change-munmap-to-use-vma_munmap_struct-for-accounting-and-surrounding-vmas.patch
mm-vma-extract-validate_mm-from-vma_complete.patch
mm-vma-inline-munmap-operation-in-mmap_region.patch
mm-vma-expand-mmap_region-munmap-call.patch
mm-vma-support-vma-==-null-in-init_vma_munmap.patch
mm-mmap-reposition-vma-iterator-in-mmap_region.patch
mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct.patch
mm-clean-up-unmap_region-argument-list.patch
mm-mmap-avoid-zeroing-vma-tree-in-mmap_region.patch
mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure.patch
mm-mmap-use-phys_pfn-in-mmap_region.patch
mm-mmap-use-vms-accounted-pages-in-mmap_region.patch
ipc-shm-mm-drop-do_vma_munmap.patch
mm-move-may_expand_vm-check-in-mmap_region.patch
mm-vma-drop-incorrect-comment-from-vms_gather_munmap_vmas.patch
mm-vmah-optimise-vma_munmap_struct.patch

