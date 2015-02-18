From: akpm@linux-foundation.org
Subject: [merged] fs-affs-superc-fix-switch-indentation.patch removed from -mm tree
Date: Wed, 18 Feb 2015 11:43:44 -0800
Message-ID: <54e4eb70.8CRYkSg8dnKDzNGM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbbBRTnp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:43:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/super.c: fix switch indentation
has been removed from the -mm tree.  Its filename was
     fs-affs-superc-fix-switch-indentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs/super.c: fix switch indentation

Fix checkpatch error:
ERROR: switch and case should be at the same indent

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/super.c |   66 +++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff -puN fs/affs/super.c~fs-affs-superc-fix-switch-indentation fs/affs/super.c
--- a/fs/affs/super.c~fs-affs-superc-fix-switch-indentation
+++ a/fs/affs/super.c
@@ -432,39 +432,39 @@ got_root:
 		sb->s_flags |= MS_RDONLY;
 	}
 	switch (chksum) {
-		case MUFS_FS:
-		case MUFS_INTLFFS:
-		case MUFS_DCFFS:
-			sbi->s_flags |= SF_MUFS;
-			/* fall thru */
-		case FS_INTLFFS:
-		case FS_DCFFS:
-			sbi->s_flags |= SF_INTL;
-			break;
-		case MUFS_FFS:
-			sbi->s_flags |= SF_MUFS;
-			break;
-		case FS_FFS:
-			break;
-		case MUFS_OFS:
-			sbi->s_flags |= SF_MUFS;
-			/* fall thru */
-		case FS_OFS:
-			sbi->s_flags |= SF_OFS;
-			sb->s_flags |= MS_NOEXEC;
-			break;
-		case MUFS_DCOFS:
-		case MUFS_INTLOFS:
-			sbi->s_flags |= SF_MUFS;
-		case FS_DCOFS:
-		case FS_INTLOFS:
-			sbi->s_flags |= SF_INTL | SF_OFS;
-			sb->s_flags |= MS_NOEXEC;
-			break;
-		default:
-			pr_err("Unknown filesystem on device %s: %08X\n",
-			       sb->s_id, chksum);
-			return -EINVAL;
+	case MUFS_FS:
+	case MUFS_INTLFFS:
+	case MUFS_DCFFS:
+		sbi->s_flags |= SF_MUFS;
+		/* fall thru */
+	case FS_INTLFFS:
+	case FS_DCFFS:
+		sbi->s_flags |= SF_INTL;
+		break;
+	case MUFS_FFS:
+		sbi->s_flags |= SF_MUFS;
+		break;
+	case FS_FFS:
+		break;
+	case MUFS_OFS:
+		sbi->s_flags |= SF_MUFS;
+		/* fall thru */
+	case FS_OFS:
+		sbi->s_flags |= SF_OFS;
+		sb->s_flags |= MS_NOEXEC;
+		break;
+	case MUFS_DCOFS:
+	case MUFS_INTLOFS:
+		sbi->s_flags |= SF_MUFS;
+	case FS_DCOFS:
+	case FS_INTLOFS:
+		sbi->s_flags |= SF_INTL | SF_OFS;
+		sb->s_flags |= MS_NOEXEC;
+		break;
+	default:
+		pr_err("Unknown filesystem on device %s: %08X\n",
+		       sb->s_id, chksum);
+		return -EINVAL;
 	}
 
 	if (mount_flags & SF_VERBOSE) {
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch

