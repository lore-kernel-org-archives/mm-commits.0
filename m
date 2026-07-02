Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C5B28030E
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 02:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782957823; cv=none; b=FVaErCQijANTUCPl2J3FCZCWxFGALNcHMsYxV6YRezdnWrRTmkgj9MpCqjwoujSILLzOWcN+eyavb/imAxdC+SNgoF/AbQS7YIlsObkMa4SUzuY1Tf+4KdkJ+Ge/UaBbS6FCv9QatQ7qdUd84Dv7EE2ZHGrd2JRQoR1eOrPSRIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782957823; c=relaxed/simple;
	bh=WWrU5cgLIGt7sCPQOs9/r4vdJYfg/j5mE5/E1hJc/oY=;
	h=Date:To:From:Subject:Message-Id; b=aBJ+GGzyunbmpNx4Mgay6oVTuwrBXtwpTv23IfN7BKCCgtuSD7myZBXn8r9U6/6teScm0IPQ1eoQ2IIRg2YsWVH41QcM1MrWFsajNqkm3rhxPhFscmE9rQAZ/+YuuTXt2LfpNnPmEVpXVvN+VFT6k0DZymeD+0RSwmJY3+2e2RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cd/RsUll; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cd/RsUll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9051F000E9;
	Thu,  2 Jul 2026 02:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782957821;
	bh=6guSFo3+gbk9I1IihZjbVM10j+bL/gl89ZyYTPfctw4=;
	h=Date:To:From:Subject;
	b=Cd/RsUllmGD/3ifIhFAYfxDuO/WDqssBDxKJLHrMecyfkVolHmz9UtmAzEa4GNgS7
	 mYdqVKmKb67BgV7SwS+WNxmsqSrvGIDi4hi8lrUiQvc5q/vtPXkdqZ2jR+PVtpGV1i
	 muY1CJyTIBXGR8JVSmAyiB3GPdgnIZ+35vkH3ZRk=
Date: Wed, 01 Jul 2026 19:03:41 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,leon@kernel.org,jgg@ziepe.ca,dev.jain@arm.com,david@kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-hmm-tests-include-linux-mmanh-to-access-madv_collapse.patch removed from -mm tree
Message-Id: <20260702020341.BA9051F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: hmm-tests: include linux/mman.h to access MADV_COLLAPSE
has been removed from the -mm tree.  Its filename was
     selftests-mm-hmm-tests-include-linux-mmanh-to-access-madv_collapse.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zenghui Yu <zenghui.yu@linux.dev>
Subject: selftests/mm: hmm-tests: include linux/mman.h to access MADV_COLLAPSE
Date: Sun, 28 Jun 2026 22:31:11 +0800

The following compilation error occurs with an old version of glibc due to
a recent commit adding MADV_COLLAPSE testing:

 [root@localhost mm]# getconf GNU_LIBC_VERSION
 glibc 2.34
 [root@localhost mm]# make
   CC       hmm-tests
 hmm-tests.c: In function 'hmm_migrate_anon_huge_fault':
 hmm-tests.c:2355:27: error: 'MADV_COLLAPSE' undeclared (first use in this function); did you mean 'MADV_COLD'?
  2355 |  ret = madvise(map, size, MADV_COLLAPSE);
       |                           ^~~~~~~~~~~~~
       |                           MADV_COLD
 hmm-tests.c:2355:27: note: each undeclared identifier is reported only once for each function it appears in
 make: *** [../lib.mk:225: /root/code/linux/tools/testing/selftests/mm/hmm-tests] Error 1

Include linux/mman.h (which provides the definition of MADV_COLLAPSE) to
fix the build error.

Link: https://lore.kernel.org/20260628143111.36863-1-zenghui.yu@linux.dev
Fixes: e3d8707358ea ("selftests/mm/hmm-tests: test pagemap reads of PMD device-private entries")
Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hmm-tests.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/hmm-tests.c~selftests-mm-hmm-tests-include-linux-mmanh-to-access-madv_collapse
+++ a/tools/testing/selftests/mm/hmm-tests.c
@@ -23,6 +23,7 @@
 #include <time.h>
 #include <pthread.h>
 #include <limits.h>
+#include <linux/mman.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

tools-mm-add-thp_swap_allocator_test-binary-to-gitignore.patch

