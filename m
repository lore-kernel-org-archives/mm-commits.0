From: akpm@linux-foundation.org
Subject: [folded-merged] remove-abs64-fix-fix-fix.patch removed from -mm
 tree
Date: Mon, 09 Nov 2015 14:52:21 -0800
Message-ID: <564123a5.nAHt8F3Jw5IUdATD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbbKIWwW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 17:52:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dmitry.torokhov@gmail.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: remove-abs64-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     remove-abs64-fix-fix-fix.patch

This patch was dropped because it was folded into remove-abs64.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: remove-abs64-fix-fix-fix

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/mballoc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ext4/mballoc.c~remove-abs64-fix-fix-fix fs/ext4/mballoc.c
--- a/fs/ext4/mballoc.c~remove-abs64-fix-fix-fix
+++ a/fs/ext4/mballoc.c
@@ -3333,8 +3333,8 @@ ext4_mb_check_group_pa(ext4_fsblk_t goal
 		atomic_inc(&pa->pa_count);
 		return pa;
 	}
-	cur_distance = abs64(goal_block - cpa->pa_pstart);
-	new_distance = abs64(goal_block - pa->pa_pstart);
+	cur_distance = abs(goal_block - cpa->pa_pstart);
+	new_distance = abs(goal_block - pa->pa_pstart);
 
 	if (cur_distance <= new_distance)
 		return cpa;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-abs64.patch
remove-abs64-fix-fix-fix-fix.patch

