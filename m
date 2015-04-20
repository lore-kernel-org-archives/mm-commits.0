From: akpm@linux-foundation.org
Subject: [merged] fs-affs-superc-use-affs_set_opt.patch removed from -mm
 tree
Date: Mon, 20 Apr 2015 12:20:10 -0700
Message-ID: <5535516a.tGwKLp3Sp5xKwVNI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbbDTTNt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:13:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/super.c: use affs_set_opt()
has been removed from the -mm tree.  Its filename was
     fs-affs-superc-use-affs_set_opt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs/super.c: use affs_set_opt()

Replace direct mount option assignation by affs_set_opt() macro.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/super.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff -puN fs/affs/super.c~fs-affs-superc-use-affs_set_opt fs/affs/super.c
--- a/fs/affs/super.c~fs-affs-superc-use-affs_set_opt
+++ a/fs/affs/super.c
@@ -227,22 +227,22 @@ parse_options(char *options, kuid_t *uid
 			if (match_octal(&args[0], &option))
 				return 0;
 			*mode = option & 0777;
-			*mount_opts |= AFFS_MOUNT_SF_SETMODE;
+			affs_set_opt(*mount_opts, SF_SETMODE);
 			break;
 		case Opt_mufs:
-			*mount_opts |= AFFS_MOUNT_SF_MUFS;
+			affs_set_opt(*mount_opts, SF_MUFS);
 			break;
 		case Opt_notruncate:
-			*mount_opts |= AFFS_MOUNT_SF_NO_TRUNCATE;
+			affs_set_opt(*mount_opts, SF_NO_TRUNCATE);
 			break;
 		case Opt_prefix:
 			*prefix = match_strdup(&args[0]);
 			if (!*prefix)
 				return 0;
-			*mount_opts |= AFFS_MOUNT_SF_PREFIX;
+			affs_set_opt(*mount_opts, SF_PREFIX);
 			break;
 		case Opt_protect:
-			*mount_opts |= AFFS_MOUNT_SF_IMMUTABLE;
+			affs_set_opt(*mount_opts, SF_IMMUTABLE);
 			break;
 		case Opt_reserved:
 			if (match_int(&args[0], reserved))
@@ -258,7 +258,7 @@ parse_options(char *options, kuid_t *uid
 			*gid = make_kgid(current_user_ns(), option);
 			if (!gid_valid(*gid))
 				return 0;
-			*mount_opts |= AFFS_MOUNT_SF_SETGID;
+			affs_set_opt(*mount_opts, SF_SETGID);
 			break;
 		case Opt_setuid:
 			if (match_int(&args[0], &option))
@@ -266,10 +266,10 @@ parse_options(char *options, kuid_t *uid
 			*uid = make_kuid(current_user_ns(), option);
 			if (!uid_valid(*uid))
 				return 0;
-			*mount_opts |= AFFS_MOUNT_SF_SETUID;
+			affs_set_opt(*mount_opts, SF_SETUID);
 			break;
 		case Opt_verbose:
-			*mount_opts |= AFFS_MOUNT_SF_VERBOSE;
+			affs_set_opt(*mount_opts, SF_VERBOSE);
 			break;
 		case Opt_volume: {
 			char *vol = match_strdup(&args[0]);
@@ -435,30 +435,31 @@ got_root:
 	case MUFS_FS:
 	case MUFS_INTLFFS:
 	case MUFS_DCFFS:
-		sbi->s_flags |= AFFS_MOUNT_SF_MUFS;
+		affs_set_opt(sbi->s_flags, SF_MUFS);
 		/* fall thru */
 	case FS_INTLFFS:
 	case FS_DCFFS:
-		sbi->s_flags |= AFFS_MOUNT_SF_INTL;
+		affs_set_opt(sbi->s_flags, SF_INTL);
 		break;
 	case MUFS_FFS:
-		sbi->s_flags |= AFFS_MOUNT_SF_MUFS;
+		affs_set_opt(sbi->s_flags, SF_MUFS);
 		break;
 	case FS_FFS:
 		break;
 	case MUFS_OFS:
-		sbi->s_flags |= AFFS_MOUNT_SF_MUFS;
+		affs_set_opt(sbi->s_flags, SF_MUFS);
 		/* fall thru */
 	case FS_OFS:
-		sbi->s_flags |= AFFS_MOUNT_SF_OFS;
+		affs_set_opt(sbi->s_flags, SF_OFS);
 		sb->s_flags |= MS_NOEXEC;
 		break;
 	case MUFS_DCOFS:
 	case MUFS_INTLOFS:
-		sbi->s_flags |= AFFS_MOUNT_SF_MUFS;
+		affs_set_opt(sbi->s_flags, SF_MUFS);
 	case FS_DCOFS:
 	case FS_INTLOFS:
-		sbi->s_flags |= AFFS_MOUNT_SF_INTL | AFFS_MOUNT_SF_OFS;
+		affs_set_opt(sbi->s_flags, SF_INTL);
+		affs_set_opt(sbi->s_flags, SF_OFS);
 		sb->s_flags |= MS_NOEXEC;
 		break;
 	default:
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
linux-next.patch

