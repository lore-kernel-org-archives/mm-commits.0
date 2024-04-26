Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4810C8120A
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104473; cv=none; b=N4UtngT9JsWjLwbykMQacwndemsliHrkOPmh1AFnYhlXhp6J4IVo79YoxFxxGi2hfQLsRedA9ednYUx1iTxHux0mWVZpWBoUwpyllBg9Jvt627YM5qTofg1Av/a8Y4oZx4rYRP3nfRKD90+pPbY4rL2Eu0PNoD0A1QVTZOSXtVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104473; c=relaxed/simple;
	bh=T1XOomHwQ4MpTBzQMPxh2irlfZUlyuU5REJxFt7zh8s=;
	h=Date:To:From:Subject:Message-Id; b=lm/TlVUWoSyZryHVEWmP72dNqi/fFlI42i7Di6macDXdzOTb6PYqBGqdMoBzllV21rhNwbQbIgRi4GAysBHVgsUc76Ejvlu8KnR70PRqLA6VaaHpVfSSQJn/lIpCdlOLEgJIRFP617qJCxy014QWOqLawSSfmmOE7tzJAWGXPC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EwMV/uBE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EwMV/uBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B84C113CD;
	Fri, 26 Apr 2024 04:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104472;
	bh=T1XOomHwQ4MpTBzQMPxh2irlfZUlyuU5REJxFt7zh8s=;
	h=Date:To:From:Subject:From;
	b=EwMV/uBEK21ogFdSTKhOTienTc/zI9ciY1KePGv5eeOrvs9g0yOzWcTc1A6Tu0P6R
	 ppXfR3vmQjBcD2X7JbePohDp7RLgyCivo0AWV/HBHSTdMv6A191M6dz0xWFOo+V++R
	 q8/cIoqyLQcYQfv56/pwC4sNLkAA0InjDxSETfHI=
Date: Thu, 25 Apr 2024 21:07:52 -0700
To: mm-commits@vger.kernel.org,keescook@chromium.org,justinstitt@google.com,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-remove-deprecated-strncpy-by-not-copying-the-string.patch removed from -mm tree
Message-Id: <20240426040752.C7B84C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Squashfs: remove deprecated strncpy by not copying the string
has been removed from the -mm tree.  Its filename was
     squashfs-remove-deprecated-strncpy-by-not-copying-the-string.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Justin Stitt <justinstitt@google.com>
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


