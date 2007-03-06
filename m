From: akpm@linux-foundation.org
Subject: - reiser4-decribe-new-atom-locking-and-nested-atom-locks-to-lock-validator.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:59:59 -0800
Message-ID: <200703060159.l261xx9w008662@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46588 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965660AbXCFCAH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:00:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zam@namesys.com, reiser@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: decribe new atom locking and nested atom locks to lock validator
has been removed from the -mm tree.  Its filename was
     reiser4-decribe-new-atom-locking-and-nested-atom-locks-to-lock-validator.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: decribe new atom locking and nested atom locks to lock validator
From: Alexaner Zarochentsev <zam@namesys.com>

lock validator friendly locking of new atom in atom_begin_and_assign_to_txnh
and locking of two atoms.

Signed-off-by: Alexander Zarochentsev <zam@namesys.com>
Cc: Hans Reiser <reiser@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/txnmgr.c |   20 +++++++++++---------
 fs/reiser4/txnmgr.h |   15 +++++++++++++++
 2 files changed, 26 insertions(+), 9 deletions(-)

diff -puN fs/reiser4/txnmgr.c~reiser4-decribe-new-atom-locking-and-nested-atom-locks-to-lock-validator fs/reiser4/txnmgr.c
--- a/fs/reiser4/txnmgr.c~reiser4-decribe-new-atom-locking-and-nested-atom-locks-to-lock-validator
+++ a/fs/reiser4/txnmgr.c
@@ -397,7 +397,7 @@ static void atom_init(txn_atom * atom)
 	INIT_LIST_HEAD(ATOM_OVRWR_LIST(atom));
 	INIT_LIST_HEAD(ATOM_WB_LIST(atom));
 	INIT_LIST_HEAD(&atom->inodes);
-	spin_lock_init(&atom->alock);
+	spin_lock_init(&(atom->alock));
 	/* list of transaction handles */
 	INIT_LIST_HEAD(&atom->txnh_list);
 	/* link to transaction manager's list of atoms */
@@ -732,10 +732,12 @@ static int atom_begin_and_assign_to_txnh
 	assert("jmacd-17", atom_isclean(atom));
 
         /*
-	 * do not use spin_lock_atom because we have broken lock ordering here
-	 * which is ok, as long as @atom is new and inaccessible for others.
+	 * lock ordering is broken here. It is ok, as long as @atom is new
+	 * and inaccessible for others. We can't use spin_lock_atom or
+	 * spin_lock(&atom->alock) because they care about locking
+	 * dependencies. spin_trylock_lock doesn't.
 	 */
-	spin_lock(&(atom->alock));
+	check_me("", spin_trylock_atom(atom));
 
 	/* add atom to the end of transaction manager's list of atoms */
 	list_add_tail(&atom->atom_link, &mgr->atoms_list);
@@ -751,7 +753,7 @@ static int atom_begin_and_assign_to_txnh
 	atom->super = reiser4_get_current_sb();
 	capture_assign_txnh_nolock(atom, txnh);
 
-	spin_unlock(&(atom->alock));
+	spin_unlock_atom(atom);
 	spin_unlock_txnh(txnh);
 
 	return -E_REPEAT;
@@ -2111,11 +2113,11 @@ static void fuse_not_fused_lock_owners(t
 		atomic_inc(&atomf->refcount);
 		spin_unlock_txnh(ctx->trans);
 		if (atomf > atomh) {
-			spin_lock_atom(atomf);
+			spin_lock_atom_nested(atomf);
 		} else {
 			spin_unlock_atom(atomh);
 			spin_lock_atom(atomf);
-			spin_lock_atom(atomh);
+			spin_lock_atom_nested(atomh);
 		}
 		if (atomh == atomf || !atom_isopen(atomh) || !atom_isopen(atomf)) {
 			release_two_atoms(atomf, atomh);
@@ -2793,10 +2795,10 @@ static void lock_two_atoms(txn_atom * on
 	/* lock the atom with lesser address first */
 	if (one < two) {
 		spin_lock_atom(one);
-		spin_lock_atom(two);
+		spin_lock_atom_nested(two);
 	} else {
 		spin_lock_atom(two);
-		spin_lock_atom(one);
+		spin_lock_atom_nested(one);
 	}
 }
 
diff -puN fs/reiser4/txnmgr.h~reiser4-decribe-new-atom-locking-and-nested-atom-locks-to-lock-validator fs/reiser4/txnmgr.h
--- a/fs/reiser4/txnmgr.h~reiser4-decribe-new-atom-locking-and-nested-atom-locks-to-lock-validator
+++ a/fs/reiser4/txnmgr.h
@@ -503,6 +503,7 @@ static inline void spin_lock_atom(txn_at
 {
 	/* check that spinlocks of lower priorities are not held */
 	assert("", (LOCK_CNT_NIL(spin_locked_txnh) &&
+		    LOCK_CNT_NIL(spin_locked_atom) &&
 		    LOCK_CNT_NIL(spin_locked_jnode) &&
 		    LOCK_CNT_NIL(spin_locked_zlock) &&
 		    LOCK_CNT_NIL(rw_locked_dk) &&
@@ -514,6 +515,20 @@ static inline void spin_lock_atom(txn_at
 	LOCK_CNT_INC(spin_locked);
 }
 
+static inline void spin_lock_atom_nested(txn_atom *atom)
+{
+	assert("", (LOCK_CNT_NIL(spin_locked_txnh) &&
+		    LOCK_CNT_NIL(spin_locked_jnode) &&
+		    LOCK_CNT_NIL(spin_locked_zlock) &&
+		    LOCK_CNT_NIL(rw_locked_dk) &&
+		    LOCK_CNT_NIL(rw_locked_tree)));
+
+	spin_lock_nested(&(atom->alock), SINGLE_DEPTH_NESTING);
+
+	LOCK_CNT_INC(spin_locked_atom);
+	LOCK_CNT_INC(spin_locked);
+}
+
 static inline int spin_trylock_atom(txn_atom *atom)
 {
 	if (spin_trylock(&(atom->alock))) {
_

Patches currently in -mm which might be from zam@namesys.com are

reiser4.patch
reiser4-decribe-new-atom-locking-and-nested-atom-locks-to-lock-validator.patch
reiser4-use-generic-file-read.patch
reiser4-use-generic-file-read-fix-readpages-unix-file.patch
reiser4-simplify-reading-of-partially-converted-files.patch
reiser4-use-page_offset.patch
reiser4-use-reiser4_gfp_mask_get-in-reiser4-inode-allocation.patch
reiser4-re-add-page_count-check-to-reiser4_releasepage.patch
reiser4-restore-fibmap-ioctl-support-for-packed-files.patch
reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress.patch
