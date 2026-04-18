Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E872475E3
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498962; cv=none; b=i1sTaJlwVmDf04Fsubxg5DaNgTj8rYt0dOpeHJmjhRYzHWlwC7aQqoznLAioHrZVF14IDDVqT0IoOOVMHQqoqVzVh10tgiSNO7iCpJib10YRPexNtiwYzdRsZwdJ4LlbD32AgQ7jdb95zKsXL8pMsqBj9sfyzyduKdpZsT/e664=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498962; c=relaxed/simple;
	bh=NLFKuSn9+FPlxGwRfCtMk2HAqfRKNnqDXODb+aO6P00=;
	h=Date:To:From:Subject:Message-Id; b=ousnpuzARYw8gITIYb6a2+l1UiOEwMRoYGA8OzD3LkHnzSEOwd2rn8UQFQbv3K8yK05oG5pXyAbwFZWS64ddDWSaLWmwjiS0BGfF2J2lwEmk9uuUNfvS0pk4G20tt7fzV1sfhAUNXsp7IzSnzjLYp/x0heiuMFOMPu4UP1/wl6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vtQmMUOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vtQmMUOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D09BC19424;
	Sat, 18 Apr 2026 07:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498962;
	bh=NLFKuSn9+FPlxGwRfCtMk2HAqfRKNnqDXODb+aO6P00=;
	h=Date:To:From:Subject:From;
	b=vtQmMUOzP1EpJUdY0fvYJ2yClKpWZh45IcMHQN5GkMAQ2Mh4wEf31L/zBC5zs0Gto
	 sdstBQTsW0LGoCJJ8ng1jY5oAkKfk53Y0oxH/075Qz7nbxwdxFgmJbstJ2PhEPjBVo
	 EiwDXQsXnYLLuaWZGIDjfg/Y4GuSqtt83h8fWF4M=
Date: Sat, 18 Apr 2026 00:55:57 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jianghaoran@kylinos.cn,duanchenghao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memfd-use-folio_nr_pages-for-shmem-inode-accounting.patch removed from -mm tree
Message-Id: <20260418075601.4D09BC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memfd: use folio_nr_pages() for shmem inode accounting
has been removed from the -mm tree.  Its filename was
     mm-memfd-use-folio_nr_pages-for-shmem-inode-accounting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chenghao Duan <duanchenghao@kylinos.cn>
Subject: mm/memfd: use folio_nr_pages() for shmem inode accounting
Date: Thu, 26 Mar 2026 16:47:21 +0800

I found several modifiable points while reading the code.


This patch (of 6):

Patch series "Modify memfd_luo code", v3.

memfd_luo_retrieve_folios() called shmem_inode_acct_blocks() and
shmem_recalc_inode() with hardcoded 1 instead of the actual folio page
count.  memfd may use large folios (THP/hugepages), causing quota/limit
under-accounting and incorrect stat output.

Fix by using folio_nr_pages(folio) for both functions.

Issue found by AI review and suggested by Pratyush Yadav <pratyush@kernel.org>.
https://sashiko.dev/#/patchset/20260319012845.29570-1-duanchenghao%40kylinos.cn

Link: https://lore.kernel.org/20260326084727.118437-1-duanchenghao@kylinos.cn
Link: https://lore.kernel.org/20260326084727.118437-2-duanchenghao@kylinos.cn
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Suggested-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Haoran Jiang <jianghaoran@kylinos.cn>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd_luo.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/memfd_luo.c~mm-memfd-use-folio_nr_pages-for-shmem-inode-accounting
+++ a/mm/memfd_luo.c
@@ -410,6 +410,7 @@ static int memfd_luo_retrieve_folios(str
 	struct inode *inode = file_inode(file);
 	struct address_space *mapping = inode->i_mapping;
 	struct folio *folio;
+	long npages;
 	int err = -EIO;
 	long i;
 
@@ -456,14 +457,15 @@ static int memfd_luo_retrieve_folios(str
 		if (flags & MEMFD_LUO_FOLIO_DIRTY)
 			folio_mark_dirty(folio);
 
-		err = shmem_inode_acct_blocks(inode, 1);
+		npages = folio_nr_pages(folio);
+		err = shmem_inode_acct_blocks(inode, npages);
 		if (err) {
-			pr_err("shmem: failed to account folio index %ld: %d\n",
-			       i, err);
+			pr_err("shmem: failed to account folio index %ld(%ld pages): %d\n",
+			       i, npages, err);
 			goto unlock_folio;
 		}
 
-		shmem_recalc_inode(inode, 1, 0);
+		shmem_recalc_inode(inode, npages, 0);
 		folio_add_lru(folio);
 		folio_unlock(folio);
 		folio_put(folio);
_

Patches currently in -mm which might be from duanchenghao@kylinos.cn are


