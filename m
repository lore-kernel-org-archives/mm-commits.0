Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD273E8C74
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816341; cv=none; b=W2jYfpevYCsNAY/4mmlaSy8ucj8d0LXqHNX41RPGBuRG183iilWw9KJUsdqoC6KWr0kZE8s5qyFW/EZYpnlhaUZS9dYdoHc53oJDxMEDeJNqXED0OE5nd3oT8uGaJ33sMYeGz6+bZ2Y6V0ROVQbGQyzFurSHvr+k1zO81lsKMDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816341; c=relaxed/simple;
	bh=VTcrnw7Rmry5KQ0REvpdiGBhiZm59JXcXm89tFuDO8U=;
	h=Date:To:From:Subject:Message-Id; b=AJzJJJKa9sDtCzVVae8VYjBAseWzbqrOxWoLDQLTqMs97g2iyGslVHTyw0d5DDmsqAeERlnZ8KmOfCJIYtjv8nFwzRkJhqYeToSjklIrsjaFGwlzBwZcjda0UUMrweBGfv4JkFNMeOxXgqVEZmR5RGr0Ac5IObox1IRcGIi7xSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=khYe+uWn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="khYe+uWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3611F000E9;
	Tue,  4 Aug 2026 04:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816340;
	bh=d5M0wvTA2grd05flM9oQaOnbKLgty/q7Qj0iFIwVl3c=;
	h=Date:To:From:Subject;
	b=khYe+uWnDLmx+8YSFv8Hqi9IYmp0ZGIMiSMI2g2y2hjTwUPtRUvanbN2Yahco39Bh
	 CjIjhnPRFNUbxi6t9BTO8aUa/4UlO8Pgc65ctfB/ATIQMyWp/bc6JX8KwuVEoSwLfy
	 9gfXSCAZ7kHHN2HQedqW00C/Lsh2g+Y36Sgyx4+4=
Date: Mon, 03 Aug 2026 21:05:39 -0700
To: mm-commits@vger.kernel.org,ravi.n1@samsung.com,namjae.jeon@samsung.com,hirofumi@mail.parknet.co.jp,brauner@kernel.org,a.sahrawat@samsung.com,chenyichong@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fat-release-buffer-head-after-rebuilding-parent.patch removed from -mm tree
Message-Id: <20260804040539.DB3611F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fat: release buffer head after rebuilding parent
has been removed from the -mm tree.  Its filename was
     fat-release-buffer-head-after-rebuilding-parent.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yichong Chen <chenyichong@uniontech.com>
Subject: fat: release buffer head after rebuilding parent
Date: Wed, 15 Jul 2026 10:09:57 +0800

fat_scan_logstart() leaves the matching directory entry's buffer head in
sinfo.bh for the caller to release, just like fat_scan().

fat_rebuild_parent() uses the directory entry to rebuild the parent inode
for the nostale_ro NFS export path, but does not release sinfo.bh after a
successful scan.  Release it once fat_build_inode() has consumed the
directory entry data.

Link: https://lore.kernel.org/20260715020957.1096309-1-chenyichong@uniontech.com
Fixes: f1e6fb0ab451 ("fat (exportfs): rebuild directory-inode if fat_dget()")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: chenyichong <chenyichong@uniontech.com>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/nfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/fat/nfs.c~fat-release-buffer-head-after-rebuilding-parent
+++ a/fs/fat/nfs.c
@@ -250,8 +250,10 @@ struct inode *fat_rebuild_parent(struct
 		MSDOS_I(dummy_grand_parent)->i_pos = -1;
 	}
 
-	if (!fat_scan_logstart(dummy_grand_parent, clus_to_match, &sinfo))
+	if (!fat_scan_logstart(dummy_grand_parent, clus_to_match, &sinfo)) {
 		parent = fat_build_inode(sb, sinfo.de, sinfo.i_pos);
+		brelse(sinfo.bh);
+	}
 
 	brelse(parent_bh);
 	iput(dummy_grand_parent);
_

Patches currently in -mm which might be from chenyichong@uniontech.com are

hugetlbfs-release-subpool-on-fill_super-failure.patch
hugetlb-make-hugepage_put_subpool-tolerate-null.patch
hugetlb-evaluate-subpool-free-state-while-locked.patch

