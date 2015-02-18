From: akpm@linux-foundation.org
Subject: [merged] fs-affs-superc-destroy-sbi-mutex-in-affs_kill_sb.patch
 removed from -mm tree
Date: Wed, 18 Feb 2015 11:43:32 -0800
Message-ID: <54e4eb64.zCbVGBMbo4lY/LT1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbbBRTnd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:43:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/super.c: destroy sbi mutex in affs_kill_sb()
has been removed from the -mm tree.  Its filename was
     fs-affs-superc-destroy-sbi-mutex-in-affs_kill_sb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs/super.c: destroy sbi mutex in affs_kill_sb()

Call mutex_destroy() on superblock mutex in affs_kill_sb() otherwise mutex
debugging code isn't able to detect that mutex is used after being freed. 
(thanks to Jan Kara for complete definition).

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/super.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/affs/super.c~fs-affs-superc-destroy-sbi-mutex-in-affs_kill_sb fs/affs/super.c
--- a/fs/affs/super.c~fs-affs-superc-destroy-sbi-mutex-in-affs_kill_sb
+++ a/fs/affs/super.c
@@ -602,6 +602,7 @@ static void affs_kill_sb(struct super_bl
 		affs_free_bitmap(sb);
 		affs_brelse(sbi->s_root_bh);
 		kfree(sbi->s_prefix);
+		mutex_destroy(&sbi->s_bmlock);
 		kfree(sbi);
 	}
 }
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch

