From: akpm@linux-foundation.org
Subject: + mm-hugetlb-get-rid-of-redundant-if-operation.patch added to -mm tree
Date: Mon, 05 Jan 2009 15:05:09 -0800
Message-ID: <200901052305.n05N5970024265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889AbZAEXFZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 18:05:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, gorcunov@openvz.org, mingo@elte.hu


The patch titled
     mm: hugetlb: remove redundant `if' operation
has been added to the -mm tree.  Its filename is
     mm-hugetlb-get-rid-of-redundant-if-operation.patch

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
Subject: mm: hugetlb: remove redundant `if' operation
From: Cyrill Gorcunov <gorcunov@gmail.com>

At this point we already know that 'addr' is not NULL so get rid of
redundant 'if'.  Probably gcc eliminate it by optimization pass.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-get-rid-of-redundant-if-operation mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-get-rid-of-redundant-if-operation
+++ a/mm/hugetlb.c
@@ -1024,8 +1024,7 @@ __attribute__((weak)) int alloc_bootmem_
 			 * puts them into the mem_map).
 			 */
 			m = addr;
-			if (m)
-				goto found;
+			goto found;
 		}
 		hstate_next_node(h);
 		nr_nodes--;
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
mm-hugetlb-get-rid-of-redundant-if-operation.patch
mm-hugetlb-get-rid-of-redundant-if-operation-fix.patch
fs-fix-name-overwrite-in-__register_chrdev_region.patch
memcg-add-inactive_anon_is_low.patch

