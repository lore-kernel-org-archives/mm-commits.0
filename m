Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3B2146A71
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 16:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734366843; cv=none; b=L47pa3iqaVZ82uhvAy/mhYTR0zIMJ0DEtrKk/bAAt8JDYwTOtEJooN8rAtW4uR6ggad4r6KYtVDCR0ufCxzBd9jwFgQl3gy5E3XNIeGlRnDg8drIp7ve+WlJigPt9ECio42RNe0+TLXR+l7APiQEzRTW2JXoUkky8XE56MVmxuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734366843; c=relaxed/simple;
	bh=vyjXzX26S4jv+Ul50pmMXfH+Njn8HH93jXh7VOnr3k8=;
	h=Date:To:From:Subject:Message-Id; b=D1ZwbEAVjnLyNxhxAvweueNsqTEHCRf/jrg4W7U3uDWzLK8oKzq1lA3cwfWjEYa0T2iSlJgzk65rR27Qgy7wZxo1neOFGB9soI/Ox2sUhAqm++nFDQxNz/KFbEbTDdaK6R9Bs8UC03IQUQYYR8sgVUxAGlzuzOqkg+CAEMWVafQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ysv2NjB/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ysv2NjB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB62FC4CED0;
	Mon, 16 Dec 2024 16:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734366842;
	bh=vyjXzX26S4jv+Ul50pmMXfH+Njn8HH93jXh7VOnr3k8=;
	h=Date:To:From:Subject:From;
	b=Ysv2NjB/CmG7UedrHgzwq3eEwcBnoUoiY/XdSqgOEzRcqnpneyNnhA6cGkccFzDJ/
	 P5LTLz3SvzEBl1qJgmILEYEJZIdOpi7pMYzNKCpwINZMuxYj9teKSgoXvrY3LiOfTT
	 egJ8UM3lNPxy71wnVTQ6Z7qxwLlgeL1gQ6vkZ2Eo=
Date: Mon, 16 Dec 2024 08:34:02 -0800
To: mm-commits@vger.kernel.org,dhowells@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + iov_iter-remove-setting-of-page-index.patch added to mm-nonmm-unstable branch
Message-Id: <20241216163402.BB62FC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: iov_iter: remove setting of page->index
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     iov_iter-remove-setting-of-page-index.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/iov_iter-remove-setting-of-page-index.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: iov_iter: remove setting of page->index
Date: Mon, 16 Dec 2024 16:12:50 +0000

Nothing actually checks page->index, so just remove it.

Link: https://lkml.kernel.org/r/20241216161253.37687-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kunit_iov_iter.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/lib/kunit_iov_iter.c~iov_iter-remove-setting-of-page-index
+++ a/lib/kunit_iov_iter.c
@@ -63,9 +63,6 @@ static void *__init iov_kunit_create_buf
 		KUNIT_ASSERT_EQ(test, got, npages);
 	}
 
-	for (int i = 0; i < npages; i++)
-		pages[i]->index = i;
-
 	buffer = vmap(pages, npages, VM_MAP | VM_MAP_PUT_PAGES, PAGE_KERNEL);
         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, buffer);
 
_

Patches currently in -mm which might be from willy@infradead.org are

vmalloc-fix-accounting-with-i915.patch
mm-page_alloc-cache-page_zone-result-in-free_unref_page.patch
mm-make-alloc_pages_mpol-static.patch
mm-page_alloc-export-free_frozen_pages-instead-of-free_unref_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-post_alloc_hook.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-prep_new_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-get_page_from_freelist.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_cpuset_fallback.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_may_oom.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_compact.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_reclaim.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_slowpath.patch
mm-page_alloc-move-set_page_refcounted-to-end-of-__alloc_pages.patch
mm-page_alloc-add-__alloc_frozen_pages.patch
mm-mempolicy-add-alloc_frozen_pages.patch
slab-allocate-frozen-pages.patch
ocfs2-handle-a-symlink-read-error-correctly.patch
ocfs2-convert-ocfs2_page_mkwrite-to-use-a-folio.patch
ocfs2-pass-mmap_folio-around-instead-of-mmap_page.patch
ocfs2-convert-ocfs2_read_inline_data-to-take-a-folio.patch
ocfs2-use-a-folio-in-ocfs2_fast_symlink_read_folio.patch
ocfs2-remove-ocfs2_start_walk_page_trans-prototype.patch
iov_iter-remove-setting-of-page-index.patch

