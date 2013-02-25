From: akpm@linux-foundation.org
Subject: [merged] tmpfs-fix-mempolicy-object-leaks.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:55:56 -0800
Message-ID: <20130225205556.B08CE31C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:63336 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759844Ab3BYUz5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:55:57 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so347597ghb.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:55:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: fix mempolicy object leaks
has been removed from the -mm tree.  Its filename was
     tmpfs-fix-mempolicy-object-leaks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: tmpfs: fix mempolicy object leaks

Fix several mempolicy leaks in the tmpfs mount logic.  These leaks are
slow - on the order of one object leaked per mount attempt.

Leak 1 (umount doesn't free mpol allocated in mount):
    while true; do
        mount -t tmpfs -o mpol=interleave,size=100M nodev /mnt
        umount /mnt
    done

Leak 2 (errors parsing remount options will leak mpol):
    mount -t tmpfs -o size=100M nodev /mnt
    while true; do
        mount -o remount,mpol=interleave,size=x /mnt 2> /dev/null
    done
    umount /mnt

Leak 3 (multiple mpol per mount leak mpol):
    while true; do
        mount -t tmpfs -o mpol=interleave,mpol=interleave,size=100M nodev /mnt
        umount /mnt
    done

This patch fixes all of the above.  I could have broken the patch into
three pieces but is seemed easier to review as one.

[akpm@linux-foundation.org: fix handling of mpol_parse_str() errors, per Hugh]
Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN mm/shmem.c~tmpfs-fix-mempolicy-object-leaks mm/shmem.c
--- a/mm/shmem.c~tmpfs-fix-mempolicy-object-leaks
+++ a/mm/shmem.c
@@ -2385,6 +2385,7 @@ static int shmem_parse_options(char *opt
 			       bool remount)
 {
 	char *this_char, *value, *rest;
+	struct mempolicy *mpol = NULL;
 	uid_t uid;
 	gid_t gid;
 
@@ -2413,7 +2414,7 @@ static int shmem_parse_options(char *opt
 			printk(KERN_ERR
 			    "tmpfs: No value for mount option '%s'\n",
 			    this_char);
-			return 1;
+			goto error;
 		}
 
 		if (!strcmp(this_char,"size")) {
@@ -2462,19 +2463,24 @@ static int shmem_parse_options(char *opt
 			if (!gid_valid(sbinfo->gid))
 				goto bad_val;
 		} else if (!strcmp(this_char,"mpol")) {
-			if (mpol_parse_str(value, &sbinfo->mpol))
+			mpol_put(mpol);
+			mpol = NULL;
+			if (mpol_parse_str(value, &mpol))
 				goto bad_val;
 		} else {
 			printk(KERN_ERR "tmpfs: Bad mount option %s\n",
 			       this_char);
-			return 1;
+			goto error;
 		}
 	}
+	sbinfo->mpol = mpol;
 	return 0;
 
 bad_val:
 	printk(KERN_ERR "tmpfs: Bad value '%s' for mount option '%s'\n",
 	       value, this_char);
+error:
+	mpol_put(mpol);
 	return 1;
 
 }
@@ -2550,6 +2556,7 @@ static void shmem_put_super(struct super
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
 
 	percpu_counter_destroy(&sbinfo->used_blocks);
+	mpol_put(sbinfo->mpol);
 	kfree(sbinfo);
 	sb->s_fs_info = NULL;
 }
_

Patches currently in -mm which might be from gthelen@google.com are

origin.patch

