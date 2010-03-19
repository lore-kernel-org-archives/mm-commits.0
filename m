From: akpm@linux-foundation.org
Subject: + tmpfs-mpol=bind-0-dont-cause-mount-error.patch added to -mm tree
Date: Fri, 19 Mar 2010 16:10:45 -0700
Message-ID: <201003192310.o2JNAk46017620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153Ab0CSXMa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 19:12:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, kiran@scalex86.org, lee.schermerhorn@hp.com, mel@csn.ul.ie, stable@kernel.org


The patch titled
     tmpfs: mpol=bind:0 don't cause mount error.
has been added to the -mm tree.  Its filename is
     tmpfs-mpol=bind-0-dont-cause-mount-error.patch

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
Subject: tmpfs: mpol=bind:0 don't cause mount error.
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, following mount operation cause mount error.

% mount -t tmpfs -ompol=bind:0 none /tmp

Because commit 71fe804b6d5 (mempolicy: use struct mempolicy pointer in
shmem_sb_info) corrupted MPOL_BIND parse code.

This patch restore the needed one.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN mm/mempolicy.c~tmpfs-mpol=bind-0-dont-cause-mount-error mm/mempolicy.c
--- a/mm/mempolicy.c~tmpfs-mpol=bind-0-dont-cause-mount-error
+++ a/mm/mempolicy.c
@@ -2222,9 +2222,13 @@ int mpol_parse_str(char *str, struct mem
 		if (!nodelist)
 			err = 0;
 		goto out;
-	/*
-	 * case MPOL_BIND:    mpol_new() enforces non-empty nodemask.
-	 */
+	case MPOL_BIND:
+		/*
+		 * Insist on a nodelist
+		 */
+		if (!nodelist)
+			goto out;
+		err = 0;
 	}
 
 	mode_flags = 0;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
tmpfs-fix-oops-on-mounts-with-mpol=default.patch
tmpfs-mpol=bind-0-dont-cause-mount-error.patch
tmpfs-handle-mpol_local-mount-option-properly.patch
tmpfs-cleanup-mpol_parse_str.patch
doc-add-the-documentation-for-mpol=local.patch
mm-remove-return-value-of-putback_lru_pages.patch
mempolicy-remove-redundant-code.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists-fix.patch
proc-cleanup-remove-unused-assignments.patch
reiser4.patch

