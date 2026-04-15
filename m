Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A9226ED41;
	Wed, 15 Apr 2026 10:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776248222; cv=none; b=Ewo7ZCBduowK3wLx1dTNqqAA7jx0CeLOTLtogyC9vp+lN81E4doh2fjtCRu8NLBeojxz0YNaX1hIgp8aGwqliGHc/gksq6HbsXhnAE7GSyx0LaXr/TZvXY1gdkCKZkt6Z47lmzhg8mYydgZTSTdXXjDIKWt636OoF9GBfGttfX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776248222; c=relaxed/simple;
	bh=PuEO4ZoVkmXf0em8c7zUPljUqT2SuX0LSSreZblwqK4=;
	h=Date:To:From:Subject:Message-Id; b=qdZ6axYjn6XzX+qyGfa/H70KEwBMcTIng0QQnP5N//nAnbm+Pl++xVTBGyGZT4Wakeu5FXYm9XrzNU1iaKefRw2221HVMbP1o311QouRwWQW/SPFeEmzzl9lFPgj4kYw1MU8rz5KLI12KOQGXAqXYr3PWYUiyx4W90nSmium4+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z7BxtvyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z7BxtvyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1FBC19424;
	Wed, 15 Apr 2026 10:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776248222;
	bh=PuEO4ZoVkmXf0em8c7zUPljUqT2SuX0LSSreZblwqK4=;
	h=Date:To:From:Subject:From;
	b=z7BxtvyToTNfiVFHn7wj6xLgR3rLx47Ed/Kkfgeu8h8Vha9hjA9sv5S9y9rw6ehhf
	 RVwG0yZE6krZLeWT57pJOkKfvKCewqIUTcu9kPPHF/XH6V023fudYxkjoCdrVmRS3F
	 eSdJLh1fCdZCij9DvL8WcQb1oMXr8uAH4RRRNJFU=
Date: Wed, 15 Apr 2026 03:16:56 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,aarcange@redhat.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] userfaultfd-preserve-write-protection-across-uffdio_move.patch removed from -mm tree
Message-Id: <20260415101701.2D1FBC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: preserve write protection across UFFDIO_MOVE
has been removed from the -mm tree.  Its filename was
     userfaultfd-preserve-write-protection-across-uffdio_move.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: userfaultfd: preserve write protection across UFFDIO_MOVE
Date: Thu, 9 Apr 2026 11:28:22 -0400

move_present_ptes() unconditionally makes the destination PTE writable,
dropping uffd-wp write-protection from the source PTE.

The original intent was to follow mremap() behavior, but mremap()'s
move_ptes() preserves the source write state unconditionally.

Modify uffd to preserve the source write state and check the uffd-wp
condition of the source before setting writable on the destination.

Link: https://lkml.kernel.org/r/20260409152822.1073083-1-gourry@gourry.net
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/userfaultfd.c~userfaultfd-preserve-write-protection-across-uffdio_move
+++ a/mm/userfaultfd.c
@@ -1123,7 +1123,10 @@ static long move_present_ptes(struct mm_
 			orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
 		if (pte_dirty(orig_src_pte))
 			orig_dst_pte = pte_mkdirty(orig_dst_pte);
-		orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
+		if (pte_write(orig_src_pte))
+			orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
+		if (pte_uffd_wp(orig_src_pte))
+			orig_dst_pte = pte_mkuffd_wp(orig_dst_pte);
 		set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
 
 		src_addr += PAGE_SIZE;
_

Patches currently in -mm which might be from gourry@gourry.net are


