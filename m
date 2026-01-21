Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5748330B04
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967312; cv=none; b=fMnJtF10K3kOmTdkS+GRMsvHe2w/uVk03rr24mT3xAhg3dST/jm9uDq3wp6pOrxiOVCIuusoJ8coUdu5RQjE4zJKMv5346c6ZTXK48jaS9qnZGMZZN/+wHBoHMfkV/kfNYDfS+Rr/YrEUgLQUoxkD84qdySPd0Og3usmrTTBAjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967312; c=relaxed/simple;
	bh=Q6moqageiaJFxuG3QPdsNFC0OIYyIiR7dO6GkkHeQbw=;
	h=Date:To:From:Subject:Message-Id; b=Ee7VOeukkTn2rpKf4iUGw8cbERx2GpkqY3VtF4+whLqx4p7thz58WC5hiQJVTNO0Y8qadWINyU1A1pdf6Hm64HSJvFOO3HhcNek5hJKbJILJfywwqgwsLHZQeK1GVcTadU7aFcnAPKxkb/7ZYP2pvhlCDbssDnD3K5DzbI9i62k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vSzMf/ca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vSzMf/ca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E04AC16AAE;
	Wed, 21 Jan 2026 03:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967312;
	bh=Q6moqageiaJFxuG3QPdsNFC0OIYyIiR7dO6GkkHeQbw=;
	h=Date:To:From:Subject:From;
	b=vSzMf/cauiHpXqUIOu6pZ15gRZBzyFwKwmoTVh0KGmMcCdqpv3d4Jv5O3zSvekWWT
	 CdIIonpvjVOax3P+CtOWM4NOWmFZffquxiWHQ70GnvvV1y6Fx4rObyKqA8UYdhRdET
	 QgzAsMtK8sVIEKZK/91xCSWnUDtZXFBz8YHoqqhQ=
Date: Tue, 20 Jan 2026 19:48:31 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,kartikey406@gmail.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jiangqi903@gmail.com,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-adjust-ocfs2_xa_remove_entry-to-match-ubsan-boundary-checks.patch removed from -mm tree
Message-Id: <20260121034832.2E04AC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: adjust ocfs2_xa_remove_entry() to match UBSAN boundary checks
has been removed from the -mm tree.  Its filename was
     ocfs2-adjust-ocfs2_xa_remove_entry-to-match-ubsan-boundary-checks.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: adjust ocfs2_xa_remove_entry() to match UBSAN boundary checks
Date: Thu, 11 Dec 2025 18:59:49 +0300

After introducing 2f26f58df041 ("ocfs2: annotate flexible array members
with __counted_by_le()"), syzbot has reported the following issue:

UBSAN: array-index-out-of-bounds in fs/ocfs2/xattr.c:1955:3
index 2 is out of range for type 'struct ocfs2_xattr_entry[]
__counted_by(xh_count)' (aka 'struct ocfs2_xattr_entry[]')
...
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x40 lib/ubsan.c:233
 __ubsan_handle_out_of_bounds+0xe9/0xf0 lib/ubsan.c:455
 ocfs2_xa_remove_entry+0x36d/0x3e0 fs/ocfs2/xattr.c:1955
 ...

To address this issue, 'xh_entries[]' member removal should be performed
before actually changing 'xh_count', thus making sure that all array
accesses matches the boundary checks performed by UBSAN.

Link: https://lkml.kernel.org/r/20251211155949.774485-1-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: syzbot+cf96bc82a588a27346a8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cf96bc82a588a27346a8
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-adjust-ocfs2_xa_remove_entry-to-match-ubsan-boundary-checks
+++ a/fs/ocfs2/xattr.c
@@ -1971,8 +1971,7 @@ static void ocfs2_xa_remove_entry(struct
 	ocfs2_xa_wipe_namevalue(loc);
 	loc->xl_entry = NULL;
 
-	le16_add_cpu(&xh->xh_count, -1);
-	count = le16_to_cpu(xh->xh_count);
+	count = le16_to_cpu(xh->xh_count) - 1;
 
 	/*
 	 * Only zero out the entry if there are more remaining.  This is
@@ -1987,6 +1986,8 @@ static void ocfs2_xa_remove_entry(struct
 		memset(&xh->xh_entries[count], 0,
 		       sizeof(struct ocfs2_xattr_entry));
 	}
+
+	xh->xh_count = cpu_to_le16(count);
 }
 
 /*
_

Patches currently in -mm which might be from dmantipov@yandex.ru are


