Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD0414BF86
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248815; cv=none; b=HmtZuT+JCIqE5YKHC2RLQZIb+sNBFLphxdnwERJT7WosYWkc4+59APtKQogaeO3s9eMkiL+aDoB/NYMvqHrw+bEW9AriKHaothtSb0tADA8QkeTv7AIq7BbGZ2gdAy4rkN1tLTjUimx6Rifkt6awIDs0HDoVSSaxcAOGKvSUpvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248815; c=relaxed/simple;
	bh=T5LPknbnbq/4GZzR2foJ5CoXxc6csEAUzzPBAKzcot4=;
	h=Date:To:From:Subject:Message-Id; b=msx4CxMRMPT+ydaRJEzcOpW06CdUqtpbdvPubTfBh/2cigcTrqYdTs8mDyrvf9hLoe8feNOR1SPJKw1on4t3XoDnX9IweuA3e++4RMZkjHJu54RO/IZiqNomnYfVB6tu9ynEGSSe44BS6EF1/Cs+n2VDCxH+U6CAHZkA56MBanQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zqBx+3lB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zqBx+3lB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0478DC4CEC2;
	Mon,  2 Sep 2024 03:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248815;
	bh=T5LPknbnbq/4GZzR2foJ5CoXxc6csEAUzzPBAKzcot4=;
	h=Date:To:From:Subject:From;
	b=zqBx+3lBObF0OoNRo1qtPyR5p22OncixsIgWRHwzNLEMxdeJ3fg8WUykZ+YVaGlyx
	 LqgiGgejo1qSPal1sD221QBms0HuGL2eUT0uv8M52o7CCm0MAietJ0QmBgiYlWHJSE
	 x/KZXcRAKjrL1pW/yqEwRt0bcSPQcXZxHeIBWaqU=
Date: Sun, 01 Sep 2024 20:46:54 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-add-support-for-fs_ioc_getuuid.patch removed from -mm tree
Message-Id: <20240902034655.0478DC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: add support for FS_IOC_GETUUID
has been removed from the -mm tree.  Its filename was
     nilfs2-add-support-for-fs_ioc_getuuid.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


