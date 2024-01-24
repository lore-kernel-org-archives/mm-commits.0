Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F998C08;
	Wed, 24 Jan 2024 10:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706091440; cv=none; b=iQw5HmFAw0rjilidrAHzL3TUDCQJq8bxqOHkYesG1tL0fKI1SHuNU9ncnnjkOfDIoIoBxkuSOMTRaae2KtanJP+Z0Avza5MkFXnyiN+zLpQ0B/0gt8WKYy0AhgDdHk+8IWuCHovYJYQ4aV8wWDW+1XRls6gdo21V4/sdRrUPhnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706091440; c=relaxed/simple;
	bh=rmfjexJNayeWdvhpeWCuZkBzukuUeJz3Fi3afDQovOw=;
	h=Date:To:From:Subject:Message-Id; b=ULmZCjPSmbfiSQwTV8gpzVtf9MjexkS9KYwa1nQtX+P7fYaD08gZC5pkDJtEhpYFbppCP2qVTnOOSA97D1yuc7UqywyHLwfIu1KIsUlfWvKZvL9u2Rn88NHKSHpG8vQHtKtmSsRwObZmwe3n3eleXmktowmv6ZYg5EH82y5BE8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XgwcrziL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XgwcrziL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA36C433C7;
	Wed, 24 Jan 2024 10:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706091440;
	bh=rmfjexJNayeWdvhpeWCuZkBzukuUeJz3Fi3afDQovOw=;
	h=Date:To:From:Subject:From;
	b=XgwcrziLk7TdkoooC8EqPxo/4/f2fEQa25igfJt/TpJcA4UGZdvhBP4GCt8exrBJ5
	 PF9jaFZhvV6fm8pcL2gtQ0TzFMqnIbrfY177u7ajEW4hcxpcBa2jxzlZwSavH60wnI
	 b//i09t9LX6J+4/PDc4cNDT16l3b1Uh8tVQSsLro=
Date: Wed, 24 Jan 2024 02:17:17 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,muchun.song@linux.dev,prakash.sangappa@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-pages-should-not-be-reserved-by-shmat-if-shm_noreserve.patch added to mm-hotfixes-unstable branch
Message-Id: <20240124101719.7BA36C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb pages should not be reserved by shmat() if SHM_NORESERVE
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     hugetlb-pages-should-not-be-reserved-by-shmat-if-shm_noreserve.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-pages-should-not-be-reserved-by-shmat-if-shm_noreserve.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm: hugetlb pages should not be reserved by shmat() if SHM_NORESERVE
Date: Tue, 23 Jan 2024 12:04:42 -0800

For shared memory of type SHM_HUGETLB, hugetlb pages are reserved in
shmget() call.  If SHM_NORESERVE flags is specified then the hugetlb pages
are not reserved.  However when the shared memory is attached with the
shmat() call the hugetlb pages are getting reserved incorrectly for
SHM_HUGETLB shared memory created with SHM_NORESERVE which is a bug.

-------------------------------
Following test shows the issue.

$cat shmhtb.c

int main()
{
	int shmflags = 0660 | IPC_CREAT | SHM_HUGETLB | SHM_NORESERVE;
	int shmid;

	shmid = shmget(SKEY, SHMSZ, shmflags);
	if (shmid < 0)
	{
		printf("shmat: shmget() failed, %d\n", errno);
		return 1;
	}
	printf("After shmget()\n");
	system("cat /proc/meminfo | grep -i hugepages_");

	shmat(shmid, NULL, 0);
	printf("\nAfter shmat()\n");
	system("cat /proc/meminfo | grep -i hugepages_");

	shmctl(shmid, IPC_RMID, NULL);
	return 0;
}

 #sysctl -w vm.nr_hugepages=20
 #./shmhtb

After shmget()
HugePages_Total:      20
HugePages_Free:       20
HugePages_Rsvd:        0
HugePages_Surp:        0

After shmat()
HugePages_Total:      20
HugePages_Free:       20
HugePages_Rsvd:        5 <--
HugePages_Surp:        0
--------------------------------

Fix is to ensure that hugetlb pages are not reserved for SHM_HUGETLB shared
memory in the shmat() call.

Link: https://lkml.kernel.org/r/1706040282-12388-1-git-send-email-prakash.sangappa@oracle.com
Signed-off-by: Prakash Sangappa <prakash.sangappa@oracle.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~hugetlb-pages-should-not-be-reserved-by-shmat-if-shm_noreserve
+++ a/fs/hugetlbfs/inode.c
@@ -100,6 +100,7 @@ static int hugetlbfs_file_mmap(struct fi
 	loff_t len, vma_len;
 	int ret;
 	struct hstate *h = hstate_file(file);
+	vm_flags_t vm_flags;
 
 	/*
 	 * vma address alignment (but not the pgoff alignment) has
@@ -141,10 +142,20 @@ static int hugetlbfs_file_mmap(struct fi
 	file_accessed(file);
 
 	ret = -ENOMEM;
+
+	vm_flags = vma->vm_flags;
+	/*
+	 * for SHM_HUGETLB, the pages are reserved in the shmget() call so skip
+	 * reserving here. Note: only for SHM hugetlbfs file, the inode
+	 * flag S_PRIVATE is set.
+	 */
+	if (inode->i_flags & S_PRIVATE)
+		vm_flags |= VM_NORESERVE;
+
 	if (!hugetlb_reserve_pages(inode,
 				vma->vm_pgoff >> huge_page_order(h),
 				len >> huge_page_shift(h), vma,
-				vma->vm_flags))
+				vm_flags))
 		goto out;
 
 	ret = 0;
_

Patches currently in -mm which might be from prakash.sangappa@oracle.com are

hugetlb-pages-should-not-be-reserved-by-shmat-if-shm_noreserve.patch

