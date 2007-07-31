From: akpm@linux-foundation.org
Subject: - udf-fix-uid-and-gid-mount-option-ignorance.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:58:59 -0700
Message-ID: <200707312358.l6VNwxx7029609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59253 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760972AbXHAARH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:17:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, auslands-kv@gmx.de, jack@ucw.cz, sandeen@redhat.com, mm-commits@vger.kernel.org


The patch titled
     UDF: fix UID and GID mount option ignorance
has been removed from the -mm tree.  Its filename was
     udf-fix-uid-and-gid-mount-option-ignorance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: UDF: fix UID and GID mount option ignorance
From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch fix weird behaviour of UDF mounting procedure.  To get UID
changed (for now) we have to type

	mount -t udf -o uid=some_user,uid=ignore /dev/device /mnt/moun_point

and specifying two uid at once is strange a bit.  So with the patch we are
able to mount without additional 'uid=ignore' option.  The same for GID
option is done.

This patch will not break current mount scheme (with two option).

Btw this does fix (I hope) the following

	[BUG 6124] mount of UDF fs ignores UID and GID options
        http://bugzilla.kernel.org/show_bug.cgi?id=6124

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jan Kara <jack@ucw.cz>
Cc: Michael <auslands-kv@gmx.de>
Cc: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/inode.c  |   10 ++++++----
 fs/udf/super.c  |    2 ++
 fs/udf/udf_sb.h |    2 ++
 3 files changed, 10 insertions(+), 4 deletions(-)

diff -puN fs/udf/inode.c~udf-fix-uid-and-gid-mount-option-ignorance fs/udf/inode.c
--- a/fs/udf/inode.c~udf-fix-uid-and-gid-mount-option-ignorance
+++ a/fs/udf/inode.c
@@ -1127,13 +1127,15 @@ static void udf_fill_inode(struct inode 
 	}
 
 	inode->i_uid = le32_to_cpu(fe->uid);
-	if (inode->i_uid == -1 || UDF_QUERY_FLAG(inode->i_sb,
-						 UDF_FLAG_UID_IGNORE))
+	if (inode->i_uid == -1 ||
+	    UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_UID_IGNORE) ||
+	    UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_UID_SET))
 		inode->i_uid = UDF_SB(inode->i_sb)->s_uid;
 
 	inode->i_gid = le32_to_cpu(fe->gid);
-	if (inode->i_gid == -1 || UDF_QUERY_FLAG(inode->i_sb,
-						 UDF_FLAG_GID_IGNORE))
+	if (inode->i_gid == -1 ||
+	    UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_GID_IGNORE) ||
+	    UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_GID_SET))
 		inode->i_gid = UDF_SB(inode->i_sb)->s_gid;
 
 	inode->i_nlink = le16_to_cpu(fe->fileLinkCount);
diff -puN fs/udf/super.c~udf-fix-uid-and-gid-mount-option-ignorance fs/udf/super.c
--- a/fs/udf/super.c~udf-fix-uid-and-gid-mount-option-ignorance
+++ a/fs/udf/super.c
@@ -366,11 +366,13 @@ static int udf_parse_options(char *optio
 			if (match_int(args, &option))
 				return 0;
 			uopt->gid = option;
+			uopt->flags |= (1 << UDF_FLAG_GID_SET);
 			break;
 		case Opt_uid:
 			if (match_int(args, &option))
 				return 0;
 			uopt->uid = option;
+			uopt->flags |= (1 << UDF_FLAG_UID_SET);
 			break;
 		case Opt_umask:
 			if (match_octal(args, &option))
diff -puN fs/udf/udf_sb.h~udf-fix-uid-and-gid-mount-option-ignorance fs/udf/udf_sb.h
--- a/fs/udf/udf_sb.h~udf-fix-uid-and-gid-mount-option-ignorance
+++ a/fs/udf/udf_sb.h
@@ -24,6 +24,8 @@
 #define UDF_FLAG_UID_IGNORE     12    /* use sb uid instead of on disk uid */
 #define UDF_FLAG_GID_FORGET     13
 #define UDF_FLAG_GID_IGNORE     14
+#define UDF_FLAG_UID_SET	15
+#define UDF_FLAG_GID_SET	16
 
 #define UDF_PART_FLAG_UNALLOC_BITMAP	0x0001
 #define UDF_PART_FLAG_UNALLOC_TABLE	0x0002
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
sky-cpu-and-nexus-code-style-improvement.patch
sky-cpu-and-nexus-include-ioh.patch
sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch
sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch
sky-cpu-use-c99-style-for-struct-init.patch
sky-cpu-and-nexus-get-rid-of-useless-null-init.patch
sky-cpu-and-nexus-use-seq_file-single_open-on-proc-interface.patch
