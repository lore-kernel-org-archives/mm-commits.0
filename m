Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA77D1C878B
	for <mm-commits@vger.kernel.org>; Fri, 25 Oct 2024 22:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729895146; cv=none; b=o0t2ZcnTOn/WfN/STFqC6yMRoUMqkywtnS3NJmI+4xH/hN9vEjSN+UOHv15NpNfuxA8UpwFFLc+y9IJooEQXlIVixpWNNAY90s3fF4FZCXhcRfDDZIvMv5k+fRKESZ94NIqyaFlelXxhL0tf2cV6qMcYPjAyFd+itclDkEeEFO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729895146; c=relaxed/simple;
	bh=U+ABjCKvccP7YKnv9yuD79C1aTYV0tCVyHdWKol9Ts0=;
	h=Date:To:From:Subject:Message-Id; b=p6Zw4JRhodOcyH1gdKNYAygAWMGL93IJyPfFqkYdwzbLMaz2dh0++B5HiMW36EMU/nkmzBg7jbs9XFxLv8sB+5AYmHj2FUjEMTgxdOkPSr26SqoQpVJsCKxb6tak8C7U9bx1/7kw2ZXv2HQ1HuPb7QmHMMTHdDjUVTQL/4nC37c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cZWpStyC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cZWpStyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444F6C4CEC3;
	Fri, 25 Oct 2024 22:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729895146;
	bh=U+ABjCKvccP7YKnv9yuD79C1aTYV0tCVyHdWKol9Ts0=;
	h=Date:To:From:Subject:From;
	b=cZWpStyCTu2jqrSqpWcf8v6MsvsKYJ+p5nhENupMYScWRkgYkfU2UXjIAs3bGGtBu
	 L+wi+Hv4tV/6GG0mTSrpxPyyyU8yA2fiE0Obr+vYd7LcuLRpH61tYxqZOe0ggb+LcV
	 U/fXPkZOIO2dc962+dQDmXYwN/2orKusG72szluw=
Date: Fri, 25 Oct 2024 15:25:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tsbogend@alpha.franken.de,surenb@google.com,skhan@linuxfoundation.org,sidhartha.kumar@oracle.com,shuah@kernel.org,richard.henderson@linaro.org,paulmck@kernel.org,muchun.song@linux.dev,mattst88@gmail.com,Liam.Howlett@Oracle.com,jhubbard@nvidia.com,jeffxu@chromium.org,jcmvbkbc@gmail.com,jannh@google.com,James.Bottomley@HansenPartnership.com,hch@infradead.org,deller@gmx.de,david@redhat.com,chris@zankel.net,brauner@kernel.org,arnd@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-implement-lightweight-guard-page-mechanism-fix.patch added to mm-unstable branch
Message-Id: <20241025222546.444F6C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: yield on fatal signal/cond_sched() in vector_madvise()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-implement-lightweight-guard-page-mechanism-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-implement-lightweight-guard-page-mechanism-fix.patch

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
Subject: mm: yield on fatal signal/cond_sched() in vector_madvise()
Date: Fri, 25 Oct 2024 18:05:48 +0100

While we have to treat -ERESTARTNOINTR specially here as we are looping
through a vector of operations and can't simply restart the entire
operation, we mustn't hold up fatal signals or RT kernels.

Link: https://lkml.kernel.org/r/f09086cd-c49c-4eea-adff-d626c16083de@lucifer.local
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-implement-lightweight-guard-page-mechanism-fix
+++ a/mm/madvise.c
@@ -1713,8 +1713,14 @@ static ssize_t vector_madvise(struct mm_
 		 * we have already rescinded locks, it should be no problem to
 		 * simply try again.
 		 */
-		if (ret == -ERESTARTNOINTR)
+		if (ret == -ERESTARTNOINTR) {
+			if (fatal_signal_pending(current)) {
+				ret = -EINTR;
+				break;
+			}
+			cond_resched();
 			continue;
+		}
 		if (ret < 0)
 			break;
 		iov_iter_advance(iter, iter_iov_len(iter));
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
mm-defer-second-attempt-at-merge-on-mmap.patch
mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
mm-madvise-implement-lightweight-guard-page-mechanism-fix.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch

