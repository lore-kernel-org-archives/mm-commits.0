From: akpm@linux-foundation.org
Subject: + fs-udf-ballocc-mark-a-variable-as-uninitialized_var.patch added to -mm tree
Date: Wed, 26 Sep 2007 14:18:00 -0700
Message-ID: <200709262118.l8QLI0YV004400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36156 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751243AbXIZVSf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 17:18:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com


The patch titled
     fs/udf/balloc.c: mark a variable as uninitialized_var()
has been added to the -mm tree.  Its filename is
     fs-udf-ballocc-mark-a-variable-as-uninitialized_var.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs/udf/balloc.c: mark a variable as uninitialized_var()
From: WANG Cong <xiyou.wangcong@gmail.com>

Kill a may-be-used-uninitialized warning.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

net-bluetooth-hidp-corec-make-hidp_setup_input.patch
fs-romfs-inodec-trivial-improvements.patch
fs-udf-ballocc-mark-a-variable-as-uninitialized_var.patch
