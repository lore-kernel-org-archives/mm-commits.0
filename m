From: akpm@linux-foundation.org
Subject: - cramfs-error-message-about-endianess.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:56:12 -0700
Message-ID: <200710180656.l9I6uCQC030684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35893 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762044AbXJRHPp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lists-receive@programmierforen.de, mm-commits@vger.kernel.org


The patch titled
     cramfs: error message about endianess
has been removed from the -mm tree.  Its filename was
     cramfs-error-message-about-endianess.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cramfs: error message about endianess
From: Andi Drebes <lists-receive@programmierforen.de>

The README file in the cramfs subdirectory says: "All data is currently in
host-endian format; neither mkcramfs nor the kernel ever do swabbing."

If somebody tries to mount a cramfs with the wrong endianess, cramfs only
complains about a wrong magic but doesn't inform the user that only the
endianess isn't right.

The following patch adds an error message to the cramfs sources.  If a user
tries to mount a cramfs with the wrong endianess using the patched sources,
cramfs will display the message "cramfs: wrong endianess".

Signed-off-by: Andi Drebes <lists-receive@programmierforen.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cramfs/inode.c         |   11 ++++++++++-
 include/linux/cramfs_fs.h |    1 +
 2 files changed, 11 insertions(+), 1 deletion(-)

diff -puN fs/cramfs/inode.c~cramfs-error-message-about-endianess fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~cramfs-error-message-about-endianess
+++ a/fs/cramfs/inode.c
@@ -258,12 +258,21 @@ static int cramfs_fill_super(struct supe
 
 	/* Do sanity checks on the superblock */
 	if (super.magic != CRAMFS_MAGIC) {
+		/* check for wrong endianess */
+		if (super.magic == CRAMFS_MAGIC_WEND) {
+			if (!silent)
+				printk(KERN_ERR "cramfs: wrong endianess\n");
+			goto out;
+		}
+
 		/* check at 512 byte offset */
 		mutex_lock(&read_mutex);
 		memcpy(&super, cramfs_read(sb, 512, sizeof(super)), sizeof(super));
 		mutex_unlock(&read_mutex);
 		if (super.magic != CRAMFS_MAGIC) {
-			if (!silent)
+			if (super.magic == CRAMFS_MAGIC_WEND && !silent)
+				printk(KERN_ERR "cramfs: wrong endianess\n");
+			else if (!silent)
 				printk(KERN_ERR "cramfs: wrong magic\n");
 			goto out;
 		}
diff -puN include/linux/cramfs_fs.h~cramfs-error-message-about-endianess include/linux/cramfs_fs.h
--- a/include/linux/cramfs_fs.h~cramfs-error-message-about-endianess
+++ a/include/linux/cramfs_fs.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 
 #define CRAMFS_MAGIC		0x28cd3d45	/* some random number */
+#define CRAMFS_MAGIC_WEND	0x453dcd28	/* magic number with the wrong endianess */
 #define CRAMFS_SIGNATURE	"Compressed ROMFS"
 
 /*
_

Patches currently in -mm which might be from lists-receive@programmierforen.de are

origin.patch
fs-cramfs-inodec-remove-unused-variable.patch
fs-cramfs-inodec-replace-hardcoded-value-with-preprocessor-constant.patch
