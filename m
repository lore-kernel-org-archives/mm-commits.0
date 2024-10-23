Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A126F1E4A4
	for <mm-commits@vger.kernel.org>; Wed, 23 Oct 2024 23:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729725318; cv=none; b=URH1Sp6Mf+WtKQEvPFexuTlszyAUoZCVPAgQD4dNW/f6UkThcYmS1PsCSF8QMmpMWIxDVYFtvtl1fh8MHQCmOAy1NyEa7ysHKqsDn49U7XtfNcveQ6Y5eO1wN2JkBb4NEDmrxNEzm1HbcQtQ2QCVyNUTRTGMDJHMMUpuN1h6C1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729725318; c=relaxed/simple;
	bh=wmPgDX1gehnWhEWbP+Cc5ohhvyhMcILCMxoRaQVaopY=;
	h=Date:To:From:Subject:Message-Id; b=VptJSQtf0LmFnQ/WLFucu19rJMmvwY5NAoaKHu4R5x3y9atPqjK+INLymEKkXhlhyswpCQ9zIytzBK3JZxawNF+/XtIC/N8sxbjEdu4qXYCb49AQozL7OgoPd/nN9e3XOrSOInPnO0iHNx+QtfbwkYk8KurogWKAt5pO4zitgc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z8g6FulT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z8g6FulT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18912C4CEC6;
	Wed, 23 Oct 2024 23:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729725318;
	bh=wmPgDX1gehnWhEWbP+Cc5ohhvyhMcILCMxoRaQVaopY=;
	h=Date:To:From:Subject:From;
	b=z8g6FulTjy+TEqPoWwWAW3Y085+iLfrrQVF1IzRwW8pjQ4n97dhONb0ZiqflxNsDh
	 iCsz397xxen9c2nMWWZd22rXyrl3nzBZFfmLpIbRKxDCLNTaxbWMZiFwqBXxfOkJ43
	 z8SXy3VE0ae5AV9En3mfjpVTJkz+7jNEViJ6d7Fk=
Date: Wed, 23 Oct 2024 16:15:17 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabkba@suse.cz,vbabka@suse.cz,tsbogend@alpha.franken.de,surenb@google.com,skhan@linuxfoundation.org,sidhartha.kumar@oracle.com,shuah@kernel.org,richard.henderson@linaro.org,paulmck@kernel.org,muchun.song@linux.dev,mattst88@gmail.com,Liam.Howlett@Oracle.com,jhubbard@nvidia.com,jeffxu@chromium.org,jcmvbkbc@gmail.com,jannh@google.com,James.Bottomley@HansenPartnership.com,hch@infradead.org,deller@gmx.de,david@redhat.com,chris@zankel.net,brauner@kernel.org,arnd@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-update-tools-uapi-header-for-mman-commonh.patch added to mm-unstable branch
Message-Id: <20241023231518.18912C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools: testing: update tools UAPI header for mman-common.h
has been added to the -mm mm-unstable branch.  Its filename is
     tools-testing-update-tools-uapi-header-for-mman-commonh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-update-tools-uapi-header-for-mman-commonh.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools: testing: update tools UAPI header for mman-common.h
Date: Wed, 23 Oct 2024 17:24:41 +0100

Import the new MADV_GUARD_INSTALL/REMOVE madvise flags.

Link: https://lkml.kernel.org/r/c3e259919d5b876b9a71ba14fe8d6cb85d51f164.1729699916.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Helge Deller <deller@gmx.de>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Vlastimil Babka <vbabkba@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/uapi/asm-generic/mman-common.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/include/uapi/asm-generic/mman-common.h~tools-testing-update-tools-uapi-header-for-mman-commonh
+++ a/tools/include/uapi/asm-generic/mman-common.h
@@ -79,6 +79,9 @@
 
 #define MADV_COLLAPSE	25		/* Synchronous hugepage collapse */
 
+#define MADV_GUARD_INSTALL 102		/* fatal signal on access to range */
+#define MADV_GUARD_REMOVE 103		/* unguard range */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

fork-do-not-invoke-uffd-on-fork-if-error-occurs.patch
fork-only-invoke-khugepaged-ksm-hooks-if-no-error.patch
mm-vma-add-expand-only-vma-merge-mode-and-optimise-do_brk_flags.patch
tools-testing-add-expand-only-mode-vma-test.patch
mm-avoid-unsafe-vma-hook-invocation-when-error-arises-on-mmap-hook.patch
mm-unconditionally-close-vmas-on-error.patch
mm-refactor-map_deny_write_exec.patch
mm-resolve-faulty-mmap_region-error-path-behaviour.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch
tools-testing-add-additional-vma_internalh-stubs.patch
mm-isolate-mmap-internal-logic-to-mm-vmac.patch
mm-refactor-__mmap_region.patch
mm-defer-second-attempt-at-merge-on-mmap.patch
mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch

