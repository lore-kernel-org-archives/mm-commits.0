Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2882A8D0
	for <mm-commits@vger.kernel.org>; Fri, 27 Jun 2025 21:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751059632; cv=none; b=otvIDfx8tGnuGlBs/7VldYLeHrQ+aXYkgx0a4PBAT8UJryF1Kiz/XeZngnXGJY8ZVWMOakTdtLZp9TRaNr2T9rmyMIOF600pzZJoLICEdT8OpF/Dp2JMdEXlR5qPa3MxgSCiqKMZYbHTBsBpLn0QGkl9TodzlpU2o0r6qkNR1F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751059632; c=relaxed/simple;
	bh=y8jukb/234Nbh1toMdzOirC1bEhfhbZvncZ26xXc+08=;
	h=Date:To:From:Subject:Message-Id; b=o6KGKZ4kOhANB/rouB5xmckbu3mohrdQi9Kba66Tb1B4KsOAAHapUyW2tiy6UIb+ACa2mx50RCm/IDnqv61sY3mwC5nuKD4DdQkxF5oQqCJKiv2EyO08bTmJBjkvCfE5A36CydQD4dUsA19Hml3LRuEd7Q5u4RafrDzV8IFjpDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nxdNhSHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nxdNhSHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EADCC4CEE3;
	Fri, 27 Jun 2025 21:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751059631;
	bh=y8jukb/234Nbh1toMdzOirC1bEhfhbZvncZ26xXc+08=;
	h=Date:To:From:Subject:From;
	b=nxdNhSHs8tLWXRhH2IGCw5xXIa0jqJAoDpdAnqxIQkOmf2lFCF7R0UNblHQm185C9
	 dAZdyhy0xiu2FfHcN9lEKYoNmoYxvMb/ktgRnFQLnyBYt5zBEnXd23RiRtuJlg7554
	 64o/PSwvYk2r1PCDb5oTMuEw8xq6QJUwUJgydBqU=
Date: Fri, 27 Jun 2025 14:27:10 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-support-vm_uffd_ops-api-checkpatch-fixes.patch added to mm-new branch
Message-Id: <20250627212711.8EADCC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-shmem-support-vm_uffd_ops-api-checkpatch-fixes
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-support-vm_uffd_ops-api-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-support-vm_uffd_ops-api-checkpatch-fixes.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm-shmem-support-vm_uffd_ops-api-checkpatch-fixes
Date: Fri Jun 27 02:25:37 PM PDT 2025

WARNING: please, no space before tabs
#56: FILE: mm/shmem.c:5216:
+^I.uffd_features^I= ^I__VM_UFFD_FLAGS,$

WARNING: please, no space before tabs
#57: FILE: mm/shmem.c:5217:
+^I.uffd_ioctls^I= ^IBIT(_UFFDIO_COPY) |$

Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-support-vm_uffd_ops-api-checkpatch-fixes
+++ a/mm/shmem.c
@@ -5213,8 +5213,8 @@ static int shmem_error_remove_folio(stru
 
 #ifdef CONFIG_USERFAULTFD
 static const vm_uffd_ops shmem_uffd_ops = {
-	.uffd_features	= 	__VM_UFFD_FLAGS,
-	.uffd_ioctls	= 	BIT(_UFFDIO_COPY) |
+	.uffd_features	=	__VM_UFFD_FLAGS,
+	.uffd_ioctls	=	BIT(_UFFDIO_COPY) |
 				BIT(_UFFDIO_ZEROPAGE) |
 				BIT(_UFFDIO_WRITEPROTECT) |
 				BIT(_UFFDIO_CONTINUE) |
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fix-do_pages_stat-to-use-compat_uptr_t-fix.patch
mmslub-use-node-notifier-instead-of-memory-notifier-fix.patch
maple-tree-use-goto-label-to-simplify-code-fix.patch
mm-damon-sysfs-schemes-decouple-from-damos_action-fix.patch
mm-memcg-make-memoryreclaim-interface-generic-fix.patch
mm-shmem-support-vm_uffd_ops-api-checkpatch-fixes.patch
mm-hugetlb-support-vm_uffd_ops-api-checkpatch-fixes.patch
maintainers-add-lib-raid6-to-software-raid.patch

