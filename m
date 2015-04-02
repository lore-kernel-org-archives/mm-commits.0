From: akpm@linux-foundation.org
Subject: + nilfs2-fix-gcc-warning-at-nilfs_checkpoint_is_mounted.patch
 added to -mm tree
Date: Thu, 02 Apr 2015 13:34:33 -0700
Message-ID: <551da7d9.vCcUVinQhf4jBvmb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbbDBUee (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2015 16:34:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, dcb314@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix gcc warning at nilfs_checkpoint_is_mounted()
has been added to the -mm tree.  Its filename is
     nilfs2-fix-gcc-warning-at-nilfs_checkpoint_is_mounted.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-fix-gcc-warning-at-nilfs_checkpoint_is_mounted.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-fix-gcc-warning-at-nilfs_checkpoint_is_mounted.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: fix gcc warning at nilfs_checkpoint_is_mounted()

Fix the following build warning:

 fs/nilfs2/super.c: In function 'nilfs_checkpoint_is_mounted':
 fs/nilfs2/super.c:1023:10: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
   if (cno < 0 || cno > nilfs->ns_cno)
           ^

This warning indicates that the comparision "cno < 0" is useless because
variable "cno" has an unsigned integer type "__u64".

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/super.c~nilfs2-fix-gcc-warning-at-nilfs_checkpoint_is_mounted fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-fix-gcc-warning-at-nilfs_checkpoint_is_mounted
+++ a/fs/nilfs2/super.c
@@ -1020,7 +1020,7 @@ int nilfs_checkpoint_is_mounted(struct s
 	struct dentry *dentry;
 	int ret;
 
-	if (cno < 0 || cno > nilfs->ns_cno)
+	if (cno > nilfs->ns_cno)
 		return false;
 
 	if (cno >= nilfs_last_cno(nilfs))
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-do-not-use-async-write-flag-for-segment-summary-buffers.patch
nilfs2-use-set_mask_bits-for-operations-on-buffer-state-bitmap.patch
nilfs2-use-bgl_lock_ptr.patch
nilfs2-unify-type-of-key-arguments-in-bmap-interface.patch
nilfs2-add-bmap-function-to-seek-a-valid-key.patch
nilfs2-add-bmap-function-to-seek-a-valid-key-fix.patch
nilfs2-add-helper-to-find-existent-block-on-metadata-file.patch
nilfs2-improve-execution-time-of-nilfs_ioctl_get_cpinfo-ioctl.patch
nilfs2-fix-gcc-warning-at-nilfs_checkpoint_is_mounted.patch

