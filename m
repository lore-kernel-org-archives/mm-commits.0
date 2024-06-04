Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595D9146599;
	Tue,  4 Jun 2024 22:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717540610; cv=none; b=SrRZ+PCiD8I2P47g6ZcNMRyI6E4XXFfjDm1c4GrgV2Dp5TIrtVgkKv10WP0pEYt2DWWsx/wU+HNMiptKmuwg+lFHeBzEsn6NFX2Xm+pcLSPwexS1WKKmd9RndmVkQ9JvOuHT2Bi9OD+GdQxBdWr6HzjiWSXKVrvIFnFMi5HW8RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717540610; c=relaxed/simple;
	bh=kzpEXYvhFIGPJbW/6LW5yXMfSCpqjyC3cWtuTr3fGts=;
	h=Date:To:From:Subject:Message-Id; b=mGL+ABnIW0XCfIcP4m1SfFeNSddDZKbwXIQ40mpAlEia89DC2yUUTAeKFYzQ6DB1fhA/Wcktono+coL9vgvxthdlwE2RjdVqjsGd1rmaiGWK7Qlerv7Ikow59xLdazYQwv5lm5dCIkZQyjC3jJySqlXU9umS6mfAEtv3TADe450=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G36raR43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G36raR43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65E9C2BBFC;
	Tue,  4 Jun 2024 22:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717540609;
	bh=kzpEXYvhFIGPJbW/6LW5yXMfSCpqjyC3cWtuTr3fGts=;
	h=Date:To:From:Subject:From;
	b=G36raR43vQyEqtGr7jYiCNEZQlv0JwIuOZEaDZ4OOFSCgan0yScE/Z8OezcHEoRh5
	 0o5a9gB0A3/MEBuRdu1i5sqKtb0bSufuMCPNQtZDTkB9W/ndAHHRxgqhDd3AvNRhsV
	 fNDY2kLuxoYED5vhKC9E5szGKB/NC0Ibd94/6sU0=
Date: Tue, 04 Jun 2024 15:36:49 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-nilfs_empty_dir-misjudgment-and-long-loop-on-i-o-errors.patch added to mm-hotfixes-unstable branch
Message-Id: <20240604223649.B65E9C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix nilfs_empty_dir() misjudgment and long loop on I/O errors
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-nilfs_empty_dir-misjudgment-and-long-loop-on-i-o-errors.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-nilfs_empty_dir-misjudgment-and-long-loop-on-i-o-errors.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

nilfs2-fix-potential-kernel-bug-due-to-lack-of-writeback-flag-waiting.patch
nilfs2-fix-nilfs_empty_dir-misjudgment-and-long-loop-on-i-o-errors.patch

