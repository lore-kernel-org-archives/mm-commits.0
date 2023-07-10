Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA14BEB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 10 Jul 2023 23:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbjGJXbr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jul 2023 19:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjGJXbq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2023 19:31:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73538A6
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 16:31:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04BBF61262
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 23:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FB7C433C8;
        Mon, 10 Jul 2023 23:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689031904;
        bh=bqc8vsCMd+l1j98+6TxYuc9WCc07dMSb6fTNlIGNTBo=;
        h=Date:To:From:Subject:From;
        b=k9zL7WRxz3qQcwa3CF09mIznO+0cS5XuOZX7sby0FDxGlWiLdNrL1h31IJpFc89TL
         +Vx1gX5Vzicgnnym3LawtR+wlQOfpPrcuAZrAGB2ebL130IwKHo1ZKcYgdlUqN+dTa
         sUz2y166LsISWaGNhaM2VpRm6wZpYEkNZopeY5Vo=
Date:   Mon, 10 Jul 2023 16:31:43 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        fengwei.yin@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-batch-pte-mappings.patch added to mm-unstable branch
Message-Id: <20230710233144.54FB7C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: filemap: batch PTE mappings
has been added to the -mm mm-unstable branch.  Its filename is
     filemap-batch-pte-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-batch-pte-mappings.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yin Fengwei <fengwei.yin@intel.com>
Subject: filemap: batch PTE mappings
Date: Mon, 10 Jul 2023 21:43:38 +0100

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

Link: https://lkml.kernel.org/r/20230710204339.3554919-38-willy@infradead.org
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

filemap-add-filemap_map_folio_range.patch
rmap-add-folio_add_file_rmap_range.patch
mm-convert-do_set_pte-to-set_pte_range.patch
filemap-batch-pte-mappings.patch

