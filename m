Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF88356766
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338688; cv=none; b=ZIY/P+KX7x9KjixdOaBywpxlFS+aLbsG4x4wRjh+ZC8hzNCRuFuiWDY2r6aSfBLZ2s6lyUkm9ix90zfEOxMNk4D0lUIlP62K/lXuRRix2GnDqFdbRvyafID7H6A1BJooD3x6JW35k4dVTRJgcu2tKtNUXaw/VeQMlD4lCo7XkjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338688; c=relaxed/simple;
	bh=ZSW+a5jDdC3sZhe1h0RMvwtmyMm7T8L1O099baPZP1s=;
	h=Date:To:From:Subject:Message-Id; b=og2aduL5TiPmJWT1Eqh7IDkqnMHIteqyIDkqMKEaOmSwjeVgTr4o/oQfyb30xA4pXHs4tysjM1qf6I4gNTLvlSVJ+btrP+nCml8kFJZ41SLxfHZPvx06dfqlS+VB6B2Nvbht75h6lCKVwECq2ARxSoSM1FaQC0rGvEH0AyI9ZJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KGCa3ElS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KGCa3ElS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CBE1F0089B;
	Wed,  7 Oct 2026 02:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338687;
	bh=k7ZgKpErLqfbRWR5O7PwRMRD7/AWOxYAwfOLfFYUXU8=;
	h=Date:To:From:Subject;
	b=KGCa3ElSndleq+1lUF98MxKdPzbTCh2j5rv56nf/8RylzL4uYG069uE8ncGawtQg8
	 spqsWSyCPdupdgAq+LdUwaXNJxSP3KEOdztu9FkrWTZ0CNa7fsbMsKOtHOYVTWmCUd
	 qA/JBd1fnsgcOt7gyJJW3qg7UAJutUNRAw9D8G6I=
Date: Tue, 06 Oct 2026 19:04:46 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-reject-inconsistent-xattr-bucket-during-defrag.patch removed from -mm tree
Message-Id: <20261007020446.D8CBE1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: reject inconsistent xattr bucket during defrag
has been removed from the -mm tree.  Its filename was
     ocfs2-reject-inconsistent-xattr-bucket-during-defrag.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: reject inconsistent xattr bucket during defrag
Date: Thu, 3 Sep 2026 21:13:13 +0800

ocfs2_defrag_xattr_bucket() has two mlog_bug_on_msg() checks that assume
the name/value pairs in a bucket are disjoint and that xh_free_start is
not below the compacted region.

ocfs2_validate_xattr_bucket() only checks each entry in isolation, so a
corrupt bucket holding overlapping entries, or one with an inflated
xh_free_start, passes validation and then hits BUG() in defrag when a
setxattr triggers it.

Defrag works on a linear copy of the bucket and does not touch the real
blocks before the copy back, so the checks can return an error instead of
calling BUG().

Link: https://lore.kernel.org/20260903131313.2396208-3-joseph.qi@linux.alibaba.com
Fixes: 012255961c9e ("ocfs2: Enable xattr set in index btree")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
---

 fs/ocfs2/xattr.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-reject-inconsistent-xattr-bucket-during-defrag
+++ a/fs/ocfs2/xattr.c
@@ -4801,16 +4801,22 @@ static int ocfs2_defrag_xattr_bucket(str
 			memmove(bucket_buf + end - len,
 				bucket_buf + offset, len);
 			xe->xe_name_offset = cpu_to_le16(end - len);
+		} else if (end < offset + len) {
+			ret = ocfs2_error(inode->i_sb,
+					  "Defrag check failed for bucket %llu\n",
+					  (unsigned long long)blkno);
+			goto out;
 		}
 
-		mlog_bug_on_msg(end < offset + len, "Defrag check failed for "
-				"bucket %llu\n", (unsigned long long)blkno);
-
 		end -= len;
 	}
 
-	mlog_bug_on_msg(xh_free_start > end, "Defrag check failed for "
-			"bucket %llu\n", (unsigned long long)blkno);
+	if (xh_free_start > end) {
+		ret = ocfs2_error(inode->i_sb,
+				  "Defrag check failed for bucket %llu\n",
+				  (unsigned long long)blkno);
+		goto out;
+	}
 
 	if (xh_free_start == end)
 		goto out;
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-retain-all-security-xattrs-during-inode-creation.patch
ocfs2-restore-erange-check-in-ocfs2_xattr_tree_list_index_block.patch
ocfs2-fix-possible-deadlock-between-nfs_sync_rwlock-and-fs_reclaim.patch

