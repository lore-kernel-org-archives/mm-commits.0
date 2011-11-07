From: akpm@linux-foundation.org
Subject: [obsolete] btrfs-dont-dereference-extent_mapping-if-null.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:23:38 -0800
Message-ID: <201111072023.pA7KNenh026399@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:4638 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab1KGUXp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:23:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, chris.mason@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: btrfs: don't dereference extent_mapping if NULL
has been removed from the -mm tree.  Its filename was
     btrfs-dont-dereference-extent_mapping-if-null.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Roel Kluin <roel.kluin@gmail.com>
Subject: btrfs: don't dereference extent_mapping if NULL

Don't dereference em if it's NULL or an error pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/btrfs/inode.c~btrfs-dont-dereference-extent_mapping-if-null fs/btrfs/inode.c
--- a/fs/btrfs/inode.c~btrfs-dont-dereference-extent_mapping-if-null
+++ a/fs/btrfs/inode.c
@@ -1863,7 +1863,8 @@ static int btrfs_io_failed_hook(struct b
 
 		read_lock(&em_tree->lock);
 		em = lookup_extent_mapping(em_tree, start, failrec->len);
-		if (em->start > start || em->start + em->len < start) {
+		if (em && !IS_ERR(em) && (em->start > start ||
+					em->start + em->len < start)) {
 			free_extent_map(em);
 			em = NULL;
 		}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

