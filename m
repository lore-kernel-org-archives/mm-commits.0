From: akpm@linux-foundation.org
Subject: [merged] fs-ufs-superc-fix-potential-race-condition.patch removed from -mm tree
Date: Wed, 18 Feb 2015 11:42:52 -0800
Message-ID: <54e4eb3c.oiOYW4UQ7e7wLLQ1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46007 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbbBRTmx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:42:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ufs/super.c: fix potential race condition
has been removed from the -mm tree.  Its filename was
     fs-ufs-superc-fix-potential-race-condition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/ufs/super.c: fix potential race condition

Let locking subsystem decide on mutex management.  As reported by Andrew
Morton this patch fixes a bug:

: lock_ufs() is assuming that on non-preempt uniprocessor, the calling
: code will run atomically up to the matching unlock_ufs().
: 
: But that isn't true. The very first site I looked at (ufs_frag_map)
: does sb_bread() under lock_ufs().  And sb_bread() will call schedule(),
: very commonly.
: 
: The ->mutex_owner stuff is a bit hacky but should work OK.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN fs/ufs/super.c~fs-ufs-superc-fix-potential-race-condition fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-superc-fix-potential-race-condition
+++ a/fs/ufs/super.c
@@ -95,22 +95,18 @@
 
 void lock_ufs(struct super_block *sb)
 {
-#if defined(CONFIG_SMP) || defined (CONFIG_PREEMPT)
 	struct ufs_sb_info *sbi = UFS_SB(sb);
 
 	mutex_lock(&sbi->mutex);
 	sbi->mutex_owner = current;
-#endif
 }
 
 void unlock_ufs(struct super_block *sb)
 {
-#if defined(CONFIG_SMP) || defined (CONFIG_PREEMPT)
 	struct ufs_sb_info *sbi = UFS_SB(sb);
 
 	sbi->mutex_owner = NULL;
 	mutex_unlock(&sbi->mutex);
-#endif
 }
 
 static struct inode *ufs_nfs_get_inode(struct super_block *sb, u64 ino, u32 generation)
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch

