From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-print-out-information-of-file-affected-by-memory-error.patch removed from -mm tree
Date: Tue, 18 Dec 2012 15:04:19 -0800
Message-ID: <20121218230419.D97F8200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f201.google.com ([209.85.217.201]:34923 "EHLO
	mail-lb0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2LRXEW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 18:04:22 -0500
Received: by mail-lb0-f201.google.com with SMTP id m4so75549lbo.2
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 15:04:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, j-nomura@ce.jp.nec.com, jack@suse.cz, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: print out information of file affected by memory error
has been removed from the -mm tree.  Its filename was
     mm-print-out-information-of-file-affected-by-memory-error.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: print out information of file affected by memory error

Printing out the information about which file can be affected by a memory
error in generic_error_remove_page() is helpful for user to estimate the
impact of the error.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/truncate.c~mm-print-out-information-of-file-affected-by-memory-error mm/truncate.c
--- a/mm/truncate.c~mm-print-out-information-of-file-affected-by-memory-error
+++ a/mm/truncate.c
@@ -151,14 +151,20 @@ int truncate_inode_page(struct address_s
  */
 int generic_error_remove_page(struct address_space *mapping, struct page *page)
 {
+	struct inode *inode;
+
 	if (!mapping)
 		return -EINVAL;
+	inode = mapping->host;
 	/*
 	 * Only punch for normal data pages for now.
 	 * Handling other types like directories would need more auditing.
 	 */
-	if (!S_ISREG(mapping->host->i_mode))
+	if (!S_ISREG(inode->i_mode))
 		return -EIO;
+	pr_info("MCE %#lx: file info pgoff:%lu, inode:%lu, dev:%s\n",
+		page_to_pfn(page), page_index(page),
+		inode->i_ino, inode->i_sb->s_id);
 	return truncate_inode_page(mapping, page);
 }
 EXPORT_SYMBOL(generic_error_remove_page);
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch

