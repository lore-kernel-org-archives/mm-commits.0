Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5E83FB7C9
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 17:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774544759; cv=none; b=CdFsyxcliHwSvTDmFwWaRZ+m/brDrzX2Yt7yeObyQZMdFmM69KoGRjZuR9l1eUVOo/vZGhftDJfJF6T0o99RC3GIqj20BXImNjT1uDRh4EoXoBMQWDjb5OE8cpXWt0yKiOfUiM7R59UEq+3bon/73WndAPLFlg5nENfXfIjfGkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774544759; c=relaxed/simple;
	bh=6UR5srL9Zq0+q+NKcb3IgmFPvc0VkeK9/A9Ni0VP/Xs=;
	h=Date:To:From:Subject:Message-Id; b=rlq7egr3DSRq91602QlMc5Y7Ez+hIhmJxCgnLeev945W0SWSE980NERXzwwIF5LD35avwp//BgtY+TR0DLZMQ2wZIe4e0Bmsud/d7pk5mQZsFniNHQILaBBsHekGeX++AQqty0kgfjNrR/FmXlL3moif5iv3dVZN/gZk+PXQR6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dy7j1UbF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dy7j1UbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B018C116C6;
	Thu, 26 Mar 2026 17:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774544759;
	bh=6UR5srL9Zq0+q+NKcb3IgmFPvc0VkeK9/A9Ni0VP/Xs=;
	h=Date:To:From:Subject:From;
	b=dy7j1UbFFdyhfg6ACOhz/jCRkXQY6r0FLYePeRnVUg87IfAkpNYJy7CBlcKJ2laB9
	 ZEtsRNx7zLPC6qhdie47rEX0e3A5/azFuwv6+hF2+yhDOVEw5H5tblhkcBamk7kZpR
	 kDl6Y5TUHqEdbuh2UQm/nrRAiX2I+ScXompLAxe4=
Date: Thu, 26 Mar 2026 10:05:58 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,avagin@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy-fix.patch removed from -mm tree
Message-Id: <20260326170559.3B018C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: fix lock leak in mfill_get_vma()
has been removed from the -mm tree.  Its filename was
     userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy-fix.patch

This patch was dropped because it was folded into userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy.patch

------------------------------------------------------
From: Andrei Vagin <avagin@google.com>
Subject: userfaultfd: fix lock leak in mfill_get_vma()
Date: Mon, 16 Mar 2026 17:38:28 +0000

In mfill_get_vma(), both the per-VMA lock (via uffd_mfill_lock()) and the
map_changing_lock are acquired.  However, state->vma was only assigned at
the very end of the function.  If any validation checks failed after lock
acquisition but before this assignment, the function would jump to the
out_unlock label and call mfill_put_vma(state).

Since mfill_put_vma() only performs cleanup if state->vma is non-NULL,
these error paths would leak both the per-VMA lock and the
map_changing_lock.

Link: https://lkml.kernel.org/r/20260316173829.1126728-1-avagin@google.com
Reported-by: syzbot+cf5ad2009a9bae03cb23@syzkaller.appspotmail.com
Signed-off-by: Andrei Vagin <avagin@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy-fix
+++ a/mm/userfaultfd.c
@@ -188,6 +188,7 @@ static int mfill_get_vma(struct mfill_st
 	 * request the user to retry later
 	 */
 	down_read(&ctx->map_changing_lock);
+	state->vma = dst_vma;
 	err = -EAGAIN;
 	if (atomic_read(&ctx->mmap_changing))
 		goto out_unlock;
@@ -210,7 +211,7 @@ static int mfill_get_vma(struct mfill_st
 		goto out_unlock;
 
 	if (is_vm_hugetlb_page(dst_vma))
-		goto out;
+		return 0;
 
 	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
 		goto out_unlock;
@@ -218,8 +219,6 @@ static int mfill_get_vma(struct mfill_st
 	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
 		goto out_unlock;
 
-out:
-	state->vma = dst_vma;
 	return 0;
 
 out_unlock:
_

Patches currently in -mm which might be from avagin@google.com are

userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy.patch

