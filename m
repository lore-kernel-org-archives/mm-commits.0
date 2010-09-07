From: akpm@linux-foundation.org
Subject: + isofs-work-around-for-rock-ridgejoliet-cds-with-empty-iso-root-directory.patch added to -mm tree
Date: Tue, 07 Sep 2010 16:40:17 -0700
Message-ID: <201009072340.o87NeHiI013515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755991Ab0IGXkw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 19:40:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@rainbow-software.org, viro@zeniv.linux.org.uk


The patch titled
     isofs: work-around for Rock Ridge+Joliet CDs with empty ISO root directory
has been added to the -mm tree.  Its filename is
     isofs-work-around-for-rock-ridgejoliet-cds-with-empty-iso-root-directory.patch

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
Subject: isofs: work-around for Rock Ridge+Joliet CDs with empty ISO root directory
From: Ondrej Zary <linux@rainbow-software.org>

If a CD has both Rock Ridge and Joliet extensions and the ISO root
directory is empty, no files are visible.  Disable Rock Ridge extensions
in this case and use Joliet root directory instead.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/inode.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff -puN fs/isofs/inode.c~isofs-work-around-for-rock-ridgejoliet-cds-with-empty-iso-root-directory fs/isofs/inode.c
--- a/fs/isofs/inode.c~isofs-work-around-for-rock-ridgejoliet-cds-with-empty-iso-root-directory
+++ a/fs/isofs/inode.c
@@ -549,6 +549,34 @@ static unsigned int isofs_get_last_sessi
 }
 
 /*
+ * Check if root directory is empty (has less than 3 files).
+ *
+ * Used to detect broken CDs where ISO root directory is empty but Joliet root
+ * directory is OK. If such CD has Rock Ridge extensions, they will be disabled
+ * (and Joliet used instead) or else no files would be visible.
+ */
+static bool rootdir_empty(struct super_block *sb, unsigned long block)
+{
+	int offset = 0, files = 0, de_len;
+	struct iso_directory_record *de;
+	struct buffer_head *bh;
+
+	bh = sb_bread(sb, block);
+	if (!bh)
+		return true;
+	while (files < 3) {
+		de = (struct iso_directory_record *) (bh->b_data + offset);
+		de_len = *(unsigned char *) de;
+		if (de_len == 0)
+			break;
+		files++;
+		offset += de_len;
+	}
+	brelse(bh);
+	return files < 3;
+}
+
+/*
  * Initialize the superblock and read the root inode.
  *
  * Note: a check_disk_change() has been done immediately prior
@@ -847,6 +875,18 @@ root_found:
 		goto out_no_root;
 
 	/*
+	 * Fix for broken CDs with Rock Ridge and empty ISO root directory but
+	 * correct Joliet root directory.
+	 */
+	if (sbi->s_rock == 1 && joliet_level &&
+				rootdir_empty(s, sbi->s_firstdatazone)) {
+		printk(KERN_NOTICE
+			"ISOFS: primary root directory is empty. "
+			"Disabling Rock Ridge and switching to Joliet.");
+		sbi->s_rock = 0;
+	}
+
+	/*
 	 * If this disk has both Rock Ridge and Joliet on it, then we
 	 * want to use Rock Ridge by default.  This can be overridden
 	 * by using the norock mount option.  There is still one other
_

Patches currently in -mm which might be from linux@rainbow-software.org are

swap-revert-special-hibernation-allocation.patch
swap-prevent-reuse-during-hibernation.patch
cyber2000fb-avoid-palette-corruption-at-higher-clocks.patch
isofs-work-around-for-rock-ridgejoliet-cds-with-empty-iso-root-directory.patch

