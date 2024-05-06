Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5F95CB0
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714956988; cv=none; b=Dw2xxK77Z3Cx1qgWKZ1QlimSQU1mybT1lKO6cogy71qEQ/DAff1i8PQQ58CeTnYM+0tU5rHwEGoOyG/NFQbHHDMSJ1nm2NeaQMjlw4nMTkmjFy9QgeVEP1OYjVyYyJ8LcBFrql+GCQlOBwfoBMPQNAqxUz+cCd24D/PZlV5+RO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714956988; c=relaxed/simple;
	bh=NxEJvNTdEdzxUqAxoLbJXwqukBvUMLIeilu4mFhPby8=;
	h=Date:To:From:Subject:Message-Id; b=S//L/I2L4OZwUCKCpmkS3pqeuFwHKwamYGn/RoeMI5+JOM7hGXu7qQX272xsbocsVt/LkuPQBmKKUWai3zppTu1HsP8C8CuPw28wvTE3Fl/ag3YPEjQJ6sibkCOZSWZbN2BHGZpTkXytZDTTxUJR/i7xBX0AzcuoYt/LIjJnQoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M4D9EJEJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M4D9EJEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA9DC113CC;
	Mon,  6 May 2024 00:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714956988;
	bh=NxEJvNTdEdzxUqAxoLbJXwqukBvUMLIeilu4mFhPby8=;
	h=Date:To:From:Subject:From;
	b=M4D9EJEJtL2lLYZDvzxko5lo6jnAFCHxITRBHAhzu5Fn6R2a1pj2T4ciiJYr2WyPI
	 n6a66Hbrxh4Vs4eBEVXnWQ4K/TwJ6Z1mRYnsqkCxkbGZ2VK00126Z3Wp1TankoD7Cy
	 zkRRvU8NJ75jBqbHQ7Vxpxp1NVYEaVoJcFuIE/G4=
Date: Sun, 05 May 2024 17:56:27 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,lstoakes@gmail.com,Liam.Howlett@oracle.com,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-make-accountable_mapping-return-bool.patch removed from -mm tree
Message-Id: <20240506005628.1AA9DC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmap: make accountable_mapping return bool
has been removed from the -mm tree.  Its filename was
     mm-mmap-make-accountable_mapping-return-bool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/mmap: make accountable_mapping return bool
Date: Sun, 7 Apr 2024 14:38:43 +0800

accountable_mapping() can return bool, so change it.

Link: https://lkml.kernel.org/r/20240407063843.804274-1-gehao@kylinos.cn
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mm-mmap-make-accountable_mapping-return-bool
+++ a/mm/mmap.c
@@ -1549,14 +1549,14 @@ bool vma_wants_writenotify(struct vm_are
  * We account for memory if it's a private writeable mapping,
  * not hugepages and VM_NORESERVE wasn't set.
  */
-static inline int accountable_mapping(struct file *file, vm_flags_t vm_flags)
+static inline bool accountable_mapping(struct file *file, vm_flags_t vm_flags)
 {
 	/*
 	 * hugetlb has its own accounting separate from the core VM
 	 * VM_HUGETLB may not be set yet so we cannot check for that flag.
 	 */
 	if (file && is_file_hugepages(file))
-		return 0;
+		return false;
 
 	return (vm_flags & (VM_NORESERVE | VM_SHARED | VM_WRITE)) == VM_WRITE;
 }
_

Patches currently in -mm which might be from gehao@kylinos.cn are


