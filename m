Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFB84F8BB
	for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 18:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059690; cv=none; b=cTo1C5cAHA0NsM6x0FUpb8IIQqnoNKgyjv8Fhx2OK+JtyoF4G69SW/9vRP2fKh5hbXKSIl7fn32kdXZVh69SvVktFbMow6Zg6XDXAVWbGTEov2NuyNCyh+vO6Smfc5NIrtI/Pb5DdEOOdBcn23GSk/ZpEMnx5eFnuRVQl3ZpBv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059690; c=relaxed/simple;
	bh=0ygfBjF3tLSFDYBsjm6NCGKabM4HGYKbBNhjw3p34WI=;
	h=Date:To:From:Subject:Message-Id; b=EhGrqrv/5oYHWsUhwuPqwITMIsUyWIORhN0tx8ZSl6HXrSuIgv3o+bARXLbBPfQk7Ay/LYkvUxZcbOzFiXgCtMQUF4rFUTXeC/A6v5FyWmUFTlg23mCGYqoq5H9vGGhIVt+SGBYroKhyxspUvTjaXLZdpnGMD6jXUJ3HTIn78VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sRpX21wB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sRpX21wB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C06C433C7;
	Tue, 27 Feb 2024 18:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709059690;
	bh=0ygfBjF3tLSFDYBsjm6NCGKabM4HGYKbBNhjw3p34WI=;
	h=Date:To:From:Subject:From;
	b=sRpX21wBKI1R1kwDMXg29XqSdsVqBdoqfC9Yz/2g21jhrD3F4iNhL9kZuVfVYUEN1
	 uYNuVSambwdMc4cpffFtciR0wsSCyLekfTLuHgAL6GcVAUaMZG9yMMft4rjjwD3uwl
	 QZ9+v3SLH+65hgnELbxW+AgGraGXxf38S/8r5Dno=
Date: Tue, 27 Feb 2024 10:48:09 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-lru_to_page.patch added to mm-unstable branch
Message-Id: <20240227184809.E1C06C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove lru_to_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-lru_to_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-lru_to_page.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove lru_to_page()
Date: Tue, 27 Feb 2024 17:42:49 +0000

The last user was removed over a year ago; remove the definition.

Link: https://lkml.kernel.org/r/20240227174254.710559-16-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/mm.h~mm-remove-lru_to_page
+++ a/include/linux/mm.h
@@ -227,7 +227,6 @@ int overcommit_policy_handler(struct ctl
 /* test whether an address (unsigned long or pointer) is aligned to PAGE_SIZE */
 #define PAGE_ALIGNED(addr)	IS_ALIGNED((unsigned long)(addr), PAGE_SIZE)
 
-#define lru_to_page(head) (list_entry((head)->prev, struct page, lru))
 static inline struct folio *lru_to_folio(struct list_head *head)
 {
 	return list_entry((head)->prev, struct folio, lru);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-support-order-1-folios-in-the-page-cache.patch
mm-make-folios_put-the-basis-of-release_pages.patch
mm-convert-free_unref_page_list-to-use-folios.patch
mm-add-free_unref_folios.patch
mm-use-folios_put-in-__folio_batch_release.patch
memcg-add-mem_cgroup_uncharge_folios.patch
mm-remove-use-of-folio-list-from-folios_put.patch
mm-use-free_unref_folios-in-put_pages_list.patch
mm-use-__page_cache_release-in-folios_put.patch
mm-handle-large-folios-in-free_unref_folios.patch
mm-allow-non-hugetlb-large-folios-to-be-batch-processed.patch
mm-free-folios-in-a-batch-in-shrink_folio_list.patch
mm-free-folios-directly-in-move_folios_to_lru.patch
memcg-remove-mem_cgroup_uncharge_list.patch
mm-remove-free_unref_page_list.patch
mm-remove-lru_to_page.patch
mm-convert-free_pages_and_swap_cache-to-use-folios_put.patch
mm-use-a-folio-in-__collapse_huge_page_copy_succeeded.patch
mm-convert-free_swap_cache-to-take-a-folio.patch

