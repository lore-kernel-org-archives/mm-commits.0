From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-v2.patch removed from -mm tree
Date: Wed, 25 Mar 2015 15:51:49 -0700
Message-ID: <55133c05.GUyyMkv+VUIu+m2L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbbCYWvt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Mar 2015 18:51:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chianglungyu@gmail.com, koct9i@gmail.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-v2
has been removed from the -mm tree.  Its filename was
     mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-v2.patch

This patch was dropped because it was folded into mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch

------------------------------------------------------
From: Leon Yu <chianglungyu@gmail.com>
Subject: mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-v2

Also suggested by Michal Hocko, we can clean up vma_adjust() a bit as
anon_vma_clone() now does the work.

Signed-off-by: Leon Yu <chianglungyu@gmail.com>
Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/mmap.c~mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-v2 mm/mmap.c
--- a/mm/mmap.c~mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-v2
+++ a/mm/mmap.c
@@ -774,10 +774,8 @@ again:			remove_next = 1 + (end > next->
 
 			importer->anon_vma = exporter->anon_vma;
 			error = anon_vma_clone(importer, exporter);
-			if (error) {
-				importer->anon_vma = NULL;
+			if (error)
 				return error;
-			}
 		}
 	}
 
_

Patches currently in -mm which might be from chianglungyu@gmail.com are

mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch

