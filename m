From: akpm@linux-foundation.org
Subject: - udf-possible-null-pointer-dereference-while-load_partition.patch removed from -mm tree
Date: Tue, 08 May 2007 19:56:07 -0700
Message-ID: <200705090256.l492u7pR010009@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032397AbXEIC4M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:56:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@openvz.org, jack@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     udf: possible null pointer dereference while load_partition
has been removed from the -mm tree.  Its filename was
     udf-possible-null-pointer-dereference-while-load_partition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: udf: possible null pointer dereference while load_partition
From: Dmitriy Monakhov <dmonakhov@openvz.org>

sb_read may return NULL, let's explicitly check it.

Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/super.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/udf/super.c~udf-possible-null-pointer-dereference-while-load_partition fs/udf/super.c
--- a/fs/udf/super.c~udf-possible-null-pointer-dereference-while-load_partition
+++ a/fs/udf/super.c
@@ -1403,6 +1403,8 @@ udf_load_partition(struct super_block *s
 
 					pos = udf_block_map(UDF_SB_VAT(sb), 0);
 					bh = sb_bread(sb, pos);
+					if (!bh)
+						return 1;
 					UDF_SB_TYPEVIRT(sb,i).s_start_offset =
 						le16_to_cpu(((struct virtualAllocationTable20 *)bh->b_data + udf_ext0_offset(UDF_SB_VAT(sb)))->lengthHeader) +
 							udf_ext0_offset(UDF_SB_VAT(sb));
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

origin.patch
