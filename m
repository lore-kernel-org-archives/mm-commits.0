Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BEA4B5CD;
	Fri, 28 Jun 2024 18:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719598262; cv=none; b=Joiqb2iB7aVTw6yYpmJcEGSKGSlgkuMHZ8GPUZ9fqZ+HPSvAzOPUqXAN7mcKGyXZgG2K06GcYagKXpMqFDHMWhGcUKsAwrCVGZT8L8dGTxGpSn+5k497Osxq0wKowr/liAUiQi7TC++2L+kfaLbkQGHUkEqvI+YJQmduir2aNHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719598262; c=relaxed/simple;
	bh=AnGDBPZueGU6jsk1sE8rTkWcwZ8SYFORW43srEW6Zgg=;
	h=Date:To:From:Subject:Message-Id; b=pzFSW9HrGjYJuSW+vR76wzFjbew8dQRXDtgIV//PPusxhZKcKU8wXXe3XfWtDxo/pldq9CO1kSQQBb+gR1eVLCyxauMBGXwHZkWS9LtmNSLTIe1YD39DzVqQtdy66PGJkD5PljykGpYX6v0NVv2Dhrv0yUOFviXHLPN6YloiGAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TKZFXSHK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TKZFXSHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BE7C116B1;
	Fri, 28 Jun 2024 18:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719598261;
	bh=AnGDBPZueGU6jsk1sE8rTkWcwZ8SYFORW43srEW6Zgg=;
	h=Date:To:From:Subject:From;
	b=TKZFXSHKYzlHZHxN9Yd0jffmW3fyK1Qs3cUS8HYlJuY8AAh7ETMKFbwvZXEWI8+/X
	 TcuwTRgu3PQ/e69y2r2JdEqdwwr8G1lgbAgE/kbBoaHfF5U5/ogq9n4yQW/UcC5aq6
	 i8Z/5jhqr4NqyDHZ2q3hKPJ8i0um+wfHRfa0Mk7U=
Date: Fri, 28 Jun 2024 11:11:00 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-kernel-bug-on-rename-operation-of-broken-directory.patch added to mm-hotfixes-unstable branch
Message-Id: <20240628181101.81BE7C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix kernel bug on rename operation of broken directory
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-kernel-bug-on-rename-operation-of-broken-directory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-kernel-bug-on-rename-operation-of-broken-directory.patch

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
Subject: nilfs2: fix kernel bug on rename operation of broken directory
Date: Sat, 29 Jun 2024 01:51:07 +0900

Syzbot reported that in rename directory operation on broken directory on
nilfs2, __block_write_begin_int() called to prepare block write may fail
BUG_ON check for access exceeding the folio/page size.

This is because nilfs_dotdot(), which gets parent directory reference
entry ("..") of the directory to be moved or renamed, does not check
consistency enough, and may return location exceeding folio/page size for
broken directories.

Fix this issue by checking required directory entries ("." and "..") in
the first chunk of the directory in nilfs_dotdot().

Link: https://lkml.kernel.org/r/20240628165107.9006-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+d3abed1ad3d367fa2627@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d3abed1ad3d367fa2627
Fixes: 2ba466d74ed7 ("nilfs2: directory entry operations")
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/dir.c~nilfs2-fix-kernel-bug-on-rename-operation-of-broken-directory
+++ a/fs/nilfs2/dir.c
@@ -383,11 +383,39 @@ found:
 
 struct nilfs_dir_entry *nilfs_dotdot(struct inode *dir, struct folio **foliop)
 {
-	struct nilfs_dir_entry *de = nilfs_get_folio(dir, 0, foliop);
+	struct folio *folio;
+	struct nilfs_dir_entry *de, *next_de;
+	size_t limit;
+	char *msg;
 
+	de = nilfs_get_folio(dir, 0, &folio);
 	if (IS_ERR(de))
 		return NULL;
-	return nilfs_next_entry(de);
+
+	limit = nilfs_last_byte(dir, 0);  /* is a multiple of chunk size */
+	if (unlikely(!limit || le64_to_cpu(de->inode) != dir->i_ino ||
+		     !nilfs_match(1, ".", de))) {
+		msg = "missing '.'";
+		goto fail;
+	}
+
+	next_de = nilfs_next_entry(de);
+	/*
+	 * If "next_de" has not reached the end of the chunk, there is
+	 * at least one more record.  Check whether it matches "..".
+	 */
+	if (unlikely((char *)next_de == (char *)de + nilfs_chunk_size(dir) ||
+		     !nilfs_match(2, "..", next_de))) {
+		msg = "missing '..'";
+		goto fail;
+	}
+	*foliop = folio;
+	return next_de;
+
+fail:
+	nilfs_error(dir->i_sb, "directory #%lu %s", dir->i_ino, msg);
+	folio_release_kmap(folio, de);
+	return NULL;
 }
 
 ino_t nilfs_inode_by_name(struct inode *dir, const struct qstr *qstr)
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-kernel-bug-on-rename-operation-of-broken-directory.patch

