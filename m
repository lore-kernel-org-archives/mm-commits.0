Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278C61E1DEE
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188561; cv=none; b=TgH3cMrXqZA572ec7lNHXVXnKblBswgmt/rpNvB8uH4gSUp4cpNFXo57GFfw9OeoVOWdynOiIgBAVelCCuPlFlBRxVeYUxzmK0ly9rpm82ZbjvOr19QJ/FKUqdHaRQCY7g+PlEdDF0Qo7QGH3YRb4r+9lFRItBlYBDcSP6Dq2xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188561; c=relaxed/simple;
	bh=rWhjtqSeqeMdSdWiTbig9K+JA+04WJBKD0dYWu8AVWg=;
	h=Date:To:From:Subject:Message-Id; b=WJ7BVDpSo28SoeoRrFcxvO0/lTJJGtDFJ7XUNW++1vCw7U1zDIxpGs6DYWn3xHWTgH5y1uouLq8EnqQVWGU8Qd4qDAVvNudPM+HHh8uznyghrqrv329xA5QUuB7Z+NeqDa2qU0rtW53CTkxjsNQdKZTXphHbSkaUHmyngAgPCIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wOK69G6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wOK69G6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E96C4CEEC;
	Mon, 17 Mar 2025 05:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188561;
	bh=rWhjtqSeqeMdSdWiTbig9K+JA+04WJBKD0dYWu8AVWg=;
	h=Date:To:From:Subject:From;
	b=wOK69G6ampVrqPFFUfws0YzYf17UXHTZMbvfbbBNU4BfDSX4Av2S8EzrAIoNN5sTa
	 3cxqUZpqUYugi8TWNPntYUkt49USINYTNgOUBJFsHo3D9Xvr6qdXV1h+2kjrLCrQi+
	 HZwIOFWMFUVl05pheji7D1sQVujfGlJEQ8u9p9QI=
Date: Sun, 16 Mar 2025 22:16:00 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-change-the-return-value-of-shmem_find_swap_entries.patch removed from -mm tree
Message-Id: <20250317051600.F0E96C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: change the return value of shmem_find_swap_entries()
has been removed from the -mm tree.  Its filename was
     mm-shmem-change-the-return-value-of-shmem_find_swap_entries.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Hugh Dickins <hughd@google.com>
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


