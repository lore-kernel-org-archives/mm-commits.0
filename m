From: akpm@linux-foundation.org
Subject: + reiserfs-use-array_size-macro-when-appropriate.patch added to -mm tree
Date: Tue, 06 Feb 2007 16:13:02 -0800
Message-ID: <200702070013.l170D3ib001367@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56201 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030270AbXBGANO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 19:13:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com


The patch titled
     reiserfs: Use ARRAY_SIZE macro when appropriate
has been added to the -mm tree.  Its filename is
     reiserfs-use-array_size-macro-when-appropriate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiserfs: Use ARRAY_SIZE macro when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/do_balan.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

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

toshiba-acpi-use-array_size-macro-when-appropriate.patch
intel-agp-use-array_size-macro-when-appropriate.patch
arch-arm-use-array_size-macro-when-appropriate.patch
arch-avr32-use-array_size-macro-when-appropriate.patch
arch-powerpc-user-array_size-macro-when-appropriate.patch
arch-ppc-user-array_size-macro-when-appropriate.patch
drm-use-array_size-macro-when-appropriate.patch
git-dvb.patch
dvb-use-array_size-macro-when-appropriate.patch
git-netdev-all.patch
atm-use-array_size-macro-when-appropriate.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
s390-drivers-use-array_size-macro-when-appropriate.patch
dac960-kmalloc-kzalloc-casting-cleanups.patch
arch-arm26-use-array_size-macro-when-appropriate.patch
arch-m68knommu-user-array_size-macro-when-appropriate.patch
arch-m68k-user-array_size-macro-when-appropriate.patch
arch-cris-user-array_size-macro-when-appropriate.patch
arch-v850-user-array_size-macro-when-appropriate.patch
w1-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate-2.patch
reiserfs-use-array_size-macro-when-appropriate.patch
isdn-capi-use-array_size-when-appropriate.patch
isdn-eicon-use-array_size-macro-when-appropriate.patch
rcutorture-use-array_size-macro-when-appropriate.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
