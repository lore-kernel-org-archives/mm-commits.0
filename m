Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6494A1EB2F
	for <mm-commits@vger.kernel.org>; Tue, 17 Jun 2025 01:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750123725; cv=none; b=k2C2T3+dTLLIcPWL+2P4WLdxNVTmxZuXy9StWBIR5b7PCltV7mFvAVGXhRX5A5GA5dIlV/qxKQs0dzlzWOvys/5uUUv3cpYZdZlZytqwf9WXKNpiGkfnf7xThVr00ACgNqkIT1jtOSd+tUIxZJZrj8k4NuTECwNA4PyWQkCu3b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750123725; c=relaxed/simple;
	bh=j0CRzvNILv9YAN25U5iZ+3NbDJDDfdRkR0xIErs3HL0=;
	h=Date:To:From:Subject:Message-Id; b=jQBo4w0foiKhEuhtwPLwGqq9CRIdk+ccPNgRTJcpi2novTamVd14OvBky/VmghLdQucjYLHzQaH9pMN17UlSFVNSy6tKg3ImR/lcn6F7miDoe+N9XjUp8OfFTa7CJ1/Xk+KdHiv7T09uHS0V20gCuMoPe/GDJs5tysFOaYX1MXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jrj4eOOb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jrj4eOOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7696C4CEEA;
	Tue, 17 Jun 2025 01:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750123725;
	bh=j0CRzvNILv9YAN25U5iZ+3NbDJDDfdRkR0xIErs3HL0=;
	h=Date:To:From:Subject:From;
	b=jrj4eOOb9fl79HKg8znVIawCpG+eq4du6xvSyFTlIsjVbA9Y1YGrQJlNgaSO4GlVY
	 weR0yO3+1LVBoaD8o1kDrfI1Oeeipye63XYoFMbix5OqWIw2a+JtezgmXeGXcMIZ+n
	 7hCqZTTpe91UuyvCHGLAgaPecDUXaAlG8gR56KHw=
Date: Mon, 16 Jun 2025 18:28:44 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-convert-most-other-generic_file_mmap-users-to-mmap_prepare-fix.patch added to mm-new branch
Message-Id: <20250617012844.E7696C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs-convert-most-other-generic_file_mmap-users-to-mmap_prepare-fix
has been added to the -mm mm-new branch.  Its filename is
     fs-convert-most-other-generic_file_mmap-users-to-mmap_prepare-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-convert-most-other-generic_file_mmap-users-to-mmap_prepare-fix.patch

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
Subject: fs-convert-most-other-generic_file_mmap-users-to-mmap_prepare-fix
Date: Mon Jun 16 06:26:55 PM PDT 2025

fix missed conversion in fs/ubifs/file.c

Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ubifs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ubifs/file.c~fs-convert-most-other-generic_file_mmap-users-to-mmap_prepare-fix
+++ a/fs/ubifs/file.c
@@ -1586,7 +1586,7 @@ static int ubifs_file_mmap_prepare(struc
 	err = generic_file_mmap_prepare(desc);
 	if (err)
 		return err;
-	vma->vm_ops = &ubifs_file_vm_ops;
+	desc->vm_ops = &ubifs_file_vm_ops;
 
 	if (IS_ENABLED(CONFIG_UBIFS_ATIME_SUPPORT))
 		file_accessed(desc->file);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-convert-most-other-generic_file_mmap-users-to-mmap_prepare-fix.patch
mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate-fix.patch

