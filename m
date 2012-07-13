From: akpm@linux-foundation.org
Subject: + fs-sysv-remove-another-useless-write_super-call.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:45:39 -0700
Message-ID: <20120713214540.790CB5C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:35709 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab2GMVpn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:45:43 -0400
Received: by lbbgp10 with SMTP id gp10so222818lbb.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:45:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: artem.bityutskiy@linux.intel.com, alan@lxorguk.ukuu.org.uk, hch@lst.de, viro@ZenIV.linux.org.uk


The patch titled
     Subject: fs/sysv: remove another useless write_super call
has been added to the -mm tree.  Its filename is
     fs-sysv-remove-another-useless-write_super-call.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: fs/sysv: remove another useless write_super call

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

origin.patch
linux-next.patch
hfs-push-lock_super-down.patch
hfs-get-rid-of-lock_super.patch
hfs-remove-extra-mdb-write-on-unmount.patch
hfs-simplify-a-bit-checking-for-r-o.patch
hfs-introduce-vfs-superblock-object-back-reference.patch
hfs-get-rid-of-hfs_sync_super.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
hfs-get-rid-of-hfs_sync_super-v2.patch
hfsplus-make-hfsplus_sync_fs-static.patch
hfsplus-amend-debugging-print.patch
hfsplus-remove-useless-check.patch
hfsplus-get-rid-of-write_super.patch
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
hfsplus-get-rid-of-write_super-v3.patch
fs-ufs-remove-extra-superblock-write-on-unmount.patch
fs-ufs-re-arrange-the-code-a-bit.patch
fs-ufs-re-arrange-the-code-a-bit-checkpatch-fixes.patch
fs-ufs-get-rid-of-write_super.patch
fs-sysv-remove-useless-write_super-call.patch
fs-sysv-remove-another-useless-write_super-call.patch
fs-sysv-stop-using-write_super-and-s_dirt.patch

