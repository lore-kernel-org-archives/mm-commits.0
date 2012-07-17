From: akpm@linux-foundation.org
Subject: [merged] fs-sysv-remove-useless-write_super-call.patch removed from -mm tree
Date: Tue, 17 Jul 2012 13:05:19 -0700
Message-ID: <20120717200519.BBEDB100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:35601 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab2GQUFU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jul 2012 16:05:20 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so81857qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jul 2012 13:05:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.bityutskiy@linux.intel.com, alan@lxorguk.ukuu.org.uk, hch@lst.de, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/sysv: remove useless write_super() call
has been removed from the -mm tree.  Its filename was
     fs-sysv-remove-useless-write_super-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: fs/sysv: remove useless write_super() call

This patchset makes sysv file-system stop using the VFS '->write_supers()'
call-back and the '->s_dirt' superblock field because I plan to remove
them once all users are gone.

Compile-tested only.  If someone can give me a sysv image I could
loop-mount and test my changes - I'd appreciate.  I could not find any
tool to create this ancient file-system.  But I think my changes should
not break it.

Reminder:

The goal is to get rid of the 'sync_supers()' kernel thread.  This kernel
thread wakes up every 5 seconds (by default) and calls '->write_super()'
for all mounted file-systems.  And the bad thing is that this is done even
if all the superblocks are clean.  Moreover, many file-systems do not even
need this end they do not register the '->write_super()' method at all
(e.g., btrfs).

So 'sync_supers()' most often just generates useless wake-ups and wastes
power.  I am trying to make all file-systems independent of
'->write_super()' and plan to remove 'sync_supers()' and '->write_super()'
completely once there are no more users.


This patch: remove useless write_super() call

We do not need to call 'sysv_write_super()' from 'sysv_put_super()',
because VFS has called 'sysv_sync_fs()' before calling '->put_super()'. 
So remove it.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysv/inode.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/sysv/inode.c~fs-sysv-remove-useless-write_super-call fs/sysv/inode.c
--- a/fs/sysv/inode.c~fs-sysv-remove-useless-write_super-call
+++ a/fs/sysv/inode.c
@@ -81,9 +81,6 @@ static void sysv_put_super(struct super_
 {
 	struct sysv_sb_info *sbi = SYSV_SB(sb);
 
-	if (sb->s_dirt)
-		sysv_write_super(sb);
