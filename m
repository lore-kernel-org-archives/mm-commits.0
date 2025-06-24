Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258CA2586FE
	for <mm-commits@vger.kernel.org>; Tue, 24 Jun 2025 23:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750806832; cv=none; b=ao00mlkvlP1wjAyhN8k1s+evU+RDGZ9mAMB3ieMOvLRDiwxy6koKO0Zo4RmydJs+gmO077jd6DXtGtg08EeoGcTpQcJqTC9trLWOVbzlpvX6h19D7LWRmdpZwM/I82cZQjbnkp2OiYsDAYq6Mp0nBlqq4WEGlE6p6BPI968u+xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750806832; c=relaxed/simple;
	bh=6ECNG8WFWlNZ3HuCf6P7EuBGNxmyjkRzJJrxqWDmaL0=;
	h=Date:To:From:Subject:Message-Id; b=Naga7jCTvGhyDA7HfmKXrMvpQ7IFZ6xmp0lbOuX/cARNB7zkcLOrmMQyy6Oq6LNcTPaLs48dM4oDp3k4jgVz7YtrVw5sCMbYttN1h0P9rvoqGo9eHg4XYB9c/UxGzWln5hp8/QqcG+tVz9pbwjGnjaQH5NQ/BYj5NQ2jD38Na5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u5KzIyOj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u5KzIyOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47610C4CEE3;
	Tue, 24 Jun 2025 23:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750806831;
	bh=6ECNG8WFWlNZ3HuCf6P7EuBGNxmyjkRzJJrxqWDmaL0=;
	h=Date:To:From:Subject:From;
	b=u5KzIyOjwzYSLTYcMMNXAZsa5z4WT1Wf1G3MNTEKm9yZplnuWu/ovSzcUJYsMm8bp
	 m4mlFHzf42xxGAqKOR3TWptVu0ZUNepgp0E9B4FaWzeOglSAetIowWEGL5NU/O8Gaq
	 c2gPXOwD+gPSnqkES3GC5MwIXJr6urB8vw4XITeo=
Date: Tue, 24 Jun 2025 16:13:50 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,ccross@google.com,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-move-madvise_set_anon_name-down-the-file.patch added to mm-new branch
Message-Id: <20250624231351.47610C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, madvise: move madvise_set_anon_name() down the file
has been added to the -mm mm-new branch.  Its filename is
     mm-madvise-move-madvise_set_anon_name-down-the-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-move-madvise_set_anon_name-down-the-file.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, madvise: move madvise_set_anon_name() down the file
Date: Tue, 24 Jun 2025 15:03:47 +0200

Preparatory change so that we can use madvise_lock()/unlock() in the
function without forward declarations or more thorough shuffling.

No functional change.  Move as a separate commit helps git heuristics to
detect it properly.

Link: https://lkml.kernel.org/r/20250624-anon_name_cleanup-v2-3-600075462a11@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Colin Cross <ccross@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   64 ++++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

--- a/mm/madvise.c~mm-madvise-move-madvise_set_anon_name-down-the-file
+++ a/mm/madvise.c
@@ -133,38 +133,6 @@ static int replace_anon_vma_name(struct
 
 	return 0;
 }
-
-static int madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
-		unsigned long len_in, struct anon_vma_name *anon_name)
-{
-	unsigned long end;
-	unsigned long len;
-	struct madvise_behavior madv_behavior = {
-		.mm = mm,
-		.behavior = __MADV_SET_ANON_VMA_NAME,
-		.lock_mode = MADVISE_MMAP_WRITE_LOCK,
-		.anon_name = anon_name,
-	};
-
-	if (start & ~PAGE_MASK)
-		return -EINVAL;
-	len = (len_in + ~PAGE_MASK) & PAGE_MASK;
-
-	/* Check to see whether len was rounded up from small -ve to zero */
-	if (len_in && !len)
-		return -EINVAL;
-
-	end = start + len;
-	if (end < start)
-		return -EINVAL;
-
-	if (end == start)
-		return 0;
-
-	madv_behavior.range.start = start;
-	madv_behavior.range.end = end;
-	return madvise_walk_vmas(&madv_behavior);
-}
 #else /* CONFIG_ANON_VMA_NAME */
 static int replace_anon_vma_name(struct vm_area_struct *vma,
 				 struct anon_vma_name *anon_name)
@@ -2109,6 +2077,38 @@ static inline bool is_valid_name_char(ch
 		!strchr(ANON_VMA_NAME_INVALID_CHARS, ch);
 }
 
+static int madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
+		unsigned long len_in, struct anon_vma_name *anon_name)
+{
+	unsigned long end;
+	unsigned long len;
+	struct madvise_behavior madv_behavior = {
+		.mm = mm,
+		.behavior = __MADV_SET_ANON_VMA_NAME,
+		.lock_mode = MADVISE_MMAP_WRITE_LOCK,
+		.anon_name = anon_name,
+	};
+
+	if (start & ~PAGE_MASK)
+		return -EINVAL;
+	len = (len_in + ~PAGE_MASK) & PAGE_MASK;
+
+	/* Check to see whether len was rounded up from small -ve to zero */
+	if (len_in && !len)
+		return -EINVAL;
+
+	end = start + len;
+	if (end < start)
+		return -EINVAL;
+
+	if (end == start)
+		return 0;
+
+	madv_behavior.range.start = start;
+	madv_behavior.range.end = end;
+	return madvise_walk_vmas(&madv_behavior);
+}
+
 int set_anon_vma_name(unsigned long addr, unsigned long size,
 		      const char __user *uname)
 {
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-madvise-simplify-anon_name-handling.patch
mm-madvise-extract-mm-code-from-prctl_set_vma-to-mm-madvisec.patch
mm-madvise-move-madvise_set_anon_name-down-the-file.patch
mm-madvise-use-standard-madvise-locking-in-madvise_set_anon_name.patch

