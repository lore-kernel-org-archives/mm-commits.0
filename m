Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10E6274659
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967312; cv=none; b=un1MFz8R8/Z4bhwOYwIzKoj365LPsrxMVC+h4T349CIam0iuIrz4mRxMTJ3Ss51ispesH0dkim3PTeSVZKdb31gJx6bhvvFra0jrwDNIZIFQHyV/WF2F6fKcXQ/ySpqPO2gr2ewIJ8IPWtZ89h6Qh89E5InRlXOHt5pD8Y/HYfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967312; c=relaxed/simple;
	bh=3CnbRkZK+xwFv/a9v6DDXFJI+xxcsOcELfsmIFVoFi8=;
	h=Date:To:From:Subject:Message-Id; b=B3gIZu7+suorhdX09gqXBylsxZyCteIxGr8JCoRTACs3kxOEl8kRsDIu2nJLOULKmsGhDkjhnzjTCQdf4Mkba1zGBDeWfoJ/+/mNj8jushqHFCXIVcPT4BmjMAVhdmIGR1BtXsW6xlQHQ98kB5dDnBRXXqUjKlKmS5Gn8lXaibo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SSzISgQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SSzISgQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24F6C16AAE;
	Wed, 21 Jan 2026 03:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967311;
	bh=3CnbRkZK+xwFv/a9v6DDXFJI+xxcsOcELfsmIFVoFi8=;
	h=Date:To:From:Subject:From;
	b=SSzISgQ11Pt9G5n2SrghBkULIQBcbjOLl5J4/MfzXquUpHVoSpKYMigNFTgnZ18jN
	 7r4KzTJB0j5/7sFEK/zOuE+sFugLA5e6wRug/LfwnCefAXyN8PYBFfV/cA7RM0OjUN
	 ofc3SCeO9wfmNMMtxJOJRZSsmK+bxc35z3cDaqgw=
Date: Tue, 20 Jan 2026 19:48:30 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-validate-inline-data-i_size-during-inode-read.patch removed from -mm tree
Message-Id: <20260121034830.E24F6C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: validate inline data i_size during inode read
has been removed from the -mm tree.  Its filename was
     ocfs2-validate-inline-data-i_size-during-inode-read.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: ocfs2: validate inline data i_size during inode read
Date: Fri, 12 Dec 2025 10:51:32 +0530

When reading an inode from disk, ocfs2_validate_inode_block() performs
various sanity checks but does not validate the size of inline data.  If
the filesystem is corrupted, an inode's i_size can exceed the actual
inline data capacity (id_count).

This causes ocfs2_dir_foreach_blk_id() to iterate beyond the inline data
buffer, triggering a use-after-free when accessing directory entries from
freed memory.

In the syzbot report:
  - i_size was 1099511627576 bytes (~1TB)
  - Actual inline data capacity (id_count) is typically <256 bytes
  - A garbage rec_len (54648) caused ctx->pos to jump out of bounds
  - This triggered a UAF in ocfs2_check_dir_entry()

Fix by adding a validation check in ocfs2_validate_inode_block() to ensure
inodes with inline data have i_size <= id_count.  This catches the
corruption early during inode read and prevents all downstream code from
operating on invalid data.

Link: https://lkml.kernel.org/r/20251212052132.16750-1-kartikey406@gmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+c897823f699449cc3eb4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c897823f699449cc3eb4
Tested-by: syzbot+c897823f699449cc3eb4@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/20251211115231.3560028-1-kartikey406@gmail.com/T/ [v1]
Link: https://lore.kernel.org/all/20251212040400.6377-1-kartikey406@gmail.com/T/ [v2]
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-validate-inline-data-i_size-during-inode-read
+++ a/fs/ocfs2/inode.c
@@ -1494,12 +1494,25 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
-	if ((le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) &&
-	    le32_to_cpu(di->i_clusters)) {
-		rc = ocfs2_error(sb, "Invalid dinode %llu: %u clusters\n",
-				 (unsigned long long)bh->b_blocknr,
-				 le32_to_cpu(di->i_clusters));
-		goto bail;
+	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
+		struct ocfs2_inline_data *data = &di->id2.i_data;
+
+		if (le32_to_cpu(di->i_clusters)) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode %llu: %u clusters\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le32_to_cpu(di->i_clusters));
+			goto bail;
+		}
+
+		if (le64_to_cpu(di->i_size) > le16_to_cpu(data->id_count)) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode #%llu: inline data i_size %llu exceeds id_count %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 (unsigned long long)le64_to_cpu(di->i_size),
+					 le16_to_cpu(data->id_count));
+			goto bail;
+		}
 	}
 
 	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
_

Patches currently in -mm which might be from kartikey406@gmail.com are

mm-swap_cgroup-fix-kernel-bug-in-swap_cgroup_record.patch
mm-vmalloc-prevent-rcu-stalls-in-kasan_release_vmalloc_node.patch

