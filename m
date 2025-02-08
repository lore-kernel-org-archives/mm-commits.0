Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558802913
	for <mm-commits@vger.kernel.org>; Sat,  8 Feb 2025 03:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738983900; cv=none; b=Yd0MWspXodBoF0OlO0OuglV9X1dMcd+u3+LXRLt9WTbkUZeezLpuLfauEYhDuaUWXkajoXFJWNhI0VL+n69LQkfwTXfQ8cEaFnSj5g/pbIJY0SgZf8SukVwxafoQBqXSaxGIBHCCbw7maWUKILcvuQ8Rp1cD3HLuFKQWZR7Fmyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738983900; c=relaxed/simple;
	bh=b3w6RscvGPAcQssr4uP64HVOB1yJN62T7uQYvpjjGiM=;
	h=Date:To:From:Subject:Message-Id; b=Vh3bcNaGF3kUgUHraZGoyR8ZaLyiyJFM4PEOO3DhjgD45fNVTBBoVKHcPB0SL20uev9RNRagcIqS4reRgm3GEf6GMsQim97q6T7rPk2C7GG0CDG4VVYNFQ0Vjm7uOmmsDmLDEAwpJI/DhNOYSl6BnQi8U2Xk2cbt2ZYw9La4Ee4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hRCqIMZl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hRCqIMZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29EEC4CED1;
	Sat,  8 Feb 2025 03:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738983899;
	bh=b3w6RscvGPAcQssr4uP64HVOB1yJN62T7uQYvpjjGiM=;
	h=Date:To:From:Subject:From;
	b=hRCqIMZltIm884BU+L7/jpF+xfrje8DchQsIWVOHOYnRY16a0qRNU9Ex28uZfVe4c
	 VckSvgP1f+LTvMHBSl9/mU39vrw457kQNZ3JtHOBRbDkB2pQxe6led8WrKDdx2WZ1k
	 PvRjYepC1Q2RcgMS90/D9OufmT+SMpX7jEtRZZlk=
Date: Fri, 07 Feb 2025 19:04:59 -0800
To: mm-commits@vger.kernel.org,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-change-the-return-value-of-shmem_find_swap_entries.patch added to mm-unstable branch
Message-Id: <20250208030459.B29EEC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: change the return value of shmem_find_swap_entries()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-change-the-return-value-of-shmem_find_swap_entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-change-the-return-value-of-shmem_find_swap_entries.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: change the return value of shmem_find_swap_entries()
Date: Fri, 7 Feb 2025 17:44:20 +0800

The shmem_find_swap_entries() originally returned the index corresponding
to the swap entry, but no callers used this return value.  It should
return the number of entries that were found like other functions, which
can be used by the callers.

No functional changes.

Link: https://lkml.kernel.org/r/070489b5946b8379b2a2d25f78115cef167cd145.1738918357.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickens <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/shmem.c~mm-shmem-change-the-return-value-of-shmem_find_swap_entries
+++ a/mm/shmem.c
@@ -1379,9 +1379,9 @@ static void shmem_evict_inode(struct ino
 #endif
 }
 
-static int shmem_find_swap_entries(struct address_space *mapping,
-				   pgoff_t start, struct folio_batch *fbatch,
-				   pgoff_t *indices, unsigned int type)
+static unsigned int shmem_find_swap_entries(struct address_space *mapping,
+				pgoff_t start, struct folio_batch *fbatch,
+				pgoff_t *indices, unsigned int type)
 {
 	XA_STATE(xas, &mapping->i_pages, start);
 	struct folio *folio;
@@ -1414,7 +1414,7 @@ static int shmem_find_swap_entries(struc
 	}
 	rcu_read_unlock();
 
-	return xas.xa_index;
+	return folio_batch_count(fbatch);
 }
 
 /*
@@ -1461,8 +1461,8 @@ static int shmem_unuse_inode(struct inod
 
 	do {
 		folio_batch_init(&fbatch);
-		shmem_find_swap_entries(mapping, start, &fbatch, indices, type);
-		if (folio_batch_count(&fbatch) == 0) {
+		if (!shmem_find_swap_entries(mapping, start, &fbatch,
+					     indices, type)) {
 			ret = 0;
 			break;
 		}
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-drop-the-unused-macro.patch
mm-shmem-remove-fadvise-comments.patch
mm-shmem-remove-duplicate-error-validation.patch
mm-shmem-change-the-return-value-of-shmem_find_swap_entries.patch
mm-shmem-factor-out-the-within_size-logic-into-a-new-helper.patch
maintainers-add-myself-as-shmem-reviewer.patch

