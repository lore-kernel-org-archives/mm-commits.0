From: akpm@linux-foundation.org
Subject: [merged] ocfs2-improve-performance-for-localalloc.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:05:45 -0800
Message-ID: <563d0819.jfafttHaw8qQpSuI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033333AbbKFUFp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:05:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.de, norton.zhu@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: improve performance for localalloc
has been removed from the -mm tree.  Its filename was
     ocfs2-improve-performance-for-localalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: improve performance for localalloc

Currently cluster allocation is always trying to find a victim chain (a
chian has most space), and this may lead to poor performance because of
discontiguous allocation in some scenarios.

Our test case is block size 4k, cluster size 1M and mount option with
localalloc=2048 (2G), since a gd is 32256M (about 31.5G) and a localalloc
window is only 2G, creating 50G file will result in 2G from gd0, 2G from
gd1, ...

One way to improve performance is enlarge localalloc window size (max
31104M), but this will make end user feel that about 30G is suddenly
"missing", and localalloc currently do not support steal, which means one
node cannot use another node's localalloc even it is not used in fact.  So
using the last gd to record the allocation and continues with the gd if it
has enough space for a localalloc window can make the allocation as more
contiguous as possible.

Our test result is below (evaluated in IOPS), which is using iometer
running in VM, dynamic vhd virtual disk stored in ocfs2.

IO model                Original   After   Improved(%)
16K60%Write100%Random   703        876     24.59%
8K90%Write100%Random    735        827     12.59%
4K100%Write100%Random   859        915     6.52%
4K100%Read100%Random    2092       2600    24.30%

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Tested-by: Norton Zhu <norton.zhu@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/suballoc.c~ocfs2-improve-performance-for-localalloc fs/ocfs2/suballoc.c
--- a/fs/ocfs2/suballoc.c~ocfs2-improve-performance-for-localalloc
+++ a/fs/ocfs2/suballoc.c
@@ -1920,7 +1920,10 @@ static int ocfs2_claim_suballoc_bits(str
 	status = ocfs2_search_chain(ac, handle, bits_wanted, min_bits,
 				    res, &bits_left);
 	if (!status) {
-		hint = ocfs2_group_from_res(res);
+		if (ocfs2_is_cluster_bitmap(ac->ac_inode))
+			hint = res->sr_bg_blkno;
+		else
+			hint = ocfs2_group_from_res(res);
 		goto set_hint;
 	}
 	if (status < 0 && status != -ENOSPC) {
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-dlm-fix-race-between-convert-and-recovery.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v2.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v3.patch
ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list.patch

