Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B504A20
	for <mm-commits@vger.kernel.org>; Fri,  7 Jun 2024 20:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717790792; cv=none; b=Sz5Kbpi1ssurkiT9Mlu+Ovek1RuKcv3zb099TEQWqoWXWybU4nJfIPxXHlYkL1/PbmLWv7udWo3c4MojZxhOlRa8KnKOVq5BnTz2EpQ2jgerKSRb51sSKpnIZHJWjJ/F8n455cMDskpOCLL4WxwWZ5sPRZXSB4c0uWt8ZOZCjNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717790792; c=relaxed/simple;
	bh=z2oy+H7Qv++tQLoYa9PN/ebpYJ/B+iNzqXTHCz4495E=;
	h=Date:To:From:Subject:Message-Id; b=LdlHhEjnNNiKq0UuX1F7M9hR19DTz4r226SHb99X2CwKErwLTGKrf5UFzqqPkT4N1cmb2b36tEph8PLu+oVsuI/waXya+XfwoM7QpBYcCkoERadVMZf00hHNx8faeq6cqA2aHV9U11gMBHbRtBooOigNbZd37Et9reKCHMbbfiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zWoYujR4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zWoYujR4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038C3C2BBFC;
	Fri,  7 Jun 2024 20:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717790792;
	bh=z2oy+H7Qv++tQLoYa9PN/ebpYJ/B+iNzqXTHCz4495E=;
	h=Date:To:From:Subject:From;
	b=zWoYujR4YJbpYOdA0oBrGiu8JfLxTnTXmyasbxtRqt+Ey8mZCkp74Iu1ccabe7lkF
	 7h0YfJsh+dVq/nlVzcKTZZpPn4/6Fmw8KD+9RX23LEju8Q33wUD2mYATDK2huhKVut
	 bOkfUFI0hIbyOEcyiXvp6EzBp5ehDQ3stff0ktZM=
Date: Fri, 07 Jun 2024 13:06:31 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,usama.anjum@collabora.com,tonyb@cybernetics.com,songmuchun@bytedance.com,shuah@kernel.org,rppt@kernel.org,ritesh.list@gmail.com,david@redhat.com,axboe@kernel.dk,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages-v4.patch added to mm-unstable branch
Message-Id: <20240607200632.038C3C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest: mm: Test if hugepage does not get leaked during __bio_release_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages-v4.patch

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
From: Donet Tom <donettom@linux.ibm.com>
Subject: selftest: mm: Test if hugepage does not get leaked during __bio_release_pages()
Date: Fri, 7 Jun 2024 13:20:00 -0500

add this test to run_vmtests.sh

Link: https://lkml.kernel.org/r/20240607182000.6494-1-donettom@linux.ibm.com
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb_dio.c  |    2 +-
 tools/testing/selftests/mm/run_vmtests.sh |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/hugetlb_dio.c~selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages-v4
+++ a/tools/testing/selftests/mm/hugetlb_dio.c
@@ -40,7 +40,7 @@ void run_dio_using_hugetlb(unsigned int
 		ksft_exit_fail_msg("Unable to determine huge page size\n");
 
 	/* Open the file to DIO */
-	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT);
+	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
 	if (fd < 0)
 		ksft_exit_fail_perror("Error opening file\n");
 
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages-v4
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -265,6 +265,7 @@ CATEGORY="hugetlb" run_test ./map_hugetl
 CATEGORY="hugetlb" run_test ./hugepage-mremap
 CATEGORY="hugetlb" run_test ./hugepage-vmemmap
 CATEGORY="hugetlb" run_test ./hugetlb-madvise
+CATEGORY="hugetlb" run_test ./hugetlb_dio
 
 nr_hugepages_tmp=$(cat /proc/sys/vm/nr_hugepages)
 # For this test, we need one and just one huge page
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages.patch
selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages-v2.patch
selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages-v4.patch

