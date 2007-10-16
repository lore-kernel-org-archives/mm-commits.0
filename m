From: akpm@linux-foundation.org
Subject: - ext2-balloc-use-io_error-label.patch removed from -mm tree
Date: Tue, 16 Oct 2007 15:50:58 -0700
Message-ID: <200710162250.l9GMowOj021869@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43408 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754718AbXJPWvO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 18:51:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, cmm@us.ibm.com, mbligh@google.com, mm-commits@vger.kernel.org


The patch titled
     ext2 balloc: use io_error label
has been removed from the -mm tree.  Its filename was
     ext2-balloc-use-io_error-label.patch

This patch was dropped because it was folded into ext2-reservations.patch

------------------------------------------------------
Subject: ext2 balloc: use io_error label
From: Hugh Dickins <hugh@veritas.com>

ext2_new_blocks has a nice io_error label for setting -EIO, so goto that in
the one place that doesn't already use it.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Martin Bligh <mbligh@google.com>
Acked-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/balloc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/ext2/balloc.c~ext2-balloc-use-io_error-label fs/ext2/balloc.c
--- a/fs/ext2/balloc.c~ext2-balloc-use-io_error-label
+++ a/fs/ext2/balloc.c
@@ -1297,10 +1297,9 @@ retry_alloc:
 		if (group_no >= ngroups)
 			group_no = 0;
 		gdp = ext2_get_group_desc(sb, group_no, &gdp_bh);
-		if (!gdp) {
-			*errp = -EIO;
-			goto out;
-		}
+		if (!gdp)
+			goto io_error;
+
 		free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
 		/*
 		 * skip this group if the number of
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
lib-percpu_counter_sub.patch
mm-per-device-dirty-threshold.patch
ext2-reservations.patch
ext2-balloc-use-io_error-label.patch
memory-controller-memory-accounting-v7-fix-swapoff-breakage-however.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
shmem-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
prio_tree-debugging-patch.patch
