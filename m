Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6A81F942D
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 23:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736809896; cv=none; b=dDlJAkIIXxHcFGf6H7MOS+u1TgElvb3qCvLjmacYfWgCTTjE7hrS/D8Ygbnl7F65FXXA44crdZPqo0oHnwQXvzXcmMEKKzBpQQ9656YmSdDbzgP37RR092Uf15WXsqZ/sWGSNnMAYZePzKtZ7FtHG9RNcNRCNFM5xE4srp2oPGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736809896; c=relaxed/simple;
	bh=680j8c9PjOg+rPUwCHSET9TDxMi5qZeSylNkQA2rU8Q=;
	h=Date:To:From:Subject:Message-Id; b=MzWBjFq/9LOPFmg+MDgR9NxlrZ5mrie25jA8qJec1rmxmxI8aVqyop5jAt2fhirhWUnz5xbZVcvOJEFVMLGDoCJG5LZXxRBWjqWKA6/Y5CdR0zs+6sthTFuYWE1BRyrL92dGhebENugXL7csXoEEh40Jz99pLfDi1pKQWbp7hok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NKL/Pqne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NKL/Pqne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F93C4CED6;
	Mon, 13 Jan 2025 23:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736809896;
	bh=680j8c9PjOg+rPUwCHSET9TDxMi5qZeSylNkQA2rU8Q=;
	h=Date:To:From:Subject:From;
	b=NKL/Pqne/4nb+VWJGJJ78WoetVma7IqpLxn/bJjl4pyX8SYegf9LYFG8x2FKkqWRf
	 vGXYxtXwA4sEmKBpQ6ZsNggbbvjIgN7t5/l4eJ2dWSNyTBtmum6b+vFgVbmvHyGRG6
	 KTtyq2h25APpP9bnWO+zwNtnc6Rvmk8hzZ3GXXBw=
Date: Mon, 13 Jan 2025 15:11:35 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,mszeredi@redhat.com,josef@toxicpanda.com,jefflexu@linux.alibaba.com,bernd.schubert@fastmail.fm,joannelkoong@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] fs-writeback-in-wait_sb_inodes-skip-wait-for-as_writeback_indeterminate-mappings.patch removed from -mm tree
Message-Id: <20250113231136.75F93C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/writeback: in wait_sb_inodes(), skip wait for AS_WRITEBACK_INDETERMINATE mappings
has been removed from the -mm tree.  Its filename was
     fs-writeback-in-wait_sb_inodes-skip-wait-for-as_writeback_indeterminate-mappings.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Joanne Koong <joannelkoong@gmail.com>
Subject: fs/writeback: in wait_sb_inodes(), skip wait for AS_WRITEBACK_INDETERMINATE mappings
Date: Fri, 22 Nov 2024 15:23:57 -0800

For filesystems with the AS_WRITEBACK_INDETERMINATE flag set, writeback
operations may take an indeterminate time to complete.  For example,
writing data back to disk in FUSE filesystems depends on the userspace
server successfully completing writeback.

In this commit, wait_sb_inodes() skips waiting on writeback if the inode's
mapping has AS_WRITEBACK_INDETERMINATE set, else sync(2) may take an
indeterminate amount of time to complete.

If the caller wishes to ensure the data for a mapping with the
AS_WRITEBACK_INDETERMINATE flag set has actually been written back to
disk, they should use fsync(2)/fdatasync(2) instead.

Link: https://lkml.kernel.org/r/20241122232359.429647-4-joannelkoong@gmail.com
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/fs-writeback.c~fs-writeback-in-wait_sb_inodes-skip-wait-for-as_writeback_indeterminate-mappings
+++ a/fs/fs-writeback.c
@@ -2681,6 +2681,9 @@ static void wait_sb_inodes(struct super_
 		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
 			continue;
 
+		if (mapping_writeback_indeterminate(mapping))
+			continue;
+
 		spin_unlock_irq(&sb->s_inode_wblist_lock);
 
 		spin_lock(&inode->i_lock);
_

Patches currently in -mm which might be from joannelkoong@gmail.com are

mm-migrate-skip-migrating-folios-under-writeback-with-as_writeback_indeterminate-mappings.patch
fuse-remove-tmp-folio-for-writebacks-and-internal-rb-tree.patch

