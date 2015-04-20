From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-fix-gcc-warning-at-nilfs_checkpoint_is_mounted.patch removed from
 -mm tree
Date: Mon, 20 Apr 2015 12:18:53 -0700
Message-ID: <5535511d.LuqGJPWMYVfoJ1Zx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbbDTTMc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:12:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, dcb314@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix gcc warning at nilfs_checkpoint_is_mounted()
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-gcc-warning-at-nilfs_checkpoint_is_mounted.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

