Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75357F;
	Tue,  5 Mar 2024 00:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709599271; cv=none; b=f94c5PmG/UNF2IzGFjy6I6YPPy0ev7N5EkobF9ujLo53ncZxEh9ufXeCKXXMObmsjNphiJ3LKJVxuvZ5hMfzeVzfUEHPoj1FtFTLalvPHJGhezrDntGaSegAkeDlOTPWj6Puk03C318ptIC78BXJkPFcMRI+DdXakhufgjzSSzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709599271; c=relaxed/simple;
	bh=rbhCGCINQ6xJchSupTth+1LEwIo3ZQHh7Gfftje3iSg=;
	h=Date:To:From:Subject:Message-Id; b=O+YF+nomY4bx4jEGvD0eosH3z+QAJg2cPW2wS0kp8zT24utKvrxZK9lKTFA3ETpyzDpkiBkRbpxZnZBeKX2HaloXdKuBDGavUULV2R8n7zCi0R6JpY557B6PAr278ouVKVHbv+jV1oLl6OQPzNd5HUFE/MZLXhns6fdFYdMq2Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bo8MIXro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bo8MIXro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F86DC433C7;
	Tue,  5 Mar 2024 00:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709599271;
	bh=rbhCGCINQ6xJchSupTth+1LEwIo3ZQHh7Gfftje3iSg=;
	h=Date:To:From:Subject:From;
	b=bo8MIXrom0pbGD64bfmJwivZCT35Dpdd9EUXXcNFmiklXCkSr8ipgX6m7DUiyqVAp
	 +aBMXHG4Vd+hOQE5eT4j1CKzPaaRNtfrheqiQgqaXWvMqVu8z4tw7sbCDAMKniTiNv
	 6xGwNkLnsl9NTXfYxms2F85O8sLRzZOW7U2szvKE=
Date: Mon, 04 Mar 2024 16:41:10 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mhocko@suse.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mmap-fix-vma_merge-case-7-with-vma_ops-close.patch removed from -mm tree
Message-Id: <20240305004111.3F86DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, mmap: fix vma_merge() case 7 with vma_ops->close
has been removed from the -mm tree.  Its filename was
     mm-mmap-fix-vma_merge-case-7-with-vma_ops-close.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, mmap: fix vma_merge() case 7 with vma_ops->close
Date: Thu, 22 Feb 2024 22:59:31 +0100

When debugging issues with a workload using SysV shmem, Michal Hocko has
come up with a reproducer that shows how a series of mprotect() operations
can result in an elevated shm_nattch and thus leak of the resource.

The problem is caused by wrong assumptions in vma_merge() commit
714965ca8252 ("mm/mmap: start distinguishing if vma can be removed in
mergeability test").  The shmem vmas have a vma_ops->close callback that
decrements shm_nattch, and we remove the vma without calling it.

vma_merge() has thus historically avoided merging vma's with
vma_ops->close and commit 714965ca8252 was supposed to keep it that way. 
It relaxed the checks for vma_ops->close in can_vma_merge_after() assuming
that it is never called on a vma that would be a candidate for removal. 
However, the vma_merge() code does also use the result of this check in
the decision to remove a different vma in the merge case 7.

A robust solution would be to refactor vma_merge() code in a way that the
vma_ops->close check is only done for vma's that are actually going to be
removed, and not as part of the preliminary checks.  That would both solve
the existing bug, and also allow additional merges that the checks
currently prevent unnecessarily in some cases.

However to fix the existing bug first with a minimized risk, and for
easier stable backports, this patch only adds a vma_ops->close check to
the buggy case 7 specifically.  All other cases of vma removal are covered
by the can_vma_merge_before() check that includes the test for
vma_ops->close.

The reproducer code, adapted from Michal Hocko's code:

int main(int argc, char *argv[]) {
  int segment_id;
  size_t segment_size = 20 * PAGE_SIZE;
  char * sh_mem;
  struct shmid_ds shmid_ds;

  key_t key = 0x1234;
  segment_id = shmget(key, segment_size,
                      IPC_CREAT | IPC_EXCL | S_IRUSR | S_IWUSR);
  sh_mem = (char *)shmat(segment_id, NULL, 0);

  mprotect(sh_mem + 2*PAGE_SIZE, PAGE_SIZE, PROT_NONE);

  mprotect(sh_mem + PAGE_SIZE, PAGE_SIZE, PROT_WRITE);

  mprotect(sh_mem + 2*PAGE_SIZE, PAGE_SIZE, PROT_WRITE);

  shmdt(sh_mem);

  shmctl(segment_id, IPC_STAT, &shmid_ds);
  printf("nattch after shmdt(): %lu (expected: 0)\n", shmid_ds.shm_nattch);

  if (shmctl(segment_id, IPC_RMID, 0))
          printf("IPCRM failed %d\n", errno);
  return (shmid_ds.shm_nattch) ? 1 : 0;
}

Link: https://lkml.kernel.org/r/20240222215930.14637-2-vbabka@suse.cz
Fixes: 714965ca8252 ("mm/mmap: start distinguishing if vma can be removed in mergeability test")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-fix-vma_merge-case-7-with-vma_ops-close
+++ a/mm/mmap.c
@@ -954,13 +954,21 @@ static struct vm_area_struct
 	} else if (merge_prev) {			/* case 2 */
 		if (curr) {
 			vma_start_write(curr);
-			err = dup_anon_vma(prev, curr, &anon_dup);
 			if (end == curr->vm_end) {	/* case 7 */
+				/*
+				 * can_vma_merge_after() assumed we would not be
+				 * removing prev vma, so it skipped the check
+				 * for vm_ops->close, but we are removing curr
+				 */
+				if (curr->vm_ops && curr->vm_ops->close)
+					err = -EINVAL;
 				remove = curr;
 			} else {			/* case 5 */
 				adjust = curr;
 				adj_start = (end - curr->vm_start);
 			}
+			if (!err)
+				err = dup_anon_vma(prev, curr, &anon_dup);
 		}
 	} else { /* merge_next */
 		vma_start_write(next);
_

Patches currently in -mm which might be from vbabka@suse.cz are


