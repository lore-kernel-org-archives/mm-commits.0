From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 26 Jul 2016 14:58:04 -0700
Message-ID: <5797dcec.7KegWpzZ5hlKZcwX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbcGZV6F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 17:58:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-frontswap-convert-frontswap_enabled-to-static-key.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes

WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
#17: 
Thus, checks for "frontswap_enabled" are replaced with "frontswap_enabled()"

WARNING: space prohibited between function name and open parenthesis '('
#208: FILE: mm/frontswap.c:255:
+	VM_BUG_ON (!frontswap_ops);

total: 0 errors, 2 warnings, 188 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-frontswap-convert-frontswap_enabled-to-static-key.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/frontswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/frontswap.c~mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes mm/frontswap.c
--- a/mm/frontswap.c~mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes
+++ a/mm/frontswap.c
@@ -252,7 +252,7 @@ int __frontswap_store(struct page *page)
 	pgoff_t offset = swp_offset(entry);
 	struct frontswap_ops *ops;
 
-	VM_BUG_ON (!frontswap_ops);
+	VM_BUG_ON(!frontswap_ops);
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(sis == NULL);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-frontswap-convert-frontswap_enabled-to-static-key.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-fix-build-warnings-in-linux-compactionh-fix.patch

