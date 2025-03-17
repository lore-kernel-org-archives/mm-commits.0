Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A541D218E8B
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189511; cv=none; b=TBXTc7JGsc9c9jBqLkRK7vXVgwMd0MBbFaBH5RNMX4L05SHdyXc21p7TQcXGs/9FGv4MBrZQFeURfiepRaoW/By9qOdUTEwNk2eFI03gZ/1MXqfeA6JTclAgsOfedSbZgRtnB/Rs9m0Q26QY2LiMJizVhmKkxhNjolDJSVM6Wqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189511; c=relaxed/simple;
	bh=jT6yIPEEL6E31JlyqsWuvoXdr/hL4+9JbCY7O25SbVQ=;
	h=Date:To:From:Subject:Message-Id; b=o6LEVAfsi4dF6vuRX0BnWQDlQlqA+d1YlEZJKAxo3QPK+UwofyUFZJSHVlwNQ+f/0A9tP+OttxHj1GIJcLo717nYB/KB6x3SEmRA0J+/ZeV0A3RAuZvnn7nvpm6pejA6mEjxK3cwNlE3AtCY7rZRUFm8fwo1vLBeGNpeJaHiHx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EiYchlne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EiYchlne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F50C4CEEC;
	Mon, 17 Mar 2025 05:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189511;
	bh=jT6yIPEEL6E31JlyqsWuvoXdr/hL4+9JbCY7O25SbVQ=;
	h=Date:To:From:Subject:From;
	b=EiYchlneHZEODYM2Rr6nmB6SkciZy+eXeeKKUxqAIGEvTxlqMa6A+ncASIZk8AUh2
	 3DIRG/U5FYvrbWCPDznlgC8mPhlTel3Bgewt21Di7YYOsSKfY6Nzv2oCBnNJ7wtl5R
	 6/qtrbtMYIAwrdt++AG2qMU/FJJDfCQ7QXFommAk=
Date: Sun, 16 Mar 2025 22:31:51 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,kurt.hackel@oracle.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,kovalev@altlinux.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-validate-l_tree_depth-to-avoid-out-of-bounds-access.patch removed from -mm tree
Message-Id: <20250317053151.78F50C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: validate l_tree_depth to avoid out-of-bounds access
has been removed from the -mm tree.  Its filename was
     ocfs2-validate-l_tree_depth-to-avoid-out-of-bounds-access.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vasiliy Kovalev <kovalev@altlinux.org>
Subject: ocfs2: validate l_tree_depth to avoid out-of-bounds access
Date: Fri, 14 Feb 2025 11:49:08 +0300

The l_tree_depth field is 16-bit (__le16), but the actual maximum depth is
limited to OCFS2_MAX_PATH_DEPTH.

Add a check to prevent out-of-bounds access if l_tree_depth has an invalid
value, which may occur when reading from a corrupted mounted disk [1].

Link: https://lkml.kernel.org/r/20250214084908.736528-1-kovalev@altlinux.org
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Reported-by: syzbot+66c146268dc88f4341fd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=66c146268dc88f4341fd [1]
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Kurt Hackel <kurt.hackel@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Vasiliy Kovalev <kovalev@altlinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ocfs2/alloc.c~ocfs2-validate-l_tree_depth-to-avoid-out-of-bounds-access
+++ a/fs/ocfs2/alloc.c
@@ -1803,6 +1803,14 @@ static int __ocfs2_find_path(struct ocfs
 
 	el = root_el;
 	while (el->l_tree_depth) {
+		if (unlikely(le16_to_cpu(el->l_tree_depth) >= OCFS2_MAX_PATH_DEPTH)) {
+			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
+				    "Owner %llu has invalid tree depth %u in extent list\n",
+				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
+				    le16_to_cpu(el->l_tree_depth));
+			ret = -EROFS;
+			goto out;
+		}
 		if (le16_to_cpu(el->l_next_free_rec) == 0) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
 				    "Owner %llu has empty extent list at depth %u\n",
_

Patches currently in -mm which might be from kovalev@altlinux.org are


