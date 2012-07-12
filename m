From: akpm@linux-foundation.org
Subject: + hfsplus-get-rid-of-write_super-v3.patch added to -mm tree
Date: Thu, 12 Jul 2012 16:20:11 -0700
Message-ID: <20120712232012.16DF65C006A@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:44938 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162566Ab2GLXUO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 19:20:14 -0400
Received: by fat25 with SMTP id 25so149589fat.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 16:20:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: artem.bityutskiy@linux.intel.com, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: hfsplus-get-rid-of-write_super-v3
has been added to the -mm tree.  Its filename is
     hfsplus-get-rid-of-write_super-v3.patch

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
Subject: hfsplus-get-rid-of-write_super-v3

Remove 'cancel_delayed_work()' from 'hfsplus_sync_fs()' because it is not
enough to just cancel the job, we need to set the work_queued flag to zero
as well.  I could do this, but it is simpler to just remove this tiny
optimization - we do not gain much with it.  I caught this bug while doing
some more testing.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/super.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/hfsplus/super.c~hfsplus-get-rid-of-write_super-v3 fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-get-rid-of-write_super-v3
+++ a/fs/hfsplus/super.c
@@ -173,8 +173,6 @@ static int hfsplus_sync_fs(struct super_
 
 	dprint(DBG_SUPER, "hfsplus_sync_fs\n");
 
-	cancel_delayed_work(&sbi->sync_work);
-
 	/*
 	 * Explicitly write out the special metadata inodes.
 	 *
_
Subject: Subject: hfsplus-get-rid-of-write_super-v3

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

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

