Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1092033987
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810128; cv=none; b=UOL/iRGFamp6zqwlu8n8Fa3sG7URhXdyOeP5RYcoN4s2+8ocfBaHgg68S7svq8Z95XbZWkHNvMccGUiLLz1UKjoraLP6FR0rv+JdrnWFtGgKzBdio3oQ9Vl++KqL5YM8rjqvxr3jXma7HtGSPSoeGJ0eVarniWPBgbH5dbL55DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810128; c=relaxed/simple;
	bh=t3IBqtHoZL5WukJ2qiT//rvHYuGjpCuQaN7UzjWVe/U=;
	h=Date:To:From:Subject:Message-Id; b=aYUwT/ZhfocFKtNZO88m8upUvlz1twuz1nUDThVxFM+qNGKHeAqPCmpDErVjg/8hVwWocUZ0nDHNtli9gEMtURhyETKql9nIsE/q4MlhXTL5NeR7QYKBV+CKRk+SexWNHuKjQz/tsz2yPepH2EiJyh032AoGTMzqS47c3BpN5/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fc6qwgRd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fc6qwgRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB538C4CEEB;
	Sun, 14 Sep 2025 00:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810127;
	bh=t3IBqtHoZL5WukJ2qiT//rvHYuGjpCuQaN7UzjWVe/U=;
	h=Date:To:From:Subject:From;
	b=Fc6qwgRdVJ6YHk9yRgPJUDYlCJqwAlZYbvDM98jWwjXqlj98iTHl+YUwDBjnC97Qj
	 DTQC2Md8k7i2DAtH3Q0L1wfHmR3qcWGtETbH9k2ZgpTxQOoFAABFWzbwos7d3a1zDr
	 vZ/Qd6B9hfm93KZ2ZHsV6dwUAZLu5PyeB7J/qTYw=
Date: Sat, 13 Sep 2025 17:35:27 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,yili@winhong.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-super-block-reserved-field-offset-comment.patch removed from -mm tree
Message-Id: <20250914003527.DB538C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix super block reserved field offset comment
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-super-block-reserved-field-offset-comment.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: yili <yili@winhong.com>
Subject: ocfs2: fix super block reserved field offset comment
Date: Thu, 7 Aug 2025 23:57:49 +0800

The offset annotation for s_reserved2 in struct ocfs2_super_block
was incorrect. After the preceding fields:
- s_xattr_inline_size (2 bytes at 0xB8)
- s_reserved0 (2 bytes at 0xBA)
- s_dx_seed[3] (12 bytes at 0xBC)

The actual offset of s_reserved2 is at 0xC8, when calculating from the
start of the structure.

Correct the offset comment from C0 to C8 to reflect the proper location in
the super block structure.

Link: https://lkml.kernel.org/r/20250807155749.164481-1-yili@winhong.com
Signed-off-by: yili <yili@winhong.com>
Reviewed-by: Joel Becker <jlbec@evilplan.org>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/ocfs2_fs.h~ocfs2-fix-super-block-reserved-field-offset-comment
+++ a/fs/ocfs2/ocfs2_fs.h
@@ -614,7 +614,7 @@ struct ocfs2_super_block {
 	__le16 s_reserved0;
 	__le32 s_dx_seed[3];		/* seed[0-2] for dx dir hash.
 					 * s_uuid_hash serves as seed[3]. */
-/*C0*/  __le64 s_reserved2[15];		/* Fill out superblock */
+/*C8*/  __le64 s_reserved2[15];		/* Fill out superblock */
 /*140*/
 
 	/*
_

Patches currently in -mm which might be from yili@winhong.com are


