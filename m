Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D77114A611
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 22:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723761464; cv=none; b=uDe/Q2rnWt3XsD9FAWH6ZOnrYhK55j1TOkmJ+2McAGt1NCZs5wSsEoiRrnmZB+xlFKCKkofxbtIhXAPMfQZiZgSL2N+WBVpqwgh7ad2ej0PTtKyqZFDAaDY/Bww5eG610ltL5zl+LYuaEbIOEbwU/V7XouXhbttLfzjCHRvsw1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723761464; c=relaxed/simple;
	bh=P0qiN/dSAEXWMG40sOuhh5HcPexWFzuM0CX/OCJp/5E=;
	h=Date:To:From:Subject:Message-Id; b=Z+LgFcZFS2Kzk2DqUx0shEQBDYiyipd/wNtNe/HgStnQKy/zWHz3Tg6jcNdtfVP3Bh+gfpaGb1XE67NBGiQAG4v3/xVKKokpdzRHCp80ifhj8bSLlCDJ5V2aJEKbkKmhCaoinv71LqGhVhPQwF1RMFzRvERFpb8HqYR58jYmshU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VLtT80DN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VLtT80DN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734FCC4AF0C;
	Thu, 15 Aug 2024 22:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723761464;
	bh=P0qiN/dSAEXWMG40sOuhh5HcPexWFzuM0CX/OCJp/5E=;
	h=Date:To:From:Subject:From;
	b=VLtT80DNKtsU8Zevs+e8MXqzhfZBxL9HuyOcvzU8PkDAoGJbe2TVkTbN7S+TK6cax
	 1Z5gMai1RJq9tGy8UZMG6zPQk5GKd3CZiEDMY+zDxBfeDijaSW+4sFDRZIhtMP3XqS
	 JOh4XMtrJv9jLQh1u1t0D9xa8u8PHZLO4RXBrxpg=
Date: Thu, 15 Aug 2024 15:37:43 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-add-support-for-fs_ioc_getuuid.patch added to mm-nonmm-unstable branch
Message-Id: <20240815223744.734FCC4AF0C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: add support for FS_IOC_GETUUID
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-add-support-for-fs_ioc_getuuid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-add-support-for-fs_ioc_getuuid.patch

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
Subject: nilfs2: add support for FS_IOC_GETUUID
Date: Thu, 15 Aug 2024 16:44:05 +0900

Patch series "nilfs2: add support for some common ioctls".

This series adds support for common ioctls to nilfs2 for getting the
volume UUID and the relative path of an FS instance within the sysfs
namespace, and also implements ioctls for nilfs2 to get and set the volume
label.


This patch (of 2):

Expose the UUID of a file system instance using the super_set_uuid helper
and support the FS_IOC_GETUUID ioctl.

Link: https://lkml.kernel.org/r/20240815074408.5550-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20240815074408.5550-2-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/nilfs2/super.c~nilfs2-add-support-for-fs_ioc_getuuid
+++ a/fs/nilfs2/super.c
@@ -1063,6 +1063,9 @@ nilfs_fill_super(struct super_block *sb,
 	if (err)
 		goto failed_nilfs;
 
+	super_set_uuid(sb, nilfs->ns_sbp[0]->s_uuid,
+		       sizeof(nilfs->ns_sbp[0]->s_uuid));
+
 	cno = nilfs_last_cno(nilfs);
 	err = nilfs_attach_checkpoint(sb, cno, true, &fsroot);
 	if (err) {
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-protect-references-to-superblock-parameters-exposed-in-sysfs.patch
nilfs2-fix-missing-cleanup-on-rollforward-recovery-error.patch
nilfs2-fix-state-management-in-error-path-of-log-writing-function.patch
nilfs2-add-support-for-fs_ioc_getuuid.patch
nilfs2-add-support-for-fs_ioc_getfssysfspath.patch
nilfs2-add-support-for-fs_ioc_getfslabel.patch
nilfs2-add-support-for-fs_ioc_setfslabel.patch

