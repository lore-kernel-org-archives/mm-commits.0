From: akpm@linux-foundation.org
Subject: - afs-prevent-double-cell-registration.patch removed from -mm tree
Date: Mon, 31 Mar 2008 13:17:37 -0700
Message-ID: <200803312017.m2VKHbAT023986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756187AbYCaUS5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 16:18:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: svens@stackframe.org, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     afs: prevent double cell registration
has been removed from the -mm tree.  Its filename was
     afs-prevent-double-cell-registration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: afs: prevent double cell registration
From: Sven Schnelle <svens@stackframe.org>

kafs doesn't check if the cell already exists - so if you do an echo "add
newcell.org 1.2.3.4" >/proc/fs/afs/cells it will try to create this cell
again.  kobject will also complain about a double registration.  To prevent
such problems, return -EEXIST in that case.

Signed-off-by: Sven Schnelle <svens@stackframe.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/cell.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN fs/afs/cell.c~afs-prevent-double-cell-registration fs/afs/cell.c
--- a/fs/afs/cell.c~afs-prevent-double-cell-registration
+++ a/fs/afs/cell.c
@@ -127,14 +127,20 @@ struct afs_cell *afs_cell_create(const c
 
 	_enter("%s,%s", name, vllist);
 
+	down_write(&afs_cells_sem);
+	read_lock(&afs_cells_lock);
+	list_for_each_entry(cell, &afs_cells, link) {
+		if (strcasecmp(cell->name, name) == 0)
+			goto duplicate_name;
+	}
+	read_unlock(&afs_cells_lock);
+
 	cell = afs_cell_alloc(name, vllist);
 	if (IS_ERR(cell)) {
 		_leave(" = %ld", PTR_ERR(cell));
 		return cell;
 	}
 
-	down_write(&afs_cells_sem);
