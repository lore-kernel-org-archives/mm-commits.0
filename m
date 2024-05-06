Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A92E19BA6
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957047; cv=none; b=SFXksmoDAqObA6KXRb15RawGbGy7fdqv2kYEjClfIbKD4Vcx2I5vRvYbH2R6O7Yx5ksRhVu1NDLzczpk+oFpZp30JowkoJTYS2jiHpJXWAhdW3Icgxrur3Ox6IemnvkYhuWfw6WIstgSz02fYK1HxjqN+/bD5oiGJfi6OvJUHxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957047; c=relaxed/simple;
	bh=L4jP3Cr0703r17U7tXhsD2X75x22t9beoaHDp3PARM0=;
	h=Date:To:From:Subject:Message-Id; b=Kng56PPvZIegRA83qA5eIrhywmvkAbDiwX4blaK6kb64grJ+U5HgHnh2OeB2ylwqUQTsBLg/zBh+O0dTc3W6rkYbw/qZeFrQhA8bmKeoPC6iSiPQ5+SOOs4HdXKHiltPcl0Ld7HhWKSL520iCBVKfH/HOiKoZvXW0UkUcw5yRRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uNIACujX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uNIACujX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F59DC116B1;
	Mon,  6 May 2024 00:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957047;
	bh=L4jP3Cr0703r17U7tXhsD2X75x22t9beoaHDp3PARM0=;
	h=Date:To:From:Subject:From;
	b=uNIACujXbQkDi0sNmkAJJJzMRM5MlyEB97pz/nEh2BLbVqMLkdkWj0XZMFMb89Pkh
	 s14VJgemp/+FsClcAJUPb4HX1/eOoS1UYPZlcRlZLmFtOcyOcMVOB6qMGjBaajKbHz
	 5JZwrhH2btW6rueWIJXYjflKPGFNa4BvZlSJfzgo=
Date: Sun, 05 May 2024 17:57:26 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,peterx@redhat.com,lokeshgidra@google.com,david@redhat.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch removed from -mm tree
Message-Id: <20240506005727.0F59DC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: remove WRITE_ONCE when setting folio->index during UFFDIO_MOVE
has been removed from the -mm tree.  Its filename was
     userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: userfaultfd: remove WRITE_ONCE when setting folio->index during UFFDIO_MOVE
Date: Sun, 14 Apr 2024 19:08:21 -0700

When folio is moved with UFFDIO_MOVE it gets locked before the rmap and
index are modified.  Due to the folio lock being already held,
WRITE_ONCE() is not needed when setting the folio index.  Remove it.

Link: https://lkml.kernel.org/r/20240415020821.1152951-1-surenb@google.com
Reported-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 mm/userfaultfd.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move
+++ a/mm/huge_memory.c
@@ -2200,7 +2200,7 @@ int move_pages_huge_pmd(struct mm_struct
 		}
 
 		folio_move_anon_rmap(src_folio, dst_vma);
-		WRITE_ONCE(src_folio->index, linear_page_index(dst_vma, dst_addr));
+		src_folio->index = linear_page_index(dst_vma, dst_addr);
 
 		_dst_pmd = mk_huge_pmd(&src_folio->page, dst_vma->vm_page_prot);
 		/* Follow mremap() behavior and treat the entry dirty after the move */
--- a/mm/userfaultfd.c~userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move
+++ a/mm/userfaultfd.c
@@ -1026,7 +1026,7 @@ static int move_present_pte(struct mm_st
 	}
 
 	folio_move_anon_rmap(src_folio, dst_vma);
-	WRITE_ONCE(src_folio->index, linear_page_index(dst_vma, dst_addr));
+	src_folio->index = linear_page_index(dst_vma, dst_addr);
 
 	orig_dst_pte = mk_pte(&src_folio->page, dst_vma->vm_page_prot);
 	/* Follow mremap() behavior and treat the entry dirty after the move */
_

Patches currently in -mm which might be from surenb@google.com are


