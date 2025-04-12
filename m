Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE7CBA42
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744417991; cv=none; b=guLMsZv8ZE+kmChYjJahf3oKlV7NyB8YYhi53xOA98oJqKTtgaYlaq/C4Fnfv3fPfb5uXBoAvKC0Fh9vJQ9NngDtyPJesVr1ABKzyfBzVbJ6afkHv6fUS0ATWgZ9XjFVGDZ88SInB1e4PNl1xmYDaYRHdwLOYZEbdiaqN3RBr7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744417991; c=relaxed/simple;
	bh=g8f7/YgZ/72Fj2SjqewLCwHjhUklZk25Tjjblkp87qw=;
	h=Date:To:From:Subject:Message-Id; b=Vlz+PX21QzEAX6wTh4erUY6ZXOdd+eFzZtyAh3bBmf6+HWmBfbAyvvEniq0PKzRLFC3db6cPIv7YdsgZM1J9j+SLA6weBWf+KA9lk03zDVTIECPrfZhdDSooTduavVkXLBwAGiJCTYQbBZq9ehmuhkLXz6y8/HgvOR3Gm21G51w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qt/lSrwY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qt/lSrwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F342C4CEE2;
	Sat, 12 Apr 2025 00:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744417991;
	bh=g8f7/YgZ/72Fj2SjqewLCwHjhUklZk25Tjjblkp87qw=;
	h=Date:To:From:Subject:From;
	b=Qt/lSrwY3Ah+llaeP+bx97bzBsHV6TB07961drmEz7EJ94c7XfBjWi7ySYRF2bPTa
	 JXwAibLCD/I2bPTxXIqNFi2iO+XHtuYtLliENwjiD1GdY8W5vQSCfzbCAZ4pmbt5Et
	 bIZBNoJrZTYUK2RL3QwgwoqPMEhVPmFWVrOrS8A0=
Date: Fri, 11 Apr 2025 17:33:11 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] test-suite-use-%zu-to-print-size_t.patch removed from -mm tree
Message-Id: <20250412003311.9F342C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: test suite: use %zu to print size_t
has been removed from the -mm tree.  Its filename was
     test-suite-use-%zu-to-print-size_t.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: test suite: use %zu to print size_t
Date: Wed, 2 Apr 2025 20:33:11 -0400

On 32-bit, we can't use %lu to print a size_t variable and gcc warns us
about it.  Shame it doesn't warn about it on 64-bit.

Link: https://lkml.kernel.org/r/20250403003311.359917-1-Liam.Howlett@oracle.com
Fixes: cc86e0c2f306 ("radix tree test suite: add support for slab bulk APIs")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/shared/linux.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/shared/linux.c~test-suite-use-%zu-to-print-size_t
+++ a/tools/testing/shared/linux.c
@@ -150,7 +150,7 @@ void kmem_cache_free(struct kmem_cache *
 void kmem_cache_free_bulk(struct kmem_cache *cachep, size_t size, void **list)
 {
 	if (kmalloc_verbose)
-		pr_debug("Bulk free %p[0-%lu]\n", list, size - 1);
+		pr_debug("Bulk free %p[0-%zu]\n", list, size - 1);
 
 	pthread_mutex_lock(&cachep->lock);
 	for (int i = 0; i < size; i++)
@@ -168,7 +168,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 	size_t i;
 
 	if (kmalloc_verbose)
-		pr_debug("Bulk alloc %lu\n", size);
+		pr_debug("Bulk alloc %zu\n", size);
 
 	pthread_mutex_lock(&cachep->lock);
 	if (cachep->nr_objs >= size) {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-set-the-pte-dirty-if-the-folio-is-already-dirty.patch
mm-introduce-a-common-definition-of-mk_pte.patch
sparc32-remove-custom-definition-of-mk_pte.patch
x86-remove-custom-definition-of-mk_pte.patch
um-remove-custom-definition-of-mk_pte.patch
mm-make-mk_pte-definition-unconditional.patch
mm-add-folio_mk_pte.patch
hugetlb-simplify-make_huge_pte.patch
mm-remove-mk_huge_pte.patch
mm-add-folio_mk_pmd.patch
arch-remove-mk_pmd.patch
filemap-remove-readahead_page.patch
mm-remove-offset_in_thp.patch
iov_iter-convert-iter_xarray_populate_pages-to-use-folios.patch
iov_iter-convert-iov_iter_extract_xarray_pages-to-use-folios.patch
filemap-remove-find_subpage.patch
filemap-convert-__readahead_batch-to-use-a-folio.patch
filemap-remove-readahead_page_batch.patch
mm-delete-thp_nr_pages.patch

