Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B0ABA4A
	for <mm-commits@vger.kernel.org>; Sat, 18 Oct 2025 00:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760746610; cv=none; b=RcF/K9GmViLdVIB2TTLHZDLvxAvrb9EQgDZPsijXNnGpROC97z2Cael2vGU8pLcm7AF61oLLjdtcUWM9wMjgwkLHXkApfSNrjFUB+LBNWdrRrGKmDPxm6yHu4Tmk2LXc78dxBxgE2gEOB7d8r9zwP7bBOkGxyJYr34RSvSieDbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760746610; c=relaxed/simple;
	bh=NRVvsCUkk9C8cAW3x+2Xx0iqGWnmV83vyBprRSpAIbA=;
	h=Date:To:From:Subject:Message-Id; b=YkQLOnRMS0oIiXaXZjlWw9XY9VEmNpPkE6lPqenklvirp1t1+dOexoBoEaypRZ6854/5E6ZlHQRIkDhFIuccFTcXYg6n6dJkCEtcxSCDFr7M/0tw0OtRb5dYBnACqnMGdXEDAGOFqeZLcYTUuxzWW0tNen0eqQuQPd5VIIUSmAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zvP7vPpr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zvP7vPpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C28C4CEE7;
	Sat, 18 Oct 2025 00:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760746608;
	bh=NRVvsCUkk9C8cAW3x+2Xx0iqGWnmV83vyBprRSpAIbA=;
	h=Date:To:From:Subject:From;
	b=zvP7vPpriCJEoV47IvP0UZWut4DkUB+ThAf1A8NXlnvWH2xfgdVCw3+yW1Bg/X7Me
	 36Gqv/g2QG95yvpHnB89ZuV8NvtEEhn8n/5fevwHkJ6iXjsh7VNPF8CSlbJu+gIraK
	 k4S5Ar3EmILTtCHsp4b/CFD+JOfwl1QuwZ3oZfZ4=
Date: Fri, 17 Oct 2025 17:16:47 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-add-directory-size-check-to-ocfs2_find_dir_space_id.patch added to mm-nonmm-unstable branch
Message-Id: <20251018001648.76C28C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: add directory size check to ocfs2_find_dir_space_id()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-add-directory-size-check-to-ocfs2_find_dir_space_id.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-add-directory-size-check-to-ocfs2_find_dir_space_id.patch

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
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: add directory size check to ocfs2_find_dir_space_id()
Date: Mon, 13 Oct 2025 13:37:09 +0300

Fix a null-pointer-deref which was detected by UBSAN:

KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 UID: 0 PID: 5317 Comm: syz-executor310 Not tainted 6.15.0-syzkaller-12141-gec7714e49479 #0 PREEMPT(full) 

In 'ocfs2_find_dir_space_id()', add extra check whether the directory data
block is large enough to hold at least one directory entry, and raise
'ocfs2_error()' if the former is unexpectedly small.

Link: https://lkml.kernel.org/r/20251013103709.146001-1-dmantipov@yandex.ru
Reported-by: syzbot+ded9116588a7b73c34bc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ded9116588a7b73c34bc
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ocfs2/dir.c~ocfs2-add-directory-size-check-to-ocfs2_find_dir_space_id
+++ a/fs/ocfs2/dir.c
@@ -3431,6 +3431,14 @@ static int ocfs2_find_dir_space_id(struc
 		offset += le16_to_cpu(de->rec_len);
 	}
 
+	if (!last_de) {
+		ret = ocfs2_error(sb, "Directory entry (#%llu: size=%lld) "
+				  "is unexpectedly short",
+				  (unsigned long long)OCFS2_I(dir)->ip_blkno,
+				  i_size_read(dir));
+		goto out;
+	}
+
 	/*
 	 * We're going to require expansion of the directory - figure
 	 * out how many blocks we'll need so that a place for the
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

ocfs2-add-extra-flags-check-in-ocfs2_ioctl_move_extents.patch
ocfs2-relax-bug-to-ocfs2_error-in-__ocfs2_move_extent.patch
ocfs2-annotate-flexible-array-members-with-__counted_by_le.patch
ocfs2-annotate-flexible-array-members-with-__counted_by_le-fix.patch
ocfs2-add-extra-consistency-check-to-ocfs2_dx_dir_lookup_rec.patch
ocfs2-add-chain-list-sanity-check-to-ocfs2_block_group_alloc.patch
ocfs2-add-directory-size-check-to-ocfs2_find_dir_space_id.patch

