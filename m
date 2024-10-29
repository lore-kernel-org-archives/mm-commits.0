Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B39194A51
	for <mm-commits@vger.kernel.org>; Tue, 29 Oct 2024 01:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730164019; cv=none; b=XwYPn9sca0/hctRj37HpDndhhY/71bQufyZ2I5KNwnWYhYpCDPoJoT2LkwT1T8SqP2fO4c6oMQbcLshYPgdAwLmrSaKpuGgj0EtCu0SoHQpt33LRJirh5wxF9Nll5y7ZsMJZBKf6nOKofaxd1nuE8uGXqT1E9OjXeL0/aaBgz3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730164019; c=relaxed/simple;
	bh=wUxl7XgTfDIzeIoUR+FvmTrK8dq6P6QNJEQGsEzsRME=;
	h=Date:To:From:Subject:Message-Id; b=IPsIs6CNCUFS3UU6W+slpmcx1lAWaFE+k0ceoVH0nVM+ScspDdPX1r6iKGln6P8L7qMI8zPUoxUeSHJOxYobFWgqVU4v0ppsvs66Bm+3bTDaT5VGAv2Fye3QUiYKJK4SOoCnXHACXd+Sw7bA8fpAk7cSiosGzoV/WPWRfSFXLss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AA3KJ8Xx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AA3KJ8Xx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB72C4CEC3;
	Tue, 29 Oct 2024 01:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730164018;
	bh=wUxl7XgTfDIzeIoUR+FvmTrK8dq6P6QNJEQGsEzsRME=;
	h=Date:To:From:Subject:From;
	b=AA3KJ8Xx2cwavdpBl1gO0qnD9lyxJ34VC072sAhGIEnSpu87WiYLBRnPtBF5Df1ti
	 /eUkE8MEgqYaBMEWx0P9Md56uuvkhnPm5AZByBHhm9zR3fb5AvzJjaWM/OsRN0uoOj
	 bYv6hB4XUr6Y/S1licx+aKs3ApJi+pgPD5/8TO0A=
Date: Mon, 28 Oct 2024 18:06:58 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabkba@suse.cz,vbabka@suse.cz,tsbogend@alpha.franken.de,surenb@google.com,skhan@linuxfoundation.org,sidhartha.kumar@oracle.com,shuah@kernel.org,richard.henderson@linaro.org,paulmck@kernel.org,muchun.song@linux.dev,mattst88@gmail.com,Liam.Howlett@Oracle.com,jhubbard@nvidia.com,jeffxu@chromium.org,jcmvbkbc@gmail.com,jannh@google.com,James.Bottomley@HansenPartnership.com,hch@infradead.org,deller@gmx.de,david@redhat.com,chris@zankel.net,brauner@kernel.org,arnd@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-update-tools-uapi-header-for-mman-commonh.patch added to mm-unstable branch
Message-Id: <20241029010658.BEB72C4CEC3@smtp.kernel.org>
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
Date: Mon, 28 Oct 2024 14:13:30 +0000

Import the new MADV_GUARD_INSTALL/REMOVE madvise flags.

Link: https://lkml.kernel.org/r/ada462fa73fa1defc114242e446ab625b8290b71.1730123433.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Suggested-by: Jann Horn <jannh@google.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Helge Deller <deller@gmx.de>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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
tools-testing-fix-phys_addr_t-size-on-64-bit-systems-fix.patch
tools-testing-add-additional-vma_internalh-stubs.patch
mm-isolate-mmap-internal-logic-to-mm-vmac.patch
mm-refactor-__mmap_region.patch
mm-remove-unnecessary-reset-state-logic-on-merge-new-vma.patch
mm-defer-second-attempt-at-merge-on-mmap.patch
mm-defer-second-attempt-at-merge-on-mmap-fix.patch
mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch

