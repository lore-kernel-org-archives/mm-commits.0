Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5FA218580
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752449990; cv=none; b=hsnYkIRrbp1umOfEVil85jv3JxK/6YRuZfkYG+fns1mzR/fj/+OKiiN+wfSPkozvxXUBOZBHXylLDmiyGgBcyixcYaaKt/NoLpak+tQXZ/SUXN7fL+ToCTPrtpWkrlWXPLZWpcb2tRLMpoJkKwkuMm/vE1yPxctd0M3zVbdAgIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752449990; c=relaxed/simple;
	bh=+DSkVBA11eeb1YxjKp9xb6nqYoWD0694G3/k7n/XMpk=;
	h=Date:To:From:Subject:Message-Id; b=Vcf81Txc+2/DAQNMhjJilaNZ5BXQ5I2axqctKFtceQRGq7daKi1BNCgQpr8VVUUJgfvBFMXeCll58+RVC+zyQ5AQ4CUIhICL285tE1Xu7m8KpQq2jWDlPsKNeG6zrG9osJjXnY9mm0PqcMVAl3ILcFCxKWrYSk53KH4azOl2tJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XZggNm/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XZggNm/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7237C4CEE3;
	Sun, 13 Jul 2025 23:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752449989;
	bh=+DSkVBA11eeb1YxjKp9xb6nqYoWD0694G3/k7n/XMpk=;
	h=Date:To:From:Subject:From;
	b=XZggNm/819i8idhqgTxRDPebnwrHlnzFEWEX+rqRXxYCloiG14Nubpte/9qNI2dkb
	 mhEBmeh6d6UYuDAIa0EwdNdZq6nQRwaFgNdx3jw7Gt/0DhYPYXOKkfd3Gbby7ZEfIB
	 cXTZxsnmrPkC39HbXyUOpfG5wch6dsmHspzXawkM=
Date: Sun, 13 Jul 2025 16:39:49 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,ccross@google.com,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-move-madvise_set_anon_name-down-the-file.patch removed from -mm tree
Message-Id: <20250713233949.B7237C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, madvise: move madvise_set_anon_name() down the file
has been removed from the -mm tree.  Its filename was
     mm-madvise-move-madvise_set_anon_name-down-the-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter.patch
mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter-fix.patch

