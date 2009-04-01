From: akpm@linux-foundation.org
Subject: [merged] mm-mminit_validate_memmodel_limits-get-rid-of-redundant-test.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:34:07 -0700
Message-ID: <200904011834.n31IY7rj006976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765874AbZDASgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:36:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, cl@linux-foundation.org, gorcunov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     mm: mminit_validate_memmodel_limits(): remove redundant test
has been removed from the -mm tree.  Its filename was
     mm-mminit_validate_memmodel_limits-get-rid-of-redundant-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
