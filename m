From: akpm@linux-foundation.org
Subject: + fix-the-max-path-calculation-in-radix-treec.patch added to -mm tree
Date: Tue, 21 Aug 2007 14:00:36 -0700
Message-ID: <200708212100.l7LL0anM010716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43240 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751916AbXHUVAv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Aug 2007 17:00:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmoyer@redhat.com, nickpiggin@yahoo.com.au


The patch titled
     fix the max path calculation in radix-tree.c
has been added to the -mm tree.  Its filename is
     fix-the-max-path-calculation-in-radix-treec.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix the max path calculation in radix-tree.c
From: Jeff Moyer <jmoyer@redhat.com>

A while back, Nick Piggin introduced a patch to reduce the node memory
usage for small files (commit cfd9b7df4abd3257c9e381b0e445817b26a51c0c):

-#define RADIX_TREE_MAP_SHIFT	6
+#define RADIX_TREE_MAP_SHIFT	(CONFIG_BASE_SMALL ? 4 : 6)

Unfortunately, he didn't take into account the fact that the
calculation of the maximum path was based on an assumption of having
to round up:

#define RADIX_TREE_MAX_PATH (RADIX_TREE_INDEX_BITS/RADIX_TREE_MAP_SHIFT + 2)

So, if CONFIG_BASE_SMALL is set, you will end up with a
RADIX_TREE_MAX_PATH that is one greater than necessary.  The practical
upshot of this is just a bit of wasted memory (one long in the
height_to_maxindex array, an extra pre-allocated radix tree node per
cpu, and extra stack usage in a couple of functions), but it seems
worth getting right.

It's also worth noting that I never build with CONFIG_BASE_SMALL.
What I did to test this was duplicate the code in a small user-space
program and check the results of the calculations for max path and the
contents of the height_to_maxindex array.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/radix-tree.c~fix-the-max-path-calculation-in-radix-treec lib/radix-tree.c
--- a/lib/radix-tree.c~fix-the-max-path-calculation-in-radix-treec
+++ a/lib/radix-tree.c
@@ -60,7 +60,8 @@ struct radix_tree_path {
 };
 
 #define RADIX_TREE_INDEX_BITS  (8 /* CHAR_BIT */ * sizeof(unsigned long))
-#define RADIX_TREE_MAX_PATH (RADIX_TREE_INDEX_BITS/RADIX_TREE_MAP_SHIFT + 2)
+#define RADIX_TREE_MAX_PATH (DIV_ROUND_UP(RADIX_TREE_INDEX_BITS, \
+					  RADIX_TREE_MAP_SHIFT) + 1)
 
 static unsigned long height_to_maxindex[RADIX_TREE_MAX_PATH] __read_mostly;
 
_

Patches currently in -mm which might be from jmoyer@redhat.com are

fix-the-max-path-calculation-in-radix-treec.patch
aio-account-i-o-wait-time-properly.patch
