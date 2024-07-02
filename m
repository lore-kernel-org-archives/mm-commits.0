Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F87B674
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 02:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719887016; cv=none; b=u736CBFNl9Roypy4qqHUUXsm/v83pMYi3yLDPww7eZpPDSojam3Cb1v7GVIH+TdAX6RVl/06nIAjQ19kT1zsV+u3AQVTQMxQuwiKZ89U+cFxx+SuEPIt9gMNmybyeyt85+Y2wfTBu5SGIftwfZwQ05YsIfe0u65azkYg3UvIQ/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719887016; c=relaxed/simple;
	bh=/sUceb08iNS4u38nLxcX1OdEv9NO84wvmXGKx883NxE=;
	h=Date:To:From:Subject:Message-Id; b=rsqyEMpj2cnpIm+81dh9B43XRBqr2HyW6BNPPjqATsVR5M1pbCmf6BrDuRdTvaWSzyz9Ct7wbB2a56XZXPBLNpHlU3vdCPWjoljp+v+4hy4YZUQr6Ng9MOGTFufE7LJYZsOMUoQ+ACOAwia3coQJb0jN7ngYAcbVTQAl6QpRdwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1Ka2gHwL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1Ka2gHwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C990C116B1;
	Tue,  2 Jul 2024 02:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719887015;
	bh=/sUceb08iNS4u38nLxcX1OdEv9NO84wvmXGKx883NxE=;
	h=Date:To:From:Subject:From;
	b=1Ka2gHwLqMDLgPI7YJ1SC7XACUihgkQmCAcXDz1GfeQTCjtpKnK+xxt5ukIRyTXFj
	 1kO/mhG+Mv1+8+9w1CfJt9KhUqwCqm/4XSv1j0TXteFwKShbgS/MdGzXMT5E3rOWBs
	 k3mvrevpRI4dBkO4VRoeZw7HXIek1TLhCyGFbumk=
Date: Mon, 01 Jul 2024 19:23:34 -0700
To: mm-commits@vger.kernel.org,arnd@arndb.de,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-procfs-implement-efficient-vma-querying-api-for-proc-pid-maps-fix.patch added to mm-unstable branch
Message-Id: <20240702022335.6C990C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/procfs: improve PROCMAP_QUERY's compat mode handling
has been added to the -mm mm-unstable branch.  Its filename is
     fs-procfs-implement-efficient-vma-querying-api-for-proc-pid-maps-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-procfs-implement-efficient-vma-querying-api-for-proc-pid-maps-fix.patch

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
From: Andrii Nakryiko <andrii@kernel.org>
Subject: fs/procfs: improve PROCMAP_QUERY's compat mode handling
Date: Mon, 1 Jul 2024 10:48:05 -0700

Kernel provides compat_ptr_ioctl() wrapper to sanitize pointers for 32-bit
processes on 64-bit host architectures.  Given procfs_procmap_ioctl()
always expects pointer argument, this is exactly what we need.

This has any effect only on 32-bit processes on s390 architecture.

Link: https://lkml.kernel.org/r/20240701174805.1897344-2-andrii@kernel.org
Fixes: 3757be498749 ("fs/procfs: implement efficient VMA querying API for /proc/<pid>/maps")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-procfs-implement-efficient-vma-querying-api-for-proc-pid-maps-fix
+++ a/fs/proc/task_mmu.c
@@ -614,7 +614,7 @@ const struct file_operations proc_pid_ma
 	.llseek		= seq_lseek,
 	.release	= proc_map_release,
 	.unlocked_ioctl = procfs_procmap_ioctl,
-	.compat_ioctl	= procfs_procmap_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
 };
 
 /*
_

Patches currently in -mm which might be from andrii@kernel.org are

fs-procfs-extract-logic-for-getting-vma-name-constituents.patch
fs-procfs-implement-efficient-vma-querying-api-for-proc-pid-maps.patch
fs-procfs-implement-efficient-vma-querying-api-for-proc-pid-maps-fix.patch
fs-procfs-add-build-id-fetching-to-procmap_query-api.patch
fs-procfs-add-build-id-fetching-to-procmap_query-api-fix.patch
docs-procfs-call-out-ioctl-based-procmap_query-command-existence.patch
tools-sync-uapi-linux-fsh-header-into-tools-subdir.patch
selftests-proc-add-procmap_query-ioctl-tests.patch

