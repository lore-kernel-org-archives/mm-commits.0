Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E578E182C3;
	Thu,  6 Jun 2024 02:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717640421; cv=none; b=YuUFDZd30R0Er4g3KQW9bm27Aa+Ej+CuQ2Lgxz6XtoJt2KfyzFRfwHagUgSGzuaZrHzhKJzNWb/q2yDCC7g4alE/5ZwicoVse45t2oeGkeAQ59JQKU/F7w0iEU5RfbDKmSmy/7zSDADmjAvrQ3jwbKKIZ2GWRU+Ce12V1ueiVJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717640421; c=relaxed/simple;
	bh=xPN9nICOBh+AaxV6AiRJyMy2Acs8CtrQWo96wUErMuo=;
	h=Date:To:From:Subject:Message-Id; b=hZSWy3+gaWY5Fpf0AnDYl4wsHYDweGL2PjMWbZ4ZdqwWYetT6FECcJ+BW19U5EWYQUMBeZnovRAhZs2g7cXngUx672HiTGbx/LOgtGE2hZa3P+3JvneJPhb+6MX2tnxNyEhGspNHVzaeuDp7ZVn08Thj1YVFGPzQ3R944Pctrz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i9Po4IuZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i9Po4IuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95C1C4AF1D;
	Thu,  6 Jun 2024 02:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717640420;
	bh=xPN9nICOBh+AaxV6AiRJyMy2Acs8CtrQWo96wUErMuo=;
	h=Date:To:From:Subject:From;
	b=i9Po4IuZcgrkw6Uwf6uVD61sjtq6oj91SaGg7nPioi6OuNRFrxdTQvZyWeUn99C5g
	 nEmIVoK5sMLhBSVYprg4TnodXpVNbNeucvWa4X6HW6OGl9AwAovicCVOq0ETW1vRjX
	 fJmycWEmCylSxnfRNT2soQG4L07+cl4N+qAJyJVc=
Date: Wed, 05 Jun 2024 19:20:20 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-nilfs_empty_dir-misjudgment-and-long-loop-on-i-o-errors.patch removed from -mm tree
Message-Id: <20240606022020.B95C1C4AF1D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: fix nilfs_empty_dir() misjudgment and long loop on I/O errors
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-nilfs_empty_dir-misjudgment-and-long-loop-on-i-o-errors.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix nilfs_empty_dir() misjudgment and long loop on I/O errors
Date: Tue, 4 Jun 2024 22:42:55 +0900

The error handling in nilfs_empty_dir() when a directory folio/page read
fails is incorrect, as in the old ext2 implementation, and if the
folio/page cannot be read or nilfs_check_folio() fails, it will falsely
determine the directory as empty and corrupt the file system.

In addition, since nilfs_empty_dir() does not immediately return on a
failed folio/page read, but continues to loop, this can cause a long loop
with I/O if i_size of the directory's inode is also corrupted, causing the
log writer thread to wait and hang, as reported by syzbot.

Fix these issues by making nilfs_empty_dir() immediately return a false
value (0) if it fails to get a directory folio/page.

Link: https://lkml.kernel.org/r/20240604134255.7165-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+c8166c541d3971bf6c87@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c8166c541d3971bf6c87
Fixes: 2ba466d74ed7 ("nilfs2: directory entry operations")
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nilfs2/dir.c~nilfs2-fix-nilfs_empty_dir-misjudgment-and-long-loop-on-i-o-errors
+++ a/fs/nilfs2/dir.c
@@ -607,7 +607,7 @@ int nilfs_empty_dir(struct inode *inode)
 
 		kaddr = nilfs_get_folio(inode, i, &folio);
 		if (IS_ERR(kaddr))
-			continue;
+			return 0;
 
 		de = (struct nilfs_dir_entry *)kaddr;
 		kaddr += nilfs_last_byte(inode, i) - NILFS_DIR_REC_LEN(1);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


