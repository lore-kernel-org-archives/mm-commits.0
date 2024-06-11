Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5AB74407
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 18:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718130420; cv=none; b=OWUr2XiPubDNlmNsFB97nsjQMwMS3+EacLHWPz6q+wJ1965irwg7n0R9FwIr/Ur60WfXuit2zF5AFrx1z5XVG2P/41lj3VGpCA7+SJ8+Zpi9k/bjk4/bsP6X9OETzcP49xXJL3jV+yf6tJqXH63bfo9LrsI5Imcnv1QmW2nKRtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718130420; c=relaxed/simple;
	bh=WWNAxrsE3/PZagkxJ4LvghznCu34aLTvOrn899Dt7vs=;
	h=Date:To:From:Subject:Message-Id; b=q8hJAjybtCsAJ/j1g6h6zAqeH7dtaNtrs0JJj49nPhdr8G4LPHmIhOuKN8FAcxQEwAnPBg2VE67C5kSvtty/Rzd5wlch99bhzyhPC60DQdHtXBWWac1ZEvtQ4cg3CVh6xkzcn/PkI/K7m3tgFT/gCcyqGQ6Vghb2dFe4GXz4qa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yY8V2mIs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yY8V2mIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04353C2BD10;
	Tue, 11 Jun 2024 18:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718130420;
	bh=WWNAxrsE3/PZagkxJ4LvghznCu34aLTvOrn899Dt7vs=;
	h=Date:To:From:Subject:From;
	b=yY8V2mIso6O4Poq1ohNs0Z+d5WHkFjX8yAWB5zhqJr90BwCqS194c2NqxrjK8uq24
	 KVjuPAhQ+aPytm+tWYGiL7M1W5bkd15AGliy06elbLTQ+uKYImd4vrPOBJkcDh1HHa
	 bIjxSV9+XLeve+FoBqNxKZafp717Ib+aEN00y5tU=
Date: Tue, 11 Jun 2024 11:26:59 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-introduce-abort_munmap_vmas.patch added to mm-unstable branch
Message-Id: <20240611182700.04353C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmap: introduce abort_munmap_vmas()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-introduce-abort_munmap_vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-introduce-abort_munmap_vmas.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/mmap: introduce abort_munmap_vmas()
Date: Tue, 11 Jun 2024 14:01:54 -0400

Extract clean up of failed munmap() operations from do_vmi_align_munmap().
This simplifies later patches in the series.

Link: https://lkml.kernel.org/r/20240611180200.711239-3-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- a/mm/mmap.c~mm-mmap-introduce-abort_munmap_vmas
+++ a/mm/mmap.c
@@ -2587,6 +2587,25 @@ struct vm_area_struct *vma_merge_extend(
 }
 
 /*
+ * abort_munmap_vmas - Undo any munmap work and free resources
+ *
+ * Reattach detached vmas, free up maple tree used to track the vmas.
+ */
+static inline void abort_munmap_vmas(struct ma_state *mas_detach)
+{
+	struct vm_area_struct *vma;
+	int limit;
+
+	limit = mas_detach->index;
+	mas_set(mas_detach, 0);
+	/* Re-attach any detached VMAs */
+	mas_for_each(mas_detach, vma, limit)
+		vma_mark_detached(vma, false);
+
+	__mt_destroy(mas_detach->tree);
+}
+
+/*
  * do_vmi_align_munmap() - munmap the aligned region from @start to @end.
  * @vmi: The vma iterator
  * @vma: The starting vm_area_struct
@@ -2740,11 +2759,7 @@ clear_tree_failed:
 userfaultfd_error:
 munmap_gather_failed:
 end_split_failed:
-	mas_set(&mas_detach, 0);
-	mas_for_each(&mas_detach, next, end)
-		vma_mark_detached(next, false);
-
-	__mt_destroy(&mt_detach);
+	abort_munmap_vmas(&mas_detach);
 start_split_failed:
 map_count_exceeded:
 	validate_mm(mm);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mmap-correctly-position-vma_iterator-in-__split_vma.patch
mm-mmap-introduce-abort_munmap_vmas.patch
mm-mmap-introduce-vmi_complete_munmap_vmas.patch
mm-mmap-extract-the-gathering-of-vmas-from-do_vmi_align_munmap.patch
mm-mmap-introduce-vma_munmap_struct-for-use-in-munmap-operations.patch
mm-mmap-change-munmap-to-use-vma_munmap_struct-for-accounting-and-surrounding-vmas.patch
mm-mmap-extract-validate_mm-from-vma_complete.patch
mm-mmap-use-split-munmap-calls-for-map_fixed.patch

