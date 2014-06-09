From: akpm@linux-foundation.org
Subject: [merged]
 fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:31:07 -0700
Message-ID: <53960b7b.kboF9EdO9YwiWKsV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaFITbH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:31:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: [merged] fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch removed from -mm tree
To: fabf@skynet.be,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:31:07 -0700


The patch titled
     Subject: fs/befs/btree.c: replace strncpy by strlcpy + coding style fixing
has been removed from the -mm tree.  Its filename was
     fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/befs/btree.c: replace strncpy by strlcpy + coding style fixing

- strncpy + end of string assignement replaced by strlcpy

- Fix endif };

- Fix typo

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/btree.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/befs/btree.c~fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing fs/befs/btree.c
--- a/fs/befs/btree.c~fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing
+++ a/fs/befs/btree.c
@@ -405,7 +405,7 @@ befs_find_key(struct super_block *sb, be
  * Heres how it works: Key_no is the index of the key/value pair to 
  * return in keybuf/value.
  * Bufsize is the size of keybuf (BEFS_NAME_LEN+1 is a good size). Keysize is 
- * the number of charecters in the key (just a convenience).
+ * the number of characters in the key (just a convenience).
  *
  * Algorithm:
  *   Get the first leafnode of the tree. See if the requested key is in that
@@ -502,12 +502,11 @@ befs_btree_read(struct super_block *sb,
 			   "for key of size %d", __func__, bufsize, keylen);
 		brelse(this_node->bh);
 		goto error_alloc;
-	};
+	}
 
-	strncpy(keybuf, keystart, keylen);
+	strlcpy(keybuf, keystart, keylen + 1);
 	*value = fs64_to_cpu(sb, valarray[cur_key]);
 	*keysize = keylen;
-	keybuf[keylen] = '\0';
 
 	befs_debug(sb, "Read [%llu,%d]: Key \"%.*s\", Value %llu", node_off,
 		   cur_key, keylen, keybuf, *value);
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

