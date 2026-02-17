Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB8F33CE80;
	Tue, 17 Feb 2026 18:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771354496; cv=none; b=hvQoDmxjqIxrWxi0boYB3uGDhUexstkPa+OzT8a3+4uD6V+q8VOUqI91pL6n7FaSFStt/fff+VYYHF7I/u5foHva9Ihq2CwXuXvz1JFOXFt+n1oIuCVaBQqAi1vmKVSkkDdXdE5qdERSmrSCU/cKLrmZvBFAZnmqLkLEIMJOPhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771354496; c=relaxed/simple;
	bh=JJE0Hx6jzZgjhwlkZO/l08SngRVGoAnjVveZaJvLr0o=;
	h=Date:To:From:Subject:Message-Id; b=XIFX4WeomU9VadkpSm55yQfSag95BhIkcNsBW2Rci+zjH7CPCLP3QQ97P3otKB3K125wIlxsXOVnNG0CYFxsTKKAHt2lbL5vtITr7OSGQ2D5jyWbctUWlPbmizCLNxNXHNVA3sHbfxdAgMZKtq5CaWU9+pJrrfNDEg7PfU/aJuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wQTThFC6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wQTThFC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A3FC4CEF7;
	Tue, 17 Feb 2026 18:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771354495;
	bh=JJE0Hx6jzZgjhwlkZO/l08SngRVGoAnjVveZaJvLr0o=;
	h=Date:To:From:Subject:From;
	b=wQTThFC6t5mjbSe5Qz8jgxFEcU47Gh5J4QWQg72jmRKHbT09R7cP+NhSMyyjodqM5
	 ur7qycNBpJxc8ciavijnbS2nc474dhAOrRLLzSg/Ew4vFdgkoV055jaXssCshIEuZD
	 AM3SPiUC1WhY+i4iakqdWxpKkviqJGJuyqjINv3Y=
Date: Tue, 17 Feb 2026 10:54:54 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,brauner@kernel.org,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-check-metadata-block-offset-is-within-range.patch added to mm-hotfixes-unstable branch
Message-Id: <20260217185455.80A3FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Squashfs: check metadata block offset is within range
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     squashfs-check-metadata-block-offset-is-within-range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-check-metadata-block-offset-is-within-range.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

squashfs-check-metadata-block-offset-is-within-range.patch

