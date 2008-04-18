From: akpm@linux-foundation.org
Subject: - ext4-mballoc-fix-hot-spins-after-err_freebuddy-and-err_freemeta.patch removed from -mm tree
Date: Thu, 17 Apr 2008 22:25:58 -0700
Message-ID: <200804180525.m3I5Pw4Z012856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158AbYDRFcO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Apr 2008 01:32:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, aneesh.kumar@linux.vnet.ibm.com, cmm@us.ibm.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     ext4: mballoc: fix hot spins after err_freebuddy and err_freemeta
has been removed from the -mm tree.  Its filename was
     ext4-mballoc-fix-hot-spins-after-err_freebuddy-and-err_freemeta.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: mballoc: fix hot spins after err_freebuddy and err_freemeta
From: Roel Kluin <12o3l@tiscali.nl>

ext4_mb_init_backend() has a variable i of type ext4_group_t.  which is
typedefined in include/linux/ext4_fs_i.h:34 to unsigned long.  Since unsigned,
i >= 0 is always true, so fix hot spins after err_freebuddy and err_freemeta. 

Also when meta_group_info cannot be allocated prevent a decrement of i when
zero.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/mballoc.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff -puN fs/ext4/mballoc.c~ext4-mballoc-fix-hot-spins-after-err_freebuddy-and-err_freemeta fs/ext4/mballoc.c
--- a/fs/ext4/mballoc.c~ext4-mballoc-fix-hot-spins-after-err_freebuddy-and-err_freemeta
+++ a/fs/ext4/mballoc.c
@@ -2572,8 +2572,13 @@ static int ext4_mb_init_backend(struct s
 		meta_group_info[j] = kzalloc(len, GFP_KERNEL);
 		if (meta_group_info[j] == NULL) {
 			printk(KERN_ERR "EXT4-fs: can't allocate buddy mem\n");
-			i--;
-			goto err_freebuddy;
+			if (i != 0) {
+				i--;
+				goto err_freebuddy;
+			} else {
+				i = num_meta_group_infos - 1;
+				goto err_freemeta;
+			}
 		}
 		desc = ext4_get_group_desc(sb, i, NULL);
 		if (desc == NULL) {
@@ -2618,14 +2623,14 @@ static int ext4_mb_init_backend(struct s
 	return 0;
 
 err_freebuddy:
-	while (i >= 0) {
+	do {
 		kfree(ext4_get_group_info(sb, i));
-		i--;
-	}
-	i = num_meta_group_infos;
+	} while (i-- != 0);
+	i = num_meta_group_infos - 1;
 err_freemeta:
-	while (--i >= 0)
+	do {
 		kfree(sbi->s_group_info[i]);
+	} while (i-- != 0);
 	iput(sbi->s_buddy_cache);
 err_freesgi:
 	kfree(sbi->s_group_info);
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

mm-fix-possible-off-by-one-in-walk_pte_range.patch
dz-test-after-postfix-decrement-fails-in-dz_console_putchar.patch
git-alsa-tiwai.patch
git-powerpc.patch
git-dvb.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
git-net.patch
smc911x-test-after-postfix-decrement-fails-in-smc911x_resetdrop_pkt.patch
smc911x-test-after-postfix-decrement-fails-in-smc911x_resetdrop_pkt-checkpatch-fixes.patch
git-scsi-misc.patch
block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
git-cryptodev.patch
free-when-fb-cant-be-registered-in-video-aty-atyfb_basec.patch
drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init.patch
drivers-video-imsttfbc-add-missing-curly-brackets.patch
ext4-mballoc-fix-hot-spins-after-err_freebuddy-and-err_freemeta.patch
likeliness-accounting-change-and-cleanup.patch
likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch

