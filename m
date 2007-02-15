From: akpm@linux-foundation.org
Subject: + mincore-config_swap=n-fix.patch added to -mm tree
Date: Wed, 14 Feb 2007 19:06:00 -0800
Message-ID: <200702150306.l1F360gr018278@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60033 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964876AbXBODGE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 22:06:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     mincore: CONFIG_SWAP=n fix
has been added to the -mm tree.  Its filename is
     mincore-config_swap=n-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
mincore-config_swap=n-fix.patch
mincore-fill-in-results-properly.patch
mincore-vma-crossing-fix.patch
git-block.patch
mm-remove-gcc-workaround.patch
fs-fix-__block_write_full_page-error-case-buffer-submission.patch
