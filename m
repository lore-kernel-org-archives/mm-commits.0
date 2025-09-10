Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234AE26E158
	for <mm-commits@vger.kernel.org>; Wed, 10 Sep 2025 05:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757481617; cv=none; b=fDYWWc64o893V5Sfog9ic8BgwF6FgShCEdw/0SitzaSlDFetV6i64qQqmGcbHlvHjsm8AzZWyHachWVfxvGsHJmsGATCWQgyA5fqZTOrYlp+bZVCC44dvOOY4CrCPGczWyaF8+oU8TYOnhA3kE48nYOVrTeuLEnJrI9HfYeEo4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757481617; c=relaxed/simple;
	bh=n9yvr8whMQZqlGyNu8UQu+iPVshWYaq5G13+YvKgV7E=;
	h=Date:To:From:Subject:Message-Id; b=fq5Wi/f/K0bnVp5gy1/MIJ+ZRcRyewGgsu8EP8zC/OGqCCHlTP6vj5zP1jxicmRrVVJuNko6R+lfBgaaBfEzRMN3y4C0fjxc1CeTwetLH4J2X3b9vxALHt4GEC2v3NsZJGtwDhH/wTRzSO1DrZyo+ZSYzAmz2Iu1xj3VBj7cd0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DxrulEWq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DxrulEWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98912C4CEF0;
	Wed, 10 Sep 2025 05:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757481616;
	bh=n9yvr8whMQZqlGyNu8UQu+iPVshWYaq5G13+YvKgV7E=;
	h=Date:To:From:Subject:From;
	b=DxrulEWqWNZjnmOraCerd+3KtuUeic1omwXM+p34bXal2PtDn731OrVz9OTcW2drj
	 YoDF0u9Yot0HgpooNedUUjepVrqCs5OKyJkMFjHY7P03dwd4SPnt/7PQ1cmtlIdHiG
	 08YSFAAQHVjIRBdgjWX8pHj3J2VCmGDc5X5DKcf0=
Date: Tue, 09 Sep 2025 22:20:16 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-uffd-stress-stricten-constraint-on-free-hugepages-needed-before-the-test.patch added to mm-unstable branch
Message-Id: <20250910052016.98912C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/uffd-stress: stricten constraint on free hugepages needed before the test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-uffd-stress-stricten-constraint-on-free-hugepages-needed-before-the-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-uffd-stress-stricten-constraint-on-free-hugepages-needed-before-the-test.patch

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
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm/uffd-stress: stricten constraint on free hugepages needed before the test
Date: Tue, 9 Sep 2025 11:45:30 +0530

The test requires at least 2 * (bytes/page_size) hugetlb memory, since we
require identical number of hugepages for src and dst location.  Fix this.

Along with the above, as explained in patch "selftests/mm/uffd-stress:
Make test operate on less hugetlb memory", the racy nature of the test
requires that we have some extra number of hugepages left beyond what is
required.  Therefore, stricten this constraint.

Link: https://lkml.kernel.org/r/20250909061531.57272-3-dev.jain@arm.com
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

 tools/testing/selftests/mm/uffd-stress.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-uffd-stress-stricten-constraint-on-free-hugepages-needed-before-the-test
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -448,12 +448,6 @@ int main(int argc, char **argv)
 	parse_test_type_arg(argv[1]);
 	bytes = atol(argv[2]) * 1024 * 1024;
 
-	if (test_type == TEST_HUGETLB &&
-	   get_free_hugepages() < bytes / page_size) {
-		printf("skip: Skipping userfaultfd... not enough hugepages\n");
-		return KSFT_SKIP;
-	}
-
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	if (nr_cpus > 32) {
 		/* Don't let calculation below go to zero. */
@@ -464,6 +458,17 @@ int main(int argc, char **argv)
 		nr_parallel = nr_cpus;
 	}
 
+	/*
+	 * src and dst each require bytes / page_size number of hugepages.
+	 * Ensure nr_parallel - 1 hugepages on top of that to account
+	 * for racy extra reservation of hugepages.
+	 */
+	if (test_type == TEST_HUGETLB &&
+	   get_free_hugepages() < 2 * (bytes / page_size) + nr_parallel - 1) {
+		printf("skip: Skipping userfaultfd... not enough hugepages\n");
+		return KSFT_SKIP;
+	}
+
 	nr_pages_per_cpu = bytes / page_size / nr_parallel;
 	if (!nr_pages_per_cpu) {
 		_err("pages_per_cpu = 0, cannot test (%lu / %lu / %lu)",
_

Patches currently in -mm which might be from dev.jain@arm.com are

selftests-mm-uffd-stress-make-test-operate-on-less-hugetlb-memory.patch
selftests-mm-uffd-stress-stricten-constraint-on-free-hugepages-needed-before-the-test.patch
mm-enable-khugepaged-anonymous-collapse-on-non-writable-regions.patch
mm-drop-all-references-of-writable-and-scan_page_ro.patch

