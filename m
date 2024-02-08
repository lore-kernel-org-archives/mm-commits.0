Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E184D4F60F;
	Thu,  8 Feb 2024 05:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707369901; cv=none; b=GBns82nRxSn3ZDozFBvrpV1+0+qmfz9x+lXoqVjwhDgPZ7QkFnYIILhsEclL/LIkyqyAg55NMYphL2asUqLDLTfgMOiStYrbBryKBFK50pUMntfFsnenO9KsaQ3Mj4R7zUSVTOCYPRUTMr0QUMp8MH7Kw7SJp7DPJ6aOOCxdXeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707369901; c=relaxed/simple;
	bh=wDuJlaY5VYqH5yDtDPxtpW1CeUnq2Iq5X0NWW1qxl+Y=;
	h=Date:To:From:Subject:Message-Id; b=LpADJlwLQ04yPFkUbuAsjzh151+6hLMv+KjSgm1SJjItrnOAzhwMo68jN7QBkHtLUXCLtmCZpzJwzbmeD0D5ffCRX9RrZ7aHFZAuFL/rlaTvN1APesNEASI4Z4OoHCxCNGHLY80HOSQQIx8KpeEj1ouCbbz7k8kazpY9denZ2AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X88/4kv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X88/4kv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BDEC433C7;
	Thu,  8 Feb 2024 05:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707369900;
	bh=wDuJlaY5VYqH5yDtDPxtpW1CeUnq2Iq5X0NWW1qxl+Y=;
	h=Date:To:From:Subject:From;
	b=X88/4kv8hGU9alTMkD434AawC2yPFGKlrq6DnjMoJHOCO+6kwRBqClyC/tfTB4IAN
	 SaBBJDx5aOl3AQWKB9exQhWjPIjBK/Dg7+hx/rkXylEautYLFVrqPR1agk7YsYaTjn
	 2s8esAm4EwdH8YN5DHshMnHaO24p1PJhhIiNd+AE=
Date: Wed, 07 Feb 2024 21:24:59 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,muchun.song@linux.dev,prakash.sangappa@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] hugetlb-pages-should-not-be-reserved-by-shmat-if-shm_noreserve.patch removed from -mm tree
Message-Id: <20240208052500.45BDEC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb pages should not be reserved by shmat() if SHM_NORESERVE
has been removed from the -mm tree.  Its filename was
     hugetlb-pages-should-not-be-reserved-by-shmat-if-shm_noreserve.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


