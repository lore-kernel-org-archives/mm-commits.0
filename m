From: akpm@linux-foundation.org
Subject: [merged]
 fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:40:42 -0700
Message-ID: <53ea6dba.7yZwFLrw5kYgV2In%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:35403 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965AbaHLTkn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:43 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so1068852igi.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/adfs/dir_fplus.c: use ARRAY_SIZE instead of sizeof/sizeof[0]
has been removed from the -mm tree.  Its filename was
     fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/adfs/dir_fplus.c: use ARRAY_SIZE instead of sizeof/sizeof[0]

Use kernel.h definition.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/dir_fplus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/adfs/dir_fplus.c~fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof fs/adfs/dir_fplus.c
--- a/fs/adfs/dir_fplus.c~fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof
+++ a/fs/adfs/dir_fplus.c
@@ -55,7 +55,7 @@ adfs_fplus_read(struct super_block *sb,
 	}
 
 	size >>= sb->s_blocksize_bits;
-	if (size > sizeof(dir->bh)/sizeof(dir->bh[0])) {
+	if (size > ARRAY_SIZE(dir->bh)) {
 		/* this directory is too big for fixed bh set, must allocate */
 		struct buffer_head **bh_fplus =
 			kzalloc(size * sizeof(struct buffer_head *),
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

