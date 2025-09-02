Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E052777FC
	for <mm-commits@vger.kernel.org>; Tue,  2 Sep 2025 23:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756854642; cv=none; b=mg2roQweSJN0T8rb2tXR9cr1arQY5wORlVct2vdTivNqppj8Z2B227YuFEg8YMJKUfJAGzikK18LyuEVLML2Mn7kzgo4/IAHDJySboGMMrrVTjCVhkkL1K1OR65MKhE3oAqcVAg+D+7ksZ8oUdxBaNgxSRSpimnEZrVoOinkUL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756854642; c=relaxed/simple;
	bh=xc5NnfE2IboOxC4cKMBSB2jBcZK5P6uMWwfKvOxkIjg=;
	h=Date:To:From:Subject:Message-Id; b=rWxmainBwSJ4WFtnTB88u4JyI5+sBRLuNooZR8vNuwWUsaTkFj/UmDZ7aguqm74DQC7EKlu3kenzJlOuC8Qmff5aKyZOQNUZji1YRJNPTrUu/O/i+43ru5XMakXEtpJzySb4ZXnREUZ8UIL/rtq+PeF3fGcn84IR1GydHcWOX4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1CwHVyHi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1CwHVyHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D8FC4CEED;
	Tue,  2 Sep 2025 23:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756854641;
	bh=xc5NnfE2IboOxC4cKMBSB2jBcZK5P6uMWwfKvOxkIjg=;
	h=Date:To:From:Subject:From;
	b=1CwHVyHiOJ2Gl441YLPrkW6cvTGkUmFXmGFHlrOPutZ8iBU4KfaJ6rZzJTomA1ZtD
	 vm7KOwVRGmqftIJiqvgsVruaUrFs5oBeV2bjMBJTcKV7WiHmjx+S08L1TAEmrFRKX+
	 Z7wWj+8hOQQcrd4q0CbzEO3IQcXOSLvVMmi4cYy8=
Date: Tue, 02 Sep 2025 16:10:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,fengwei.yin@intel.com,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-optimize-order0-folio-in-filemap_map_pages.patch added to mm-new branch
Message-Id: <20250902231041.96D8FC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: filemap: optimize order0 folio in filemap_map_pages
has been added to the -mm mm-new branch.  Its filename is
     filemap-optimize-order0-folio-in-filemap_map_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-optimize-order0-folio-in-filemap_map_pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: filemap: optimize order0 folio in filemap_map_pages
Date: Tue, 19 Aug 2025 22:06:53 +0800

There are two meaningless folio refcount updates for order 0 folio in
filemap_map_pages().  First, filemap_map_order0_folio() adds folio
refcount after the folio is mapped to pte.  And then, filemap_map_pages()
drops a refcount grabbed by next_uptodate_folio().  We could remain the
refcount unchanged in this case.

With this patch, we can get 8% performance gain for lmbench testcase
'lat_pagefault -P 1 file', the size of file is 512M.

Link: https://lkml.kernel.org/r/20250819140653.3229136-1-tujinjiang@huawei.com
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Fengwei Yin <fengwei.yin@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/filemap.c~filemap-optimize-order0-folio-in-filemap_map_pages
+++ a/mm/filemap.c
@@ -3719,6 +3719,8 @@ skip:
 	}
 
 	vmf->pte = old_ptep;
+	folio_unlock(folio);
+	folio_put(folio);
 
 	return ret;
 }
@@ -3731,7 +3733,7 @@ static vm_fault_t filemap_map_order0_fol
 	struct page *page = &folio->page;
 
 	if (PageHWPoison(page))
-		return ret;
+		goto out;
 
 	/* See comment of filemap_map_folio_range() */
 	if (!folio_test_workingset(folio))
@@ -3743,15 +3745,19 @@ static vm_fault_t filemap_map_order0_fol
 	 * the fault-around logic.
 	 */
 	if (!pte_none(ptep_get(vmf->pte)))
-		return ret;
+		goto out;
 
 	if (vmf->address == addr)
 		ret = VM_FAULT_NOPAGE;
 
 	set_pte_range(vmf, folio, page, 1, addr);
 	(*rss)++;
-	folio_ref_inc(folio);
+	folio_unlock(folio);
+	return ret;
 
+out:
+	folio_unlock(folio);
+	folio_put(folio);
 	return ret;
 }
 
@@ -3809,9 +3815,6 @@ vm_fault_t filemap_map_pages(struct vm_f
 			ret |= filemap_map_folio_range(vmf, folio,
 					xas.xa_index - folio->index, addr,
 					nr_pages, &rss, &mmap_miss);
-
-		folio_unlock(folio);
-		folio_put(folio);
 	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);
 	add_mm_counter(vma->vm_mm, folio_type, rss);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range.patch
filemap-optimize-order0-folio-in-filemap_map_pages.patch

