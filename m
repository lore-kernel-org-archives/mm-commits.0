Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE79136E1B
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 19:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712172249; cv=none; b=PghNratKg5NZASixUz4Oq6NPGHPigiJeaRmC+FJHNH1RCz3u7yugkrcdiqeRsi6OH5RmwpHx7cj99KJ0AY+zw2l8Sm2nN+ohdNClk0ebOMyocH8Em4Ahbaa/m6BdiAapRca/6BJxkC5/ojB158/doaZiSwwK0NjitTCj9XVHZWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712172249; c=relaxed/simple;
	bh=E/nvm2sjyDyUlLLX8Qe+WMLvE+R6jMfpdnIdmlKjREY=;
	h=Date:To:From:Subject:Message-Id; b=aFp22m1j32v5aqln+dSyZppD+1K8BxmHvliUoNtDqcModI+2/252IC9F4+BeJzxtUci0bTQcLOstyhzEY/5SrA1s1uZRisWp/LpHtiXe8lLn5HEQLq7jUYZa7rk4QfHKi78mm2vBnZ7xEXuo0CUjgJOw2BffAL/TKwIOFGbTgiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Eg237vGY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Eg237vGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8919C433C7;
	Wed,  3 Apr 2024 19:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712172248;
	bh=E/nvm2sjyDyUlLLX8Qe+WMLvE+R6jMfpdnIdmlKjREY=;
	h=Date:To:From:Subject:From;
	b=Eg237vGYtZxNmna7fenPb4YVTZoj7eYSrC8z9xQxigLQz/o7h5VpqwCX1pBgoiCB9
	 7v1NjUek7rc5GrpBso5xAQbsFTUFMdqRMr8OvtrOqF20bUi2ykkKRsWqwwf1YSzcQf
	 pwZZhP5uYAVeaww7bO9Al5QoJ7ErEhp5TKrq0ISE=
Date: Wed, 03 Apr 2024 12:24:08 -0700
To: mm-commits@vger.kernel.org,justinstitt@google.com,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-remove-deprecated-strncpy-by-not-copying-the-string.patch added to mm-nonmm-unstable branch
Message-Id: <20240403192408.B8919C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Squashfs: remove deprecated strncpy by not copying the string
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-remove-deprecated-strncpy-by-not-copying-the-string.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-remove-deprecated-strncpy-by-not-copying-the-string.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: remove deprecated strncpy by not copying the string
Date: Wed, 3 Apr 2024 19:33:52 +0100

Squashfs copied the passed string (name) into a temporary buffer to ensure
it was NUL-terminated.  This however is completely unnecessary as the
string is already NUL-terminated.  So remove the deprecated strncpy() by
completely removing the string copy.

The background behind this unnecessary string copy is that it dates back
to the days when Squashfs was an out of kernel patch.  The code
deliberately did not assume the string was NUL-terminated in case in
future this changed (due to kernel changes).  This would mean the out of
tree patches would be broken but still compile OK.

Link: https://lkml.kernel.org/r/20240403183352.391308-1-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Justin Stitt <justinstitt@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/namei.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/fs/squashfs/namei.c~squashfs-remove-deprecated-strncpy-by-not-copying-the-string
+++ a/fs/squashfs/namei.c
@@ -62,27 +62,21 @@
  */
 static int get_dir_index_using_name(struct super_block *sb,
 			u64 *next_block, int *next_offset, u64 index_start,
-			int index_offset, int i_count, const char *name,
-			int len)
+			int index_offset, int i_count, const char *name)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	int i, length = 0, err;
 	unsigned int size;
 	struct squashfs_dir_index *index;
-	char *str;
 
 	TRACE("Entered get_dir_index_using_name, i_count %d\n", i_count);
 
-	index = kmalloc(sizeof(*index) + SQUASHFS_NAME_LEN * 2 + 2, GFP_KERNEL);
+	index = kmalloc(sizeof(*index) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
 	if (index == NULL) {
 		ERROR("Failed to allocate squashfs_dir_index\n");
 		goto out;
 	}
 
-	str = &index->name[SQUASHFS_NAME_LEN + 1];
-	strncpy(str, name, len);
-	str[len] = '\0';
-
 	for (i = 0; i < i_count; i++) {
 		err = squashfs_read_metadata(sb, index, &index_start,
 					&index_offset, sizeof(*index));
@@ -101,7 +95,7 @@ static int get_dir_index_using_name(stru
 
 		index->name[size] = '\0';
 
-		if (strcmp(index->name, str) > 0)
+		if (strcmp(index->name, name) > 0)
 			break;
 
 		length = le32_to_cpu(index->index);
@@ -153,7 +147,7 @@ static struct dentry *squashfs_lookup(st
 	length = get_dir_index_using_name(dir->i_sb, &block, &offset,
 				squashfs_i(dir)->dir_idx_start,
 				squashfs_i(dir)->dir_idx_offset,
-				squashfs_i(dir)->dir_idx_cnt, name, len);
+				squashfs_i(dir)->dir_idx_cnt, name);
 
 	while (length < i_size_read(dir)) {
 		/*
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-remove-deprecated-strncpy-by-not-copying-the-string.patch

