Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBB1279DAD
	for <mm-commits@vger.kernel.org>; Mon, 12 Oct 2026 02:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791771568; cv=none; b=Ta2tYKTVhXWrJQ6jDUtDrMNTReTN9h0pIXJAQxjPDfugxqLdi9E6L2sx9mdpXzBvO1h18N08VIzbX0JCSZvRzdDTAU+P9DfDnI9r7m7+imGAee2w2f35pyHzsta/LiC5F6DtTTgFk72rlrK/bBZUFmmv7KLiGae+zcd24ymAJv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791771568; c=relaxed/simple;
	bh=CwInEZp8cdiVt4Tle4cWwB2ktoQTZdNe8T0jbGOobdk=;
	h=Date:To:From:Subject:Message-Id; b=iU0H50Yq9kFWi52NVF3h8x5X0oR2ijyXgnIMVtIqGViocubmw/a8vt6lJSZ11hTkfdm/Y6SBLkJPpYtvKtcrBkHI0nW+HSgh9cd1IyWfXZiCE/Un6v3CrJvi8y8XgqMe3lB+5PpXpP4i7PHctKeVu1N2yanYSdPSBhMN8B9SLeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OR1U5rpC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OR1U5rpC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27011F0089B;
	Mon, 12 Oct 2026 02:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791771566;
	bh=NUXgG3xWtz5iOUQq0CjgSm0/HzOURA5Ps5BpwkK6BAg=;
	h=Date:To:From:Subject;
	b=OR1U5rpCbJY53mTB4irp4d3VE1s6HceuZzv99t4BeDaSR36hF0H9DTrDCSB2iuauf
	 x+R7mbCLnEySLcjre0LLw620jhkVY25XnFtK7Jeg3t5ILgD0xTFmEgwgK1n/eEB1sI
	 eZWtqPJQ9tGqQx6J+tLZBlMnTka/dSII0AWnjQrI=
Date: Sun, 11 Oct 2026 19:19:26 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-uffd-move-pmd-test-crash-on-64k-base-page-systems.patch added to mm-new branch
Message-Id: <20261012021926.D27011F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix uffd move-pmd test crash on 64K base page systems
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-uffd-move-pmd-test-crash-on-64k-base-page-systems.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-uffd-move-pmd-test-crash-on-64k-base-page-systems.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: selftests/mm: fix uffd move-pmd test crash on 64K base page systems
Date: Mon, 12 Oct 2026 00:35:27 +0800

uffd_move_pmd_test()/uffd_move_test_common() splits the test area into
chunks of chunk_size and moves them one by one.  On arm64 with 64K base
pages the chunk_size (read_pmd_pagesize()) is 512MB, which is larger than
the whole 32MB (UFFD_TEST_MEM_SIZE) test area:

  step_count = nr_pages / (chunk_size / page_size) == 0

Because chunk_size > page_size, the test then aligns both areas up to
512MB, which points far outside of the 32MB mappings, and decrements
step_count, which underflows to ULONG_MAX.  The verification loop then
runs away and the first dereference of area_src faults with a SIGSEGV.

Skip the test when a single chunk cannot fit into the test area.

Link: https://lore.kernel.org/20261011163527.95988-1-zenghui.yu@linux.dev
Fixes: a2bf6a9ca805 ("selftests/mm: add UFFDIO_MOVE ioctl test")
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-fix-uffd-move-pmd-test-crash-on-64k-base-page-systems
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1937,6 +1937,11 @@ uffd_move_test_common(uffd_global_test_o
 
 	args.gopts = gopts;
 
+	if (chunk_size > gopts->nr_pages * gopts->page_size) {
+		uffd_test_skip("chunk size does not fit in the test area");
+		return;
+	}
+
 	/* Prevent source pages from being mapped more than once */
 	if (madvise(gopts->area_src, gopts->nr_pages * gopts->page_size, MADV_DONTFORK))
 		err("madvise(MADV_DONTFORK) failure");
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

selftests-damon-stop-kdamond-on-error-exits-of-no-op-commit-test.patch
selftests-damon-ignore-test-generated-damon_dump_output.patch
mm-damon-api-remove-unused-nr_damos_-enumerators.patch
selftests-mm-fix-uffd-move-pmd-test-crash-on-64k-base-page-systems.patch

