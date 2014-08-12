From: akpm@linux-foundation.org
Subject: [merged]
 fs-adfs-dir_fplusc-replace-countsize-kzalloc-by-kcalloc.patch removed from
 -mm tree
Date: Tue, 12 Aug 2014 12:40:44 -0700
Message-ID: <53ea6dbc.rL2swAxsbS1PFR3N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:48218 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974AbaHLTko (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:44 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so1919454oac.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/adfs/dir_fplus.c: replace count*size kzalloc by kcalloc
has been removed from the -mm tree.  Its filename was
     fs-adfs-dir_fplusc-replace-countsize-kzalloc-by-kcalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/adfs/dir_fplus.c: replace count*size kzalloc by kcalloc

kcalloc manages count*sizeof overflow.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/dir_fplus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/adfs/dir_fplus.c~fs-adfs-dir_fplusc-replace-countsize-kzalloc-by-kcalloc fs/adfs/dir_fplus.c
--- a/fs/adfs/dir_fplus.c~fs-adfs-dir_fplusc-replace-countsize-kzalloc-by-kcalloc
+++ a/fs/adfs/dir_fplus.c
@@ -58,7 +58,7 @@ adfs_fplus_read(struct super_block *sb,
 	if (size > ARRAY_SIZE(dir->bh)) {
 		/* this directory is too big for fixed bh set, must allocate */
 		struct buffer_head **bh_fplus =
-			kzalloc(size * sizeof(struct buffer_head *),
+			kcalloc(size, sizeof(struct buffer_head *),
 				GFP_KERNEL);
 		if (!bh_fplus) {
 			adfs_error(sb, "not enough memory for"
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

