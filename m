Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6E4154BE2
	for <mm-commits@vger.kernel.org>; Wed, 10 Sep 2025 00:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757464600; cv=none; b=CYsDmVL4Dk9ycPJG7JIWwfkGeCpCu/oLkIwNy3vcxMYw4CfJVYlCn4E/I9IB6TsypmjG7WF9dc2f6n8lPO7YRWLRv5U72LGmeD7p09XtB/UgSJ1PSEB3q5owsdjyL99t8U4uugs95QZUQMIHCO4dSMFlTWzVEFqZWUzWgI4zs7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757464600; c=relaxed/simple;
	bh=YGxKGGnVb7j29hcmRtlGpxOBe0NtbIAtdYbaVw0P+ho=;
	h=Date:To:From:Subject:Message-Id; b=YhK9d/l4X3bajt8gtYBbWJGfYb+r6O5ayZMHjJ/kTOfSRQ2pv9AUyM6YEXir+CFn5Z8yZIVMxjfeSOdIPRAIyABrW1WA8893BQ+p0JUdShPtZLJfhfc+SC46k2FS4bnlnHujEF//Ix5it+PPY6EWowXbcAaHRUVAC8RVKnzaixc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XSvgfmNm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XSvgfmNm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD317C4CEF4;
	Wed, 10 Sep 2025 00:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757464599;
	bh=YGxKGGnVb7j29hcmRtlGpxOBe0NtbIAtdYbaVw0P+ho=;
	h=Date:To:From:Subject:From;
	b=XSvgfmNmG0776Kq+7viloEC4OE7113APn+mkksAQp8p1vlrE9kcUQVfm20TfDWlwo
	 aaUaaBIknzdC8QlW+DBoaNYcIK5b2E2Uq5H9zY/JtqJQ88+2lf9k3oNJzqxES7y4Sc
	 TjvoPZzr8qg4/LeD2pGseSZJqIzYlJGgF95YbbQo=
Date: Tue, 09 Sep 2025 17:36:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ryan.roberts@arm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,zokeefe@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-remove-prot_exec-req-from-file-collapse-tests.patch added to mm-new branch
Message-Id: <20250910003639.CD317C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: remove PROT_EXEC req from file-collapse tests
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-remove-prot_exec-req-from-file-collapse-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-remove-prot_exec-req-from-file-collapse-tests.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: selftests/mm: remove PROT_EXEC req from file-collapse tests
Date: Tue, 9 Sep 2025 12:05:34 -0700

As of v6.8 commit 7fbb5e188248 ("mm: remove VM_EXEC requirement for THP
eligibility") thp collapse no longer requires file-backed mappings be
created with PROT_EXEC.

Remove the overly-strict dependency from thp collapse tests so we test the
least-strict requirement for success.

Link: https://lkml.kernel.org/r/20250909190534.512801-1-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-remove-prot_exec-req-from-file-collapse-tests
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -394,7 +394,7 @@ static void *file_setup_area(int nr_hpag
 		perror("open()");
 		exit(EXIT_FAILURE);
 	}
-	p = mmap(BASE_ADDR, size, PROT_READ | PROT_EXEC,
+	p = mmap(BASE_ADDR, size, PROT_READ,
 		 MAP_PRIVATE, finfo.fd, 0);
 	if (p == MAP_FAILED || p != BASE_ADDR) {
 		perror("mmap()");
_

Patches currently in -mm which might be from zokeefe@google.com are

selftests-mm-remove-prot_exec-req-from-file-collapse-tests.patch

