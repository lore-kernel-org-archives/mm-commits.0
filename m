From: akpm@linux-foundation.org
Subject: - mincore-fill-in-results-properly.patch removed from -mm tree
Date: Fri, 16 Feb 2007 00:02:39 -0800
Message-ID: <200702160802.l1G82dA5023949@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58776 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966183AbXBPIC5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 03:02:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mincore: fill in results properly
has been removed from the -mm tree.  Its filename was
     mincore-fill-in-results-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mincore: fill in results properly
From: Nick Piggin <npiggin@suse.de>

Paper bag time.  Thanks to Randy for noticing that I didn't actually assign
'present' to anything.

Unfortunately my original patch passed the few simple test cases I gave it,
purely by coincidence.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/mincore.c~mincore-fill-in-results-properly mm/mincore.c
--- a/mm/mincore.c~mincore-fill-in-results-properly
+++ a/mm/mincore.c
@@ -125,6 +125,8 @@ static long do_mincore(unsigned long add
 #endif
 			}
 		}
+
+		vec[i] = present;
 	}
 	pte_unmap_unlock(ptep-1, ptl);
 
@@ -135,6 +137,9 @@ none_mapped:
 		pgoff = linear_page_index(vma, addr);
 		for (i = 0; i < nr; i++, pgoff++)
 			vec[i] = mincore_page(vma->vm_file->f_mapping, pgoff);
+	} else {
+		for (i = 0; i < nr; i++)
+			vec[i] = 0;
 	}
 
 	return nr;
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
git-block.patch
fs-fix-__block_write_full_page-error-case-buffer-submission.patch
fs-fix-libfs-data-leak.patch
fs-fix-nobh-data-leak.patch
