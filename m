Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F038378B50
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423567; cv=none; b=YnNyyEWN1mQbVZG00t1p2ubK3+DbWpBnps+NJ9XKmgS+qMUW1e/JSG3EyM22ZtMK3u3U61VdwvBpCYtBJv3ciZ1SKiFUhOysaTza8kQc63NSCjskWaA59S0iwsB/a2UkIDbFQEL+bOy6WF9Jt5a0n5/OgiC48ZWDacR9zmpo4mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423567; c=relaxed/simple;
	bh=j728E7w4sE4tbKkGaVSlUo4ypC0QLRJNY4Och4JI59U=;
	h=Date:To:From:Subject:Message-Id; b=WrLBAPRd9CJ76w2DHeuaPwx1E8fOCeUKJYeACOkk49Gs7DuPJuf5edLkTUuK4lEWYLznEVhBbkKpEdbE3QFiR++Q5po6J17DVT205sMvXBgBugrUqJIXDomBZEfmNbHHWonq3ngOT5aYoeaI/HLkGAdyIdsxrJCJWSMPkwQ3sMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DV4O/n33; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DV4O/n33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9293C4CEC2;
	Wed,  4 Sep 2024 04:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423565;
	bh=j728E7w4sE4tbKkGaVSlUo4ypC0QLRJNY4Och4JI59U=;
	h=Date:To:From:Subject:From;
	b=DV4O/n335PPMNtT/DbAaaYP0wlDV+iFw+v+YP6Ha1kRTYe+cvh+/JH5hd03d5bJew
	 m1twEWvNhC41tCiHEYPHlRB3+aIv4V73Awbv/AjtRbN6eUC3ZYyL0yaK2vRNWbfCy+
	 UaNtXSZtNZqrEGETNPnigxhxFYZ7iqGu/1R8f1Us=
Date: Tue, 03 Sep 2024 21:19:25 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-clean-up-unmap_region-argument-list.patch removed from -mm tree
Message-Id: <20240904041925.A9293C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: clean up unmap_region() argument list
has been removed from the -mm tree.  Its filename was
     mm-clean-up-unmap_region-argument-list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm: clean up unmap_region() argument list
Date: Fri, 30 Aug 2024 00:00:53 -0400

With the only caller to unmap_region() being the error path of
mmap_region(), the argument list can be significantly reduced.

Link: https://lkml.kernel.org/r/20240830040101.822209-14-Liam.Howlett@oracle.com
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

 mm/mmap.c |    3 +--
 mm/vma.c  |   17 ++++++++---------
 mm/vma.h  |    6 ++----
 3 files changed, 11 insertions(+), 15 deletions(-)

--- a/mm/mmap.c~mm-clean-up-unmap_region-argument-list
+++ a/mm/mmap.c
@@ -1615,8 +1615,7 @@ unmap_and_free_vma:
 
 		vma_iter_set(&vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
-		unmap_region(mm, &vmi.mas, vma, prev, next, vma->vm_start,
-			     vma->vm_end, vma->vm_end, true);
+		unmap_region(&vmi.mas, vma, prev, next);
 	}
 	if (writable_file_mapping)
 		mapping_unmap_writable(file->f_mapping);
--- a/mm/vma.c~mm-clean-up-unmap_region-argument-list
+++ a/mm/vma.c
@@ -155,22 +155,21 @@ void remove_vma(struct vm_area_struct *v
  *
  * Called with the mm semaphore held.
  */
-void unmap_region(struct mm_struct *mm, struct ma_state *mas,
-		struct vm_area_struct *vma, struct vm_area_struct *prev,
-		struct vm_area_struct *next, unsigned long start,
-		unsigned long end, unsigned long tree_end, bool mm_wr_locked)
+void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
+		struct vm_area_struct *prev, struct vm_area_struct *next)
 {
+	struct mm_struct *mm = vma->vm_mm;
 	struct mmu_gather tlb;
-	unsigned long mt_start = mas->index;
 
 	lru_add_drain();
 	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
-	unmap_vmas(&tlb, mas, vma, start, end, tree_end, mm_wr_locked);
-	mas_set(mas, mt_start);
+	unmap_vmas(&tlb, mas, vma, vma->vm_start, vma->vm_end, vma->vm_end,
+		   /* mm_wr_locked = */ true);
+	mas_set(mas, vma->vm_end);
 	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
-				 next ? next->vm_start : USER_PGTABLES_CEILING,
-				 mm_wr_locked);
+		      next ? next->vm_start : USER_PGTABLES_CEILING,
+		      /* mm_wr_locked = */ true);
 	tlb_finish_mmu(&tlb);
 }
 
--- a/mm/vma.h~mm-clean-up-unmap_region-argument-list
+++ a/mm/vma.h
@@ -149,10 +149,8 @@ int do_vmi_munmap(struct vma_iterator *v
 
 void remove_vma(struct vm_area_struct *vma, bool unreachable);
 
-void unmap_region(struct mm_struct *mm, struct ma_state *mas,
-		struct vm_area_struct *vma, struct vm_area_struct *prev,
-		struct vm_area_struct *next, unsigned long start,
-		unsigned long end, unsigned long tree_end, bool mm_wr_locked);
+void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
+		struct vm_area_struct *prev, struct vm_area_struct *next);
 
 /* Required by mmap_region(). */
 bool
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


