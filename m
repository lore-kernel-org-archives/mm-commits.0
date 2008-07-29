From: akpm@linux-foundation.org
Subject: + omfs-fix-sparse-signedness-warnings.patch added to -mm tree
Date: Tue, 29 Jul 2008 15:56:53 -0700
Message-ID: <200807292256.m6TMurmC026323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759898AbYG2W5W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 18:57:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, me@bobcopeland.com


The patch titled
     omfs: fix sparse signedness warnings
has been added to the -mm tree.  Its filename is
     omfs-fix-sparse-signedness-warnings.patch

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
Subject: omfs: fix sparse signedness warnings
From: Harvey Harrison <harvey.harrison@gmail.com>

fs/omfs/bitmap.c:74:18: warning: incorrect type in argument 2 (different signedness)
fs/omfs/bitmap.c:74:18:    expected unsigned long volatile *addr
fs/omfs/bitmap.c:74:18:    got long *<noident>
fs/omfs/bitmap.c:77:20: warning: incorrect type in argument 2 (different signedness)
fs/omfs/bitmap.c:77:20:    expected unsigned long volatile *addr
fs/omfs/bitmap.c:77:20:    got long *<noident>
fs/omfs/bitmap.c:112:17: warning: incorrect type in argument 2 (different signedness)
fs/omfs/bitmap.c:112:17:    expected unsigned long volatile *addr
fs/omfs/bitmap.c:112:17:    got long *<noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/omfs/bitmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/omfs/bitmap.c~omfs-fix-sparse-signedness-warnings fs/omfs/bitmap.c
--- a/fs/omfs/bitmap.c~omfs-fix-sparse-signedness-warnings
+++ a/fs/omfs/bitmap.c
@@ -71,10 +71,10 @@ static int set_run(struct super_block *s
 		}
 		if (set) {
 			set_bit(bit, sbi->s_imap[map]);
-			set_bit(bit, (long *) bh->b_data);
+			set_bit(bit, (unsigned long *)bh->b_data);
 		} else {
 			clear_bit(bit, sbi->s_imap[map]);
-			clear_bit(bit, (long *) bh->b_data);
+			clear_bit(bit, (unsigned long *)bh->b_data);
 		}
 	}
 	mark_buffer_dirty(bh);
@@ -109,7 +109,7 @@ int omfs_allocate_block(struct super_blo
 		if (!bh)
 			goto out;
 
-		set_bit(bit, (long *) bh->b_data);
+		set_bit(bit, (unsigned long *)bh->b_data);
 		mark_buffer_dirty(bh);
 		brelse(bh);
 	}
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

omfs-sparse-annotations.patch
omfs-fix-sparse-signedness-warnings.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
v4l-drx397xdc-sparse-annotations.patch
v4l-drx397xdc-replace-__function__-occurrences.patch
input-ads7846c-sparse-lock-annotation.patch
mtd-diskonchipc-fix-sparse-endian-warnings.patch
net-use-the-common-ascii-hex-helpers.patch
isdn-use-the-common-ascii-hex-helpers.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch

