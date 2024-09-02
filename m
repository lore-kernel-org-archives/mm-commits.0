Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5DD42070
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247668; cv=none; b=LrfKLUkbs4hoRoFROsAvlg954lfN7DFDDpvZ5z0aMLlSI/XX5s63hzROhiImdajXnYZzicFJsnHDqZAc0bnmNPmS8JIVZwNSmfZ2ruX5pnlNAyNP/FYWeHWG8uIfH8YK8GM8WgxFfgHq9rRZhFn7T+fP3t8sVKaGE4dwYPh1Mc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247668; c=relaxed/simple;
	bh=NECXmPWSTBFM8FWFOzTExq5o3EylnLDW7HHNjAT2KkQ=;
	h=Date:To:From:Subject:Message-Id; b=nGT9poh1Pq/Mt7LUzCj+hfbS9ERYheNBOY0g6cB9SJH4k9HPprUVHQgYnFUXMzKvSs6Ah8ByOG8lWAlO9kSHGTTv339i92wDME4L0lIv94tm/Nbpu/Ve4iztg2qOJSIdAeg9mdTv9ugTwgbGdJ20tj/2/9+qXGYwLZEZSM6ER60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=naWGSHqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="naWGSHqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82584C4CEC2;
	Mon,  2 Sep 2024 03:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247668;
	bh=NECXmPWSTBFM8FWFOzTExq5o3EylnLDW7HHNjAT2KkQ=;
	h=Date:To:From:Subject:From;
	b=naWGSHqm09iP5s8wWU7cLrJThrTVDeIEujZqjags3kwOJ/wt0ozrpt231v82csj7R
	 Vp0UPhy9+uUyYGmIHuwFp4sUPr8QZio/NmHsqaX1Zmb8pU2C6AqF9DcC+ACfa4SDYa
	 jdbiIuErwWqsr/iohuQsI9eATf7Q27v1XPszHFhk=
Date: Sun, 01 Sep 2024 20:27:48 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cleanup-flags-usage-in-faultin_page.patch removed from -mm tree
Message-Id: <20240902032748.82584C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: cleanup flags usage in faultin_page
has been removed from the -mm tree.  Its filename was
     mm-cleanup-flags-usage-in-faultin_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josef Bacik <josef@toxicpanda.com>
Subject: mm: cleanup flags usage in faultin_page
Date: Thu, 18 Jul 2024 17:26:06 -0400

Patch series "mm: some small page fault cleanups".

I was recently wreaking havoc in the page fault code and I noticed some
things that could be cleaned up.  We no longer modify the gup flags in
faultin_page, so we can clean up how we pass the flags in and remove the
extra variable in __get_user_pages.


This patch (of 2):

We're passing a pointer to the foll_flags for faultin_page, however we
never modify the flags in this call.  Change this to just take the flags
value instead.

Link: https://lkml.kernel.org/r/2df51a54c06bdf93e1cb09a19a9ef1df6557b59e.1721337845.git.josef@toxicpanda.com
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/gup.c~mm-cleanup-flags-usage-in-faultin_page
+++ a/mm/gup.c
@@ -1153,19 +1153,19 @@ unmap:
  * to 0 and -EBUSY returned.
  */
 static int faultin_page(struct vm_area_struct *vma,
-		unsigned long address, unsigned int *flags, bool unshare,
+		unsigned long address, unsigned int flags, bool unshare,
 		int *locked)
 {
 	unsigned int fault_flags = 0;
 	vm_fault_t ret;
 
-	if (*flags & FOLL_NOFAULT)
+	if (flags & FOLL_NOFAULT)
 		return -EFAULT;
-	if (*flags & FOLL_WRITE)
+	if (flags & FOLL_WRITE)
 		fault_flags |= FAULT_FLAG_WRITE;
-	if (*flags & FOLL_REMOTE)
+	if (flags & FOLL_REMOTE)
 		fault_flags |= FAULT_FLAG_REMOTE;
-	if (*flags & FOLL_UNLOCKABLE) {
+	if (flags & FOLL_UNLOCKABLE) {
 		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 		/*
 		 * FAULT_FLAG_INTERRUPTIBLE is opt-in. GUP callers must set
@@ -1173,12 +1173,12 @@ static int faultin_page(struct vm_area_s
 		 * That's because some callers may not be prepared to
 		 * handle early exits caused by non-fatal signals.
 		 */
-		if (*flags & FOLL_INTERRUPTIBLE)
+		if (flags & FOLL_INTERRUPTIBLE)
 			fault_flags |= FAULT_FLAG_INTERRUPTIBLE;
 	}
-	if (*flags & FOLL_NOWAIT)
+	if (flags & FOLL_NOWAIT)
 		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT;
-	if (*flags & FOLL_TRIED) {
+	if (flags & FOLL_TRIED) {
 		/*
 		 * Note: FAULT_FLAG_ALLOW_RETRY and FAULT_FLAG_TRIED
 		 * can co-exist
@@ -1212,7 +1212,7 @@ static int faultin_page(struct vm_area_s
 	}
 
 	if (ret & VM_FAULT_ERROR) {
-		int err = vm_fault_to_errno(ret, *flags);
+		int err = vm_fault_to_errno(ret, flags);
 
 		if (err)
 			return err;
@@ -1490,7 +1490,7 @@ retry:
 
 		page = follow_page_mask(vma, start, foll_flags, &ctx);
 		if (!page || PTR_ERR(page) == -EMLINK) {
-			ret = faultin_page(vma, start, &foll_flags,
+			ret = faultin_page(vma, start, foll_flags,
 					   PTR_ERR(page) == -EMLINK, locked);
 			switch (ret) {
 			case 0:
_

Patches currently in -mm which might be from josef@toxicpanda.com are


