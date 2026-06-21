Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9885936AB49
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067166; cv=none; b=EMVe7vksajgAdWkjkOSjnmxtsCoxLADMMPG9UMaMZF3QKxzWMJnUkz0HcJ76PBpkIDkCP1K0xKZfVaOLMSSBB7PoGbgoxf6ElSq1Au/+gJc0o/Km5P4Fk5XpubaNEoIZzzX9acaH4ca7i9n2kLM3OFtpXUhDKyzBNzCU4ati0c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067166; c=relaxed/simple;
	bh=uLH111BhEbUaFMqJqotNP5skfZXozHVzdmia+MAFiqs=;
	h=Date:To:From:Subject:Message-Id; b=jrABLymiPVWWXUTD+fLlSmMVuZ/8M+PWiZLILd2kK5VyEek8EvsWe9JHitUV7xkn3M3pGuCnSONpM83OqjPMmaabFE4EPjjyPFBwp5iF/N2Sa7X/9gDYsZzojiFAsmx7cIsyovQ84cKBdhvqLD/1Z9diAts0ofgr6SSkl/PJ3cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jQO+NGGz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jQO+NGGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B391F000E9;
	Sun, 21 Jun 2026 18:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067165;
	bh=G52ovGowLW3cb1I/rEFZ4JQEZgAOdJYJYEsC4lUIhbs=;
	h=Date:To:From:Subject;
	b=jQO+NGGzFnqBRZy4u/78HIAX9yd8Rv+247gIsEebaNuVsP3ZvNS/E8QzJPNqjWm7m
	 jed+3kMEfHWvqoKC0PZuKkoVc6pe6qT8sapfO+VM5QcWFSqeevQoNqy8KXsdYYL/X/
	 zNGkkHroKFlMpN+BsQz4jFETLdoSYGBrjpThIsIk=
Date: Sun, 21 Jun 2026 11:39:25 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-hugetlb_fault_after_madv-add-setup-of-hugetlb-pages.patch removed from -mm tree
Message-Id: <20260621183925.74B391F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: hugetlb_fault_after_madv: add setup of HugeTLB pages
has been removed from the -mm tree.  Its filename was
     selftests-mm-hugetlb_fault_after_madv-add-setup-of-hugetlb-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: hugetlb_fault_after_madv: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:21 +0300

hugetlb_fault_after_madv test skips testing if there are no free huge
pages prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Link: https://lore.kernel.org/20260511162840.375890-38-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
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
Cc: Li Wang <li.wang@linux.dev>
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

 tools/testing/selftests/mm/hugetlb_fault_after_madv.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c~selftests-mm-hugetlb_fault_after_madv-add-setup-of-hugetlb-pages
+++ a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
@@ -54,7 +54,6 @@ void *madv(void *unused)
 
 int main(void)
 {
-	unsigned long free_hugepages;
 	pthread_t thread1, thread2;
 	/*
 	 * On kernel 6.4, we are able to reproduce the problem with ~1000
@@ -78,11 +77,8 @@ int main(void)
 	ksft_print_msg("[INFO] detected default hugetlb page size: %zu KiB\n",
 		       huge_page_size / 1024);
 
-	free_hugepages = hugetlb_free_default_pages();
-	if (free_hugepages != 1) {
-		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
-			       free_hugepages);
-	}
+	if (!hugetlb_setup_default(1))
+		ksft_exit_skip("Not enough HugeTLB pages\n");
 
 	while (max--) {
 		huge_ptr = mmap(NULL, huge_page_size, PROT_READ | PROT_WRITE,
_

Patches currently in -mm which might be from rppt@kernel.org are


