From: akpm@linux-foundation.org
Subject: + hfsplus-quieten-down-mounting-hfsplus-journaled-fs-read-only.patch added to -mm tree
Date: Mon, 11 Aug 2008 13:35:03 -0700
Message-ID: <200808112035.m7BKZ3SN020054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752989AbYHKUfY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 16:35:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mac@mcrowe.com, zippel@linux-m68k.org


The patch titled
     hfsplus: quieten down mounting hfsplus journaled fs read only
has been added to the -mm tree.  Its filename is
     hfsplus-quieten-down-mounting-hfsplus-journaled-fs-read-only.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

hfsplus-quieten-down-mounting-hfsplus-journaled-fs-read-only.patch

