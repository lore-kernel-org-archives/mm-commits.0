From: akpm@linux-foundation.org
Subject: + mm-try-both-endianess-when-checking-for-endianess.patch added to -mm tree
Date: Mon, 25 Feb 2008 11:37:43 -0800
Message-ID: <200802251938.m1PJceYf016143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756693AbYBYTi7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Feb 2008 14:38:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chris@mips.com, hugh@veritas.com, ralf@linux-mips.org


The patch titled
     mm: try both endianess when checking for endianess.
has been added to the -mm tree.  Its filename is
     mm-try-both-endianess-when-checking-for-endianess.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: try both endianess when checking for endianess.
From: Chris Dearman <chris@mips.com>

When checking for the swap header try byteswapping the endianess dependent
fields to allow the swap partition to be shared between big & little endian
systems.

Signed-off-by: Chris Dearman <chris@mips.com>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Hugh Dickins <hugh@veritas.com>
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

mm-try-both-endianess-when-checking-for-endianess.patch
