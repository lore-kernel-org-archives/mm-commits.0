From: akpm@linux-foundation.org
Subject: [folded-merged]
 fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix.patch removed from -mm tree
Date: Fri, 11 Sep 2015 13:03:56 -0700
Message-ID: <55f333ac.+Ieb4QpAKXpA5XI2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbbIKUD5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 16:03:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, broonie@kernel.org, joe@perches.com, jroedel@suse.de, rostedt@goodmis.org, sfr@canb.auug.org.au, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix
has been removed from the -mm tree.  Its filename was
     fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix.patch

This patch was dropped because it was folded into fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix

fix drivers/iommu/omap-iommu-debug.c for fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

Cc: Mark Brown <broonie@kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Joe Perches <joe@perches.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/omap-iommu-debug.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/iommu/omap-iommu-debug.c~fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix drivers/iommu/omap-iommu-debug.c
--- a/drivers/iommu/omap-iommu-debug.c~fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix
+++ a/drivers/iommu/omap-iommu-debug.c
@@ -135,8 +135,9 @@ __dump_tlb_entries(struct omap_iommu *ob
 static ssize_t iotlb_dump_cr(struct omap_iommu *obj, struct cr_regs *cr,
 			     struct seq_file *s)
 {
-	return seq_printf(s, "%08x %08x %01x\n", cr->cam, cr->ram,
+	seq_printf(s, "%08x %08x %01x\n", cr->cam, cr->ram,
 			  (cr->cam & MMU_CAM_P) ? 1 : 0);
+	return 0;
 }
 
 static size_t omap_dump_tlb_entries(struct omap_iommu *obj, struct seq_file *s)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch
revert-ocfs2-dlm-use-list_for_each_entry-instead-of-list_for_each.patch

