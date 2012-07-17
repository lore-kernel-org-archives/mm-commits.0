From: akpm@linux-foundation.org
Subject: [merged] hfs-get-rid-of-hfs_sync_super-v2.patch removed from -mm tree
Date: Tue, 17 Jul 2012 13:04:41 -0700
Message-ID: <20120717200441.AC8731E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:61738 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab2GQUEm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jul 2012 16:04:42 -0400
Received: by mail-qa0-f74.google.com with SMTP id g24so87559qab.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jul 2012 13:04:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.bityutskiy@linux.intel.com, hch@lst.de, jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfs: get rid of hfs_sync_super
has been removed from the -mm tree.  Its filename was
     hfs-get-rid-of-hfs_sync_super-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: hfs: get rid of hfs_sync_super

Remove enough to just cancel the job, we need to set the work_queued flag
to zero as well.  I could do this, but it is simpler to just remove this
tiny optimization - we do not gain much with it.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/mdb.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/hfs/mdb.c~hfs-get-rid-of-hfs_sync_super-v2 fs/hfs/mdb.c
--- a/fs/hfs/mdb.c~hfs-get-rid-of-hfs_sync_super-v2
+++ a/fs/hfs/mdb.c
@@ -263,8 +263,6 @@ void hfs_mdb_commit(struct super_block *
 	if (sb->s_flags & MS_RDONLY)
 		return;
 
-	cancel_delayed_work(&HFS_SB(sb)->mdb_work);
