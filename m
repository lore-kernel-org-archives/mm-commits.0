From: akpm@linux-foundation.org
Subject: - fs-udf-ballocc-mark-a-variable-as-uninitialized_var.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:01:21 -0700
Message-ID: <200710180701.l9I71Lt8031170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45278 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760154AbXJRHPa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs/udf/balloc.c: mark a variable as uninitialized_var()
has been removed from the -mm tree.  Its filename was
     fs-udf-ballocc-mark-a-variable-as-uninitialized_var.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs/udf/balloc.c: mark a variable as uninitialized_var()
From: WANG Cong <xiyou.wangcong@gmail.com>

Kill a may-be-used-uninitialized warning.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/balloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/udf/balloc.c~fs-udf-ballocc-mark-a-variable-as-uninitialized_var fs/udf/balloc.c
--- a/fs/udf/balloc.c~fs-udf-ballocc-mark-a-variable-as-uninitialized_var
+++ a/fs/udf/balloc.c
@@ -689,7 +689,7 @@ static int udf_table_new_block(struct su
 	uint32_t spread = 0xFFFFFFFF, nspread = 0xFFFFFFFF;
 	uint32_t newblock = 0, adsize;
 	uint32_t elen, goal_elen = 0;
-	kernel_lb_addr eloc, goal_eloc;
+	kernel_lb_addr eloc, uninitialized_var(goal_eloc);
 	struct extent_position epos, goal_epos;
 	int8_t etype;
 
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
drivers-net-wireless-b43-mainc-fix-an-uninitialized.patch
