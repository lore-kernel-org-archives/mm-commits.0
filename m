From: akpm@linux-foundation.org
Subject: + fix-ext4-jbd2-build-warnings.patch added to -mm tree
Date: Wed, 18 Jul 2007 20:19:46 -0700
Message-ID: <200707190319.l6J3JkTN011226@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58205 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754158AbXGSDUD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 23:20:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cmm@us.ibm.com, jeff@garzik.org, tytso@mit.edu


The patch titled
     fix ext4/JBD2 build warnings
has been added to the -mm tree.  Its filename is
     fix-ext4-jbd2-build-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: fix ext4/JBD2 build warnings
=46rom: Mingming Cao <cmm@us.ibm.com>

Looking at the current linus-git tree jbd_debug() define in
include/linux/jbd2.h

extern u8 journal_enable_debug;

#define jbd_debug(n, f, a...)                                          =
 \
        do {                                                           =
 \
                if ((n) <=3D journal_enable_debug) {                   =
   \
                        printk (KERN_DEBUG "(%s, %d): %s: ",           =
 \
                                __FILE__, __LINE__, __FUNCTION__);     =
 \
                        printk (f, ## a);                              =
 \
                }                                                      =
 \
        } while (0)
> fs/ext4/inode.c: In function =E2=80=98ext4_write_inode=E2=80=99:
> fs/ext4/inode.c:2906: warning: comparison is always true due to limit=
ed
> range of data type
>
> fs/jbd2/recovery.c: In function =E2=80=98jbd2_journal_recover=E2=80=99=
:
> fs/jbd2/recovery.c:254: warning: comparison is always true due to
> limited range of data type
> fs/jbd2/recovery.c:257: warning: comparison is always true due to
> limited range of data type
>
> fs/jbd2/recovery.c: In function =E2=80=98jbd2_journal_skip_recovery=E2=
=80=99:
> fs/jbd2/recovery.c:301: warning: comparison is always true due to
> limited range of data type
>
Noticed all warnings are occurs when the debug level is 0. Then found
the "jbd2: Move jbd2-debug file to debugfs" patch
http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
commit;h=3D0f49d5d019afa4e94253bfc92f0daca3badb990b

changed the jbd2_journal_enable_debug from int type to u8, makes the
jbd_debug comparision is always true when the debugging level is 0. Thu=
s
the compile warning occurs.

Thought about changing the jbd2_journal_enable_debug data type back to
int, but can't, because the jbd2-debug is moved to debug fs, where
calling debugfs_create_u8() to create the debugfs entry needs the value
to be u8 type.

Even if we changed the data type back to int, the code is still buggy,
kernel should not print jbd2 debug message if the
jbd2_journal_enable_debug is set to 0. But this is not the case.

The fix is change the level of debugging to 1. The same should fixed in
ext3/JBD, but currently ext3 jbd-debug via /proc fs is broken, so we
probably should fix it all together.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Theodore Tso <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c    |    2 +-
 fs/jbd2/recovery.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ext4/inode.c~fix-ext4-jbd2-build-warnings fs/ext4/inode.c
--- a/fs/ext4/inode.c~fix-ext4-jbd2-build-warnings
+++ a/fs/ext4/inode.c
@@ -2972,7 +2972,7 @@ int ext4_write_inode(struct inode *inode
 		return 0;
=20
 	if (ext4_journal_current_handle()) {
-		jbd_debug(0, "called recursively, non-PF_MEMALLOC!\n");
+		jbd_debug(1, "called recursively, non-PF_MEMALLOC!\n");
 		dump_stack();
 		return -EIO;
 	}
diff -puN fs/jbd2/recovery.c~fix-ext4-jbd2-build-warnings fs/jbd2/recov=
ery.c
--- a/fs/jbd2/recovery.c~fix-ext4-jbd2-build-warnings
+++ a/fs/jbd2/recovery.c
@@ -251,10 +251,10 @@ int jbd2_journal_recover(journal_t *jour
 	if (!err)
 		err =3D do_one_pass(journal, &info, PASS_REPLAY);
=20
-	jbd_debug(0, "JBD: recovery, exit status %d, "
+	jbd_debug(1, "JBD: recovery, exit status %d, "
 		  "recovered transactions %u to %u\n",
 		  err, info.start_transaction, info.end_transaction);
-	jbd_debug(0, "JBD: Replayed %d and revoked %d/%d blocks\n",
+	jbd_debug(1, "JBD: Replayed %d and revoked %d/%d blocks\n",
 		  info.nr_replays, info.nr_revoke_hits, info.nr_revokes);
=20
 	/* Restart the log at the next transaction ID, thus invalidating
@@ -298,7 +298,7 @@ int jbd2_journal_skip_recovery(journal_t
 #ifdef CONFIG_JBD2_DEBUG
 		int dropped =3D info.end_transaction - be32_to_cpu(sb->s_sequence);
 #endif
-		jbd_debug(0,
+		jbd_debug(1,
 			  "JBD: ignoring %d transaction%s from the journal.\n",
 			  dropped, (dropped =3D=3D 1) ? "" : "s");
 		journal->j_transaction_sequence =3D ++info.end_transaction;
_

Patches currently in -mm which might be from cmm@us.ibm.com are

origin.patch
fix-ext4-jbd2-build-warnings.patch
ext2-reservations.patch
fix-for-ext2-reservation.patch
ext2-balloc-use-io_error-label.patch
