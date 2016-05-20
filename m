From: akpm@linux-foundation.org
Subject: [patch 018/117] ocfs2: clean up unused parameter 'count' in
 o2hb_read_block_input()
Date: Thu, 19 May 2016 17:09:50 -0700
Message-ID: <573e55ce.zRDu0sNqSKhCHac3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45913 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbcETAJv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:09:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, piaojun@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de

From: Jun Piao <piaojun@huawei.com>
Subject: ocfs2: clean up unused parameter 'count' in o2hb_read_block_input()

Clean up unused parameter 'count' in o2hb_read_block_input().

Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-clean-up-unused-parameter-count-in-o2hb_read_block_input fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-clean-up-unused-parameter-count-in-o2hb_read_block_input
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -1456,7 +1456,6 @@ static void o2hb_region_release(struct c
 
 static int o2hb_read_block_input(struct o2hb_region *reg,
 				 const char *page,
-				 size_t count,
 				 unsigned long *ret_bytes,
 				 unsigned int *ret_bits)
 {
@@ -1499,8 +1498,8 @@ static ssize_t o2hb_region_block_bytes_s
 	if (reg->hr_bdev)
 		return -EINVAL;
 
-	status = o2hb_read_block_input(reg, page, count,
-				       &block_bytes, &block_bits);
+	status = o2hb_read_block_input(reg, page, &block_bytes,
+				       &block_bits);
 	if (status)
 		return status;
 
_
