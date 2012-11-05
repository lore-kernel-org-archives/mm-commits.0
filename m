From: akpm@linux-foundation.org
Subject: + mm-print-out-information-of-file-affected-by-memory-error.patch added to -mm tree
Date: Mon, 05 Nov 2012 14:02:20 -0800
Message-ID: <20121105220221.387E0100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:62875 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933253Ab2KEWCW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2012 17:02:22 -0500
Received: by mail-gh0-f202.google.com with SMTP id z15so731920ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 05 Nov 2012 14:02:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, j-nomura@ce.jp.nec.com, jack@suse.cz, tony.luck@intel.com


The patch titled
     Subject: mm: print out information of file affected by memory error
has been added to the -mm tree.  Its filename is
     mm-print-out-information-of-file-affected-by-memory-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

hwpoison-fix-action_result-to-print-out-dirty-clean.patch
mm-print-out-information-of-file-affected-by-memory-error.patch

