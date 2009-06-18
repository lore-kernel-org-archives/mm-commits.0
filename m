From: akpm@linux-foundation.org
Subject: [merged] reiserfs-fix-warnings-with-gcc-44.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:45:07 -0700
Message-ID: <200906182245.n5IMj7h4004126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758224AbZFRWpp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:45:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@jeffreymahoney.com, jeffm@suse.com, mason@oracle.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: fix warnings with gcc 4.4
has been removed from the -mm tree.  Its filename was
     reiserfs-fix-warnings-with-gcc-44.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: fix warnings with gcc 4.4
From: Jeff Mahoney <jeffm@jeffreymahoney.com>

Several code paths in reiserfs have a construct like:

 if (is_direntry_le_ih(ih = B_N_PITEM_HEAD(src, item_num))) ...

which, in addition to being ugly, end up causing compiler warnings with
gcc 4.4.0.  Previous compilers didn't issue a warning.

fs/reiserfs/do_balan.c:1273: warning: operation on `aux_ih' may be undefined
fs/reiserfs/lbalance.c:393: warning: operation on `ih' may be undefined
fs/reiserfs/lbalance.c:421: warning: operation on `ih' may be undefined
fs/reiserfs/lbalance.c:777: warning: operation on `ih' may be undefined

I believe this is due to the ih being passed to macros which evaluate the
argument more than once.  This is old code and we haven't seen any
problems with it, but this patch eliminates the warnings.

It converts the multiple evaluation macros to static inlines and does a
preassignment for the cases that were causing the warnings because that
code is just ugly.

Reported-by: Chris Mason <mason@oracle.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/do_balan.c      |    5 +--
 fs/reiserfs/lbalance.c      |   10 ++++---
 include/linux/reiserfs_fs.h |   47 ++++++++++++++++++++++++++++------
 3 files changed, 47 insertions(+), 15 deletions(-)

