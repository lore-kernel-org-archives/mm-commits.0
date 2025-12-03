Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF42C482EB
	for <mm-commits@vger.kernel.org>; Wed,  3 Dec 2025 22:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764802266; cv=none; b=hCWRjjlASrdlFBHwPY+xwqFiDuNza1kbojCPCHHhlRyj978SGQB0VqfvCMdHA4jUwggzbuv0J3xx1yZlkWMJ8zP9fWP/RR7JV5pRW9pVDgbTJS/a9ei53/Th70XwVY10xAr32IK2fIlY88oIT54vJINXl6AbtEMsGH/z/Bq+xpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764802266; c=relaxed/simple;
	bh=Vx/CITSs1UP4AqPU2M9xDPcYGAQLxLhkagEVv5Vkg54=;
	h=Date:To:From:Subject:Message-Id; b=FkIloeX0iQ+ft/vPNwhTItabNkvPZW6NL6gF913mbA20tHyluyn0o3NHzP5OkcCVzGRGjpUQiVrZov1T1TpVU2A2apKiKYeP0euQppH7on74vP3chGTTv1c/BzIAZDLm/ALQxc2i86aIKEXy093rgSLBAbXeUwQeVk7lReb6FmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1KrFNri9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1KrFNri9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D682C4CEF5;
	Wed,  3 Dec 2025 22:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764802263;
	bh=Vx/CITSs1UP4AqPU2M9xDPcYGAQLxLhkagEVv5Vkg54=;
	h=Date:To:From:Subject:From;
	b=1KrFNri9NfnuSGvsZgYSoI1DvjP7H5bOuvJISnovTgN0w9Vq7+37hs32a12YyP7g2
	 HVI7TCnQDspdSwQbaekNdBmn5b5wgYC4FOdRGDRG47wGtK3cwxJGxPAudiyz01573g
	 vnpa2LJ9QW40pfKr7LUvJjIoTwaLCX5Dgw51Q2AE=
Date: Wed, 03 Dec 2025 14:51:02 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,david.hunter.linux@gmail.com,albinbabuvarghese20@gmail.com,eraykrdg1@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-invalidate-inode-if-i_mode-is-zero-after-block-read.patch added to mm-nonmm-unstable branch
Message-Id: <20251203225103.3D682C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: invalidate inode if i_mode is zero after block read
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-invalidate-inode-if-i_mode-is-zero-after-block-read.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-invalidate-inode-if-i_mode-is-zero-after-block-read.patch

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
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Subject: ocfs2: invalidate inode if i_mode is zero after block read
Date: Wed, 3 Dec 2025 01:45:08 +0300

A panic occurs in ocfs2_unlink due to WARN_ON(inode->i_nlink == 0) when
handling a corrupted inode with i_mode=0 and i_nlink=0 in memory.

This "zombie" inode is created because ocfs2_read_locked_inode proceeds
even after ocfs2_validate_inode_block successfully validates a block that
structurally looks okay (passes checksum, signature etc.) but contains
semantically invalid data (specifically i_mode=0).  The current validation
function doesn't check for i_mode being zero.

This results in an in-memory inode with i_mode=0 being added to the VFS
cache, which later triggers the panic during unlink.

Prevent this by adding an explicit check for (i_mode == 0, i_nlink == 0,
non-orphan) within ocfs2_validate_inode_block.  If the check is true,
return -EFSCORRUPTED to signal corruption.  This causes the caller
(ocfs2_read_locked_inode) to invoke make_bad_inode(), correctly preventing
the zombie inode from entering the cache.

Link: https://lkml.kernel.org/r/20251202224507.53452-2-eraykrdg1@gmail.com
Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Reported-by: syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com
Fixes: https://syzkaller.appspot.com/bug?extid=55c40ae8a0e5f3659f2b
Link: https://lore.kernel.org/all/20251022222752.46758-2-eraykrdg1@gmail.com/T/
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: David Hunter <david.hunter.linux@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-invalidate-inode-if-i_mode-is-zero-after-block-read
+++ a/fs/ocfs2/inode.c
@@ -1461,6 +1461,14 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
+	if ((!di->i_links_count && !di->i_links_count_hi) || !di->i_mode) {
+		mlog(ML_ERROR, "Invalid dinode #%llu: "
+			"Corrupt state (nlink = %u or mode = %u) detected!\n",
+		        (unsigned long long)bh->b_blocknr,
+			ocfs2_read_links_count(di), le16_to_cpu(di->i_mode));
+		rc = -EFSCORRUPTED;
+		goto bail;
+	}
 	/*
 	 * Errors after here are fatal.
 	 */
_

Patches currently in -mm which might be from eraykrdg1@gmail.com are

ocfs2-add-ocfs2_emergency_state-helper-and-apply-to-setattr.patch
ocfs2-convert-remaining-read-only-checks-to-ocfs2_emergency_state.patch
ocfs2-invalidate-inode-if-i_mode-is-zero-after-block-read.patch

