From: akpm@linux-foundation.org
Subject: + mem-controller-gfp-mask-fix.patch added to -mm tree
Date: Tue, 18 Sep 2007 19:08:24 -0700
Message-ID: <200709190208.l8J28OBJ002048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36580 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940AbXISCIa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Sep 2007 22:08:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pbadari@gmail.com, pbadari@us.ibm.com


The patch titled
     mem-controller gfp-mask fix
has been added to the -mm tree.  Its filename is
     mem-controller-gfp-mask-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -440,7 +440,8 @@ int filemap_write_and_wait_range(struct 
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

ext3-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops-fix.patch
mem-controller-gfp-mask-fix.patch
