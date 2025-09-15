Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D1D221282;
	Mon, 15 Sep 2025 22:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757975816; cv=none; b=aY9k5E+ivNwlUbjzQdMo0Y0kPVVaJzIXblQ/+lU+F6EX1EE371UlOET58HxP23NzA8oWfgpz2JZk5oQ8iuBw5ypXsoa/WCtbFtqG70GxoNZpFGeCbTeRTTAbYbPFK1UQ58AI+MZB+TczrykdZrHNLHShcUmfQ7PwlQZp6/fVpaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757975816; c=relaxed/simple;
	bh=4RJpiPEJbovQcoZusoOGY/1DOn/aCSJvOdfaA8YpnK4=;
	h=Date:To:From:Subject:Message-Id; b=Z67/krjPS3mFkz34W+ZuUclojtO48oSoUCXX2PrgVOk5n2/QYCy5lauu8oqTaEToIyZuro0lOhjKP6eBIYzGpqqZYGHuFkgumAb/moAtg9iQIk5Drz/kOElOLHlBJZgTjja097AjjLeyea9olsCflRSQIbaf/saOKaziY9LnkZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=noY4hCMU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="noY4hCMU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588C9C4CEF1;
	Mon, 15 Sep 2025 22:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757975816;
	bh=4RJpiPEJbovQcoZusoOGY/1DOn/aCSJvOdfaA8YpnK4=;
	h=Date:To:From:Subject:From;
	b=noY4hCMUcG1ejLTBcaUS8E7t+nhMHtkVv00hpsLqdIo1yXOKP9cf4DQo6po81fy2l
	 RIQuYe6lxQALxRkapuUrB2xcn3RoE8DSr8gFp4L+ubVhhndN79xndJyYXwU9788Wfw
	 rhlkNXlNCQj4IXHU4NuojiNuXL9G4NQFGiyuTyGk=
Date: Mon, 15 Sep 2025 15:36:55 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,pfalcato@suse.de,minchan@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,david@redhat.com,kaleshsingh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-off-by-one-error-in-vma-count-limit-checks.patch added to mm-hotfixes-unstable branch
Message-Id: <20250915223656.588C9C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix off-by-one error in VMA count limit checks
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-off-by-one-error-in-vma-count-limit-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-off-by-one-error-in-vma-count-limit-checks.patch

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
From: Kalesh Singh <kaleshsingh@google.com>
Subject: mm: fix off-by-one error in VMA count limit checks
Date: Mon, 15 Sep 2025 09:36:32 -0700

The VMA count limit check in do_mmap() and do_brk_flags() uses a strict
inequality (>), which allows a process's VMA count to exceed the
configured sysctl_max_map_count limit by one.

A process with mm->map_count == sysctl_max_map_count will incorrectly pass
this check and then exceed the limit upon allocation of a new VMA when its
map_count is incremented.

Other VMA allocation paths, such as split_vma(), already use the correct,
inclusive (>=) comparison.

Fix this bug by changing the comparison to be inclusive in do_mmap() and
do_brk_flags(), bringing them in line with the correct behavior of other
allocation paths.

Link: https://lkml.kernel.org/r/20250915163838.631445-2-kaleshsingh@google.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 mm/vma.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mm-fix-off-by-one-error-in-vma-count-limit-checks
+++ a/mm/mmap.c
@@ -374,7 +374,7 @@ unsigned long do_mmap(struct file *file,
 		return -EOVERFLOW;
 
 	/* Too many mappings? */
-	if (mm->map_count > sysctl_max_map_count)
+	if (mm->map_count >= sysctl_max_map_count)
 		return -ENOMEM;
 
 	/*
--- a/mm/vma.c~mm-fix-off-by-one-error-in-vma-count-limit-checks
+++ a/mm/vma.c
@@ -2772,7 +2772,7 @@ int do_brk_flags(struct vma_iterator *vm
 	if (!may_expand_vm(mm, vm_flags, len >> PAGE_SHIFT))
 		return -ENOMEM;
 
-	if (mm->map_count > sysctl_max_map_count)
+	if (mm->map_count >= sysctl_max_map_count)
 		return -ENOMEM;
 
 	if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
_

Patches currently in -mm which might be from kaleshsingh@google.com are

mm-fix-off-by-one-error-in-vma-count-limit-checks.patch

