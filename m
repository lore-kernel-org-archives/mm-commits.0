From: akpm@linux-foundation.org
Subject: + iommu-helper-simplify-find_next_zero_area.patch added to -mm tree
Date: Fri, 09 Oct 2009 16:43:47 -0700
Message-ID: <200910092343.n99NhltL030443@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933064AbZJIXo5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 19:44:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, fujita.tomonori@lab.ntt.co.jp, joerg.roedel@amd.com


The patch titled
     iommu-helper: simplify find_next_zero_area
has been added to the -mm tree.  Its filename is
     iommu-helper-simplify-find_next_zero_area.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iommu-helper: simplify find_next_zero_area
From: Akinobu Mita <akinobu.mita@gmail.com>

Use find_next_bit instead of doing test_bit for each bit

Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN lib/iommu-helper.c~iommu-helper-simplify-find_next_zero_area lib/iommu-helper.c
--- a/lib/iommu-helper.c~iommu-helper-simplify-find_next_zero_area
+++ a/lib/iommu-helper.c
@@ -21,11 +21,10 @@ again:
 	end = index + nr;
 	if (end >= size)
 		return -1;
-	for (i = index; i < end; i++) {
-		if (test_bit(i, map)) {
-			start = i+1;
-			goto again;
-		}
+	i = find_next_bit(map, end, index);
+	if (i < end) {
+		start = i + 1;
+		goto again;
 	}
 	return index;
 }
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

iommu-helper-simplify-find_next_zero_area.patch
bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area.patch
iommu-helper-use-bitmap-library.patch
isp1362-hcd-use-bitmap_find_next_zero_area.patch
mlx4-use-bitmap_find_next_zero_area.patch
sparc-use-bitmap_find_next_zero_area.patch
ia64-use-bitmap_find_next_zero_area.patch
genalloc-use-bitmap_find_next_zero_area.patch

