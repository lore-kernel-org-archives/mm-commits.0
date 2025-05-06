Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC9F7263F
	for <mm-commits@vger.kernel.org>; Tue,  6 May 2025 23:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746573637; cv=none; b=ttrC/Zr0RhMi8ZDrLFp+03j3EfzEqJA5fHkZA+Lmqc+zn3356Rj+pQnIQxiCzQjsAuHnd/a7f95OspwfVs4tviqTvR6ee6yaulPwgyBVUlCWzE7Z7cDXui8W9zfY6NLBpqEK6h0MrMr8c10T+gx2WtYiDGGaovbAhpIL2qZ4oHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746573637; c=relaxed/simple;
	bh=CKrVaose7z0MABzKtpZ8AHv6IpB5cMsiO2kXcj1ckwo=;
	h=Date:To:From:Subject:Message-Id; b=lW/YgtrVioz2+kwuAC9ofcYeRYhXbuoPu12E1f6wmbtoCFgAA4qVtXtIILtJgrdYd+bd0kYCn2POhSO5Zlbb7a9+pEXdhkl7USAe6ka2b5n4cpy/hSGm7d3Q+/wbRDQeuCmpm++k3mv9KW/ksyxkCcQITqmJzqR+4DHVdNlbGOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fOWfYdoJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fOWfYdoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E588AC4CEE4;
	Tue,  6 May 2025 23:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746573637;
	bh=CKrVaose7z0MABzKtpZ8AHv6IpB5cMsiO2kXcj1ckwo=;
	h=Date:To:From:Subject:From;
	b=fOWfYdoJVf6pM9p7LdnmvXl888lKCOrTzjH1GFA9SJpdO0wyS/bsORlFSiQuYz/bp
	 NHjT8Jg8uhvHQyF5wH5UrhzNvSN04AgpPG5sesJnWqpZIlBJfP7wir/BxFjEzV0GKT
	 kaZIVsWT6w6cV3cD3MB0gdys8aDn+a8Rl0/BdZCg=
Date: Tue, 06 May 2025 16:20:36 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,jhubbard@nvidia.com,jgg@nvidia.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-mm-gup-section.patch added to mm-hotfixes-unstable branch
Message-Id: <20250506232036.E588AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add mm GUP section
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-mm-gup-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-mm-gup-section.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add mm GUP section
Date: Tue, 6 May 2025 18:36:01 +0100

As part of the ongoing efforts to sub-divide memory management
maintainership and reviewership, establish a section for GUP (Get User
Pages) support and add appropriate maintainers and reviewers.

Link: https://lkml.kernel.org/r/20250506173601.97562-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/MAINTAINERS~maintainers-add-mm-gup-section
+++ a/MAINTAINERS
@@ -15527,6 +15527,18 @@ S:	Maintained
 F:	include/linux/execmem.h
 F:	mm/execmem.c
 
+MEMORY MANAGEMENT - GUP (GET USER PAGES)
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@redhat.com>
+R:	Jason Gunthorpe <jgg@nvidia.com>
+R:	John Hubbard <jhubbard@nvidia.com>
+R:	Peter Xu <peterx@redhat.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	mm/gup.c
+
 MEMORY MANAGEMENT - NUMA MEMBLOCKS AND NUMA EMULATION
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-reverse-mapping-section.patch
maintainers-add-core-mm-section.patch
maintainers-add-mm-thp-section.patch
maintainers-add-mm-thp-section-fix.patch
tools-testing-selftests-fix-guard-region-test-tmpfs-assumption.patch
maintainers-add-mm-gup-section.patch
mm-vma-fix-incorrectly-disallowed-anonymous-vma-merges.patch
tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch
tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch
mm-move-mmap-vma-locking-logic-into-specific-files.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality.patch
mm-abstract-initial-stack-setup-to-mm-subsystem.patch
mm-move-dup_mmap-to-mm.patch
mm-perform-vma-allocation-freeing-duplication-in-mm.patch

