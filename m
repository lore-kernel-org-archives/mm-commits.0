Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6A83043DE
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 19:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308801; cv=none; b=tgT2IsnQKLRCeKQZcFu+ShvBplrWzGV1Bq3bxMVv8LlAsqBJpR5ZfGBabeX7qsA5HcmGzp8lG8gzyn9Pz5oKrzguH4JTzquoY4d8wyUDQkxhihnFCRyyCv31abJRmeODt0Ngu+qhfCtsJJoIpBjDvTbtxtKyFKGj4OOAtcZ/peY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308801; c=relaxed/simple;
	bh=focqmDTQphdyWh7XDI3PqI5VlM7kePMNJxs3z9vYTE4=;
	h=Date:To:From:Subject:Message-Id; b=ZxclxCHTpPxMnzLt0H0PdLXI8xIjDzVAeHp3mYL2ooTvGQdV5MwZUmX7KaAWjrhu16OdrnS6fi2FUdoH8HKGWKPzWra+xMphH3HbhUy8NYSWaPcIuMyeG+hSRh4AMsr65nVakpc3u/1lqsgzzrfY7Wgjw9Q9kWbCmT437FlrcY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CWGrUSop; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CWGrUSop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01808C4CEF5;
	Tue,  9 Dec 2025 19:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308801;
	bh=focqmDTQphdyWh7XDI3PqI5VlM7kePMNJxs3z9vYTE4=;
	h=Date:To:From:Subject:From;
	b=CWGrUSop8QGYJvCwMvPNlbvRJ7x+shk/Z9h4jtNWFDhiNGJfVy6hgQgwl5ze2hazE
	 1U1hlNC5t+lTxg+BlXyihUll2+QJ235caUsEa9d0UfNPSI/QDO8dMzjk15REgSbOpA
	 8kzgUuZJmgJYlfYVR46fjjql6nKCayKAm/TS8a38=
Date: Tue, 09 Dec 2025 11:33:20 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-validate-inline-xattr-size-and-entry-count-in-ocfs2_xattr_ibody_list.patch removed from -mm tree
Message-Id: <20251209193321.01808C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: validate inline xattr size and entry count in ocfs2_xattr_ibody_list
has been removed from the -mm tree.  Its filename was
     ocfs2-validate-inline-xattr-size-and-entry-count-in-ocfs2_xattr_ibody_list.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: ocfs2: validate inline xattr size and entry count in ocfs2_xattr_ibody_list
Date: Thu, 20 Nov 2025 09:41:45 +0530

Add comprehensive validation of inline xattr metadata in
ocfs2_xattr_ibody_list() to prevent out-of-bounds access and
use-after-free bugs when processing corrupted inline xattrs.

The patch adds two critical validations:

1. Validates i_xattr_inline_size before use:
   - Ensures it does not exceed block size
   - Ensures it is at least large enough for xattr header
   - Prevents pointer arithmetic with corrupted size values that could
     point outside the inode block

2. Validates xattr entry count (xh_count):
   - Calculates maximum entries that can fit in the inline space
   - Rejects counts that exceed this limit
   - Prevents out-of-bounds array access in subsequent code

Without these checks, a corrupted filesystem with invalid inline xattr
metadata can cause the code to access memory beyond the allocated space.
For example:
- A corrupted i_xattr_inline_size of 0 would cause header pointer
  calculation to point past the end of the block
- A corrupted xh_count of 22 with inline_size of 256 would cause
  array access 7 entries beyond the 15 that actually fit (the syzbot
  reproducer used xh_count of 20041), leading to use-after-free when
  accessing freed memory pages

The validation uses the correct inline_size (from di->i_xattr_inline_size)
rather than block size, ensuring accurate bounds checking for inline
xattrs specifically.

Link: https://lkml.kernel.org/r/20251120041145.33176-1-kartikey406@gmail.com
Link: https://lore.kernel.org/all/20251111073831.2027072-1-kartikey406@gmail.com/ [v1]
Link: https://lore.kernel.org/all/20251117063217.5690-1-kartikey406@gmail.com/ [v2]
Link: https://lore.kernel.org/all/20251117114224.12948-1-kartikey406@gmail.com/ [v3]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ab0ad25088673470d2d9
Tested-by: syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
Suggested-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |   30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-validate-inline-xattr-size-and-entry-count-in-ocfs2_xattr_ibody_list
+++ a/fs/ocfs2/xattr.c
@@ -971,13 +971,39 @@ static int ocfs2_xattr_ibody_list(struct
 	struct ocfs2_xattr_header *header = NULL;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	int ret = 0;
+	u16 xattr_count;
+	size_t max_entries;
+	u16 inline_size;
 
 	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL))
 		return ret;
 
+	inline_size = le16_to_cpu(di->i_xattr_inline_size);
+
+	/* Validate inline size is reasonable */
+	if (inline_size > inode->i_sb->s_blocksize ||
+	    inline_size < sizeof(struct ocfs2_xattr_header)) {
+		ocfs2_error(inode->i_sb,
+			    "Invalid xattr inline size %u in inode %llu\n",
+			    inline_size,
+			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
+		return -EFSCORRUPTED;
+	}
+
 	header = (struct ocfs2_xattr_header *)
-		 ((void *)di + inode->i_sb->s_blocksize -
-		 le16_to_cpu(di->i_xattr_inline_size));
+		 ((void *)di + inode->i_sb->s_blocksize - inline_size);
+
+	xattr_count = le16_to_cpu(header->xh_count);
+	max_entries = (inline_size - sizeof(struct ocfs2_xattr_header)) /
+		       sizeof(struct ocfs2_xattr_entry);
+
+	if (xattr_count > max_entries) {
+		ocfs2_error(inode->i_sb,
+			    "xattr entry count %u exceeds maximum %zu in inode %llu\n",
+			    xattr_count, max_entries,
+			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
+		return -EFSCORRUPTED;
+	}
 
 	ret = ocfs2_xattr_list_entries(inode, header, buffer, buffer_size);
 
_

Patches currently in -mm which might be from kartikey406@gmail.com are


