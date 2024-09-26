Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0410F17D344
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 20:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727381491; cv=none; b=sg6199nqaODFZsb3CtiwDCj2qJcKpqYU7tuoAKij4840r7NhYoo47QyyOgzYVMcNRnSZ6UKEMDIgL89zaSc2U2sQSMg5IAONaTSQF3kB+YlgZS5+A8YX2cPh2xVkYmf9JBjrpT4qcBSPVJftHQu1tei3907ybHfI+jYnza5iKZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727381491; c=relaxed/simple;
	bh=ROgmGvRDwDvxqeJJ88P23J9VbwfrFl1SW5b6CT63OQQ=;
	h=Date:To:From:Subject:Message-Id; b=A9JRcncFtHccX8uGpPDfGw3bnmsMHrK85xeOr2xNk5GxWXh7IhplkNRLHwzfG7UaIOxMyl4V/a7FYlIdMFoiXPMyx4XhE/ylKmRIGfF6/IrFF0nui7llEAWbGB4S1K8lIXO9DIq5wG8MMu5mIfO+kjqt5ir82Feakp+EFQRCTQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ATsh879c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ATsh879c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56D5C4CEC5;
	Thu, 26 Sep 2024 20:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727381490;
	bh=ROgmGvRDwDvxqeJJ88P23J9VbwfrFl1SW5b6CT63OQQ=;
	h=Date:To:From:Subject:From;
	b=ATsh879cAx/Nb5N3W6AaeBOrSKsPyz3UrH/2mhO46k2LnPtvJ6H7J2GZqxtgtxXRt
	 zq9roloyMJaJliBtpd5lYLLrIyfmtV2Cl5UG51X8ciZUhx5ojIX/2KL0ZVFvjEjehg
	 f/SHkJn94zlHC0ed03k9C0xmV1o7YD/tuPhcapZY=
Date: Thu, 26 Sep 2024 13:11:29 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,shuah@kernel.org,mcasquer@redhat.com,leitao@debian.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-hugetlb_fault_after_madv-use-default-hguetlb-page-size.patch added to mm-unstable branch
Message-Id: <20240926201130.B56D5C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: hugetlb_fault_after_madv: use default hugetlb page size
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-hugetlb_fault_after_madv-use-default-hguetlb-page-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-hugetlb_fault_after_madv-use-default-hguetlb-page-size.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: selftests/mm: hugetlb_fault_after_madv: use default hugetlb page size
Date: Thu, 26 Sep 2024 17:20:43 +0200

Patch series "selftests/mm: hugetlb_fault_after_madv improvements".

Mario brought to my attention that the hugetlb_fault_after_madv test is
currently always skipped on s390x.  Let's adjust the test to be
independent of the default hugetlb page size and while at it, also improve
the test output.


This patch (of 2):

We currently assume that the hugetlb page size is 2 MiB, which is why we
mmap() a 2 MiB range.

Is the default hugetlb size is larger, mmap() will fail because the range
is not suitable.  If the default hugetlb size is smaller (e.g., s390x),
mmap() will fail because we would need more than one hugetlb page, but
just asserted that we have exactly one.

So let's simply use the default hugetlb page size instead of hard-coded 2
MiB, so the test isn't unconditionally skipped on architectures like
s390x.

Before this patch on s390x:
$ ./hugetlb_fault_after_madv
	1..0 # SKIP Failed to allocated huge page

With this change on s390x:
	$ ./hugetlb_fault_after_madv

While at it, make "huge_ptr" static.

Link: https://lkml.kernel.org/r/20240926152044.2205129-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240926152044.2205129-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Mario Casquero <mcasquer@redhat.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: Breno Leitao <leitao@debian.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb_fault_after_madv.c |   14 ++++++----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c~selftests-mm-hugetlb_fault_after_madv-use-default-hguetlb-page-size
+++ a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
@@ -9,10 +9,10 @@
 #include "vm_util.h"
 #include "../kselftest.h"
 
-#define MMAP_SIZE (1 << 21)
 #define INLOOP_ITER 100
 
-char *huge_ptr;
+static char *huge_ptr;
+static size_t huge_page_size;
 
 /* Touch the memory while it is being madvised() */
 void *touch(void *unused)
@@ -30,7 +30,7 @@ void *madv(void *unused)
 	usleep(rand() % 10);
 
 	for (int i = 0; i < INLOOP_ITER; i++)
-		madvise(huge_ptr, MMAP_SIZE, MADV_DONTNEED);
+		madvise(huge_ptr, huge_page_size, MADV_DONTNEED);
 
 	return NULL;
 }
@@ -47,6 +47,10 @@ int main(void)
 
 	srand(getpid());
 
+	huge_page_size = default_huge_page_size();
+	if (!huge_page_size)
+		ksft_exit_skip("Could not detect default hugetlb page size.");
+
 	free_hugepages = get_free_hugepages();
 	if (free_hugepages != 1) {
 		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
@@ -54,7 +58,7 @@ int main(void)
 	}
 
 	while (max--) {
-		huge_ptr = mmap(NULL, MMAP_SIZE, PROT_READ | PROT_WRITE,
+		huge_ptr = mmap(NULL, huge_page_size, PROT_READ | PROT_WRITE,
 				MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
 				-1, 0);
 
@@ -66,7 +70,7 @@ int main(void)
 
 		pthread_join(thread1, NULL);
 		pthread_join(thread2, NULL);
-		munmap(huge_ptr, MMAP_SIZE);
+		munmap(huge_ptr, huge_page_size);
 	}
 
 	return KSFT_PASS;
_

Patches currently in -mm which might be from david@redhat.com are

selftests-mm-hugetlb_fault_after_madv-use-default-hguetlb-page-size.patch
selftests-mm-hugetlb_fault_after_madv-improve-test-output.patch

