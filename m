Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE40013A88A
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 06:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720161818; cv=none; b=lyREwJ0qSZnp1TSavK3/v/qJwLDXEZnDFHfgMIShXg+Jgg2PHh7FwlqSGYVRab9jqaajIOAL4/u3PANSBuNcQ5Jz6m2IDEA3GwdOy0po0nBPd4sVD7+kCEwf0jV5syCoFjeFR/kWF4fH4e96MELjv3PRHV/cNi4G6nw5zypyPuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720161818; c=relaxed/simple;
	bh=d20ccyNttIqeyuSd2Mg0NDJmol0y1z+iZbsR5nL62Ds=;
	h=Date:To:From:Subject:Message-Id; b=gyykY/7Hi7ztKUXA+4Sx9JWwgz5tM++iXk0ehsZSw4SovCpnecV35pXtQcQObuM8DBCjngXuLhlrWje5vQ9Q/ppqwEEKdTM1NXyoj4dRBDv7jikkIdnDZULZQ986r+p79mQlZz2GrGLA/AA3BE1FOO7SsNd/Z8ZH6J1QuiWW9wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tyRpKrDv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tyRpKrDv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF91C116B1;
	Fri,  5 Jul 2024 06:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720161818;
	bh=d20ccyNttIqeyuSd2Mg0NDJmol0y1z+iZbsR5nL62Ds=;
	h=Date:To:From:Subject:From;
	b=tyRpKrDvATseDWWDhx2UcLS3i/1tOgiXPu6FX7zC7Vx3YGNxj+c7ColTiGIrRGojy
	 rdAYP+2x5m8TKQy5lklM829BYoHqxp60fQ73OBKVAQUkkM7PvTsDlVdSJv1pPW7SGN
	 t8Ju3Hk/mhX7j2f+O/rpfdI9Gs2xS2FEnhE0Q+cs=
Date: Thu, 04 Jul 2024 23:43:37 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,yang.lee@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-add-kernel-doc-comments-to-ocfs2_prepare_orphan_dir.patch removed from -mm tree
Message-Id: <20240705064338.3AF91C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: add kernel-doc comments to ocfs2_prepare_orphan_dir()
has been removed from the -mm tree.  Its filename was
     fs-add-kernel-doc-comments-to-ocfs2_prepare_orphan_dir.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: fs: add kernel-doc comments to ocfs2_prepare_orphan_dir()
Date: Fri, 22 Mar 2024 14:37:18 +0800

This commit adds kernel-doc style comments with complete parameter
descriptions for the function ocfs2_prepare_orphan_dir.

Link: https://lkml.kernel.org/r/20240322063718.88183-1-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ocfs2/namei.c~fs-add-kernel-doc-comments-to-ocfs2_prepare_orphan_dir
+++ a/fs/ocfs2/namei.c
@@ -2189,8 +2189,10 @@ static int __ocfs2_prepare_orphan_dir(st
  * @osb: ocfs2 file system
  * @ret_orphan_dir: Orphan dir inode - returned locked!
  * @blkno: Actual block number of the inode to be inserted into orphan dir.
+ * @name: Buffer to store the name of the orphan.
  * @lookup: dir lookup result, to be passed back into functions like
  *          ocfs2_orphan_add
+ * @dio: Flag indicating if direct IO is being used or not.
  *
  * Returns zero on success and the ret_orphan_dir, name and lookup
  * fields will be populated.
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are


