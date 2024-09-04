Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B958978281
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423550; cv=none; b=WFlbEJhjPpChQ5BYuP55Z/r8EeMlbGLcgfs6TAGANmPSEGtcpOCoYcn+yadkRP0F06mHidlApogJMCrIc1Ok4yNL5yLj6CHylAiVwkgQdokRvcDAnD80jUtjiTlGUyfhERba45+Ag0zZHzrBYeHNtRQnoIkbr9I9zGsDz9R6J2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423550; c=relaxed/simple;
	bh=0Yy6Y6PHV8WcYrtiwIWnYStFNuzbxrc37KIWVWVooh8=;
	h=Date:To:From:Subject:Message-Id; b=QmTuLYKN6wkb7H5miEp9CB8urKa/UB3/rCqP4W3E9QS1TdVFIfWR6iA4bwl4UxYGqmhkn8xG0M4ZjleV9joEjZezHHdAhJrOir8kvM71fyWoj710MbSOXslCsW2WRc1Y7RcNUAE46I4y1q6uphlSDjLrUUYlczsULKeQKsMG4eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ticzFAKk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ticzFAKk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40ACEC4CEC2;
	Wed,  4 Sep 2024 04:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423550;
	bh=0Yy6Y6PHV8WcYrtiwIWnYStFNuzbxrc37KIWVWVooh8=;
	h=Date:To:From:Subject:From;
	b=ticzFAKkXrhzoRPHO3zf9Rv/HdfO3OcY4yjlm70YQf7ELxBmAE7RV98Y/e/0+b7+D
	 cw+Md08n3cDG9Of8Y4z7wlM5Rf+mkCbO7vcOBpWhRB6RjBkpDBQRA8m+IgOVQeegye
	 +ppge5rn0gutXhjHDOWhjeoPXAynQIef6mXWb3x8=
Date: Tue, 03 Sep 2024 21:19:09 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-introduce-abort_munmap_vmas.patch removed from -mm tree
Message-Id: <20240904041910.40ACEC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: introduce abort_munmap_vmas()
has been removed from the -mm tree.  Its filename was
     mm-vma-introduce-abort_munmap_vmas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


