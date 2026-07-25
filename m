Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F26532B989;
	Sat, 25 Jul 2026 04:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784954696; cv=none; b=dnIXgG2arc1CBINI1huoDUof3RfINZhT2SNX8fpv6o1ab+D9e1oRmRXKq9zKQoHt/2+iYfbMSpQvAkiP+FFwaV23Blufn9yjzbz27iV+AXd2I6v07PjxNYCwfBhNiquHp8xYSrffsQnFgvNb3npAi+O3lhLBEC6Ti3JY2OND0qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784954696; c=relaxed/simple;
	bh=b2BrQwmzf6JgPCnXFcT69MbElxivcL/7VLuJxQj9ADw=;
	h=Date:To:From:Subject:Message-Id; b=OCrKrjgdgsHAUbB8M0AzrzulDbLy1ZEJer4ZuLQiKzdyVTFa3xeuv4EG0SRbiP2Y2YaLOd0Ok8StPR3P47gBNxQgD9kL24czSgGphQNq+/BJxYNDsBzTBY7Tant0ZU+9JwwRbJQyDVYz0P0APZMR+DtKxw96p3U7bHlSEeeqJ7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yLl54xfD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yLl54xfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6531F000E9;
	Sat, 25 Jul 2026 04:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784954694;
	bh=VXqh5pqiDV+nKnhkwuh6TzKeSve4anUuKvd/jLEGYH0=;
	h=Date:To:From:Subject;
	b=yLl54xfDNl2yviM6vcRlSCuTwIwiykxFZMWT6KYJRB0X9J1eFCgdS5nTXGYnXLcBc
	 C4tHZ/XkvYlqSm7mCiZiv3yx9bRIv3KDdaNeZubet6TMst51Qd7BSFkMjw6lGHT6sd
	 uoGdsgi5rapnCwaQuYJnwpDxiuvuWeFo8IU9xTDc=
Date: Fri, 24 Jul 2026 21:44:54 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,icb@fastmail.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-missing-metadata-reservation-for-large-xattrs.patch added to mm-nonmm-unstable branch
Message-Id: <20260725044454.6F6531F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix missing metadata reservation for large xattrs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-missing-metadata-reservation-for-large-xattrs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-missing-metadata-reservation-for-large-xattrs.patch

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
From: Ian Bridges <icb@fastmail.org>
Subject: ocfs2: fix missing metadata reservation for large xattrs
Date: Thu, 23 Jul 2026 23:57:03 -0500

[BUG]
lsetxattr() panics the kernel when setting a large xattr value on a
fragmented filesystem where the file already has an external xattr
block.

[CAUSE]
ocfs2_calc_xattr_set_need() never reserves metadata blocks for a new
xattr value's extent tree when the file already has an external xattr
block. The not_found path leaves meta_add at zero, so meta_ac is NULL
when ocfs2_xattr_extend_allocation() runs.

A new value root has room for a single extent record. On a fragmented
filesystem, the allocator cannot satisfy the xattr value in one
contiguous run, so each non-contiguous run requires its own extent
record. When the value root's extent list is full and meta_ac is NULL,
ocfs2_add_clusters_in_btree() returns RESTART_META, and
ocfs2_xattr_extend_allocation() hits BUG_ON(why == RESTART_META).

[FIX]
The case where no xattr block exists yet already calls
ocfs2_extend_meta_needed(&def_xv.xv.xr_list) to reserve value tree
metadata. Add the same reservation to the case where an xattr block
already exists, making the two cases consistent.

Replace the BUG_ON with a -ENOSPC return so that if RESTART_META is
returned despite the reservation, the error propagates to userspace
instead of panicking the kernel.

Link: https://lore.kernel.org/amLwn3i9tET8yhG7@dev
Fixes: a78f9f466894 ("ocfs2: make xattr extension work with new local alloc reservation.")
Signed-off-by: Ian Bridges <icb@fastmail.org>
Reported-by: syzbot+e538032956b1157914a3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e538032956b1157914a3
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-fix-missing-metadata-reservation-for-large-xattrs
+++ a/fs/ocfs2/xattr.c
@@ -764,12 +764,10 @@ static int ocfs2_xattr_extend_allocation
 					 prev_clusters;
 
 		if (why != RESTART_NONE && clusters_to_add) {
-			/*
-			 * We can only fail in case the alloc file doesn't give
-			 * up enough clusters.
-			 */
-			BUG_ON(why == RESTART_META);
-
+			if (why == RESTART_META) {
+				status = -ENOSPC;
+				break;
+			}
 			credits = ocfs2_calc_extend_credits(inode->i_sb,
 							    &vb->vb_xv->xr_list);
 			status = ocfs2_extend_trans(handle, credits);
@@ -3444,6 +3442,14 @@ meta_guess:
 			credits += OCFS2_SUBALLOC_ALLOC + 1;
 
 		/*
+		 * Reserve metadata for the new xattr's value extent tree.
+		 * The not_found path above adds credits for this tree but
+		 * omits meta_add, leaving meta_ac NULL for large values.
+		 */
+		if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE)
+			meta_add += ocfs2_extend_meta_needed(&def_xv.xv.xr_list);
+
+		/*
 		 * This cluster will be used either for new bucket or for
 		 * new xattr block.
 		 * If the cluster size is the same as the bucket size, one
_

Patches currently in -mm which might be from icb@fastmail.org are

ocfs2-fix-missing-metadata-reservation-for-large-xattrs.patch

