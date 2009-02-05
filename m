From: akpm@linux-foundation.org
Subject: + ext2-xip-refuse-to-change-xip-flag-during-remount-with-busy-inodes.patch added to -mm tree
Date: Thu, 05 Feb 2009 12:53:23 -0800
Message-ID: <200902052053.n15KrOqm015699@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751783AbZBEUyJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 15:54:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cotte@de.ibm.com, heiko.carstens@de.ibm.com, jaredeh@gmail.com, npiggin@suse.de, schwidefsky@de.ibm.com


The patch titled
     ext2/xip: refuse to change xip flag during remount with busy inodes
has been added to the -mm tree.  Its filename is
     ext2-xip-refuse-to-change-xip-flag-during-remount-with-busy-inodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2/xip: refuse to change xip flag during remount with busy inodes
From: Carsten Otte <cotte@de.ibm.com>

For a reason that I was unable to understand in three months of debugging,
mount ext2 -o remount stopped working properly when remounting from
regular operation to xip, or the other way around.  According to a git
bisect search, the problem was introduced with the VM_MIXEDMAP/PTE_SPECIAL
rework in the vm:

commit 70688e4dd1647f0ceb502bbd5964fa344c5eb411
Author: Nick Piggin <npiggin@suse.de>
Date:   Mon Apr 28 02:13:02 2008 -0700

    xip: support non-struct page backed memory

In the failing scenario, the filesystem is mounted read only via root=
kernel parameter on s390x.  During remount (in rc.sysinit), the inodes of
the bash binary and its libraries are busy and cannot be invalidated (the
bash which is running rc.sysinit resides on subject filesystem). 
Afterwards, another bash process (running ifup-eth) recurses into a
subshell, runs dup_mm (via fork).  Some of the mappings in this bash
process were created from inodes that could not be invalidated during
remount.

Both parent and child process crash some time later due to inconsistencies
in their address spaces.  The issue seems to be timing sensitive, various
attempts to recreate it have failed.

This patch refuses to change the xip flag during remount in case some
inodes cannot be invalidated.  This patch keeps users from running into
that issue.

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Jared Hulbert <jaredeh@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/super.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN fs/ext2/super.c~ext2-xip-refuse-to-change-xip-flag-during-remount-with-busy-inodes fs/ext2/super.c
--- a/fs/ext2/super.c~ext2-xip-refuse-to-change-xip-flag-during-remount-with-busy-inodes
+++ a/fs/ext2/super.c
@@ -1185,9 +1185,12 @@ static int ext2_remount (struct super_bl
 	es = sbi->s_es;
 	if (((sbi->s_mount_opt & EXT2_MOUNT_XIP) !=
 	    (old_mount_opt & EXT2_MOUNT_XIP)) &&
-	    invalidate_inodes(sb))
-		ext2_warning(sb, __func__, "busy inodes while remounting "\
-			     "xip remain in cache (no functional problem)");
+	    invalidate_inodes(sb)) {
+		ext2_warning(sb, __func__, "refusing change of xip flag "\
+			     "with busy inodes while remounting");
+		sbi->s_mount_opt &= ~EXT2_MOUNT_XIP;
+		sbi->s_mount_opt |= old_mount_opt & EXT2_MOUNT_XIP;
+	}
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
 		return 0;
 	if (*flags & MS_RDONLY) {
_

Patches currently in -mm which might be from cotte@de.ibm.com are

do_wp_page-fix-regression-with-execute-in-place.patch
linux-next.patch
ext2-xip-refuse-to-change-xip-flag-during-remount-with-busy-inodes.patch

