From: akpm@linux-foundation.org
Subject: - mem-controller-gfp-mask-fix.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:03:37 -0800
Message-ID: <200802080803.m1883I5Y014111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48912 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758463AbYBHITh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@gmail.com, pbadari@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     mem-controller gfp-mask fix
has been removed from the -mm tree.  Its filename was
     mem-controller-gfp-mask-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mem-controller gfp-mask fix
From: Badari Pulavarty <pbadari@gmail.com>

Need to strip __GFP_HIGHMEM flag while passing to mem_container_cache_charge().

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/filemap.c~mem-controller-gfp-mask-fix mm/filemap.c
--- a/mm/filemap.c~mem-controller-gfp-mask-fix
+++ a/mm/filemap.c
@@ -460,7 +460,8 @@ int filemap_write_and_wait_range(struct 
 int add_to_page_cache(struct page *page, struct address_space *mapping,
 		pgoff_t offset, gfp_t gfp_mask)
 {
-	int error = mem_cgroup_cache_charge(page, current->mm, gfp_mask);
+	int error = mem_cgroup_cache_charge(page, current->mm,
+					gfp_mask & ~__GFP_HIGHMEM);
 	if (error)
 		goto out;
 
_

Patches currently in -mm which might be from pbadari@gmail.com are

origin.patch
