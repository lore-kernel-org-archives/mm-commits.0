From: akpm@linux-foundation.org
Subject: [folded-merged] ext4-add-dax-functionality-fix.patch removed from -mm tree
Date: Mon, 16 Feb 2015 15:45:38 -0800
Message-ID: <54e28122.op1BLQpq43pp3ZDj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53933 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbbBPXqP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 18:46:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, matthew.r.wilcox@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ext4-add-dax-functionality-fix
has been removed from the -mm tree.  Its filename was
     ext4-add-dax-functionality-fix.patch

This patch was dropped because it was folded into ext4-add-dax-functionality.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ext4-add-dax-functionality-fix

remap_pages went away

Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/file.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/ext4/file.c~ext4-add-dax-functionality-fix fs/ext4/file.c
--- a/fs/ext4/file.c~ext4-add-dax-functionality-fix
+++ a/fs/ext4/file.c
@@ -206,7 +206,6 @@ static int ext4_dax_mkwrite(struct vm_ar
 static const struct vm_operations_struct ext4_dax_vm_ops = {
 	.fault		= ext4_dax_fault,
 	.page_mkwrite	= ext4_dax_mkwrite,
-	.remap_pages	= generic_file_remap_pages,
 };
 #else
 #define ext4_dax_vm_ops	ext4_file_vm_ops
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-fix-xip-fault-vs-truncate-race.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch
dax-add-dax_zero_page_range.patch
ext4-add-dax-functionality.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch

