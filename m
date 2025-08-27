Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272122F60B4
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 03:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756265382; cv=none; b=QEuCJdHEb/Of7i/kQ1qrMSAgxl8t0I/1GfJOCh86vNKHQTTx0jSaApPsAXNycitv9t/VfMfpciQaF3F5Fg7bLwEMkGzZqz6sItxjK1k/pCchaYT0VFuPe5E1AH6fUO3ij34ucWLrPPdlWBJe1KsF0xNSS6OxaocMtw4nb1D4Vec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756265382; c=relaxed/simple;
	bh=z9Rg4JtG/73S47sBE/DnI7374c80thuh16N9E+VGRB0=;
	h=Date:To:From:Subject:Message-Id; b=WE6DJdwnQjpy4YJMIq4JIHgDnv9btOhNSr7h05Bpia7uCpHxIsrKJuAW360x4AVpwU8A1FH+xYW2QihpeWFbOUnnEFHyxMwRHkYj8J+IrFwB0o6dvnDc1t8qnfV8ACsw0YsxHftC4sIMF7348B+KFkhg4Hfm47y4uBmXStesqMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J7GdStDN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J7GdStDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3F0C4CEEB;
	Wed, 27 Aug 2025 03:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756265381;
	bh=z9Rg4JtG/73S47sBE/DnI7374c80thuh16N9E+VGRB0=;
	h=Date:To:From:Subject:From;
	b=J7GdStDNdlgN04CprV389qkvHEt+gn1OckSNGo7R9WULlHDXF2Z8NNKChaNnn33KZ
	 vKjfHgFK3fRkRMIZIuPAf74Z3DmEopRnADf6qDMTkPeIYSJbxb8EiOSXSbLF8h4jzs
	 3EKComjm9LDVhBzFDSf+5FoXnnu3WsKA1PuBNWG0=
Date: Tue, 26 Aug 2025 20:29:40 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-uffd-stress-stricten-constraint-on-free-hugepages-before-the-test.patch added to mm-new branch
Message-Id: <20250827032941.9E3F0C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/uffd-stress: Stricten constraint on free hugepages before the test
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-uffd-stress-stricten-constraint-on-free-hugepages-before-the-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-uffd-stress-stricten-constraint-on-free-hugepages-before-the-test.patch

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
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm/uffd-stress: Stricten constraint on free hugepages before the test
Date: Tue, 26 Aug 2025 12:37:05 +0530

The test requires at least 2 * (bytes/page_size) hugetlb memory, since we
require identical number of hugepages for src and dst location.  Fix this.

Along with the above, as explained in patch "selftests/mm/uffd-stress:
Make test operate on less hugetlb memory", the racy nature of the test
requires that we have some extra number of hugepages left beyond what is
required.  Therefore, stricten this constraint.

Link: https://lkml.kernel.org/r/20250826070705.53841-3-dev.jain@arm.com
Fixes: 5a6aa60d1823 ("selftests/mm: skip uffd hugetlb tests with insufficient hugepages")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-uffd-stress-stricten-constraint-on-free-hugepages-before-the-test
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -469,7 +469,7 @@ int main(int argc, char **argv)
 	bytes = atol(argv[2]) * 1024 * 1024;
 
 	if (gopts->test_type == TEST_HUGETLB &&
-	   get_free_hugepages() < bytes / gopts->page_size) {
+	   get_free_hugepages() < 2 * (bytes / gopts->page_size) + 10) {
 		printf("skip: Skipping userfaultfd... not enough hugepages\n");
 		return KSFT_SKIP;
 	}
_

Patches currently in -mm which might be from dev.jain@arm.com are

selftests-mm-uffd-stress-make-test-operate-on-less-hugetlb-memory.patch
selftests-mm-uffd-stress-stricten-constraint-on-free-hugepages-before-the-test.patch

