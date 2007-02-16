From: akpm@linux-foundation.org
Subject: - mincore-config_swap=n-fix.patch removed from -mm tree
Date: Fri, 16 Feb 2007 00:02:36 -0800
Message-ID: <200702160802.l1G82a2Y023946@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58775 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966181AbXBPIC5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 03:02:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mincore: CONFIG_SWAP=n fix
has been removed from the -mm tree.  Its filename was
     mincore-config_swap=n-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mincore: CONFIG_SWAP=n fix
From: Nick Piggin <npiggin@suse.de>

Fix mincore-anon patch to compile with CONFIG_SWAP=n

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/mincore.c~mincore-config_swap=n-fix mm/mincore.c
--- a/mm/mincore.c~mincore-config_swap=n-fix
+++ a/mm/mincore.c
@@ -116,8 +116,13 @@ static long do_mincore(unsigned long add
 				/* migration entries are always uptodate */
 				present = 1;
 			} else {
+#ifdef CONFIG_SWAP
 				pgoff = entry.val;
 				present = mincore_page(&swapper_space, pgoff);
+#else
+				WARN_ON(1);
+				present = 1;
+#endif
 			}
 		}
 	}
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
git-block.patch
fs-fix-__block_write_full_page-error-case-buffer-submission.patch
fs-fix-libfs-data-leak.patch
fs-fix-nobh-data-leak.patch
