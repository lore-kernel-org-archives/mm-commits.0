From: akpm@linux-foundation.org
Subject: - ext2-fix-reservation-extension.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:14:23 -0800
Message-ID: <200703060114.l261ENGP007319@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44473 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933761AbXCFBOi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:14:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmm@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ext3: fix reservation extension
has been removed from the -mm tree.  Its filename was
     ext2-fix-reservation-extension.patch

This patch was dropped because it was folded into ext2-reservations.patch

------------------------------------------------------
Subject: ext3: fix reservation extension
From: Mingming Cao <cmm@us.ibm.com>

Hugh Dickins wrote:
> Not found anything relevant, but I keep noticing these lines
> in ext2_try_to_allocate_with_rsv(), ext3 and ext4 similar:
>
> 		} else if (grp_goal > 0 &&
> 				(my_rsv->rsv_end - grp_goal + 1) < *count)
> 			try_to_extend_reservation(my_rsv, sb,
> 					*count-my_rsv->rsv_end + grp_goal - 1);
>
> They're wrong, a no-op in most groups, aren't they?  rsv_end is an
> absolute block number, whereas grp_goal is group-relative, so the
> calculation ought to bring in group_first_block?  Or I'm confused.
>

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext2/balloc.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN fs/ext2/balloc.c~ext2-fix-reservation-extension fs/ext2/balloc.c
--- a/fs/ext2/balloc.c~ext2-fix-reservation-extension
+++ a/fs/ext2/balloc.c
@@ -1089,10 +1089,14 @@ ext2_try_to_allocate_with_rsv(struct sup
 			if (!goal_in_my_reservation(&my_rsv->rsv_window,
 							grp_goal, group, sb))
 				grp_goal = -1;
-		} else if (grp_goal > 0 &&
-				(my_rsv->rsv_end-grp_goal+1) < *count)
-			try_to_extend_reservation(my_rsv, sb,
-					*count-my_rsv->rsv_end + grp_goal - 1);
+		} else if (grp_goal > 0) {
+			int curr = my_rsv->rsv_end -
+					(grp_goal + group_first_block) + 1;
+
+			if (curr < *count)
+				try_to_extend_reservation(my_rsv, sb,
+							*count - curr);
+		}
 
 		if ((my_rsv->rsv_start > group_last_block) ||
 				(my_rsv->rsv_end < group_first_block)) {
_

Patches currently in -mm which might be from cmm@us.ibm.com are

origin.patch
ext2-reservations.patch
ext2-fix-reservation-extension.patch
ext2-balloc-fix-_with_rsv-freeze.patch
ext2-balloc-reset-windowsz-when-full.patch
ext2-balloc-fix-off-by-one-against-rsv_end.patch
ext2-balloc-fix-off-by-one-against-grp_goal.patch
ext2-balloc-say-rb_entry-not-list_entry.patch
ext2-balloc-use-io_error-label.patch
