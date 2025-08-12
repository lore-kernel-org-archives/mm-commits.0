Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B011DF27F
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 03:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754971060; cv=none; b=ZTQk239yVoOaIEIzAG8zfUKTz78YGudA9C86HwZYP9SD0kAr2J9YvolpCJgrdr+nen4lzWyoBYU6ie3/UHEWm71EPSibjZwW5bbryZnvEm9F159GhP8327i2QxyDA4DXhCx8ocGYDC2fUcBETwz/hccZCBRv51ByRLK9covKdO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754971060; c=relaxed/simple;
	bh=oJm5RnqdjecYxs/54RW8BcmCxYT+VxNpUfgj1Cw5+Ec=;
	h=Date:To:From:Subject:Message-Id; b=B8LS6aqppdoWfhjX/4fnMBp41l/GKsquFUUEDleWgZQehp6DAf5MeXKZ0cyUTDPiO3MpGZ8H1zS6FWOm0P9ppgBuTK9JuRTTVT0YaxyU6970EuZgcfZ3UknB6n3y8osXWfDNJ/kEPLHHFmn5HhuW9qHECAqmmVIGni5sZ5KETdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f34U9HhZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f34U9HhZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1028FC4CEF0;
	Tue, 12 Aug 2025 03:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754971060;
	bh=oJm5RnqdjecYxs/54RW8BcmCxYT+VxNpUfgj1Cw5+Ec=;
	h=Date:To:From:Subject:From;
	b=f34U9HhZRyt4znGSM9kEKkqd0B7lp+HahxQlHbnPCXqKl3Tlj1QbBoFTSqg8ethEt
	 l9ACKqJ60tNRSydotzomlsPWoM9M9XPGv6Lkx68sqhZdHcM03ymS6tPWAs25i7afAp
	 VssxhSYQ6Wt+UWJl1Ijjt2GTltclWiS3an1l/XH0=
Date: Mon, 11 Aug 2025 20:57:39 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-catch-invalid-multi-vma-moves-earlier.patch added to mm-hotfixes-unstable branch
Message-Id: <20250812035740.1028FC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: catch invalid multi VMA moves earlier
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mremap-catch-invalid-multi-vma-moves-earlier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-catch-invalid-multi-vma-moves-earlier.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mremap: catch invalid multi VMA moves earlier
Date: Sun, 3 Aug 2025 12:11:22 +0100

Previously, any attempt to solely move a VMA would require that the
span specified reside within the span of that single VMA, with no gaps
before or afterwards.

After commit d23cb648e365 ("mm/mremap: permit mremap() move of multiple
VMAs"), the multi VMA move permitted a gap to exist only after VMAs. 
This was done to provide maximum flexibility.

However, We have consequently permitted this behaviour for the move of
a single VMA including those not eligible for multi VMA move.

The change introduced here means that we no longer permit non-eligible
VMAs from being moved in this way.

This is consistent, as it means all eligible VMA moves are treated the
same, and all non-eligible moves are treated as they were before.

This change does not break previous behaviour, which equally would have
disallowed such a move (only in all cases).

Link: https://lkml.kernel.org/r/2b5aad5681573be85b5b8fac61399af6fb6b68b6.1754218667.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/mm/mremap.c~mm-mremap-catch-invalid-multi-vma-moves-earlier
+++ a/mm/mremap.c
@@ -1820,10 +1820,11 @@ static unsigned long remap_move(struct v
 	unsigned long start = vrm->addr;
 	unsigned long end = vrm->addr + vrm->old_len;
 	unsigned long new_addr = vrm->new_addr;
-	bool allowed = true, seen_vma = false;
 	unsigned long target_addr = new_addr;
 	unsigned long res = -EFAULT;
 	unsigned long last_end;
+	bool seen_vma = false;
+
 	VMA_ITERATOR(vmi, current->mm, start);
 
 	/*
@@ -1837,9 +1838,6 @@ static unsigned long remap_move(struct v
 		unsigned long len = min(end, vma->vm_end) - addr;
 		unsigned long offset, res_vma;
 
-		if (!allowed)
-			return -EFAULT;
-
 		/* No gap permitted at the start of the range. */
 		if (!seen_vma && start < vma->vm_start)
 			return -EFAULT;
@@ -1867,9 +1865,14 @@ static unsigned long remap_move(struct v
 		vrm->new_addr = target_addr + offset;
 		vrm->old_len = vrm->new_len = len;
 
-		allowed = vma_multi_allowed(vma);
-		if (seen_vma && !allowed)
-			return -EFAULT;
+		if (!vma_multi_allowed(vma)) {
+			/* This is not the first VMA, abort immediately. */
+			if (seen_vma)
+				return -EFAULT;
+			/* This is the first, but there are more, abort. */
+			if (vma->vm_end < end)
+				return -EFAULT;
+		}
 
 		res_vma = check_prep_vma(vrm);
 		if (!res_vma)
@@ -1878,7 +1881,8 @@ static unsigned long remap_move(struct v
 			return res_vma;
 
 		if (!seen_vma) {
-			VM_WARN_ON_ONCE(allowed && res_vma != new_addr);
+			VM_WARN_ON_ONCE(vma_multi_allowed(vma) &&
+					res_vma != new_addr);
 			res = res_vma;
 		}
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mremap-avoid-expensive-folio-lookup-on-mremap-folio-pte-batch.patch
tools-testing-add-linux-argsh-header-and-fix-radix-vma-tests.patch
mm-mremap-allow-multi-vma-move-when-filesystem-uses-thp_get_unmapped_area.patch
mm-mremap-catch-invalid-multi-vma-moves-earlier.patch
selftests-mm-add-test-for-invalid-multi-vma-operations.patch

