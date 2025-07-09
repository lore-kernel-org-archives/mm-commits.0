Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF13242D8A
	for <mm-commits@vger.kernel.org>; Wed,  9 Jul 2025 22:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752099458; cv=none; b=iU7tDDA3WtIR89vZp3j5/jyVQ+xTh8VVEag2Bmnr5UjrxZd0kp0m5z4gTqBo2ygPag6bE+w6HGTPBbXZF49j7Q7lxWl65PVfpV0Gwt1VR/+WaqleX64mGQN1DaJH4M76QscyVABTLi3NkFh6nqJ9SIKKn3NEwLrZHVZm6t7xO5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752099458; c=relaxed/simple;
	bh=opd7HTOkXT+MJo9PjVrf/gKul+8gJa77+pTuty0jECg=;
	h=Date:To:From:Subject:Message-Id; b=Yi2PLC8E5uQnULe5sFC6MTC75vwsryxn/vJwPr4+mhVo3aGJ4cAUIvv9/dzSSxB0pyk9YE/G5XRZUpBX9WUA7hUtOeEpYiQ+VX+wHY3hLpdHQobkT5kGj72oIwE+vVibEAgg2DaXEfb++GkpfZyeToFOpD/CUZXtMNvN5Me2bDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KIudltOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KIudltOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A91C4CEEF;
	Wed,  9 Jul 2025 22:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752099457;
	bh=opd7HTOkXT+MJo9PjVrf/gKul+8gJa77+pTuty0jECg=;
	h=Date:To:From:Subject:From;
	b=KIudltOLFmNvh6NhugS3in+Tk3o+skVrDAbcWoF2kGPkjg3llhpFcx6elMvTJ7et6
	 q+R+p/QILbj9ZC7zmfZoKNUvzGbFpmDPIdG00ahfKDH+lRGlU1ZOevz+VGJSYVNpi/
	 mA8C0um3VlHwObsDP9rXg4Ep9eIK1T9ASE8JjLyc=
Date: Wed, 09 Jul 2025 15:17:37 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,linux@jordanrome.com,david@redhat.com,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unmap_and_put_page.patch added to mm-new branch
Message-Id: <20250709221737.97A91C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove unmap_and_put_page()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-unmap_and_put_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-unmap_and_put_page.patch

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm: remove unmap_and_put_page()
Date: Wed, 9 Jul 2025 12:40:18 -0700

There are no callers of unmap_and_put_page() left. Remove it.

Link: https://lkml.kernel.org/r/20250709194017.927978-6-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jordan Rome <linux@jordanrome.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/highmem.h~mm-remove-unmap_and_put_page
+++ a/include/linux/highmem.h
@@ -682,10 +682,4 @@ static inline void folio_release_kmap(st
 	kunmap_local(addr);
 	folio_put(folio);
 }
-
-static inline void unmap_and_put_page(struct page *page, void *addr)
-{
-	folio_release_kmap(page_folio(page), addr);
-}
-
 #endif /* _LINUX_HIGHMEM_H */
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-memoryc-use-folios-in-__copy_remote_vm_str.patch
mm-memoryc-use-folios-in-__access_remote_vm.patch
mm-remove-unmap_and_put_page.patch