diff -puN fs/reiserfs/do_balan.c~reiserfs-fix-warnings-with-gcc-44 fs/reiserfs/do_balan.c
--- a/fs/reiserfs/do_balan.c~reiserfs-fix-warnings-with-gcc-44
+++ a/fs/reiserfs/do_balan.c
@@ -1270,9 +1270,8 @@ static int balance_leaf(struct tree_bala
 
 					RFALSE(ih, "PAP-12210: ih must be 0");
 
-					if (is_direntry_le_ih
-					    (aux_ih =
-					     B_N_PITEM_HEAD(tbS0, item_pos))) {
+					aux_ih = B_N_PITEM_HEAD(tbS0, item_pos);
+					if (is_direntry_le_ih(aux_ih)) {
 						/* we append to directory item */
 
 						int entry_count;
diff -puN fs/reiserfs/lbalance.c~reiserfs-fix-warnings-with-gcc-44 fs/reiserfs/lbalance.c
--- a/fs/reiserfs/lbalance.c~reiserfs-fix-warnings-with-gcc-44
+++ a/fs/reiserfs/lbalance.c
@@ -390,7 +390,8 @@ static void leaf_item_bottle(struct buff
 
 	if (last_first == FIRST_TO_LAST) {
 		/* if ( if item in position item_num in buffer SOURCE is directory item ) */
-		if (is_direntry_le_ih(ih = B_N_PITEM_HEAD(src, item_num)))
+		ih = B_N_PITEM_HEAD(src, item_num);
+		if (is_direntry_le_ih(ih))
 			leaf_copy_dir_entries(dest_bi, src, FIRST_TO_LAST,
 					      item_num, 0, cpy_bytes);
 		else {
@@ -418,7 +419,8 @@ static void leaf_item_bottle(struct buff
 		}
 	} else {
 		/*  if ( if item in position item_num in buffer SOURCE is directory item ) */
-		if (is_direntry_le_ih(ih = B_N_PITEM_HEAD(src, item_num)))
+		ih = B_N_PITEM_HEAD(src, item_num);
+		if (is_direntry_le_ih(ih))
 			leaf_copy_dir_entries(dest_bi, src, LAST_TO_FIRST,
 					      item_num,
 					      I_ENTRY_COUNT(ih) - cpy_bytes,
@@ -774,8 +776,8 @@ void leaf_delete_items(struct buffer_inf
 			leaf_delete_items_entirely(cur_bi, first + 1,
 						   del_num - 1);
 
-			if (is_direntry_le_ih
-			    (ih = B_N_PITEM_HEAD(bh, B_NR_ITEMS(bh) - 1)))
+			ih = B_N_PITEM_HEAD(bh, B_NR_ITEMS(bh) - 1);
+			if (is_direntry_le_ih(ih))
 				/* the last item is directory  */
 				/* len = numbers of directory entries in this item */
 				len = ih_entry_count(ih);
diff -puN include/linux/reiserfs_fs.h~reiserfs-fix-warnings-with-gcc-44 include/linux/reiserfs_fs.h
--- a/include/linux/reiserfs_fs.h~reiserfs-fix-warnings-with-gcc-44
+++ a/include/linux/reiserfs_fs.h
@@ -660,23 +660,54 @@ static inline void set_le_key_k_type(int
 		   cpu_to_le32(type2uniqueness(type)))
 	    : (void)(set_offset_v2_k_type(&(key->u.k_offset_v2), type));
 }
+
 static inline void set_le_ih_k_type(struct item_head *ih, int type)
 {
 	set_le_key_k_type(ih_version(ih), &(ih->ih_key), type);
 }
 
-#define is_direntry_le_key(version,key) (le_key_k_type (version, key) == TYPE_DIRENTRY)
-#define is_direct_le_key(version,key) (le_key_k_type (version, key) == TYPE_DIRECT)
-#define is_indirect_le_key(version,key) (le_key_k_type (version, key) == TYPE_INDIRECT)
-#define is_statdata_le_key(version,key) (le_key_k_type (version, key) == TYPE_STAT_DATA)
+static inline int is_direntry_le_key(int version, struct reiserfs_key *key)
+{
+	return le_key_k_type(version, key) == TYPE_DIRENTRY;
+}
+
+static inline int is_direct_le_key(int version, struct reiserfs_key *key)
+{
+	return le_key_k_type(version, key) == TYPE_DIRECT;
+}
+
+static inline int is_indirect_le_key(int version, struct reiserfs_key *key)
+{
+	return le_key_k_type(version, key) == TYPE_INDIRECT;
+}
+
+static inline int is_statdata_le_key(int version, struct reiserfs_key *key)
+{
+	return le_key_k_type(version, key) == TYPE_STAT_DATA;
+}
 
 //
 // item header has version.
 //
-#define is_direntry_le_ih(ih) is_direntry_le_key (ih_version (ih), &((ih)->ih_key))
-#define is_direct_le_ih(ih) is_direct_le_key (ih_version (ih), &((ih)->ih_key))
-#define is_indirect_le_ih(ih) is_indirect_le_key (ih_version(ih), &((ih)->ih_key))
-#define is_statdata_le_ih(ih) is_statdata_le_key (ih_version (ih), &((ih)->ih_key))
+static inline int is_direntry_le_ih(struct item_head *ih)
+{
+	return is_direntry_le_key(ih_version(ih), &ih->ih_key);
+}
+
+static inline int is_direct_le_ih(struct item_head *ih)
+{
+	return is_direct_le_key(ih_version(ih), &ih->ih_key);
+}
+
+static inline int is_indirect_le_ih(struct item_head *ih)
+{
+	return is_indirect_le_key(ih_version(ih), &ih->ih_key);
+}
+
+static inline int is_statdata_le_ih(struct item_head *ih)
+{
+	return is_statdata_le_key(ih_version(ih), &ih->ih_key);
+}
 
 //
 // key is pointer to cpu key, result is cpu
_

Patches currently in -mm which might be from jeffm@jeffreymahoney.com are

origin.patch

