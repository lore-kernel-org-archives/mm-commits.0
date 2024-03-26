Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359151B28D
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 18:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711476489; cv=none; b=gE97NF/pcexJ/EzCiSIKWAfbumWCSlhMvw/orOujw/sw7mQ9WDp4ZtSkaSi9vKn4MylqQPwGIw45p4woDSe3HrP0ja+e7Q3wzSsbnlzH1g+JXzK3sTivHqNJPcEAUW4RDOMvjQs1aSdL/IK1m19c4uXqYCnDVA2RsUT+ImCUInE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711476489; c=relaxed/simple;
	bh=OoWpAkFIOZoWbHvtINxxtkQILTfQPTQa8N6cXsontWM=;
	h=Date:To:From:Subject:Message-Id; b=pMD+75fUk7xQNCr+4Be5+Duhpifeesa8KZTeSM0HuJBlIOZsyFkdnX4/HcyfYNB/NH59Gg0wnwe73T6MSRZqGaYT82b7Y53Xiz9BDNyvCQ3O0CrkexS2sW1oGSK0IqnQSxC04gJAtg63xrb6bZ1CP6igpwhEFdjy9HLTKQm1bdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dT5N/Gn4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dT5N/Gn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0BAC433F1;
	Tue, 26 Mar 2024 18:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711476488;
	bh=OoWpAkFIOZoWbHvtINxxtkQILTfQPTQa8N6cXsontWM=;
	h=Date:To:From:Subject:From;
	b=dT5N/Gn4Rd3UVp97/Ww2R8dvd5cukVH+6U7qWL1aFwhlQ5cLEkMXdXEVHfejEkQpO
	 E3W1rCvkJj17+SMjIkS+DsWREDOjkZ7KBhNXPbZgzfh8z/OREBF92GRw37czzBdZFO
	 50b1m+KEvt6ufiImjcEBSzbiGVSo/wOkuFk+9lZk=
Date: Tue, 26 Mar 2024 11:08:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shy828301@gmail.com,peterx@redhat.com,nadav.amit@gmail.com,kbusch@kernel.org,david@redhat.com,aarcange@redhat.com,vt@altlinux.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-fix-build-with-_fortify_source.patch removed from -mm tree
Message-Id: <20240326180808.9C0BAC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: Fix build with _FORTIFY_SOURCE
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-build-with-_fortify_source.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vitaly Chikunov <vt@altlinux.org>
Subject: selftests/mm: Fix build with _FORTIFY_SOURCE
Date: Mon, 18 Mar 2024 05:34:44 +0300

Add missing flags argument to open(2) call with O_CREAT.

Some tests fail to compile if _FORTIFY_SOURCE is defined (to any valid
value) (together with -O), resulting in similar error messages such as:

  In file included from /usr/include/fcntl.h:342,
                   from gup_test.c:1:
  In function 'open',
      inlined from 'main' at gup_test.c:206:10:
  /usr/include/bits/fcntl2.h:50:11: error: call to '__open_missing_mode' declared with attribute error: open with O_CREAT or O_TMPFILE in second argument needs 3 arguments
     50 |           __open_missing_mode ();
        |           ^~~~~~~~~~~~~~~~~~~~~~

_FORTIFY_SOURCE is enabled by default in some distributions, so the
tests are not built by default and are skipped.

open(2) man-page warns about missing flags argument: "if it is not
supplied, some arbitrary bytes from the stack will be applied as the
file mode."

Link: https://lkml.kernel.org/r/20240318023445.3192922-1-vt@altlinux.org
Fixes: aeb85ed4f41a ("tools/testing/selftests/vm/gup_benchmark.c: allow user specified file")
Fixes: fbe37501b252 ("mm: huge_memory: debugfs for file-backed THP split")
Fixes: c942f5bd17b3 ("selftests: soft-dirty: add test for mprotect")
Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_test.c             |    2 +-
 tools/testing/selftests/mm/soft-dirty.c           |    2 +-
 tools/testing/selftests/mm/split_huge_page_test.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/gup_test.c~selftests-mm-fix-build-with-_fortify_source
+++ a/tools/testing/selftests/mm/gup_test.c
@@ -203,7 +203,7 @@ int main(int argc, char **argv)
 	ksft_print_header();
 	ksft_set_plan(nthreads);
 
-	filed = open(file, O_RDWR|O_CREAT);
+	filed = open(file, O_RDWR|O_CREAT, 0664);
 	if (filed < 0)
 		ksft_exit_fail_msg("Unable to open %s: %s\n", file, strerror(errno));
 
--- a/tools/testing/selftests/mm/soft-dirty.c~selftests-mm-fix-build-with-_fortify_source
+++ a/tools/testing/selftests/mm/soft-dirty.c
@@ -137,7 +137,7 @@ static void test_mprotect(int pagemap_fd
 		if (!map)
 			ksft_exit_fail_msg("anon mmap failed\n");
 	} else {
-		test_fd = open(fname, O_RDWR | O_CREAT);
+		test_fd = open(fname, O_RDWR | O_CREAT, 0664);
 		if (test_fd < 0) {
 			ksft_test_result_skip("Test %s open() file failed\n", __func__);
 			return;
--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-fix-build-with-_fortify_source
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -223,7 +223,7 @@ void split_file_backed_thp(void)
 		ksft_exit_fail_msg("Fail to create file-backed THP split testing file\n");
 	}
 
-	fd = open(testfile, O_CREAT|O_WRONLY);
+	fd = open(testfile, O_CREAT|O_WRONLY, 0664);
 	if (fd == -1) {
 		ksft_perror("Cannot open testing file");
 		goto cleanup;
_

Patches currently in -mm which might be from vt@altlinux.org are


