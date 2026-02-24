Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1816C301468;
	Tue, 24 Feb 2026 19:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771960445; cv=none; b=dGnDTEX2tiVu5LfjOotc9rg+8OCoCTW+WFyiCPXUpur/iZEsqlyujXdjAr98u8aR7T7he4gLYo2BV7b74ZVge337wdbiRhFcCQxElOLUijWDseBxfVtr8ogRF9JtlYFNkubPTcO6/YebqJXvMrSIuHufxQZSgpuaCvfvnrDOtIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771960445; c=relaxed/simple;
	bh=84igjuhslbg4jYuWAt+VyxcMngsVajbxXFgxJMrHfao=;
	h=Date:To:From:Subject:Message-Id; b=utEdwjDCoqcg6QgmX8IYonZ5DCsfYJNpP2qcsldj5c62QEBq7ZZPXNqMkiPE83Ez01oyub4RGtCLIG/NYggTGqD7KU+386759H4YFptMYQE8bf39JswKgsbEWPVV967Z6xd269It5bnvEcsn3GVmyOjmcAzO6XdJYNMOyr8E2ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vwEGnqR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vwEGnqR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B8EC116D0;
	Tue, 24 Feb 2026 19:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771960444;
	bh=84igjuhslbg4jYuWAt+VyxcMngsVajbxXFgxJMrHfao=;
	h=Date:To:From:Subject:From;
	b=vwEGnqR/KX27XQ51wcWyRkNGH4HaJMlPCpSKguPYfrLNywH3Jt6uCkXGeTYps1mL3
	 YcKNFwMkZwcOtbZyB4Pc41cZ1Wi3ezzTYtNavp/SvVBsuVLekY5GO0FRMRrpdgNGls
	 Y0OcMriqI7fKlBiZQej16lGeDN663ZekdCBGc1r0=
Date: Tue, 24 Feb 2026 11:14:04 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,brauner@kernel.org,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] squashfs-check-metadata-block-offset-is-within-range.patch removed from -mm tree
Message-Id: <20260224191404.D2B8EC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Squashfs: check metadata block offset is within range
has been removed from the -mm tree.  Its filename was
     squashfs-check-metadata-block-offset-is-within-range.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: check metadata block offset is within range
Date: Tue, 17 Feb 2026 05:09:55 +0000

Syzkaller reports a "general protection fault in squashfs_copy_data"

This is ultimately caused by a corrupted index look-up table, which
produces a negative metadata block offset.

This is subsequently passed to squashfs_copy_data (via
squashfs_read_metadata) where the negative offset causes an out of bounds
access.

The fix is to check that the offset is within range in
squashfs_read_metadata.  This will trap this and other cases.

Link: https://lkml.kernel.org/r/20260217050955.138351-1-phillip@squashfs.org.uk
Fixes: f400e12656ab ("Squashfs: cache operations")
Reported-by: syzbot+a9747fe1c35a5b115d3f@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/699234e2.a70a0220.2c38d7.00e2.GAE@google.com/
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/cache.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/squashfs/cache.c~squashfs-check-metadata-block-offset-is-within-range
+++ a/fs/squashfs/cache.c
@@ -344,6 +344,9 @@ int squashfs_read_metadata(struct super_
 	if (unlikely(length < 0))
 		return -EIO;
 
+	if (unlikely(*offset < 0 || *offset >= SQUASHFS_METADATA_SIZE))
+		return -EIO;
+
 	while (length) {
 		entry = squashfs_cache_get(sb, msblk->block_cache, *block, 0);
 		if (entry->error) {
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-check-xz-dictionary-size-isnt-zero.patch

