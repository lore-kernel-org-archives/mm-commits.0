From: akpm@linux-foundation.org
Subject: + mm-mminit_validate_memmodel_limits-get-rid-of-redundant-test.patch added to -mm tree
Date: Mon, 12 Jan 2009 15:14:51 -0800
Message-ID: <200901122314.n0CNEpRK002934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753775AbZALXPN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 18:15:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, cl@linux-foundation.org, gorcunov@openvz.org


The patch titled
     mm: mminit_validate_memmodel_limits(): remove redundant test
has been added to the -mm tree.  Its filename is
     mm-mminit_validate_memmodel_limits-get-rid-of-redundant-test.patch

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
Subject: mm: mminit_validate_memmodel_limits(): remove redundant test
From: Cyrill Gorcunov <gorcunov@gmail.com>

In case if start_pfn overlap the upper bound no need to test end_pfn again
since we have it already trimmed.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/sparse.c~mm-mminit_validate_memmodel_limits-get-rid-of-redundant-test mm/sparse.c
--- a/mm/sparse.c~mm-mminit_validate_memmodel_limits-get-rid-of-redundant-test
+++ a/mm/sparse.c
@@ -164,9 +164,7 @@ void __meminit mminit_validate_memmodel_
 		WARN_ON_ONCE(1);
 		*start_pfn = max_sparsemem_pfn;
 		*end_pfn = max_sparsemem_pfn;
-	}
