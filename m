From: akpm@linux-foundation.org
Subject: + ext4-fix-printk-format-warning.patch added to -mm tree
Date: Thu, 30 Oct 2008 14:40:11 -0700
Message-ID: <200810302140.m9ULeBh8022169@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753334AbYJ3VkQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 17:40:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.beregalov@gmail.com, tytso@mit.edu


The patch titled
     ext4: fix printk format warning
has been added to the -mm tree.  Its filename is
     ext4-fix-printk-format-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: fix printk format warning
From: Alexander Beregalov <a.beregalov@gmail.com>

fs/ext4/balloc.c:607: warning: format '%lld' expects type 'long long int', but argument 2 has type 's64'
fs/ext4/inode.c:1822: warning: format '%lld' expects type 'long long int', but argument 2 has type 's64'
fs/ext4/inode.c:1824: warning: format '%lld' expects type 'long long int', but argument 2 has type 's64'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/balloc.c |    2 +-
 fs/ext4/inode.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ext4/balloc.c~ext4-fix-printk-format-warning fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~ext4-fix-printk-format-warning
+++ a/fs/ext4/balloc.c
@@ -612,7 +612,7 @@ int ext4_claim_free_blocks(struct ext4_s
 		if (dirty_blocks < 0) {
 			printk(KERN_CRIT "Dirty block accounting "
 					"went wrong %lld\n",
-					dirty_blocks);
+					(long long)dirty_blocks);
 		}
 	}
 	/* Check whether we have space after
diff -puN fs/ext4/inode.c~ext4-fix-printk-format-warning fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext4-fix-printk-format-warning
+++ a/fs/ext4/inode.c
@@ -1830,9 +1830,9 @@ static void ext4_print_free_blocks(struc
 			ext4_count_free_blocks(inode->i_sb));
 	printk(KERN_EMERG "Free/Dirty block details\n");
 	printk(KERN_EMERG "free_blocks=%lld\n",
-			percpu_counter_sum(&sbi->s_freeblocks_counter));
+			(long long)percpu_counter_sum(&sbi->s_freeblocks_counter));
 	printk(KERN_EMERG "dirty_blocks=%lld\n",
-			percpu_counter_sum(&sbi->s_dirtyblocks_counter));
+			(long long)percpu_counter_sum(&sbi->s_dirtyblocks_counter));
 	printk(KERN_EMERG "Block reservation details\n");
 	printk(KERN_EMERG "i_reserved_data_blocks=%lu\n",
 			EXT4_I(inode)->i_reserved_data_blocks);
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

linux-next.patch
ext4-fix-printk-format-warning.patch

