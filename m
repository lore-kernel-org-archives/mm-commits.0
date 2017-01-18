From: akpm@linux-foundation.org
Subject: +
 mm-mempolicyc-do-not-put-mempolicy-before-using-its-nodemask.patch added to -mm tree
Date: Wed, 18 Jan 2017 14:01:31 -0800
Message-ID: <587fe5bb.3QqjoqZQ3wvDB4xg%akpm__21128.4356461421$1484776913$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40252 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753825AbdARWBc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2017 17:01:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy.c: do not put mempolicy before using its nodemask
has been added to the -mm tree.  Its filename is
     mm-mempolicyc-do-not-put-mempolicy-before-using-its-nodemask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicyc-do-not-put-mempolicy-before-using-its-nodemask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicyc-do-not-put-mempolicy-before-using-its-nodemask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/mempolicy.c: do not put mempolicy before using its nodemask

Since commit be97a41b291e ("mm/mempolicy.c: merge alloc_hugepage_vma to
alloc_pages_vma") alloc_pages_vma() can potentially free a mempolicy by
mpol_cond_put() before accessing the embedded nodemask by
__alloc_pages_nodemask().  The commit log says it's so "we can use a
single exit path within the function" but that's clearly wrong.  We can
still do that when doing mpol_cond_put() after the allocation attempt.

Make sure the mempolicy is not freed prematurely, otherwise
__alloc_pages_nodemask() can end up using a bogus nodemask, which could
lead e.g.  to premature OOM.

Fixes: be97a41b291e ("mm/mempolicy.c: merge alloc_hugepage_vma to alloc_pages_vma")
Link: http://lkml.kernel.org/r/20170118141124.8345-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>	[4.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mm-mempolicyc-do-not-put-mempolicy-before-using-its-nodemask mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicyc-do-not-put-mempolicy-before-using-its-nodemask
+++ a/mm/mempolicy.c
@@ -2017,8 +2017,8 @@ retry_cpuset:
 
 	nmask = policy_nodemask(gfp, pol);
 	zl = policy_zonelist(gfp, pol, node);
-	mpol_cond_put(pol);
 	page = __alloc_pages_nodemask(gfp, order, zl, nmask);
+	mpol_cond_put(pol);
 out:
 	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-mempolicyc-do-not-put-mempolicy-before-using-its-nodemask.patch
mm-page_alloc-dont-convert-pfn-to-idx-when-merging.patch
mm-page_alloc-avoid-page_to_pfn-when-merging-buddies.patch
mm-page_alloc-convert-page_group_by_mobility_disable-to-static-key.patch

