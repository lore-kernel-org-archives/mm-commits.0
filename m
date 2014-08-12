From: akpm@linux-foundation.org
Subject: [merged] fs-ufs-superc-use-__func__-in-logging.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:39:26 -0700
Message-ID: <53ea6d6e.2jIJ14Tbzl7AorVv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:35939 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbaHLTj1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:39:27 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so1911085oig.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:39:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ufs/super.c: use __func__ in logging
has been removed from the -mm tree.  Its filename was
     fs-ufs-superc-use-__func__-in-logging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/ufs/super.c: use __func__ in logging

Replace approximate function name by __func__ using standard format
"function():"

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff -puN fs/ufs/super.c~fs-ufs-superc-use-__func__-in-logging fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-superc-use-__func__-in-logging
+++ a/fs/ufs/super.c
@@ -1030,7 +1030,7 @@ again:
 		goto again;
 	}
 	if (!silent)
-		pr_err("ufs_read_super: bad magic number\n");
+		pr_err("%s(): bad magic number\n", __func__);
 	goto failed;
 
 magic_found:
@@ -1044,33 +1044,33 @@ magic_found:
 	uspi->s_fshift = fs32_to_cpu(sb, usb1->fs_fshift);
 
 	if (!is_power_of_2(uspi->s_fsize)) {
-		pr_err("ufs_read_super: fragment size %u is not a power of 2\n",
-		       uspi->s_fsize);
+		pr_err("%s(): fragment size %u is not a power of 2\n",
+		       __func__, uspi->s_fsize);
 		goto failed;
 	}
 	if (uspi->s_fsize < 512) {
-		pr_err("ufs_read_super: fragment size %u is too small\n",
-		       uspi->s_fsize);
+		pr_err("%s(): fragment size %u is too small\n",
+		       __func__, uspi->s_fsize);
 		goto failed;
 	}
 	if (uspi->s_fsize > 4096) {
-		pr_err("ufs_read_super: fragment size %u is too large\n",
-		       uspi->s_fsize);
+		pr_err("%s(): fragment size %u is too large\n",
+		       __func__, uspi->s_fsize);
 		goto failed;
 	}
 	if (!is_power_of_2(uspi->s_bsize)) {
-		pr_err("ufs_read_super: block size %u is not a power of 2\n",
-		       uspi->s_bsize);
+		pr_err("%s(): block size %u is not a power of 2\n",
+		       __func__, uspi->s_bsize);
 		goto failed;
 	}
 	if (uspi->s_bsize < 4096) {
-		pr_err("ufs_read_super: block size %u is too small\n",
-		       uspi->s_bsize);
+		pr_err("%s(): block size %u is too small\n",
+		       __func__, uspi->s_bsize);
 		goto failed;
 	}
 	if (uspi->s_bsize / uspi->s_fsize > 8) {
-		pr_err("ufs_read_super: too many fragments per block (%u)\n",
-		       uspi->s_bsize / uspi->s_fsize);
+		pr_err("%s(): too many fragments per block (%u)\n",
+		       __func__, uspi->s_bsize / uspi->s_fsize);
 		goto failed;
 	}
 	if (uspi->s_fsize != block_size || uspi->s_sbsize != super_block_size) {
@@ -1109,21 +1109,21 @@ magic_found:
 			UFSD("fs is DEC OSF/1\n");
 			break;
 		case UFS_FSACTIVE:
-			pr_err("ufs_read_super: fs is active\n");
+			pr_err("%s(): fs is active\n", __func__);
 			sb->s_flags |= MS_RDONLY;
 			break;
 		case UFS_FSBAD:
-			pr_err("ufs_read_super: fs is bad\n");
+			pr_err("%s(): fs is bad\n", __func__);
 			sb->s_flags |= MS_RDONLY;
 			break;
 		default:
-			pr_err("ufs_read_super: can't grok fs_clean 0x%x\n",
-			       usb1->fs_clean);
+			pr_err("%s(): can't grok fs_clean 0x%x\n",
+			       __func__, usb1->fs_clean);
 			sb->s_flags |= MS_RDONLY;
 			break;
 		}
 	} else {
-		pr_err("ufs_read_super: fs needs fsck\n");
+		pr_err("%s(): fs needs fsck\n", __func__);
 		sb->s_flags |= MS_RDONLY;
 	}
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

