Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9AA2248B5
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 07:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738827641; cv=none; b=R97MG9tSJSUh/Onj1MPJiy1D92De7IeSvxZbshYzp3WuEoWpCcICayjrDNgBtoS1wVjD6amf9SSAcMtIl5NMCalcU7+8H/yPDi+6hp1schSxWulrTOogrGmjOkOb3GFMst20bZJk3CkkZ5+3JsP6EsPztPAVnaiCIk4dy5DOmTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738827641; c=relaxed/simple;
	bh=Mkyb/6nN5rp8vm8eWLinFdJO6kw2Eg2JEvMO3+UyHXc=;
	h=Date:To:From:Subject:Message-Id; b=ZSRD4bRdR5EAP65KqyB1wVObpnX6nlYxAxuv9zrTPnnGecrSG6h5vnPDjs77QiYjLX5TYOt9eImVx8kNrTHD+T6cdIGSNzW+hepRN4uNf0mFRccpYPAvfwflQ1NpCrr9OACgNn1mA2Vm49CuaSmg8a/4FWhII0708jChcMUxA1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1mZYFxtV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1mZYFxtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB55C4CEDD;
	Thu,  6 Feb 2025 07:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738827640;
	bh=Mkyb/6nN5rp8vm8eWLinFdJO6kw2Eg2JEvMO3+UyHXc=;
	h=Date:To:From:Subject:From;
	b=1mZYFxtVINuDgQdHM+IgOVrs+R7EM34Tx28to/EdLYI0wYnTf7SvR5CLSQiChNkR6
	 7O3ZOofT3m4ewPYf9ZdjRY3IYXh/HiGNuuxUwZaG3neYUkV74YDp4xfEhjp6AHRoVi
	 zt7urLHSjF3SLC1T0T5PSiNHlt6UhwLZda18kH00=
Date: Wed, 05 Feb 2025 23:40:39 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,dave@stgolabs.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-split-out-madvise-behavior-execution.patch added to mm-unstable branch
Message-Id: <20250206074040.CCB55C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: split out madvise() behavior execution
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-split-out-madvise-behavior-execution.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-split-out-madvise-behavior-execution.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/madvise: split out madvise() behavior execution
Date: Wed, 5 Feb 2025 22:15:16 -0800

Split out the madvise behavior applying logic from do_madvise() to make
it easier to reuse from the following change.

Link: https://lkml.kernel.org/r/20250206061517.2958-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   53 +++++++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 23 deletions(-)

--- a/mm/madvise.c~mm-madvise-split-out-madvise-behavior-execution
+++ a/mm/madvise.c
@@ -1622,6 +1622,35 @@ static bool is_valid_madvise(unsigned lo
 	return true;
 }
 
+static int madvise_do_behavior(struct mm_struct *mm,
+		unsigned long start, size_t len_in, size_t len, int behavior)
+{
+	struct blk_plug plug;
+	unsigned long end;
+	int error;
+
+#ifdef CONFIG_MEMORY_FAILURE
+	if (behavior == MADV_HWPOISON || behavior == MADV_SOFT_OFFLINE)
+		return madvise_inject_error(behavior, start, start + len_in);
+#endif
+	start = untagged_addr_remote(mm, start);
+	end = start + len;
+
+	blk_start_plug(&plug);
+	switch (behavior) {
+	case MADV_POPULATE_READ:
+	case MADV_POPULATE_WRITE:
+		error = madvise_populate(mm, start, end, behavior);
+		break;
+	default:
+		error = madvise_walk_vmas(mm, start, end, behavior,
+					  madvise_vma_behavior);
+		break;
+	}
+	blk_finish_plug(&plug);
+	return error;
+}
+
 /*
  * The madvise(2) system call.
  *
@@ -1699,7 +1728,6 @@ int do_madvise(struct mm_struct *mm, uns
 	unsigned long end;
 	int error;
 	size_t len;
-	struct blk_plug plug;
 
 	if (!is_valid_madvise(start, len_in, behavior))
 		return -EINVAL;
@@ -1713,28 +1741,7 @@ int do_madvise(struct mm_struct *mm, uns
 	error = madvise_lock(mm, behavior);
 	if (error)
 		return error;
-
-#ifdef CONFIG_MEMORY_FAILURE
-	if (behavior == MADV_HWPOISON || behavior == MADV_SOFT_OFFLINE)
-		return madvise_inject_error(behavior, start, start + len_in);
-#endif
-
-	start = untagged_addr_remote(mm, start);
-	end = start + len;
-
-	blk_start_plug(&plug);
-	switch (behavior) {
-	case MADV_POPULATE_READ:
-	case MADV_POPULATE_WRITE:
-		error = madvise_populate(mm, start, end, behavior);
-		break;
-	default:
-		error = madvise_walk_vmas(mm, start, end, behavior,
-					  madvise_vma_behavior);
-		break;
-	}
-	blk_finish_plug(&plug);
-
+	error = madvise_do_behavior(mm, start, len_in, len, behavior);
 	madvise_unlock(mm, behavior);
 
 	return error;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-madvise-split-out-mmap-locking-operations-for-madvise.patch
mm-madvise-split-out-madvise-input-validity-check.patch
mm-madvise-split-out-madvise-behavior-execution.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch

