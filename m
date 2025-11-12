Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9466F14B96E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908563; cv=none; b=KwvR0z+9f25ocp0vn5A7/EML34jIMAK+tfbZSU0dUQdP5ewyL7Yh7mlshBonIcBFD33Zwdx+BpffG8CJEqWjODudmyE4W/Y439MpOsszlnoedzMhH5CRcOOaNPIf8/i/1/ZzmHMBNVp6+lD6QPflua/ShSdC0eMKZll3RrNI2LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908563; c=relaxed/simple;
	bh=A+SjlkllvCl/RfqsOAKrbCiBYdwg7B2DD5+xqmoZnZA=;
	h=Date:To:From:Subject:Message-Id; b=Gpj+nUK/Guat/Q27T65DLUPq+QID2cOeq5LjDUnsCGcY+j3RnMgKLr65cuMnO/zHQkrIMZfdr9gi0wprjA05oeepVKd9lFWVUqUBdgEyBXWXCW5XLhXmou4gcnzeHlfLTo51pxlHD+Tfdof55LRDeootaAsXrGudmssa1jtiphg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZlrFpHzp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZlrFpHzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E9DC4CEFB;
	Wed, 12 Nov 2025 00:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908563;
	bh=A+SjlkllvCl/RfqsOAKrbCiBYdwg7B2DD5+xqmoZnZA=;
	h=Date:To:From:Subject:From;
	b=ZlrFpHzpW7zN2nDrXDQirXbHbbYBPzgJOc9vUmGhMXph6TSXusF4gQ9otO+ZCarwh
	 MjuURR+tdJEakHx5Oo5bztS/l2KM7ll52IA6MUCSimKbqiK/KmiGJI70hK7LYF90mn
	 +AKrH2ca/0dvE+NSiSn8ogP81wBghLySNXrH0fL4=
Date: Tue, 11 Nov 2025 16:49:22 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-relax-bug-to-ocfs2_error-in-__ocfs2_move_extent.patch removed from -mm tree
Message-Id: <20251112004923.66E9DC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: relax BUG() to ocfs2_error() in __ocfs2_move_extent()
has been removed from the -mm tree.  Its filename was
     ocfs2-relax-bug-to-ocfs2_error-in-__ocfs2_move_extent.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: relax BUG() to ocfs2_error() in __ocfs2_move_extent()
Date: Thu, 9 Oct 2025 13:23:49 +0300

In '__ocfs2_move_extent()', relax 'BUG()' to 'ocfs2_error()' just
to avoid crashing the whole kernel due to a filesystem corruption.

Fixes: 8f603e567aa7 ("Ocfs2/move_extents: move a range of extent.")
Link: https://lkml.kernel.org/r/20251009102349.181126-2-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>Closes: https://syzkaller.appspot.com/bug?extid=727d161855d11d81e411
Reported-by: syzbot+727d161855d11d81e411@syzkaller.appspotmail.com
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/move_extents.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/move_extents.c~ocfs2-relax-bug-to-ocfs2_error-in-__ocfs2_move_extent
+++ a/fs/ocfs2/move_extents.c
@@ -98,7 +98,13 @@ static int __ocfs2_move_extent(handle_t
 
 	rec = &el->l_recs[index];
 
-	BUG_ON(ext_flags != rec->e_flags);
+	if (ext_flags != rec->e_flags) {
+		ret = ocfs2_error(inode->i_sb,
+				  "Inode %llu has corrupted extent %d with flags 0x%x at cpos %u\n",
+				  (unsigned long long)ino, index, rec->e_flags, cpos);
+		goto out;
+	}
+
 	/*
 	 * after moving/defraging to new location, the extent is not going
 	 * to be refcounted anymore.
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

ocfs2-add-extra-consistency-checks-for-chain-allocator-dinodes.patch

