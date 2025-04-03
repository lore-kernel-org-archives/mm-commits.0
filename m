Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D103B666
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 02:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743647196; cv=none; b=SNUWe2RBxjDljytHsuNZ+LdjTFJeuyEb8ewZkB96sTVo8Qxm+l8h6/JDWCFFoeOMEmSIbAtzEXwCq5oi43iSFZNTGrBRZyro9kZR0V8k7TEhzJWLsv0D5Jhis3+YvEcX209yFtSFmzmpDRq1ZbWzu8UiBYHabH3sXdcEdP6CM6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743647196; c=relaxed/simple;
	bh=6zi7EG4UcosNB89XXww+ZCECmp8rXvXPHg2EOEuSGcU=;
	h=Date:To:From:Subject:Message-Id; b=jpxfpvFScCFLGszzAhJXa0evEqWekwGECPyJmH5/SfWmOzg/gAFs2RnRP+OEFZ2eOGRYnwa1kH/LfSTchAfngGrKC7IHSZxnPP3TVsaJLocQw2oOn9IlOyeymSch/J8wddAJKPTWtwz/nfQKwvspQ/UeQGc3u38vk1flvYcyF3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PfeLn8Zw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PfeLn8Zw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD8CC4CEDD;
	Thu,  3 Apr 2025 02:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743647196;
	bh=6zi7EG4UcosNB89XXww+ZCECmp8rXvXPHg2EOEuSGcU=;
	h=Date:To:From:Subject:From;
	b=PfeLn8Zw4zjyNJ++1UG1sqOodf8OWcMDXT3kcDLjFS+oYu/q9PaaIzp9RoATcJRAz
	 9FloIlYlM7bJhAPR3kZi2tYFEBdgR1Xz1woQVmBSiCJLF7UlnJ7/5DIjkYilyICRtu
	 XfJcXnyt9DOdJGDqtRNqO06JXPNdsCzq4DR7uR2g=
Date: Wed, 02 Apr 2025 19:26:35 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + test-suite-use-%zu-to-print-size_t.patch added to mm-hotfixes-unstable branch
Message-Id: <20250403022636.2CD8CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: test suite: use %zu to print size_t
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     test-suite-use-%zu-to-print-size_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/test-suite-use-%zu-to-print-size_t.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: test suite: use %zu to print size_t
Date: Wed, 2 Apr 2025 20:33:11 -0400

On 32-bit, we can't use %lu to print a size_t variable and gcc warns us
about it.  Shame it doesn't warn about it on 64-bit.

Link: https://lkml.kernel.org/r/20250403003311.359917-1-Liam.Howlett@oracle.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Fixes: cc86e0c2f306 ("radix tree test suite: add support for slab bulk APIs")
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

test-suite-use-%zu-to-print-size_t.patch
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

