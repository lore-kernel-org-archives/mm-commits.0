Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDBC219EA;
	Mon, 15 Apr 2024 19:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713208123; cv=none; b=gYWsHFAKtYtLfRFscEVDc38TysVI7Tm3yXJcWGgUbUZeXxEAztLUDZcOMkVkCjkOhiDa9U5WxsRN2NZRs5ZDaw3jL++GnAcxPAejlZVYZBACbfMPTuIlkQlWvmkAzLElVJoCO/mCJgu8ODnR3vcPHs+Wd1RCJ+zAeCPKJo+DCAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713208123; c=relaxed/simple;
	bh=Omfyss0oSwl9blvF1ZPl+9UFJvBZWozOwVcDPAMj4Qs=;
	h=Date:To:From:Subject:Message-Id; b=urRT770Jhop15VxAKKljESRl4rjw7sVyo/UCVdGsNk/tDv8q7myDOIIe7fucG7exlUouGJHJzL4kFdFkKrcFBLE5MxTUGB4lQCcaPn2XhdjvNj9lK9EIcLhdQZ/BIK7Xqc3IuNxRmE6nJWkt6ssFxD3C1b0dqCjNdjrREOfqZ4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qOFAGav2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qOFAGav2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A2DC113CC;
	Mon, 15 Apr 2024 19:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713208122;
	bh=Omfyss0oSwl9blvF1ZPl+9UFJvBZWozOwVcDPAMj4Qs=;
	h=Date:To:From:Subject:From;
	b=qOFAGav2EGnl1z5XUqDv1XBtAOuPayWp11iJMPouNx3N0LCMgsHZurZGgfWlcQcG7
	 2oOi0QDx9YhxW8fPXkSLqJ+KfFOGXFhhrZrWGSX36qRnevMNHIEtOdsExQSRZAqfbc
	 6K1t0BkshYFkqfLREzovILEWoyZgXV0Wpn4/zgQM=
Date: Mon, 15 Apr 2024 12:08:41 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,aha310510@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-oob-in-nilfs_set_de_type.patch added to mm-hotfixes-unstable branch
Message-Id: <20240415190842.63A2DC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix OOB in nilfs_set_de_type
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-oob-in-nilfs_set_de_type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-oob-in-nilfs_set_de_type.patch

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
From: Jeongjun Park <aha310510@gmail.com>
Subject: nilfs2: fix OOB in nilfs_set_de_type
Date: Tue, 16 Apr 2024 03:20:48 +0900

The size of the nilfs_type_by_mode array in the fs/nilfs2/dir.c file is
defined as "S_IFMT >> S_SHIFT", but the nilfs_set_de_type() function,
which uses this array, specifies the index to read from the array in the
same way as "(mode & S_IFMT) >> S_SHIFT".

static void nilfs_set_de_type(struct nilfs_dir_entry *de, struct inode
 *inode)
{
	umode_t mode = inode->i_mode;

	de->file_type = nilfs_type_by_mode[(mode & S_IFMT)>>S_SHIFT]; // oob
}

However, when the index is determined this way, an out-of-bounds (OOB)
error occurs by referring to an index that is 1 larger than the array size
when the condition "mode & S_IFMT == S_IFMT" is satisfied.  Therefore, a
patch to resize the nilfs_type_by_mode array should be applied to prevent
OOB errors.

Link: https://lkml.kernel.org/r/20240415182048.7144-1-konishi.ryusuke@gmail.com
Reported-by: syzbot+2e22057de05b9f3b30d8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2e22057de05b9f3b30d8
Fixes: 2ba466d74ed7 ("nilfs2: directory entry operations")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nilfs2/dir.c~nilfs2-fix-oob-in-nilfs_set_de_type
+++ a/fs/nilfs2/dir.c
@@ -240,7 +240,7 @@ nilfs_filetype_table[NILFS_FT_MAX] = {
 
 #define S_SHIFT 12
 static unsigned char
-nilfs_type_by_mode[S_IFMT >> S_SHIFT] = {
+nilfs_type_by_mode[(S_IFMT >> S_SHIFT) + 1] = {
 	[S_IFREG >> S_SHIFT]	= NILFS_FT_REG_FILE,
 	[S_IFDIR >> S_SHIFT]	= NILFS_FT_DIR,
 	[S_IFCHR >> S_SHIFT]	= NILFS_FT_CHRDEV,
_

Patches currently in -mm which might be from aha310510@gmail.com are

nilfs2-fix-oob-in-nilfs_set_de_type.patch

