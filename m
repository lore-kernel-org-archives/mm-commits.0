Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C8023D2A4
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 18:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782672779; cv=none; b=WXe1SkHf1FKJ6d4OPYV1V/iGr9WDdY045Ds2NYI0Xm1zjhJZo4XU3q5BhHtYyqya/GJv1CyY7tToyOPpGiILRudeSAKIeYG+o1Ei5ijcjlYGt6eYbH1Dl25WY2fPCb3Sb2c1rv05j0Dli8YilgVLGy8qtGGnVSGRGt7oJChU180=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782672779; c=relaxed/simple;
	bh=FGKY8Tnm6RlV2Ozz10q9PB5P1sYICnlVqs4TVQDw4VQ=;
	h=Date:To:From:Subject:Message-Id; b=XeiVSxX+toi+3WBhWlKA9hJntlLZqy1N66F6q7MOnvrxeyP2MbWuNa/47EZ8c/pZveQlo59vEwvWnw11A+XE6sQB23AzPMduYzMiRL0VzNrxIGntYPv7Yyqu02P8RqUSyhda/s7HjwCfrHQGiVInc953m6zJ3C79r0ejJrzDpZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sYfbOGWB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sYfbOGWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23941F000E9;
	Sun, 28 Jun 2026 18:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782672778;
	bh=v+gE3iHJttR+kM1JWbC5Ms1+jNTfbPg1aCss0EIDxhs=;
	h=Date:To:From:Subject;
	b=sYfbOGWBGpR0KX35E8YQrPzLhTFN287roUA63mz62wd0Q2mkMU6lPMGoEVRmyRueG
	 t8SBfHPdZyUD1LfuJf8Zg1b690LJ4HNMzYo7R893UbtdZBPrBoZpKIJ+xrzUWGP7TJ
	 jySykTD7iYwQq8+/dKQzd2APZxwLS+yNdQFB/ocU=
Date: Sun, 28 Jun 2026 11:52:57 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,leon@kernel.org,jgg@ziepe.ca,dev.jain@arm.com,david@kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-hmm-tests-include-linux-mmanh-to-access-madv_collapse.patch added to mm-hotfixes-unstable branch
Message-Id: <20260628185257.F23941F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: hmm-tests: include linux/mman.h to access MADV_COLLAPSE
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-hmm-tests-include-linux-mmanh-to-access-madv_collapse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-hmm-tests-include-linux-mmanh-to-access-madv_collapse.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
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

selftests-mm-pagemap_ioctl-use-the-correct-page-size-for-transact_test.patch
selftests-mm-hmm-tests-include-linux-mmanh-to-access-madv_collapse.patch
tools-mm-add-thp_swap_allocator_test-binary-to-gitignore.patch
docs-pagemap-fix-flags-location-member-name-and-sample-code.patch

