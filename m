Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7EC38DE6
	for <mm-commits@vger.kernel.org>; Sun, 21 Jan 2024 22:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705875231; cv=none; b=svWC/iY5sNKYAmjmjQxmrC05q1fj86pO8yjR9tvTlk83wAyrNs3LDqa1asZ3uIvnrd8MoKxyK30irR8Jo60Cy2qBCnqIJ/phdC99Tw7nJux8YCSiTFW48UvQLSvJoAVp+yckPX+cCgmqWKv6E0qpfyMf/9ErGZIYx4TSZF15Mc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705875231; c=relaxed/simple;
	bh=XUy7pjzuJ4FfkDGh+UQgBJBju7rVO1hgJ0FQz9r4xzk=;
	h=Date:To:From:Subject:Message-Id; b=fhrn9O/dYmHFAr4JuOcnMJPga9EzRTAWqjjYmfD/VbCRw9STzHm8HGtU0QIMZXHl9i+FVAIsnGa7sj8Mowa2YLJEYDc7UXb/vIeYJmH6+JQ1AHWxbJcSLkatngpxC7i4WfA5PCUXBhBLxHhAhgp5kfcj4eIHMV/ojimTj1TzS04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NiJw+EPT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NiJw+EPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E957C433F1;
	Sun, 21 Jan 2024 22:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705875230;
	bh=XUy7pjzuJ4FfkDGh+UQgBJBju7rVO1hgJ0FQz9r4xzk=;
	h=Date:To:From:Subject:From;
	b=NiJw+EPTA1Tehdecn6TC51aniZv8071An05vNd41jdCSw1m5x7HTzPWwJ7Bz3WEeu
	 w/RBzCEKpQ4X8e0IZWhkCc9nHmUx2MZB+cxHV+MoQHN2O1GqDRtlsovnZlpEX34InO
	 pSH3IHLLfCw/AHLEq7rCs0INuiLSyfyif6Yh2jtw=
Date: Sun, 21 Jan 2024 14:13:47 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,prakash.sangappa@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-pages-should-not-be-reserved-by-shmat-if-shm_noreserve.patch added to mm-unstable branch
Message-Id: <20240121221350.0E957C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Hugetlb pages should not be reserved by shmat() if SHM_NORESERVE
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-pages-should-not-be-reserved-by-shmat-if-shm_noreserve.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-pages-should-not-be-reserved-by-shmat-if-shm_noreserve.patch

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
From: Prakash Sangappa <prakash.sangappa@oracle.com>
Subject: Hugetlb pages should not be reserved by shmat() if SHM_NORESERVE
Date: Fri, 19 Jan 2024 17:17:52 -0800

For shared memory of type SHM_HUGETLB, hugetlb pages are reserved in
shmget() call.  If SHM_NORESERVE flags is specified then the hugetlb pages
are not reserved.  However when the shared memory is attached with the
shmat() call the hugetlb pages are getting reserved incorrectly for
SHM_HUGETLB shared memory created with SHM_NORESERVE.

Ensure that the hugetlb pages are no reserved for SHM_HUGETLB shared
memory in the shmat() call.

Link: https://lkml.kernel.org/r/1705713472-3537-1-git-send-email-prakash.sangappa@oracle.com
Signed-off-by: Prakash Sangappa <prakash.sangappa@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~hugetlb-pages-should-not-be-reserved-by-shmat-if-shm_noreserve
+++ a/fs/hugetlbfs/inode.c
@@ -141,7 +141,13 @@ static int hugetlbfs_file_mmap(struct fi
 	file_accessed(file);
 
 	ret = -ENOMEM;
-	if (!hugetlb_reserve_pages(inode,
+
+	/*
+	 * for SHM_HUGETLB, the pages are reserved in the shmget() call so skip
+	 * reserving here. Note only for SHM hugetlbfs file, the inode
+	 * flag S_PRIVATE is set.
+	 */
+	if (!(inode->i_flags & S_PRIVATE) && !hugetlb_reserve_pages(inode,
 				vma->vm_pgoff >> huge_page_order(h),
 				len >> huge_page_shift(h), vma,
 				vma->vm_flags))
_

Patches currently in -mm which might be from prakash.sangappa@oracle.com are

hugetlb-pages-should-not-be-reserved-by-shmat-if-shm_noreserve.patch

