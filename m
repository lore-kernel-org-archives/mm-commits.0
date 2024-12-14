Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656613208
	for <mm-commits@vger.kernel.org>; Sat, 14 Dec 2024 00:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734136450; cv=none; b=oyoYrncDycRCidqPq3K3XcfuxlBXtvHBU7ae8goWaUg9iZHzK8hMi0oerJ4Z7CTS6JD76lmcfWuX1OnOFvdFxThBB4BIyD4EClrJyHKRA4pG6P3JUHRBTfygoZ1Ko1y6L7no3VSKcJKQoSlk7f1ufHdFBacNtMWg3Jgvgb/OyD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734136450; c=relaxed/simple;
	bh=g7DElOC4yOrWWVSKzg4AqhqNyDkyz+TMW1irXi5BK7c=;
	h=Date:To:From:Subject:Message-Id; b=Bam0fT7UgfxaMJ0hL62E9Tx/kE5in2FUQIAdw2R2CCN9GufAY0cDH2UWsmiPpb2qyDw0uSp8XV4VkloMySDwxvjuyzP17pIi5fsq0r05PYVy/jqPDTZSZMwX77YBIeN5+ANlk8PGKDDyS/JHgbiUsnNfmGEhaJGNS8g4gB8GdRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lI6TV53f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lI6TV53f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB0EC4CED0;
	Sat, 14 Dec 2024 00:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734136449;
	bh=g7DElOC4yOrWWVSKzg4AqhqNyDkyz+TMW1irXi5BK7c=;
	h=Date:To:From:Subject:From;
	b=lI6TV53fTFnH2rDowHE7iJ6Rhj8wZJ8mU30qQxs6BfH9KNxNWLYsp+bM44qvrijc6
	 zaKlDlGUQO361NTIkaOFUWTECEih5v59+i1P/RMp3i+UX+KKmFd9MvQXRnw11cR5GH
	 q/FtQ+BOQmBRDMB+u1fFjvN+eaa0NWDWO4qETeFw=
Date: Fri, 13 Dec 2024 16:34:09 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,mszeredi@redhat.com,josef@toxicpanda.com,jefflexu@linux.alibaba.com,bernd.schubert@fastmail.fm,joannelkoong@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-writeback-in-wait_sb_inodes-skip-wait-for-as_writeback_indeterminate-mappings.patch added to mm-unstable branch
Message-Id: <20241214003409.CEB0EC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/writeback: in wait_sb_inodes(), skip wait for AS_WRITEBACK_INDETERMINATE mappings
has been added to the -mm mm-unstable branch.  Its filename is
     fs-writeback-in-wait_sb_inodes-skip-wait-for-as_writeback_indeterminate-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-writeback-in-wait_sb_inodes-skip-wait-for-as_writeback_indeterminate-mappings.patch

This patch will later appear in the mm-unstable branch at
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

mm-add-as_writeback_indeterminate-mapping-flag.patch
mm-skip-reclaiming-folios-in-legacy-memcg-writeback-indeterminate-contexts.patch
fs-writeback-in-wait_sb_inodes-skip-wait-for-as_writeback_indeterminate-mappings.patch
mm-migrate-skip-migrating-folios-under-writeback-with-as_writeback_indeterminate-mappings.patch
fuse-remove-tmp-folio-for-writebacks-and-internal-rb-tree.patch

