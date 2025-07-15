Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8101F1537
	for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2025 23:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752622954; cv=none; b=DwHOt9CDAhAzCIAe20Qv3ahxNwjIIxJE2nnquZOO5biXZ12YgRqmn0PvUpvgVk2u//KL0d+BWxYLh5wRDS9EjgFD/N4MrVOPvHRu46mcT2nKZWXemir/gFIqni+ntLLPwfF6bg5MPMFksSngqYJ1iauEDSWO/eAZnyq4FKUQpsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752622954; c=relaxed/simple;
	bh=Ax265EuLsQQG07teM5yeNvz0saL6owICdKBLlP5WVgc=;
	h=Date:To:From:Subject:Message-Id; b=reWtkmnzY6hHM63GuQvSgN3rSu84lWPT3X6VFoWrZ37X8Zm69J1Umywbnv0qBCwsikCENPD23AAbr6s6/H51b3pheaZQy1mR94H6tQmxv+aMS/5Wpfsg0ClmqzWBFYuqR52cbD2GNwZxUhivvB1LqqlX6/2JQ4oLmRBKNkASE3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H6om2yPG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H6om2yPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9532BC4CEE3;
	Tue, 15 Jul 2025 23:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752622954;
	bh=Ax265EuLsQQG07teM5yeNvz0saL6owICdKBLlP5WVgc=;
	h=Date:To:From:Subject:From;
	b=H6om2yPGTLVFpevvpY0LdwncWkzxJ/Qxo98OHW0Wb8sblXc6YyKNs9WyRGRiMEC/0
	 pJ+oldjiSwVZN7ls281tVD05LEuDY1IG/cLfuA7J/JD0w52ZEtgd759oe9o6jOSIbe
	 1QJi8IGK7G0Lpgl/IHYsp4poHKA0bi6B6GnQtsZU=
Date: Tue, 15 Jul 2025 16:42:33 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,hughd@google.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-simplify-swapin-path-and-result-handling-fix-fix.patch added to mm-unstable branch
Message-Id: <20250715234234.9532BC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-shmem-swap-simplify-swapin-path-and-result-handling-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-swap-simplify-swapin-path-and-result-handling-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-swap-simplify-swapin-path-and-result-handling-fix-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-shmem-swap-simplify-swapin-path-and-result-handling-fix-fix
Date: Tue Jul 15 04:40:30 PM PDT 2025

s/readhaed/readahead/, because we all want a happy Hugh

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-swap-simplify-swapin-path-and-result-handling-fix-fix
+++ a/mm/shmem.c
@@ -2321,7 +2321,7 @@ static int shmem_swapin_folio(struct ino
 		}
 
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
-			/* Direct swapin skipping swap cache & readhaed */
+			/* Direct swapin skipping swap cache & readahead */
 			folio = shmem_swap_alloc_folio(inode, vma, index, swap, order, gfp);
 			if (IS_ERR(folio)) {
 				error = PTR_ERR(folio);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-make-memoryreclaim-interface-generic-fix.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling-fix.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling-fix-fix.patch
squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix.patch
init-kconfig-restore-config_broken-help-text.patch

