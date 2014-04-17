From: akpm@linux-foundation.org
Subject: +
 fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch added
 to -mm tree
Date: Thu, 17 Apr 2014 13:38:59 -0700
Message-ID: <53503be3.znJY/uZfEwYGHfc4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60107 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaDQUjA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Apr 2014 16:39:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Thu, 17 Apr 2014 13:38:59 -0700


The patch titled
     Subject: fs/befs/btree.c: Replace strncpy by strlcpy + coding style fixing
has been added to the -mm tree.  Its filename is
     fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/befs/btree.c: Replace strncpy by strlcpy + coding style fixing

-strncpy + end of string assignement replaced by strlcpy
-Fix endif };
-Fix typo

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

ntfs-remove-null-value-assignments.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch

