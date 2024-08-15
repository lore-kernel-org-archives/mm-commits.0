Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA80614A611
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 22:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723761466; cv=none; b=pfrbrtqpRHQLBl4NLP/7/g3tMbif6zNupxnnoefT8ALomgO41eOZTIPUM5VDqHUaXK9g6Ql2UZ5UcRBDK8n3PVUzCnetOo4epqf2iPBsNqwFo5PwPJpq57hv6FT85o1cnqpG5lCrkmNjPqsBblhUlz+1CzD4V8i4UrNAnPMdFkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723761466; c=relaxed/simple;
	bh=fBmuof3DH8YnI1diJ+SmWkYPprJr35Fy1P+qbuhGFDk=;
	h=Date:To:From:Subject:Message-Id; b=MSbbSk4C/44fQs3zmA2JgqdlzKy4H/nmoPqQMxrNLcltOSDdLtBCSDxHkrkXnmaMnIHUmTz7oqngVQVa937mJsfZh8K+ZjfPPM2FcPlKf770kWGxQwfqIo+vpdNDmL57vLeBTCSKxdJP9A2pZKN5VkjXdatUdqJe5i1JhsIPkmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rd2lXpJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rd2lXpJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE175C32786;
	Thu, 15 Aug 2024 22:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723761465;
	bh=fBmuof3DH8YnI1diJ+SmWkYPprJr35Fy1P+qbuhGFDk=;
	h=Date:To:From:Subject:From;
	b=Rd2lXpJ8dlZEcu0faAUqs23wyDyEgXzq1iGfrCxN0SPlVzaMmz+UFN7/QVDQDGrOG
	 j4vlg4Q5PnuRD88Q2yKu+Qpmud2a0po4jRlwjnlNOr0lHCKPNK4IDQrYOeJjKL1084
	 cnPqL6lRX1zsoL/j3u8fje9YMJ4PZ1ZtScs2Qolk=
Date: Thu, 15 Aug 2024 15:37:45 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-add-support-for-fs_ioc_getfssysfspath.patch added to mm-nonmm-unstable branch
Message-Id: <20240815223745.AE175C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: add support for FS_IOC_GETFSSYSFSPATH
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-add-support-for-fs_ioc_getfssysfspath.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-add-support-for-fs_ioc_getfssysfspath.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: add support for FS_IOC_GETFSSYSFSPATH
Date: Thu, 15 Aug 2024 16:44:06 +0900

Use the standard helper super_set_sysfs_name_bdev() to give the sysfs
subpath of the filesystem for the FS_IOC_GETFSSYSFSPATH ioctl.

For nilfs2, it will output "nilfs2/<dev>".

Link: https://lkml.kernel.org/r/20240815074408.5550-3-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nilfs2/super.c~nilfs2-add-support-for-fs_ioc_getfssysfspath
+++ a/fs/nilfs2/super.c
@@ -1065,6 +1065,7 @@ nilfs_fill_super(struct super_block *sb,
 
 	super_set_uuid(sb, nilfs->ns_sbp[0]->s_uuid,
 		       sizeof(nilfs->ns_sbp[0]->s_uuid));
+	super_set_sysfs_name_bdev(sb);
 
 	cno = nilfs_last_cno(nilfs);
 	err = nilfs_attach_checkpoint(sb, cno, true, &fsroot);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-protect-references-to-superblock-parameters-exposed-in-sysfs.patch
nilfs2-fix-missing-cleanup-on-rollforward-recovery-error.patch
nilfs2-fix-state-management-in-error-path-of-log-writing-function.patch
nilfs2-add-support-for-fs_ioc_getuuid.patch
nilfs2-add-support-for-fs_ioc_getfssysfspath.patch
nilfs2-add-support-for-fs_ioc_getfslabel.patch
nilfs2-add-support-for-fs_ioc_setfslabel.patch

