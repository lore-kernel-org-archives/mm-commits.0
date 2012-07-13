From: akpm@linux-foundation.org
Subject: + fs-sysv-remove-useless-write_super-call.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:45:36 -0700
Message-ID: <20120713214537.315A51E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:52597 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757594Ab2GMVpi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:45:38 -0400
Received: by vcqp1 with SMTP id p1so138260vcq.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:45:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: artem.bityutskiy@linux.intel.com, alan@lxorguk.ukuu.org.uk, hch@lst.de, viro@ZenIV.linux.org.uk


The patch titled
     Subject: fs/sysv: remove useless write_super() call
has been added to the -mm tree.  Its filename is
     fs-sysv-remove-useless-write_super-call.patch

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
-
 	if (!(sb->s_flags & MS_RDONLY)) {
 		/* XXX ext2 also updates the state here */
 		mark_buffer_dirty(sbi->s_bh1);
_
Subject: Subject: fs/sysv: remove useless write_super() call

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

