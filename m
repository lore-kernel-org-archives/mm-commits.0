From: akpm@linux-foundation.org
Subject: [merged]
 fs-omfs-inodec-replace-countsize-kzalloc-by-kcalloc.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:40:56 -0700
Message-ID: <53ea6dc8.zvoxBUPaYNXvgxxl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:59817 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988AbaHLTk5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:57 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so1919367oah.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, me@bobcopeland.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/omfs/inode.c: replace count*size kzalloc by kcalloc
has been removed from the -mm tree.  Its filename was
     fs-omfs-inodec-replace-countsize-kzalloc-by-kcalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/omfs/inode.c: replace count*size kzalloc by kcalloc

kcalloc manages count*sizeof overflow.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Acked-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/omfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/omfs/inode.c~fs-omfs-inodec-replace-countsize-kzalloc-by-kcalloc fs/omfs/inode.c
--- a/fs/omfs/inode.c~fs-omfs-inodec-replace-countsize-kzalloc-by-kcalloc
+++ a/fs/omfs/inode.c
@@ -321,7 +321,7 @@ static int omfs_get_imap(struct super_bl
 		goto out;
 
 	sbi->s_imap_size = array_size;
-	sbi->s_imap = kzalloc(array_size * sizeof(unsigned long *), GFP_KERNEL);
+	sbi->s_imap = kcalloc(array_size, sizeof(unsigned long *), GFP_KERNEL);
 	if (!sbi->s_imap)
 		goto nomem;
 
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

