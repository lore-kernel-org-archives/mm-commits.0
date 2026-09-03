Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56335381B0A
	for <mm-commits@vger.kernel.org>; Thu,  3 Sep 2026 18:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788460434; cv=none; b=G6hlL8IFy3GQ32IcpDWkVZuzgvFGu108xgbP26XUZbrNOKy9Tyu9xTxdDtt+7eaEK/bXMVocOUqdpMXjBIDetEX0x1n9ZIYT8gZ61O0WRKIbk24hse0HQNZhkHIs/ETBm8V6hM/GiZxZN2QzvM8rpotWFKR3cNEIPHRroPXUJ44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788460434; c=relaxed/simple;
	bh=iDCVmlCtKz4s2A1Vu6wzF7pzYCaV0haNIFlN5gdy3os=;
	h=Date:To:From:Subject:Message-Id; b=Tn4e9Ts3Ryt7ikz+Hn3fEMDk9LL3s6xgcsEtf3qd5Aw4jnVAXNAujg36tqkzjgE6INYhzVep6TfB3Hfs0Y/fn3XMYIYQph2XQkfMyofDi6fb1GXsAGkc76Pa56ik59rv8Ab+pXOdZk1NsQDkC6OoE8WLXGZj5OZKSE+q2x/e1/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ey3Y5/LK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ey3Y5/LK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF461F00A3D;
	Thu,  3 Sep 2026 18:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788460418;
	bh=B+pKw0ytEaTOsjST0/+TREYHmQXO4NLmI1lkGdWoUjE=;
	h=Date:To:From:Subject;
	b=ey3Y5/LKMES78XVNrs/L/rQp85pvY11d/8dX6iT+ZFpyUNn1sPEqdXwee8z1+qukp
	 K6a4d83ivsglLq72npi0QUWxd8MgddwA2PnwpuO1a+YB8kvVLhIroHq/zlblIdOdrG
	 t2VSM1snN6OiibQvYWm5SQ7ofbJCt5ZV+bSSjvgA=
Date: Thu, 03 Sep 2026 11:33:38 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-reject-inconsistent-xattr-bucket-during-defrag.patch added to mm-nonmm-unstable branch
Message-Id: <20260903183338.7DF461F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: reject inconsistent xattr bucket during defrag
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-reject-inconsistent-xattr-bucket-during-defrag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-reject-inconsistent-xattr-bucket-during-defrag.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-reject-inconsistent-xattr-bucket-during-defrag
+++ a/fs/ocfs2/xattr.c
@@ -4804,16 +4804,22 @@ static int ocfs2_defrag_xattr_bucket(str
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

ocfs2-fix-deadlock-in-inline-data-truncate-transactions.patch
ocfs2-exit-recovery-thread-on-mount-error-path.patch
ocfs2-free-replay-slots-in-ocfs2_recovery_exit.patch
ocfs2-defer-suballocator-block-group-reclaim-to-workqueue.patch
ocfs2-restrict-ocfs2_invalid_slot-suballoc-slot-to-system-inodes.patch
ocfs2-validate-suballoc-bit-during-inode-read.patch
ocfs2-validate-suballoc-slot-and-bit-of-xattr-and-dir-index-blocks.patch
ocfs2-validate-suballoc-slot-and-bit-of-extent-and-refcount-blocks.patch
ocfs2-allow-xattr-bucket-entries-to-span-multiple-blocks.patch
ocfs2-reject-inconsistent-xattr-bucket-during-defrag.patch

