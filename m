From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch removed from -mm tree
Date: Fri, 27 Mar 2015 11:16:42 -0700
Message-ID: <55159e8a.e2AkKmHQHfv2IO2/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbbC0SQn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Mar 2015 14:16:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chianglungyu@gmail.com, koct9i@gmail.com, mhocko@suse.cz, riel@redhat.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix anon_vma->degree underflow in anon_vma endless growing prevention
has been removed from the -mm tree.  Its filename was
     mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Leon Yu <chianglungyu@gmail.com>
Subject: mm: fix anon_vma->degree underflow in anon_vma endless growing prevention

I have constantly stumbled upon "kernel BUG at mm/rmap.c:399!" after
upgrading to 3.19 and had no luck with 4.0-rc1 neither.

So, after looking into new logic introduced by 7a3ef208e662 ("mm: prevent
endless growth of anon_vma hierarchy"), I found chances are that
unlink_anon_vmas() is called without incrementing dst->anon_vma->degree in
anon_vma_clone() due to allocation failure.  If dst->anon_vma is not NULL
in error path, its degree will be incorrectly decremented in
unlink_anon_vmas() and eventually underflow when exiting as a result of
another call to unlink_anon_vmas().  That's how "kernel BUG at
mm/rmap.c:399!" is triggered for me.

This patch fixes the underflow by dropping dst->anon_vma when allocation
fails.  It's safe to do so regardless of original value of dst->anon_vma
because dst->anon_vma doesn't have valid meaning if anon_vma_clone()
fails.  Besides, callers don't care dst->anon_vma in such case neither.

Also suggested by Michal Hocko, we can clean up vma_adjust() a bit as
anon_vma_clone() now does the work.

[akpm@linux-foundation.org: tweak comment]
Fixes: 7a3ef208e662 ("mm: prevent endless growth of anon_vma hierarchy")
Signed-off-by: Leon Yu <chianglungyu@gmail.com>
Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 +---
 mm/rmap.c |    7 +++++++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff -puN mm/mmap.c~mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention mm/mmap.c
--- a/mm/mmap.c~mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention
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
 
diff -puN mm/rmap.c~mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention mm/rmap.c
--- a/mm/rmap.c~mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention
+++ a/mm/rmap.c
@@ -287,6 +287,13 @@ int anon_vma_clone(struct vm_area_struct
 	return 0;
 
  enomem_failure:
+	/*
+	 * dst->anon_vma is dropped here otherwise its degree can be incorrectly
+	 * decremented in unlink_anon_vmas().
+	 * We can safely do this because callers of anon_vma_clone() don't care
+	 * about dst->anon_vma if anon_vma_clone() failed.
+	 */
+	dst->anon_vma = NULL;
 	unlink_anon_vmas(dst);
 	return -ENOMEM;
 }
_

Patches currently in -mm which might be from chianglungyu@gmail.com are

origin.patch

