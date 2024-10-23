Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F7A78C9C
	for <mm-commits@vger.kernel.org>; Wed, 23 Oct 2024 19:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729712799; cv=none; b=g2vSNazLyBNTU+SL6SrreHroY52QNcZBsnlNEXKKzfuxJz2wQNySd8iFL7oPGoQDSmS7t5xtkoO1Dr2p+ohQY/FHmDrPOy2pPJ4iLSGscSV2KdvCdLb+bAX9arh5noSohW5UxXWvJdjWPcc499eSPcANGjfklWEWftsvZqVEINk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729712799; c=relaxed/simple;
	bh=zgHz0cjChZe6wXTb+HtG4KQFQQpQBSW0HUpZpDAoqEc=;
	h=Date:To:From:Subject:Message-Id; b=Q7ENKfOj9/NTi56Fm8C+Qa+DkrY2QCjjpIvdeKg79s6QmL1X9bkAPkjZrRazVHZf6IaiKGXCnxWJp8pnrgKMx3xgAWu1O0hK+FqEesfibpEMWX95TxeTf4VeBX5Sdgdq2j1NDA/tGNwncLR07HPe/JEHymHcBifPEOz/ApaMloQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ciD5g2sM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ciD5g2sM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40E0C4CEC6;
	Wed, 23 Oct 2024 19:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729712798;
	bh=zgHz0cjChZe6wXTb+HtG4KQFQQpQBSW0HUpZpDAoqEc=;
	h=Date:To:From:Subject:From;
	b=ciD5g2sMy/iQAf3Q8RCsIC7sPf5jav7qWD7RbPo8DYK7IjClkzg27ilPlL+KWyK4F
	 han2cbtRL2AdbBIXPZ299xv8hHiCOkcWWCzjSFJ/ZfwS7fI/Rfo0WyuHnNMvh1m1dL
	 +TRV2Io7Ve41mIi+d+hkh1i1c7ezLc2zaTQ+ttdo=
Date: Wed, 23 Oct 2024 12:46:38 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,skhan@linuxfoundation.org,peterx@redhat.com,anupnewsmail@gmail.com,manas18244@iiitd.ac.in,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memoryc-simplify-pfnmap_lockdep_assert.patch added to mm-unstable branch
Message-Id: <20241023194638.D40E0C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory.c: simplify pfnmap_lockdep_assert
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memoryc-simplify-pfnmap_lockdep_assert.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memoryc-simplify-pfnmap_lockdep_assert.patch

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
From: Manas <manas18244@iiitd.ac.in>
Subject: mm/memory.c: simplify pfnmap_lockdep_assert
Date: Fri, 04 Oct 2024 23:12:16 +0530

Use local `mapping' to reduce the pointer chasing.

akpm: extracted from a bugfix which Linus fixed with b1b46751671be ("mm:
fix follow_pfnmap API lockdep assert").

Link: https://lkml.kernel.org/r/20241004-fix-null-deref-v4-1-d0a8ec01ac85@iiitd.ac.in
Signed-off-by: Manas <manas18244@iiitd.ac.in>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Anup Sharma <anupnewsmail@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memoryc-simplify-pfnmap_lockdep_assert
+++ a/mm/memory.c
@@ -6381,7 +6381,7 @@ static inline void pfnmap_lockdep_assert
 	struct address_space *mapping = file ? file->f_mapping : NULL;
 
 	if (mapping)
-		lockdep_assert(lockdep_is_held(&vma->vm_file->f_mapping->i_mmap_rwsem) ||
+		lockdep_assert(lockdep_is_held(&mapping->i_mmap_rwsem) ||
 			       lockdep_is_held(&vma->vm_mm->mmap_lock));
 	else
 		lockdep_assert(lockdep_is_held(&vma->vm_mm->mmap_lock));
_

Patches currently in -mm which might be from manas18244@iiitd.ac.in are

mm-memoryc-simplify-pfnmap_lockdep_assert.patch

