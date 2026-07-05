Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBD33624B2;
	Sun,  5 Jul 2026 07:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783237893; cv=none; b=UWM6bdhduwvAROcOJ4rZWZiqjwk359GrvCXKDNilxA4sUtbzUyjG9sOuU8GrU9wbsiNYAnx/5Ek5QjVTi1tH+aq6l3KX2fO7HnwNEQ9vC4VpZmRijET3/KsLnl6duywM86RCaCosM/7K3jZ6xe/bQ0LAG+5YA5M8rVKPXMurkPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783237893; c=relaxed/simple;
	bh=/JpF1ycmBG57aN43O+qRI9YRboZ6l0Z71UnSnayW/x4=;
	h=Date:To:From:Subject:Message-Id; b=HznBLmpUU3dD85nRT3lT8yFfY0v7RpcuGkSHX6VFvS/fGp6frcwg+Fz286DvGDshFMT/dfMhop9mpDsZ23oOZ71xmhTs1W+kqrVRrFjJQZhcwKjGYhVe0dcsq6E8rNtoG3R0QQBMEMgErbV0LgRaVgyceLJuq6zkuJrkSndJjUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sB/bosu+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sB/bosu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BC91F00A3A;
	Sun,  5 Jul 2026 07:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783237891;
	bh=BVM2Jv6bvyIMxQd3CRQfcscHMQEpiWzaw1dIAWXLHPs=;
	h=Date:To:From:Subject;
	b=sB/bosu+SFZOiX+cF2m332u9Amo+IaeztChHKOrKGKZnxVjxtYJMFLOBjvs/l4aUj
	 fIr3YDFhj+Ez37PTvE3/PGq9IjUk7HEXgQB1tBfVrvFDbEvqAWYvpT/VI/1HAkyOiQ
	 MpiigyuOsMbGIIViujn6tEI+//cJUq/49K6ZZi98=
Date: Sun, 05 Jul 2026 00:51:30 -0700
To: mm-commits@vger.kernel.org,vladimirelitokarev@gmail.com,viro@zeniv.linux.org.uk,torvalds@linuxfoundation.org,stable@vger.kernel.org,peterx@redhat.com,oleg@redhat.com,ljs@kernel.org,jack@suse.cz,david@kernel.org,brauner@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-prevent-registration-of-special-vmas.patch added to mm-hotfixes-unstable branch
Message-Id: <20260705075131.65BC91F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: prevent registration of special VMAs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     userfaultfd-prevent-registration-of-special-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-prevent-registration-of-special-vmas.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: userfaultfd: prevent registration of special VMAs
Date: Thu, 18 Jun 2026 12:50:17 +0300

Vova Tokarev says:

  userfaultfd allows registration on shadow stack VMAs.  With userfaultfd
  access, you can register on the shadow stack, discard a page ... and
  inject a page with chosen return addresses via UFFDIO_COPY.

Update vma_can_userfault() to reject VM_SHADOW_STACK.

While on it, also reject VM_SPECIAL so that if a driver would implement
vm_uffd_ops, it wouldn't be possible to register special VMAs with
userfaultfd.

Since VM_SPECIAL includes VM_DONTEXPAND which is set but hugetlb, exclude
hugetlb VMAs from the check for VM_SPECIAL.

Link: https://lore.kernel.org/20260618095017.2553004-1-rppt@kernel.org
Fixes: 54007f818206 ("mm: Introduce VM_SHADOW_STACK for shadow stack memory")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reported-by: vova tokarev <vladimirelitokarev@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/userfaultfd.c~userfaultfd-prevent-registration-of-special-vmas
+++ a/mm/userfaultfd.c
@@ -2111,7 +2111,10 @@ static bool vma_can_userfault(struct vm_
 {
 	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
 
-	if (vma->vm_flags & VM_DROPPABLE)
+	if (vma->vm_flags & (VM_DROPPABLE | VM_SHADOW_STACK))
+		return false;
+
+	if (!is_vm_hugetlb_page(vma) && (vma->vm_flags & VM_SPECIAL))
 		return false;
 
 	vm_flags &= __VM_UFFD_FLAGS;
_

Patches currently in -mm which might be from rppt@kernel.org are

userfaultfd-prevent-registration-of-special-vmas.patch
selftests-mm-uffd-dont-treat-uffdio_copy-enoent-as-a-failure.patch

