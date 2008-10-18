From: akpm@linux-foundation.org
Subject: - hfsplus-quieten-down-mounting-hfsplus-journaled-fs-read-only.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:18:29 -0700
Message-ID: <200810182318.m9INITTM029290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752168AbYJRXSy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:18:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mac@mcrowe.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hfsplus: quieten down mounting hfsplus journaled fs read only
has been removed from the -mm tree.  Its filename was
     hfsplus-quieten-down-mounting-hfsplus-journaled-fs-read-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hfsplus: quieten down mounting hfsplus journaled fs read only
From: Mike Crowe <mac@mcrowe.com>

Check whether the file system was to be mounted read only anyway before
warning about changing the mount to read only.

Signed-off-by: Mike Crowe <mac@mcrowe.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hfsplus/super.c~hfsplus-quieten-down-mounting-hfsplus-journaled-fs-read-only fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-quieten-down-mounting-hfsplus-journaled-fs-read-only
+++ a/fs/hfsplus/super.c
@@ -356,7 +356,7 @@ static int hfsplus_fill_super(struct sup
 	} else if (vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_SOFTLOCK)) {
 		printk(KERN_WARNING "hfs: Filesystem is marked locked, mounting read-only.\n");
 		sb->s_flags |= MS_RDONLY;
-	} else if (vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_JOURNALED)) {
+	} else if ((vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_JOURNALED)) && !(sb->s_flags & MS_RDONLY)) {
 		printk(KERN_WARNING "hfs: write access to a journaled filesystem is not supported, "
 		       "use the force option at your own risk, mounting read-only.\n");
 		sb->s_flags |= MS_RDONLY;
_

Patches currently in -mm which might be from mac@mcrowe.com are

origin.patch

