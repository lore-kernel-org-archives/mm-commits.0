From: akpm@linux-foundation.org
Subject: - reiserfs-use-array_size-macro-when-appropriate.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:43:47 -0800
Message-ID: <200702122243.l1CMhlVg013529@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44889 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030248AbXBLWnt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:43:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: Use ARRAY_SIZE macro when appropriate
has been removed from the -mm tree.  Its filename was
     reiserfs-use-array_size-macro-when-appropriate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: reiserfs: Use ARRAY_SIZE macro when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/do_balan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/reiserfs/do_balan.c~reiserfs-use-array_size-macro-when-appropriate fs/reiserfs/do_balan.c
--- a/fs/reiserfs/do_balan.c~reiserfs-use-array_size-macro-when-appropriate
+++ a/fs/reiserfs/do_balan.c
@@ -19,6 +19,7 @@
 #include <linux/time.h>
 #include <linux/reiserfs_fs.h>
 #include <linux/buffer_head.h>
+#include <linux/kernel.h>
 
 #ifdef CONFIG_REISERFS_CHECK
 
@@ -1756,7 +1757,7 @@ static void store_thrown(struct tree_bal
 	if (buffer_dirty(bh))
 		reiserfs_warning(tb->tb_sb,
 				 "store_thrown deals with dirty buffer");
-	for (i = 0; i < sizeof(tb->thrown) / sizeof(tb->thrown[0]); i++)
+	for (i = 0; i < ARRAY_SIZE(tb->thrown); i++)
 		if (!tb->thrown[i]) {
 			tb->thrown[i] = bh;
 			get_bh(bh);	/* free_thrown puts this */
@@ -1769,7 +1770,7 @@ static void free_thrown(struct tree_bala
 {
 	int i;
 	b_blocknr_t blocknr;
-	for (i = 0; i < sizeof(tb->thrown) / sizeof(tb->thrown[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(tb->thrown); i++) {
 		if (tb->thrown[i]) {
 			blocknr = tb->thrown[i]->b_blocknr;
 			if (buffer_dirty(tb->thrown[i]))
_

Patches currently in -mm which might be from darwish.07@gmail.com are

origin.patch
git-acpi.patch
git-agpgart.patch
git-arm.patch
git-avr32.patch
git-drm.patch
git-dvb.patch
git-infiniband.patch
git-mips.patch
atm-use-array_size-macro-when-appropriate.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
rcutorture-use-array_size-macro-when-appropriate.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
