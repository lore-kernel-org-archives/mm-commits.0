Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B840F155312
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854720; cv=none; b=Wzm6ZbCGggPuo7mbcf8d/N5crFaoFhXB3A4agWl8tojCyX8itpHoB/SaTZnpH+lpnuXeBBFE7v/x5m1j9u+b5uC/Us+l0r6YulqDoogdAIue7SZp/xLI0cqVihcDwWpC0cB0Trp+75YQ6qLh8ja2dAOuhRa6i+//jrdgmB/67MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854720; c=relaxed/simple;
	bh=+O1iaRYKDA2RQWIx4dr839PcUFQWHhModcBFZZE+kp4=;
	h=Date:To:From:Subject:Message-Id; b=Q2uMMZyXlkRh3lP+5wxX5UfS6Qkc66l8KdR/GqACtySbLTqgdPgYs6cZ8eO41KhpxBjHDFNh09Z1Qm9TqV6rUL3D5Izv7u4lJDtQ2ZGvaeMRp8Z1KT1veD1b7+bEpSGLuItc9AGxfii1Mh9kVyIu2w5V9xnotqCz/jMvQcw1xwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KUiuQtzO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KUiuQtzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B6CC4CECF;
	Wed,  6 Nov 2024 00:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854720;
	bh=+O1iaRYKDA2RQWIx4dr839PcUFQWHhModcBFZZE+kp4=;
	h=Date:To:From:Subject:From;
	b=KUiuQtzOdJ49HFNgXkR52FG5kLPLwx3PKJ/iyJhzj2Qfetp3X5hTdKWyijILy9ScV
	 HPM8japw0uWrvGaYSC4SP1yDvZb+1eFbu1yvTgJoy8xP7NFK3F5MuRpxlH2bITxQdF
	 OAy3MLNfEznVyDduhOkgPD7f2fGzFDDZDhUL7DAI=
Date: Tue, 05 Nov 2024 16:58:39 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,shuah@kernel.org,mcasquer@redhat.com,leitao@debian.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-hugetlb_fault_after_madv-use-default-hguetlb-page-size.patch removed from -mm tree
Message-Id: <20241106005840.56B6CC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: hugetlb_fault_after_madv: use default hugetlb page size
has been removed from the -mm tree.  Its filename was
     selftests-mm-hugetlb_fault_after_madv-use-default-hguetlb-page-size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Tested-by: Mario Casquero <mcasquer@redhat.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
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


