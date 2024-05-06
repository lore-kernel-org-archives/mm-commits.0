Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406CD2770B
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957062; cv=none; b=hil57Ghpl+d8QqQevBCmo/N3/QmC4GNHQzPKvDWzrCn5PG6K+ije9zHUOGPryipJysJmXfKOZlEh6QF+qzS8Ujqqg/lPZ1C/yHU6I87yD/+HHfMHI9V0yoS2CwkCrVvuVrVnM6YTPC02D0+3oy8hmTom5h369CZMirQIdSWw2sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957062; c=relaxed/simple;
	bh=6fIIuGZIqJy/KWHBXeA+tCVME3fiW6SK8Psm4HqRSdE=;
	h=Date:To:From:Subject:Message-Id; b=JyID4TVWYnSfojEjnr1GaT67ah8UHdhifbdVVMmDyj4BL/pcB8kWOXvBz7Wa3qggZhaKLVZ10wUaR47d86PqvOFFXcyTSLxlBRAqRCjX8WEZ16NPXYJbROHQvHPfaFo7FlzcLkShz397krRrxSbtXuMhWe0hEXM2r5DWLkDmHXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DvZ6STEJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DvZ6STEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10177C116B1;
	Mon,  6 May 2024 00:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957062;
	bh=6fIIuGZIqJy/KWHBXeA+tCVME3fiW6SK8Psm4HqRSdE=;
	h=Date:To:From:Subject:From;
	b=DvZ6STEJD4bLCKVghQP+9OTtX4kv+B8FZmKtEsxAbiHLvcqXT5NrTcJvJl0ihpMgv
	 diezMdna3dZbjd0285xvt6mQ65sjdgwxEU24xzZvkWnDh4Gs4cJa+lP+9nCHzCZ/9H
	 V0WslsXxG/sfSkVXWSQxMW35d5C5oMx9dWr9g8BM=
Date: Sun, 05 May 2024 17:57:41 -0700
To: mm-commits@vger.kernel.org,p.raghav@samsung.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-improve-bdev_getblk-documentation.patch removed from -mm tree
Message-Id: <20240506005742.10177C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: buffer: improve bdev_getblk documentation
has been removed from the -mm tree.  Its filename was
     buffer-improve-bdev_getblk-documentation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: improve bdev_getblk documentation
Date: Tue, 16 Apr 2024 04:17:51 +0100

Add some more information about the state of the buffer_head returned.

Link: https://lkml.kernel.org/r/20240416031754.4076917-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/buffer.c~buffer-improve-bdev_getblk-documentation
+++ a/fs/buffer.c
@@ -1424,6 +1424,11 @@ EXPORT_SYMBOL(__find_get_block);
  * @size: The size of buffer_heads for this @bdev.
  * @gfp: The memory allocation flags to use.
  *
+ * The returned buffer head has its reference count incremented, but is
+ * not locked.  The caller should call brelse() when it has finished
+ * with the buffer.  The buffer may not be uptodate.  If needed, the
+ * caller can bring it uptodate either by reading it or overwriting it.
+ *
  * Return: The buffer head, or NULL if memory could not be allocated.
  */
 struct buffer_head *bdev_getblk(struct block_device *bdev, sector_t block,
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

