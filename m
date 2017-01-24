From: akpm@linux-foundation.org
Subject: [patch 13/26] mm/mempolicy.c: do not put mempolicy before using
 its nodemask
Date: Tue, 24 Jan 2017 15:18:18 -0800
Message-ID: <5887e0ba.aw/pGI4UA1/izEB8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41446 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750931AbdAXXSU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 18:18:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vbabka@suse.cz, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, rientjes@google.com, stable@vger.kernel.org

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
