From: akpm@linux-foundation.org
Subject: - fs-ocfs2-use-bug_on.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:46:56 -0800
Message-ID: <200803050746.m257kuUK021807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763464AbYCEHra (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:47:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mm-commits@vger.kernel.org


The patch titled
     fs/ocfs2: Use BUG_ON
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-use-bug_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/ocfs2: Use BUG_ON
From: Julia Lawall <julia@diku.dk>

if (...) BUG(); should be replaced with BUG_ON(...) when the test has no
side-effects to allow a definition of BUG_ON that drops the code completely.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ disable unlikely @ expression E,f; @@

(
  if (<... f(...) ...>) { BUG(); }
|
- if (unlikely(E)) { BUG(); }
+ BUG_ON(E);
)

@@ expression E,f; @@

(
  if (<... f(...) ...>) { BUG(); }
|
- if (E) { BUG(); }
+ BUG_ON(E);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c   |    3 +--
 fs/ocfs2/journal.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/alloc.c~fs-ocfs2-use-bug_on fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~fs-ocfs2-use-bug_on
+++ a/fs/ocfs2/alloc.c
@@ -1029,8 +1029,7 @@ static void ocfs2_rotate_leaf(struct ocf
 	BUG_ON(!next_free);
 
 	/* The tree code before us didn't allow enough room in the leaf. */
-	if (el->l_next_free_rec == el->l_count && !has_empty)
-		BUG();
+	BUG_ON(el->l_next_free_rec == el->l_count && !has_empty);
 
 	/*
 	 * The easiest way to approach this is to just remove the
diff -puN fs/ocfs2/journal.c~fs-ocfs2-use-bug_on fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~fs-ocfs2-use-bug_on
+++ a/fs/ocfs2/journal.c
@@ -586,8 +586,7 @@ int ocfs2_journal_load(struct ocfs2_jour
 
 	mlog_entry_void();
 
-	if (!journal)
-		BUG();
+	BUG_ON(!journal);
 
 	osb = journal->j_osb;
 
_

Patches currently in -mm which might be from julia@diku.dk are

sound-use-bug_on.patch
git-powerpc.patch
git-dvb.patch
git-hid.patch
git-udf.patch
drivers-net-mv643xx_ethc-use-field_sizeof.patch
git-ocfs2.patch
drivers-block-viodasdc-use-field_sizeof.patch
usb-use-div_round_up.patch
drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and.patch
drivers-acpi-asus_acpic-correct-use-of-and.patch
fs-affs-filec-use-bug_on.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch

