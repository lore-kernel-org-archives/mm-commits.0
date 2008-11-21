From: akpm@linux-foundation.org
Subject: + hfsplus-fix-journal-detection.patch added to -mm tree
Date: Fri, 21 Nov 2008 12:34:35 -0800
Message-ID: <200811212034.mALKYans029812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752843AbYKUUfN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 15:35:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wt@penguintechs.org, zippel@linux-m68k.org


The patch titled
     hfsplus: fix journal detection
has been added to the -mm tree.  Its filename is
     hfsplus-fix-journal-detection.patch

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
Subject: hfsplus: fix journal detection
From: Warren Turkal <wt@penguintechs.org>

The code currently mounts an HFS+ volume read-only (unless given the
"force" mount option) if it detects that the HFS+ volume has a journal. 
The code was unconditionally assuming that the volume had a jounal if the
journal attribute was set in the volume header.  However, the volume also
has to have a non-zero journal info block to actually have a journal.

In this patch, I refactored the journal detection into a function since
the logic is used twice.  The journal detection also uses the better logic
to determine if there is a journal.

Signed-off-by: Warren Turkal <wt@penguintechs.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/super.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN fs/hfsplus/super.c~hfsplus-fix-journal-detection fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-fix-journal-detection
+++ a/fs/hfsplus/super.c
@@ -20,6 +20,12 @@ static void hfsplus_destroy_inode(struct
 
 #include "hfsplus_fs.h"
 
+static bool hfsplus_vol_has_journal(struct hfsplus_vh *vhdr)
+{
+	return (vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_JOURNALED) &&
+				vhdr->journal_info_block);
+}
+
 struct inode *hfsplus_iget(struct super_block *sb, unsigned long ino)
 {
 	struct hfs_find_data fd;
@@ -260,7 +266,7 @@ static int hfsplus_remount(struct super_
 			printk(KERN_WARNING "hfs: filesystem is marked locked, leaving read-only.\n");
 			sb->s_flags |= MS_RDONLY;
 			*flags |= MS_RDONLY;
-		} else if (vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_JOURNALED)) {
+		} else if (hfsplus_vol_has_journal(vhdr)) {
 			printk(KERN_WARNING "hfs: filesystem is marked journaled, leaving read-only.\n");
 			sb->s_flags |= MS_RDONLY;
 			*flags |= MS_RDONLY;
@@ -356,7 +362,7 @@ static int hfsplus_fill_super(struct sup
 	} else if (vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_SOFTLOCK)) {
 		printk(KERN_WARNING "hfs: Filesystem is marked locked, mounting read-only.\n");
 		sb->s_flags |= MS_RDONLY;
-	} else if ((vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_JOURNALED)) && !(sb->s_flags & MS_RDONLY)) {
+	} else if (hfsplus_vol_has_journal(vhdr) && !(sb->s_flags & MS_RDONLY)) {
 		printk(KERN_WARNING "hfs: write access to a journaled filesystem is not supported, "
 		       "use the force option at your own risk, mounting read-only.\n");
 		sb->s_flags |= MS_RDONLY;
_

Patches currently in -mm which might be from wt@penguintechs.org are

hfsplus-identify-journal-info-block-in-volume-header.patch
hfsplus-fix-journal-detection.patch

