From: akpm@linux-foundation.org
Subject: [merged] logfs-fix-deadlock-in-logfs_get_wblocks-hold-and-wait-on-super-s_write_mutex.patch removed from -mm tree
Date: Thu, 23 Dec 2010 14:36:22 -0800
Message-ID: <201012232240.oBNMeAmx015427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752117Ab0LWWkh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Dec 2010 17:40:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prasadjoshi124@gmail.com, florian@mickler.org, joern@logfs.org, maciej.rutecki@gmail.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     logfs: fix deadlock in logfs_get_wblocks, hold and wait on super->s_write_mutex
has been removed from the -mm tree.  Its filename was
     logfs-fix-deadlock-in-logfs_get_wblocks-hold-and-wait-on-super-s_write_mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: logfs: fix deadlock in logfs_get_wblocks, hold and wait on super->s_write_mutex
From: Prasad Joshi <prasadjoshi124@gmail.com>

do_logfs_journal_wl_pass() should use GFP_NOFS for memory allocation GC
code calls btree_insert32 with GFP_KERNEL while holding a mutex
super->s_write_mutex.  The same mutex is used in
address_space_operations->writepage().  Call to writepage() could be
triggered as a result of memory allocation in btree_insert32, causing a
deadlock.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=20342

Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
Cc: Joern Engel <joern@logfs.org>
Cc: Florian Mickler <florian@mickler.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/logfs/journal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/logfs/journal.c~logfs-fix-deadlock-in-logfs_get_wblocks-hold-and-wait-on-super-s_write_mutex fs/logfs/journal.c
--- a/fs/logfs/journal.c~logfs-fix-deadlock-in-logfs_get_wblocks-hold-and-wait-on-super-s_write_mutex
+++ a/fs/logfs/journal.c
@@ -828,7 +828,7 @@ void do_logfs_journal_wl_pass(struct sup
 		super->s_journal_seg[i] = segno;
 		super->s_journal_ec[i] = ec;
 		logfs_set_segment_reserved(sb, segno);
-		err = btree_insert32(head, segno, (void *)1, GFP_KERNEL);
+		err = btree_insert32(head, segno, (void *)1, GFP_NOFS);
 		BUG_ON(err); /* mempool should prevent this */
 		err = logfs_erase_segment(sb, segno, 1);
 		BUG_ON(err); /* FIXME: remount-ro would be nicer */
_

Patches currently in -mm which might be from prasadjoshi124@gmail.com are

origin.patch

