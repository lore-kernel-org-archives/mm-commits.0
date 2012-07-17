From: akpm@linux-foundation.org
Subject: [merged] fs-sysv-remove-another-useless-write_super-call.patch removed from -mm tree
Date: Tue, 17 Jul 2012 13:05:22 -0700
Message-ID: <20120717200523.26E545C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:39149 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab2GQUFZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jul 2012 16:05:25 -0400
Received: by weyr1 with SMTP id r1so47907wey.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jul 2012 13:05:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.bityutskiy@linux.intel.com, alan@lxorguk.ukuu.org.uk, hch@lst.de, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/sysv: remove another useless write_super call
has been removed from the -mm tree.  Its filename was
     fs-sysv-remove-another-useless-write_super-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: fs/sysv: remove another useless write_super call

We do not need to call 'sysv_write_super()' from 'sysv_remount()', because
VFS has called 'sysv_sync_fs()' before calling '->remount()'.  So remove
it.  Remove also '(un)lock_super()' which obvioulsy is becoming useless in
this function.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysv/inode.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/sysv/inode.c~fs-sysv-remove-another-useless-write_super-call fs/sysv/inode.c
--- a/fs/sysv/inode.c~fs-sysv-remove-another-useless-write_super-call
+++ a/fs/sysv/inode.c
@@ -68,12 +68,9 @@ static void sysv_write_super(struct supe
 static int sysv_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct sysv_sb_info *sbi = SYSV_SB(sb);
-	lock_super(sb);
+
 	if (sbi->s_forced_ro)
 		*flags |= MS_RDONLY;
-	if (*flags & MS_RDONLY)
-		sysv_write_super(sb);
-	unlock_super(sb);
 	return 0;
 }
 
_

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

linux-next.patch

