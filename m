Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA37B3314B9
	for <mm-commits@vger.kernel.org>; Wed, 15 Apr 2026 09:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776244584; cv=none; b=L7sAZpvyD4twXg/kHhyyLw5K8iskLjLhk9Q7xe2s0EivDn60N8RfP9bjOpb8Kms9CWYSjCfywxzgJskrrrZ4Fxyl8Lbiyh/+nmMjML+Lyp51T2qV95h9xB1e7UpIvie6wppjoaHKNmPfVIsRzCqT51uJgF3FE/jrEjEYj8OcidM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776244584; c=relaxed/simple;
	bh=aoIRFSwAp2P6GTxMa//pv4bjf5WwzeCpM9oKna8Jxfg=;
	h=Date:To:From:Subject:Message-Id; b=qJ+1Ggy4wZQAWrZp30dMKiphPz8AqswxM4iv5/Lc4FwSldToii5KmmHVkeCSg8OlYWvCFFVouHRpMDm1eTYTPmW7qTaxqYm6oCS08DCE+PGCTAEPOAR1oxRQu0vNfIoFVjsob+UoebaVyEzKu1UgM37F37e9U2Z1OGZQkxkFuVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ae5SKGZ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ae5SKGZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D159DC19424;
	Wed, 15 Apr 2026 09:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776244584;
	bh=aoIRFSwAp2P6GTxMa//pv4bjf5WwzeCpM9oKna8Jxfg=;
	h=Date:To:From:Subject:From;
	b=Ae5SKGZ8UqVNNXXrSkIo1WNXYwCfpl+hn9Cmwhozmq7cWS+uzilMETbKDGgOHI1RU
	 rhDvPkWiFbGFlG4z0YJVPvboMMJa14fbZTy6/MVGPu7IsQsu3aq/hQUJz9Iz2XwNEA
	 iVa/Y2a8MaQ/62Cwe5BcaeLnddYbZp8nCJwU7iho=
Date: Wed, 15 Apr 2026 02:16:20 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-remove-empty-extent-list-check-in-ocfs2_dx_dir_lookup_rec.patch removed from -mm tree
Message-Id: <20260415091623.D159DC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: remove empty extent list check in ocfs2_dx_dir_lookup_rec()
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-empty-extent-list-check-in-ocfs2_dx_dir_lookup_rec.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: remove empty extent list check in ocfs2_dx_dir_lookup_rec()
Date: Fri, 3 Apr 2026 17:08:01 +0800

The full extent list check is introduced by commit 44acc46d182f, which is
to avoid NULL pointer dereference if a dirent is not found.

Reworking the error message to not reference rec.  Instead, report
major_hash being looked up and l_next_free_rec, which naturally covers
both failure cases (empty extent list and no matching record) without
needing a separate l_next_free_rec == 0 guard.

Link: https://lkml.kernel.org/r/20260403090803.3860971-3-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

--- a/fs/ocfs2/dir.c~ocfs2-remove-empty-extent-list-check-in-ocfs2_dx_dir_lookup_rec
+++ a/fs/ocfs2/dir.c
@@ -835,14 +835,6 @@ static int ocfs2_dx_dir_lookup_rec(struc
 		}
 	}
 
-	if (le16_to_cpu(el->l_next_free_rec) == 0) {
-		ret = ocfs2_error(inode->i_sb,
-				  "Inode %lu has empty extent list at depth %u\n",
-				  inode->i_ino,
-				  le16_to_cpu(el->l_tree_depth));
-		goto out;
-	}
-
 	found = 0;
 	for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
 		rec = &el->l_recs[i];
@@ -855,10 +847,9 @@ static int ocfs2_dx_dir_lookup_rec(struc
 
 	if (!found) {
 		ret = ocfs2_error(inode->i_sb,
-				  "Inode %lu has bad extent record (%u, %u, 0) in btree\n",
-				  inode->i_ino,
-				  le32_to_cpu(rec->e_cpos),
-				  ocfs2_rec_clusters(el, rec));
+				  "Inode %lu has no extent record for hash %u in btree (next_free_rec %u)\n",
+				  inode->i_ino, major_hash,
+				  le16_to_cpu(el->l_next_free_rec));
 		goto out;
 	}
 
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


