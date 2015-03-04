From: akpm@linux-foundation.org
Subject: +
 mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-v2.patch added to -mm tree
Date: Wed, 04 Mar 2015 12:55:17 -0800
Message-ID: <54f77135.cPEhacKd0gQ7ktP1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59967 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbbCDUzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 15:55:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chianglungyu@gmail.com, koct9i@gmail.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-v2
has been added to the -mm tree.  Its filename is
     mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-v2.patch

