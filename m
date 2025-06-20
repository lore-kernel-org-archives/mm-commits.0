Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8CA42A8F
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 01:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750383247; cv=none; b=F/oJNrT0Ty/MdRmX6SGJ8I0gXJCUyWlmy8mVnlkluRWPD3+nExDoxl5Brz8sqGyqQHlpoIWvT3YiuIA5ZSxWBTZHyJZx4vFJ5jYQ3ftPXX6e1VNrdljfz0m7/slINsqNQMX4oHHo1P9lotlTXY1VA+KrM1i8VMA+neg1auxYKDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750383247; c=relaxed/simple;
	bh=Y3hLkmuhm07lgZaigxjOyPFmuO6WnfMXURqV4sw3s2o=;
	h=Date:To:From:Subject:Message-Id; b=qaNWorSaxWCZCiZwVFoe+UhIRH6Yk/iT43jf2gR/FU/RrOsWa2uchroa8VPgPk8ZLhcqfQEUeTPNnVAJP0fGAg+oW5p9vhFlraKnGMAG9voFc0TBLcPsgyTUZif+Kz+QbM5u/YXImdpdzfiYve4xwWw27UyZp5Dmb45WseBpZIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vn2marYT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vn2marYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B58EC4CEEA;
	Fri, 20 Jun 2025 01:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750383247;
	bh=Y3hLkmuhm07lgZaigxjOyPFmuO6WnfMXURqV4sw3s2o=;
	h=Date:To:From:Subject:From;
	b=Vn2marYT/pkXTzLMnjcID+ax6DA7l4IC6RW3uerl/TrW1GBfEG7K+i/1cQ0/UTiZl
	 Ga0FVV5rdO4t7SQf3j/owBLrC/G5Mkd0hpqKNWhqKcm49au1wuMOSK90eXKkM2XBXI
	 z3Zrn6IRrRiAW4CJ1kyibqz4Pu3wGhT3w9CO1mZs=
Date: Thu, 19 Jun 2025 18:34:06 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,peterx@redhat.com,Jason@zx2c4.com,jack@suse.cz,david@redhat.com,brauner@kernel.org,aarcange@redhat.com,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-correctly-prevent-registering-vm_droppable-regions.patch added to mm-unstable branch
Message-Id: <20250620013407.0B58EC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: correctly prevent registering VM_DROPPABLE regions
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-correctly-prevent-registering-vm_droppable-regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-correctly-prevent-registering-vm_droppable-regions.patch

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: userfaultfd: correctly prevent registering VM_DROPPABLE regions
Date: Thu, 19 Jun 2025 21:24:23 -0400

Patch series "mm: userfaultfd: assorted fixes and cleanups", v3.

Two fixes and two cleanups for userfaultfd.

Note that the third patch yields a small change in the ABI, but we seem to
have concluded that it is acceptable in this case.


This patch (of 4):

vma_can_userfault() masks off non-userfaultfd VM flags from vm_flags.  The
vm_flags & VM_DROPPABLE test will then always be false, incorrectly
allowing VM_DROPPABLE regions to be registered with userfaultfd.

Additionally, vm_flags is not guaranteed to correspond to the actual VMA's
flags.  Fix this test by checking the VMA's flags directly.

Link: https://lkml.kernel.org/r/20250619-uffd-fixes-v3-0-a7274d3bd5e4@columbia.edu
Link: https://lore.kernel.org/linux-mm/5a875a3a-2243-4eab-856f-bc53ccfec3ea@redhat.com/
Link: https://lkml.kernel.org/r/20250619-uffd-fixes-v3-1-a7274d3bd5e4@columbia.edu
Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/userfaultfd_k.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/userfaultfd_k.h~userfaultfd-correctly-prevent-registering-vm_droppable-regions
+++ a/include/linux/userfaultfd_k.h
@@ -218,7 +218,7 @@ static inline bool vma_can_userfault(str
 {
 	vm_flags &= __VM_UFFD_FLAGS;
 
-	if (vm_flags & VM_DROPPABLE)
+	if (vma->vm_flags & VM_DROPPABLE)
 		return false;
 
 	if ((vm_flags & VM_UFFD_MINOR) &&
_

Patches currently in -mm which might be from tz2294@columbia.edu are

userfaultfd-correctly-prevent-registering-vm_droppable-regions.patch
userfaultfd-prevent-unregistering-vmas-through-a-different-userfaultfd.patch
userfaultfd-remove-vm_bug_ons.patch
userfaultfd-remove-uffd_cloexec-uffd_nonblock-and-uffd_flags_set.patch

