Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C7DFBF6;
	Thu,  4 Jul 2024 05:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720071734; cv=none; b=iEH7pTkmD4D6i4nolLNAxbISiod6FVaxFF61cpPVGoXMrhbzYq1KR4rYZeg5JWYpfJrI5yhRaO6TnoGHMTtJfFZeCvBkMTM59T5WW/g0VwkBlwRm21REcWACkBYmDBUWMr9QL25e3cWQZQ8PQ6dGe0YuqHqGb1SGg/FSIoljsnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720071734; c=relaxed/simple;
	bh=7kjEx0DKcnNhUxxFPLN32w4htzHLUMZTSaHSSI1m6U8=;
	h=Date:To:From:Subject:Message-Id; b=rJo9MGQIuWzL9WVkftSmbQA3Q8U6ZghPxc49N1EdeDruulJQir0kT9JL7I3R8UTpQMA63nsXP5RwXXP69vD2xoXSKVr/trw5XC+v/4xy2eAiOY3i47/ZIR2MiXg3GdwlmyP5z/hVT7cBpTI72Z7WkHASKlWSaeueWpPjntZj1aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1bgJEYSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1bgJEYSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F13AC3277B;
	Thu,  4 Jul 2024 05:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720071734;
	bh=7kjEx0DKcnNhUxxFPLN32w4htzHLUMZTSaHSSI1m6U8=;
	h=Date:To:From:Subject:From;
	b=1bgJEYSQPYVU1MSBmC6lHMReE0dixRar51LJwonRzpaUm3IYQ4AYGvbeHL2zjYh3x
	 rbvJkUUW/2P1bXwU3otyfyGUUEm1IgMv0OrOl4VBhBKOGCD/xqr/NffJ/N/KMABqI4
	 ItLZJUIRm2WLgRc/pTLMfBnYWncmZwWecSsv3IpQ=
Date: Wed, 03 Jul 2024 22:42:14 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-kernel-bug-on-rename-operation-of-broken-directory.patch removed from -mm tree
Message-Id: <20240704054214.8F13AC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: fix kernel bug on rename operation of broken directory
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-kernel-bug-on-rename-operation-of-broken-directory.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

nilfs2-avoid-undefined-behavior-in-nilfs_cnt32_ge-macro.patch

