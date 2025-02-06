Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFE4224882
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 07:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738827638; cv=none; b=V0Jz2TTwjfsFcqnk19UF3V4HhtjZQm5yoE+ZV2YpuR/3lLUFV0jr9+1bDgz9Yb0LBzwz/VjERtOm/ce8MhVNhJpW1RAns4+WgBLDy6l+QnvMb+x/x0tuBDCBCqVoFguojCwKfHBugaMZSO9FNEt2IjjRnXdkf9dg5pQErEWTnwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738827638; c=relaxed/simple;
	bh=i94q2gCf47YfdSn63yPrCCn6Rv6AcFFuz+QQIotvmfA=;
	h=Date:To:From:Subject:Message-Id; b=J/zpVL6lm8Sh92IoK38PKE97E5TQLskTet7XvahzrqgleG2aro2mbWzV033YMQw0fmsMuJ/7n4+fW3+zMamyFdpnXOdrc+mbJ5JC+blm343pKCwHbbCqZdSba8Xrfmf+DgfMyNTiM+HX5q4gZFAiqE3tI7lYAbm3QmfaTMQpEEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gakezdy4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gakezdy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A22C4CEDD;
	Thu,  6 Feb 2025 07:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738827637;
	bh=i94q2gCf47YfdSn63yPrCCn6Rv6AcFFuz+QQIotvmfA=;
	h=Date:To:From:Subject:From;
	b=gakezdy4ec8502aDdlt4gLfLR5fjFFj687xQ2wFnt+1SOpNOvQhYOlvrEsPQXlu8j
	 uHIEVY6rlCgFm72u7N/O3Kk/Si2H02lusAqB45UyU3wDtzQlyGftk23HfDv7uW2V9/
	 6C8RnoDgXNkzlQbMN0jVbVLaHI3sKR3UtqKX6+TM=
Date: Wed, 05 Feb 2025 23:40:37 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,dave@stgolabs.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-split-out-madvise-input-validity-check.patch added to mm-unstable branch
Message-Id: <20250206074037.B3A22C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: split out madvise input validity check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-split-out-madvise-input-validity-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-split-out-madvise-input-validity-check.patch

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
Subject: mm/madvise: split out madvise input validity check
Date: Wed, 5 Feb 2025 22:15:15 -0800

Split out the madvise parameters validation logic from do_madvise(), for
easy reuse of the logic from a future change.

Link: https://lkml.kernel.org/r/20250206061517.2958-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

--- a/mm/madvise.c~mm-madvise-split-out-madvise-input-validity-check
+++ a/mm/madvise.c
@@ -1601,6 +1601,27 @@ static void madvise_unlock(struct mm_str
 		mmap_read_unlock(mm);
 }
 
+static bool is_valid_madvise(unsigned long start, size_t len_in, int behavior)
+{
+	size_t len;
+
+	if (!madvise_behavior_valid(behavior))
+		return false;
+
+	if (!PAGE_ALIGNED(start))
+		return false;
+	len = PAGE_ALIGN(len_in);
+
+	/* Check to see whether len was rounded up from small -ve to zero */
+	if (len_in && !len)
+		return false;
+
+	if (start + len < start)
+		return false;
+
+	return true;
+}
+
 /*
  * The madvise(2) system call.
  *
@@ -1680,20 +1701,11 @@ int do_madvise(struct mm_struct *mm, uns
 	size_t len;
 	struct blk_plug plug;
 
-	if (!madvise_behavior_valid(behavior))
+	if (!is_valid_madvise(start, len_in, behavior))
 		return -EINVAL;
 
-	if (!PAGE_ALIGNED(start))
-		return -EINVAL;
 	len = PAGE_ALIGN(len_in);
-
-	/* Check to see whether len was rounded up from small -ve to zero */
-	if (len_in && !len)
-		return -EINVAL;
-
 	end = start + len;
-	if (end < start)
-		return -EINVAL;
 
 	if (end == start)
 		return 0;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-madvise-split-out-mmap-locking-operations-for-madvise.patch
mm-madvise-split-out-madvise-input-validity-check.patch
mm-madvise-split-out-madvise-behavior-execution.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch

