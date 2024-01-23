Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1A0FBFA
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 05:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705986743; cv=none; b=ZhrDSYcWVuLqCOd2+zDUHKp3Twy+Zg8nieMvyJ/7oNGIbYjJbyopwhshOe+KHZyiC4jaJR4LkptKSMmQjDJAW1YEtkZy4+pCdEpU1RgdpCcnhdjSF0J+5n/vRd41fjwkDJEt4XqZcRGsDIWNS7SwnwaJ8Lk1XjN//sxN1+F+sJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705986743; c=relaxed/simple;
	bh=NVQW4/MuwLGYGQwEeM+ikbyehzWEBF3Q23ucE/JcskQ=;
	h=Date:To:From:Subject:Message-Id; b=kRVUjPY/nMsQI98orY6DLPrRgAzyekEju1jfD5e5zKgB9oSzSVk8Nd01T9w+60bB1YruCYLz1uEKCCQksvwfEMjTFR3Atq5LgieZpz/zhKuAwjFvXCGYPV2R1iWK7PQiZfJgk06PUU+GT8VhAn5WdTcuqEcYzn0zPuSnxsFya3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qUMRNq4C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qUMRNq4C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01767C433F1;
	Tue, 23 Jan 2024 05:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705986742;
	bh=NVQW4/MuwLGYGQwEeM+ikbyehzWEBF3Q23ucE/JcskQ=;
	h=Date:To:From:Subject:From;
	b=qUMRNq4C4rVtGNar4CO6/kawudD606SsFZX7IL1uDrU3L79b+k+dqbixHvweSCo2Q
	 SR8Y8/WEqxXapMo6w1psVj3IgnHfsgorBJDWapOjVQKkatniag+Mkr2FMqDsM93s54
	 XsN+9/37Gy0XIY6nSxIxx+FOj3Ox9GBlp8UX3AOw=
Date: Mon, 22 Jan 2024 21:12:19 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,prakash.sangappa@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] hugetlb-pages-should-not-be-reserved-by-shmat-if-shm_noreserve.patch removed from -mm tree
Message-Id: <20240123051222.01767C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb pages should not be reserved by shmat() if SHM_NORESERVE
has been removed from the -mm tree.  Its filename was
     hugetlb-pages-should-not-be-reserved-by-shmat-if-shm_noreserve.patch

This patch was dropped because an updated version will be merged

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


