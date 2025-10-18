Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641281388;
	Sat, 18 Oct 2025 00:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760746662; cv=none; b=W6hrHvjD1rFt0nzwcc7lh+X3+F7QJujrDqsbQ0W9NVu+cjfQaUm6uWRKbHKOUuqmAhkUYZ4ZBAOyJt6bHyLbHC04frt3IqbyRAFhT4zxBAMZ/Q1VJ4jnqqizaMNmc2QTPpNr/4O+/EIBiu1Gp2tq4asqHNQHwaMWq4uN8tUYh1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760746662; c=relaxed/simple;
	bh=nPxvzU1bJ9PWc+udBBoaTFAOhwRan2qgTw6VjJM0v+E=;
	h=Date:To:From:Subject:Message-Id; b=uFEcKgl+KGA9MrbvlBURT+UVJrFf/CYV8aV8KseF3a+4kYmSC1IXCzJMTwNALlYxlaIXnNrjz5X/gqg+M6V8z9HfpUzUhP119TmhLymRWLp6h51sTajw+yTnS1gWd1c293wGeaD5Jm5DcNAnfTmakZp/xvJ0xGnjnZ5I/9zken8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RXFBwlm+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RXFBwlm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CBBC4CEF9;
	Sat, 18 Oct 2025 00:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760746662;
	bh=nPxvzU1bJ9PWc+udBBoaTFAOhwRan2qgTw6VjJM0v+E=;
	h=Date:To:From:Subject:From;
	b=RXFBwlm+S5yiXASd5gMShXwo+zmcO1NImKG3fr40loHq5l8GV/bYHTM1imJqglhgr
	 9SvmBozMek1OqvtUyjUIzRwOrQ4g9hKUDeOhUVxGvepoJyWWC56e1kGGETtX8zfuNF
	 b5tshSYIYGzGq0dL2YAz/hAfLVmGUiMJeXaRsKDE=
Date: Fri, 17 Oct 2025 17:17:41 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] ocfs2-add-chain-list-sanity-check-to-ocfs2_block_group_alloc.patch removed from -mm tree
Message-Id: <20251018001742.12CBBC4CEF9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: add chain list sanity check to ocfs2_block_group_alloc()
has been removed from the -mm tree.  Its filename was
     ocfs2-add-chain-list-sanity-check-to-ocfs2_block_group_alloc.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: add chain list sanity check to ocfs2_block_group_alloc()
Date: Thu, 16 Oct 2025 11:46:53 +0300

Fix a UBSAN error:

UBSAN: array-index-out-of-bounds in fs/ocfs2/suballoc.c:380:22
index 0 is out of range for type 'struct ocfs2_chain_rec[] __counted_by(cl_count)' (aka 'struct ocfs2_chain_rec[]')

In 'ocfs2_block_group_alloc()', add an extra check whether the maximum
amount of chain records in 'struct ocfs2_chain_list' matches the value
calculated based on the filesystem block size.

Link: https://lkml.kernel.org/r/20251016084653.59686-1-dmantipov@yandex.ru
Reported-by: syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=77026564530dbc29b854
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/ocfs2/suballoc.c~ocfs2-add-chain-list-sanity-check-to-ocfs2_block_group_alloc
+++ a/fs/ocfs2/suballoc.c
@@ -671,6 +671,11 @@ static int ocfs2_block_group_alloc(struc
 	BUG_ON(ocfs2_is_cluster_bitmap(alloc_inode));
 
 	cl = &fe->id2.i_chain;
+	if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(osb->sb)) {
+		status = -EINVAL;
+		goto bail;
+	}
+
 	status = ocfs2_reserve_clusters_with_limit(osb,
 						   le16_to_cpu(cl->cl_cpg),
 						   max_block, flags, &ac);
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

ocfs2-add-extra-flags-check-in-ocfs2_ioctl_move_extents.patch
ocfs2-relax-bug-to-ocfs2_error-in-__ocfs2_move_extent.patch
ocfs2-annotate-flexible-array-members-with-__counted_by_le.patch
ocfs2-annotate-flexible-array-members-with-__counted_by_le-fix.patch
ocfs2-add-extra-consistency-check-to-ocfs2_dx_dir_lookup_rec.patch
ocfs2-add-directory-size-check-to-ocfs2_find_dir_space_id.patch

