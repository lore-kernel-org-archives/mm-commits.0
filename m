Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BF236605A
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067119; cv=none; b=oQn6JJDOO2FcpuRq50rLOlxQmip2Q7aPNubc+H8Yf8UPtyJhZb/RRxX1Lh9Ia24ht/hpHd9pvtwyyzktsnb/VYmglbIm4vgK4bBartiNHw6v/iH3LKjjguK9GKCt6K4mTTfnSqdytEPlCXI/Gsqo6crg5i6pWqOsOJs8VPVdAcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067119; c=relaxed/simple;
	bh=awkZoiHv2p7QN+WKt9Vk1UmNaJDb1kYXe2FSLQasofM=;
	h=Date:To:From:Subject:Message-Id; b=QWjmSzy9dfCL3cuTarLJFhjuTv6LlhWqcsb55BS1T4d19pWKF4Pq7boRDcb+34H8y/81nQLET2WjcDaaiWv94Ijih07yG22gIRpsOBiwit3I4ZdoAtKczOj5B5F0ixxaT2nv9MLFT5LKUeWGzkwS2ypC3AgcXNKSuqbGhjlTO8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZsKTcVyp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZsKTcVyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF211F00A3D;
	Sun, 21 Jun 2026 18:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067118;
	bh=WpcHhy0Wk6RhPK3w1RgbaOnQjZq2g1Kf7ndxjg6eFlw=;
	h=Date:To:From:Subject;
	b=ZsKTcVypE7pD8aF8NwY7IMAQfgPJkbNFslr9g1GxznOG4yA4Y+CBYRp9d1CnYjbpo
	 77mNqyKgyKeq9apB7kU2z/FUaAgshd8cFODLlrTlZiNUleveRBdcKPL3doDDrt5+yh
	 uesKzWZXy9M+5o7R4YwupOgOzNnLMdJzvmKNc8Qw=
Date: Sun, 21 Jun 2026 11:38:37 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-hugetlb-read-hwpoison-add-sigbus-handler.patch removed from -mm tree
Message-Id: <20260621183838.2BF211F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: hugetlb-read-hwpoison: add SIGBUS handler
has been removed from the -mm tree.  Its filename was
     selftests-mm-hugetlb-read-hwpoison-add-sigbus-handler.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: hugetlb-read-hwpoison: add SIGBUS handler
Date: Mon, 11 May 2026 19:27:45 +0300

Patch series "make MM selftests more CI friendly", v4.

There's a lot of dancing around HugeTLB settings in run_vmtests.sh.  Some
test need just a few default huge pages, some require at least 256 MB, and
some just skip lots of tests if huge pages of all supported sizes are not
available.

The goal of this set is to make tests deal with HugeTLB setup and
teardown.

There are already convenient helpers that allow easy reading and writing
of /proc and /sysfs, so adding a few APIs that will detect and update
HugeTLB settings shouldn't be a big deal.  But these nice helpers use
kselftest framework, and many of HugeTLB (and even THP) test don't, so as
a result this patchset also includes a lot of churn for conversion of
those tests to kselftest framework (patches 7-19).

The series break out:
patches 1-5:   small fixes
patch 6:       merge of hugetlb mmap tests
patch 7:       renaming of hugepage-* to hugetlb-*
patches 8-21:  mechanical conversion to kselftest framework
patches 22-28: extension of thp_settings to hugepage_settings to also include
               HugeTLB helpers
patches 29-30: add helpers for setting up SHM limits in hugetlb-shm and
               thuge-gen tests
patches 31-53: integrate the new APIs in all the tests that use HugeTLB
patches 54-55: drop HugeTLB setup from run_vmtests.sh


This patch (of 55):

Injection of a memory error with madvise() causes SIGBUS, which terminates
the hugetlb-read-hwpoison test prematurely.

Add a dummy SIGBUS handler to allow the test to continue regardless of
SIGBUS.

Link: https://lore.kernel.org/20260511162840.375890-1-rppt@kernel.org
Link: https://lore.kernel.org/20260511162840.375890-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Tested-by: Li Wang <li.wang@linux.dev>
Reviewed-by: Li Wang <li.wang@linux.dev>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb-read-hwpoison.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c~selftests-mm-hugetlb-read-hwpoison-add-sigbus-handler
+++ a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
@@ -10,6 +10,7 @@
 #include <sys/statfs.h>
 #include <errno.h>
 #include <stdbool.h>
+#include <signal.h>
 
 #include "kselftest.h"
 
@@ -261,6 +262,10 @@ close:
 	return -1;
 }
 
+static void sigbus_handler(int sig)
+{
+}
+
 int main(void)
 {
 	int fd;
@@ -273,6 +278,7 @@ int main(void)
 	};
 	size_t i;
 
+	signal(SIGBUS, sigbus_handler);
 	for (i = 0; i < ARRAY_SIZE(wr_chunk_sizes); ++i) {
 		printf("Write/read chunk size=0x%lx\n",
 		       wr_chunk_sizes[i]);
_

Patches currently in -mm which might be from rppt@kernel.org are


