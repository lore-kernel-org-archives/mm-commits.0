From: akpm@linux-foundation.org
Subject: - hfsplus-fix-mount-uid-gid-bug.patch removed from -mm tree
Date: Sun, 24 Jun 2007 11:01:20 -0700
Message-ID: <200706241801.l5OI1Kl1018623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48247 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505AbXFXSCJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Jun 2007 14:02:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wyatt@banksresearch.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     HFSPlus: fix mount uid/gid bug
has been removed from the -mm tree.  Its filename was
     hfsplus-fix-mount-uid-gid-bug.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: HFSPlus: fix mount uid/gid bug
From: Wyatt Banks <wyatt@banksresearch.com>

HFSPlus: fix broken logic for mount uid=xxx,gid=xxx. (bug 3533)

This is a patch to address bug 3533.

The 2 lines that should be setting the uid/gid:

if (!inode->i_uid && !mode)
if (!inode->i_gid && !mode)

always evaluate as false.  mode is the BSD file type and mode bits.
These lines do nothing since the file type bits are not masked off
with S_IFMT.

References:

http://bugzilla.kernel.org/show_bug.cgi?id=3533
http://developer.apple.com/technotes/tn/tn1150.html

Signed-off-by: Wyatt Banks <wyatt@banksresearch.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/hfsplus_fs.h |    2 ++
 fs/hfsplus/inode.c      |    4 ++--
 fs/hfsplus/options.c    |    2 ++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/hfsplus/hfsplus_fs.h~hfsplus-fix-mount-uid-gid-bug fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~hfsplus-fix-mount-uid-gid-bug
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -139,6 +139,8 @@ struct hfsplus_sb_info {
 	uid_t uid;
 	gid_t gid;
 
+	int uid_provided, gid_provided;
+
 	int part, session;
 
 	unsigned long flags;
diff -puN fs/hfsplus/inode.c~hfsplus-fix-mount-uid-gid-bug fs/hfsplus/inode.c
--- a/fs/hfsplus/inode.c~hfsplus-fix-mount-uid-gid-bug
+++ a/fs/hfsplus/inode.c
@@ -186,11 +186,11 @@ static void hfsplus_get_perms(struct ino
 	mode = be16_to_cpu(perms->mode);
 
 	inode->i_uid = be32_to_cpu(perms->owner);
-	if (!inode->i_uid && !mode)
+	if (HFSPLUS_SB(sb).uid_provided)
 		inode->i_uid = HFSPLUS_SB(sb).uid;
 
 	inode->i_gid = be32_to_cpu(perms->group);
-	if (!inode->i_gid && !mode)
+	if (HFSPLUS_SB(sb).gid_provided)
 		inode->i_gid = HFSPLUS_SB(sb).gid;
 
 	if (dir) {
diff -puN fs/hfsplus/options.c~hfsplus-fix-mount-uid-gid-bug fs/hfsplus/options.c
--- a/fs/hfsplus/options.c~hfsplus-fix-mount-uid-gid-bug
+++ a/fs/hfsplus/options.c
@@ -106,6 +106,7 @@ int hfsplus_parse_options(char *input, s
 				return 0;
 			}
 			sbi->uid = (uid_t)tmp;
+			sbi->uid_provided = 1;
 			break;
 		case opt_gid:
 			if (match_int(&args[0], &tmp)) {
@@ -113,6 +114,7 @@ int hfsplus_parse_options(char *input, s
 				return 0;
 			}
 			sbi->gid = (gid_t)tmp;
+			sbi->gid_provided = 1;
 			break;
 		case opt_part:
 			if (match_int(&args[0], &sbi->part)) {
_

Patches currently in -mm which might be from wyatt@banksresearch.com are

hfsplus-change-kmalloc-memset-to-kzalloc.patch
hfsplus-fix-mount-uid-gid-bug.patch
hfsplus-fix-mount-uid-gid-bug-tidy.patch
