From: akpm@linux-foundation.org
Subject: + udf-possible-null-pointer-dereference-while-load_partition.patch added to -mm tree
Date: Thu, 08 Mar 2007 00:34:04 -0800
Message-ID: <200703080834.l288Y4jR023196@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57775 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030280AbXCHIeN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Mar 2007 03:34:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@openvz.org, jack@ucw.cz


The patch titled
     udf: possible null pointer dereference while load_partition
has been added to the -mm tree.  Its filename is
     udf-possible-null-pointer-dereference-while-load_partition.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1405,6 +1405,8 @@ udf_load_partition(struct super_block *s
 
 					pos = udf_block_map(UDF_SB_VAT(sb), 0);
 					bh = sb_bread(sb, pos);
+					if (!bh)
+						return 1;
 					UDF_SB_TYPEVIRT(sb,i).s_start_offset =
 						le16_to_cpu(((struct virtualAllocationTable20 *)bh->b_data + udf_ext0_offset(UDF_SB_VAT(sb)))->lengthHeader) +
 							udf_ext0_offset(UDF_SB_VAT(sb));
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

git-libata-all.patch
git-netdev-all.patch
mpt-fusion-handle-mpt_resume-failure-while-resuming.patch
freevxfs-possible-null-pointer-dereference-fix.patch
reiserfs-possible-null-pointer-dereference-during-resize.patch
irq-add-__must_check-to-request_irq.patch
ext3-dirindex-error-pointer-issues.patch
floppy-handle-device_create_file-failure-while-init.patch
udf-possible-null-pointer-dereference-while-load_partition.patch
