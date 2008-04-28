From: akpm@linux-foundation.org
Subject: - mm-try-both-endianess-when-checking-for-endianess.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:51:11 -0700
Message-ID: <200804282151.m3SLpBsx017556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934614AbYD1Vv1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:51:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@mips.com, hugh@veritas.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mm: try both endianess when checking for endianess
has been removed from the -mm tree.  Its filename was
     mm-try-both-endianess-when-checking-for-endianess.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: try both endianess when checking for endianess
From: Chris Dearman <chris@mips.com>

When checking for the swap header try byteswapping the endianess dependent
fields to allow the swap partition to be shared between big & little endian
systems.

Signed-off-by: Chris Dearman <chris@mips.com>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/swapfile.c~mm-try-both-endianess-when-checking-for-endianess mm/swapfile.c
--- a/mm/swapfile.c~mm-try-both-endianess-when-checking-for-endianess
+++ a/mm/swapfile.c
@@ -1582,6 +1582,14 @@ asmlinkage long sys_swapon(const char __
 		error = -EINVAL;
 		goto bad_swap;
 	case 2:
+		/* swap partition endianess hack... */
+		if (swab32(swap_header->info.version) == 1) {
+			swab32s(&swap_header->info.version);
+			swab32s(&swap_header->info.last_page);
+			swab32s(&swap_header->info.nr_badpages);
+			for (i = 0; i < swap_header->info.nr_badpages; i++)
+				swab32s(&swap_header->info.badpages[i]);
+		}
 		/* Check the swap header's sub-version and the size of
                    the swap file and bad block lists */
 		if (swap_header->info.version != 1) {
_

Patches currently in -mm which might be from chris@mips.com are

origin.patch
git-mips.patch

