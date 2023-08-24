Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F4FC727BA
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244101AbjHXXWc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244086AbjHXXV6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51009E59
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E413664452
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4778FC433C8;
        Thu, 24 Aug 2023 23:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919315;
        bh=hzi/sLEBKfIdoQO6Xv7p9rC1UMTu2lQGxnGsYnz/O+0=;
        h=Date:To:From:Subject:From;
        b=FQqO+BPHONG7S+4Awc81iBA5Sx1ej1wqFcIx+rJ3YqnduI6zcoAm8tA5WsJELwwv8
         rvvtpYAoLVn81/PWLdJvFU5OJDCmCLwkMjqbd3eaVgJtd55spIv/Sy2udOnhq7gsL9
         mRrTYXNkxDsty08xH/sKWbp5gsEcxJtnMmA2DYe0=
Date:   Thu, 24 Aug 2023 16:21:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        fengwei.yin@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-batch-pte-mappings.patch removed from -mm tree
Message-Id: <20230824232155.4778FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: filemap: batch PTE mappings
has been removed from the -mm tree.  Its filename was
     filemap-batch-pte-mappings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yin Fengwei <fengwei.yin@intel.com>
Subject: filemap: batch PTE mappings
Date: Wed, 2 Aug 2023 16:14:05 +0100

Call set_pte_range() once per contiguous range of the folio instead of
once per page.  This batches the updates to mm counters and the rmap.

With a will-it-scale.page_fault3 like app (change file write fault testing
to read fault testing.  Trying to upstream it to will-it-scale at [1]) got
15% performance gain on a 48C/96T Cascade Lake test box with 96 processes
running against xfs.

Perf data collected before/after the change:
  18.73%--page_add_file_rmap
          |
           --11.60%--__mod_lruvec_page_state
                     |
                     |--7.40%--__mod_memcg_lruvec_state
                     |          |
                     |           --5.58%--cgroup_rstat_updated
                     |
                      --2.53%--__mod_lruvec_state
                                |
                                 --1.48%--__mod_node_page_state

  9.93%--page_add_file_rmap_range
         |
          --2.67%--__mod_lruvec_page_state
                    |
                    |--1.95%--__mod_memcg_lruvec_state
                    |          |
                    |           --1.57%--cgroup_rstat_updated
                    |
                     --0.61%--__mod_lruvec_state
                               |
                                --0.54%--__mod_node_page_state

The running time of __mode_lruvec_page_state() is reduced about 9%.

[1]: https://github.com/antonblanchard/will-it-scale/pull/37

Link: https://lkml.kernel.org/r/20230802151406.3735276-38-willy@infradead.org
Signed-off-by: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

--- a/mm/filemap.c~filemap-batch-pte-mappings
+++ a/mm/filemap.c
@@ -3480,11 +3480,12 @@ static vm_fault_t filemap_map_folio_rang
 	struct file *file = vma->vm_file;
 	struct page *page = folio_page(folio, start);
 	unsigned int mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
-	unsigned int ref_count = 0, count = 0;
+	unsigned int count = 0;
+	pte_t *old_ptep = vmf->pte;
 
 	do {
-		if (PageHWPoison(page))
-			continue;
+		if (PageHWPoison(page + count))
+			goto skip;
 
 		if (mmap_miss > 0)
 			mmap_miss--;
@@ -3494,20 +3495,34 @@ static vm_fault_t filemap_map_folio_rang
 		 * handled in the specific fault path, and it'll prohibit the
 		 * fault-around logic.
 		 */
-		if (!pte_none(*vmf->pte))
-			continue;
+		if (!pte_none(vmf->pte[count]))
+			goto skip;
 
-		if (vmf->address == addr)
+		count++;
+		continue;
+skip:
+		if (count) {
+			set_pte_range(vmf, folio, page, count, addr);
+			folio_ref_add(folio, count);
+			if (in_range(vmf->address, addr, count))
+				ret = VM_FAULT_NOPAGE;
+		}
+
+		count++;
+		page += count;
+		vmf->pte += count;
+		addr += count * PAGE_SIZE;
+		count = 0;
+	} while (--nr_pages > 0);
+
+	if (count) {
+		set_pte_range(vmf, folio, page, count, addr);
+		folio_ref_add(folio, count);
+		if (in_range(vmf->address, addr, count))
 			ret = VM_FAULT_NOPAGE;
+	}
 
-		ref_count++;
-		set_pte_range(vmf, folio, page, 1, addr);
-	} while (vmf->pte++, page++, addr += PAGE_SIZE, ++count < nr_pages);
-
-	/* Restore the vmf->pte */
-	vmf->pte -= nr_pages;
-
-	folio_ref_add(folio, ref_count);
+	vmf->pte = old_ptep;
 	WRITE_ONCE(file->f_ra.mmap_miss, mmap_miss);
 
 	return ret;
_

Patches currently in -mm which might be from fengwei.yin@intel.com are


