Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB122AE84
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 22:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725055855; cv=none; b=H6BmhbtZV7y9CX0GTYMgx8o9L9uyfaahVgPi1Cy8uydnLsQqwQiHNXAy76BX5o9JfMN1reul34ohCRR41TBsZKz5PJ4Mm0b0H0qv42STsglBOoiNUs2/yEixgVEeVtK+JAj8t+O26fNlISVqnaoYV+ZCfzvMYoPl0TkC5x+AgiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725055855; c=relaxed/simple;
	bh=tQZaOMewUKg2y4dSxtZEwofSj19UWwtfXQlfjpZWfyM=;
	h=Date:To:From:Subject:Message-Id; b=Bm8nQR4XwrMNxGbPX6W3h7FgPWuxNicGOpEJW0ObFgh61SLFezPgRR4zzeivZtXvLMabR8V+4tcUmImB95Gic8N+LMQugOe2qUXPWJkfL0cyqtWAvUYX725l0Y9K6o98vAFbQm6X/V3JbW3lj9VdqlSPPkjxmcCZdJUOOupPUn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ax/71vpl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ax/71vpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F237C4CEC2;
	Fri, 30 Aug 2024 22:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725055855;
	bh=tQZaOMewUKg2y4dSxtZEwofSj19UWwtfXQlfjpZWfyM=;
	h=Date:To:From:Subject:From;
	b=ax/71vplwZxLjSnw34CnemYkkhzX8Xb972sLKAI09P1KeuhqT7Jx4Mq571yRgAeDO
	 PfNJ/UJnuGG7zEEKXtRsfy05/22DCCAkzGeEGJYxWO4HrN8mWy4LOFj54Z0Y2DG0du
	 63TueqgNPFZCQfmYM0J2FnHZ8MsZGngntpmklzTE=
Date: Fri, 30 Aug 2024 15:10:54 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-introduce-abort_munmap_vmas.patch added to mm-unstable branch
Message-Id: <20240830221055.2F237C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: introduce abort_munmap_vmas()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-introduce-abort_munmap_vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-introduce-abort_munmap_vmas.patch

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
Subject: mm/vma: introduce abort_munmap_vmas()
Date: Fri, 30 Aug 2024 00:00:42 -0400

Extract clean up of failed munmap() operations from do_vmi_align_munmap().
This simplifies later patches in the series.

It is worth noting that the mas_for_each() loop now has a different upper
limit.  This should not change the number of vmas visited for reattaching
to the main vma tree (mm_mt), as all vmas are reattached in both
scenarios.

Link: https://lkml.kernel.org/r/20240830040101.822209-3-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/mm/vma.c~mm-vma-introduce-abort_munmap_vmas
+++ a/mm/vma.c
@@ -669,6 +669,22 @@ again:
 }
 
 /*
+ * abort_munmap_vmas - Undo any munmap work and free resources
+ *
+ * Reattach any detached vmas and free up the maple tree used to track the vmas.
+ */
+static inline void abort_munmap_vmas(struct ma_state *mas_detach)
+{
+	struct vm_area_struct *vma;
+
+	mas_set(mas_detach, 0);
+	mas_for_each(mas_detach, vma, ULONG_MAX)
+		vma_mark_detached(vma, false);
+
+	__mt_destroy(mas_detach->tree);
+}
+
+/*
  * do_vmi_align_munmap() - munmap the aligned region from @start to @end.
  * @vmi: The vma iterator
  * @vma: The starting vm_area_struct
@@ -834,11 +850,7 @@ clear_tree_failed:
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

