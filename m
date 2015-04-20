From: akpm@linux-foundation.org
Subject: [merged]
 befs-replace-typedef-befs_mount_options-by-structure.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:18:33 -0700
Message-ID: <55355109.8O8xgieFjmtsqgvm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40274 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbbDTTMM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:12:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: befs: replace typedef befs_mount_options by structure
has been removed from the -mm tree.  Its filename was
     befs-replace-typedef-befs_mount_options-by-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: befs: replace typedef befs_mount_options by structure

See Documentation/CodingStyle

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/befs.h     |    6 +++---
 fs/befs/linuxvfs.c |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/befs/befs.h~befs-replace-typedef-befs_mount_options-by-structure fs/befs/befs.h
--- a/fs/befs/befs.h~befs-replace-typedef-befs_mount_options-by-structure
+++ a/fs/befs/befs.h
@@ -19,14 +19,14 @@ typedef u64 befs_blocknr_t;
  * BeFS in memory structures
  */
 
-typedef struct befs_mount_options {
+struct befs_mount_options {
 	kgid_t gid;
 	kuid_t uid;
 	int use_gid;
 	int use_uid;
 	int debug;
 	char *iocharset;
-} befs_mount_options;
+};
 
 typedef struct befs_sb_info {
 	u32 magic1;
@@ -52,7 +52,7 @@ typedef struct befs_sb_info {
 	befs_inode_addr indices;
 	u32 magic3;
 
-	befs_mount_options mount_opts;
+	struct befs_mount_options mount_opts;
 	struct nls_table *nls;
 
 } befs_sb_info;
diff -puN fs/befs/linuxvfs.c~befs-replace-typedef-befs_mount_options-by-structure fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~befs-replace-typedef-befs_mount_options-by-structure
+++ a/fs/befs/linuxvfs.c
@@ -51,7 +51,7 @@ static int befs_nls2utf(struct super_blo
 static void befs_put_super(struct super_block *);
 static int befs_remount(struct super_block *, int *, char *);
 static int befs_statfs(struct dentry *, struct kstatfs *);
-static int parse_options(char *, befs_mount_options *);
+static int parse_options(char *, struct befs_mount_options *);
 
 static const struct super_operations befs_sops = {
 	.alloc_inode	= befs_alloc_inode,	/* allocate a new inode */
@@ -669,7 +669,7 @@ static const match_table_t befs_tokens =
 };
 
 static int
-parse_options(char *options, befs_mount_options * opts)
+parse_options(char *options, struct befs_mount_options *opts)
 {
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
linux-next.patch

