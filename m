From: akpm@linux-foundation.org
Subject: + hfs-fix-unlink-of-links.patch added to -mm tree
Date: Wed, 09 Apr 2008 16:19:03 -0700
Message-ID: <200804092319.m39NJ3La002316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826AbYDIXT3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2008 19:19:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zippel@linux-m68k.org, rechner@vlado-do.de, stable@kernel.org


The patch titled
     HFS+: fix unlink of links
has been added to the -mm tree.  Its filename is
     hfs-fix-unlink-of-links.patch

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
Subject: HFS+: fix unlink of links
From: Roman Zippel <zippel@linux-m68k.org>

Some time ago while attempting to handle invalid link counts, I botched the
unlink of links itself, so this patch fixes this now correctly, so that only
the link count of nodes that don't point to links is ignored.  Thanks to Vlado
Plaga for notifying me of this problem.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Cc: Vlado Plaga <rechner@vlado-do.de> 
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/dir.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff -puN fs/hfsplus/dir.c~hfs-fix-unlink-of-links fs/hfsplus/dir.c
--- a/fs/hfsplus/dir.c~hfs-fix-unlink-of-links
+++ a/fs/hfsplus/dir.c
@@ -340,16 +340,23 @@ static int hfsplus_unlink(struct inode *
 
 	if (inode->i_nlink > 0)
 		drop_nlink(inode);
-	hfsplus_delete_inode(inode);
-	if (inode->i_ino != cnid && !inode->i_nlink) {
-		if (!atomic_read(&HFSPLUS_I(inode).opencnt)) {
-			res = hfsplus_delete_cat(inode->i_ino, HFSPLUS_SB(sb).hidden_dir, NULL);
-			if (!res)
-				hfsplus_delete_inode(inode);
+	if (inode->i_ino == cnid)
+		clear_nlink(inode);
+	if (!inode->i_nlink) {
+		if (inode->i_ino != cnid) {
+			HFSPLUS_SB(sb).file_count--;
+			if (!atomic_read(&HFSPLUS_I(inode).opencnt)) {
+				res = hfsplus_delete_cat(inode->i_ino,
+							 HFSPLUS_SB(sb).hidden_dir,
+							 NULL);
+				if (!res)
+					hfsplus_delete_inode(inode);
+			} else
+				inode->i_flags |= S_DEAD;
 		} else
-			inode->i_flags |= S_DEAD;
+			hfsplus_delete_inode(inode);
 	} else
-		clear_nlink(inode);
+		HFSPLUS_SB(sb).file_count--;
 	inode->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
 
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

hfs-fix-unlink-of-links.patch
git-x86.patch
provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc.patch
time-close-small-window-for-vsyscall-time-inconsistencies.patch
time-close-small-window-for-vsyscall-time-inconsistencies-checkpatch-fixes.patch
git-watchdog.patch
m68k-replace-remaining-__function__-occurences.patch
fs-hfsplus-proper-externs.patch
affs-handle-match_strdup-failure.patch
hfs-handle-match_strdup-failure.patch
hfsplus-handle-match_strdup-failure.patch
fs-affs-filec-use-bug_on.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
introduce-explicit-signed-unsigned-64bit-divide.patch
convert-a-few-do_div-user.patch
rename-div64_64-to-div64_u64.patch
remove-div_long_long_rem.patch
ntp-cleanup-ntpc.patch
ntp-ntp4-user-space-bits-update.patch
ntp-increase-time_freq-resolution.patch
ntp-increase-time_offset-resolution.patch
ntp-support-for-tai.patch
ntp-rename-tick_length_shift-to-ntp_scale_shift.patch
ntp-remove-current_tick_length.patch
ntp-handle-leap-second-via-timer.patch

