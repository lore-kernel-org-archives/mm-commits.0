From: akpm@linux-foundation.org
Subject: + rmap-move-the-out-to-a-more-proper-place.patch added to -mm tree
Date: Tue, 03 Nov 2009 14:10:19 -0800
Message-ID: <200911032210.nA3MAJ9M014260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754799AbZKCWKf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 17:10:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shijie8@gmail.com, fengguang.wu@intel.com


The patch titled
     rmap: move label `out' to a better place
has been added to the -mm tree.  Its filename is
     rmap-move-the-out-to-a-more-proper-place.patch

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
Subject: rmap: move label `out' to a better place
From: Huang Shijie <shijie8@gmail.com>

When the code jumps to the `out', `referenced' is still zero.  So there is
no need to check it.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/rmap.c~rmap-move-the-out-to-a-more-proper-place mm/rmap.c
--- a/mm/rmap.c~rmap-move-the-out-to-a-more-proper-place
+++ a/mm/rmap.c
@@ -388,9 +388,10 @@ static int page_referenced_one(struct pa
 out_unmap:
 	(*mapcount)--;
 	pte_unmap_unlock(pte, ptl);
-out:
+
 	if (referenced)
 		*vm_flags |= vma->vm_flags;
+out:
 	return referenced;
 }
 
_

Patches currently in -mm which might be from shijie8@gmail.com are

rmap-fix-the-comment-for-try_to_unmap_anon.patch
rmap-simplify-try_to_unmap_file.patch
rmap-move-the-out-to-a-more-proper-place.patch

