Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411DE2D0C8C
	for <mm-commits@vger.kernel.org>; Wed,  3 Sep 2025 04:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756875305; cv=none; b=SSPD141nt41ykuSjyV5xkZZvCKcq3xgQt9kB2nfO4tiapJOPq/RyxDG0XIobuBbWSCzS5NBFl8LAJABHpVsZ0JdWbocIw7x16AYVJ4DqH7ANhnnwRjX9fe9HwZ3TUMGk2lSLyrDDQMtS3WRh5v4+hq6zXzTWuhN8JCcpBYSTBkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756875305; c=relaxed/simple;
	bh=wddMZ+ERfsTipCpIAxT0/eGbTovqbrqtsfKKX1TZkfo=;
	h=Date:To:From:Subject:Message-Id; b=u23FcYGqa5aSR8nbzxPCW3V893MmiA335EFMEbWKagCIsoJC7mwp8PFld9/MQuwdFKIiHR2k/M/W9bUt2DHW5wpYlmAvbev3Aa4lUFmRdttk90bm3K0N7qYzuKualk9LDHYthHM/6N85SiA7ojd2bhgexMrE4AYDcz4qPBTwL4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MHDef5rg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MHDef5rg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB69BC4CEF0;
	Wed,  3 Sep 2025 04:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756875304;
	bh=wddMZ+ERfsTipCpIAxT0/eGbTovqbrqtsfKKX1TZkfo=;
	h=Date:To:From:Subject:From;
	b=MHDef5rgKB1f88A5HNRCelnexF6n7Ry9AAMWvrFuIBKQ6JoNLQM76N9Q8VEHJDQU8
	 P/qmT9l7RHltAEZkeAC7WdgOPxDMqrJ9Zauicy8XnEc2Psr+MBlLgiAkfPEiu61CSZ
	 dv1DRpeqDLL8SU3XoCcJZ8imJ5MTv2oeP725FpWo=
Date: Tue, 02 Sep 2025 21:55:04 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,fengwei.yin@intel.com,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] filemap-optimize-order0-folio-in-filemap_map_pages.patch removed from -mm tree
Message-Id: <20250903045504.AB69BC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: filemap: optimize order0 folio in filemap_map_pages
has been removed from the -mm tree.  Its filename was
     filemap-optimize-order0-folio-in-filemap_map_pages.patch

This patch was dropped because an updated version will be issued

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

