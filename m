Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7384256B851
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 19:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788894742; cv=none; b=C4jUnWbJe816Kky63jPqysar+pmLN7zqiv1LTvvlA/7r7Q1g72rDjdKtN6QjWMEJszwqcrU9C4SCc3WrWVixeRM62V2biRl+ebVZKohd6KNnXRRIVzlafCZJf7m+Lo7LKOHDsgZQTBSBN8HlSIMlCbLW2igxBsduIfhWuppAxm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788894742; c=relaxed/simple;
	bh=fR2EuLgahPhOWDbQCv6FZ1DUiEUcCH6cR07jUkKkuNY=;
	h=Date:To:From:Subject:Message-Id; b=cMxgTdIqwhqw2QNcc3OS/BX48JyCfVEObYGyx71yUb7m7ivRu7mC4vmYzmD4rYsGQV3wpVInpE09cMLvxUNm1DaltW8hUvR6gFY9Ch1n3XCZ1Ng0xFMPQRKM4g9eNhkU5CbubkVXwqoc/OQtEQLZ01Wt+NkXPIZ7Cj8Jc6c402E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A9HEJpHv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A9HEJpHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0AC1F00A3A;
	Tue,  8 Sep 2026 19:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788894741;
	bh=pUdbf+BWFGL4c4MfEqRRNcAM1TYb6U0r9tCU6dhcUwI=;
	h=Date:To:From:Subject;
	b=A9HEJpHvcsF/KikxvnX8BFPLSaw1DPeiEGTvunLM4n+bw3CvB8sSzer6YFZoV6cV0
	 LYa184UWIYbaT8jvQYJJvzNh7wb8i8IoTCBW/9s5RQjVbcsqMQLs0ep6D5J90mO9Iw
	 TeI2WsKzW7EjLk8Ic4sT8xj+t05CkHrtL+IT4cP4=
Date: Tue, 08 Sep 2026 12:12:20 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gourry@gourry.net,david@kernel.org,akpm@linux-foundation.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-init-page-sizes-early-in-pagemap_ioctl-test.patch added to mm-new branch
Message-Id: <20260908191221.0D0AC1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: init page sizes early in pagemap_ioctl test
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-init-page-sizes-early-in-pagemap_ioctl-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-init-page-sizes-early-in-pagemap_ioctl-test.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: selftests/mm: init page sizes early in pagemap_ioctl test
Date: Tue, 8 Sep 2026 21:44:05 +0800

Initialize page_size and hpage_size before calling init_uffd(),
hugetlb_setup_default(), etc.  That won't fix anything, but it is safer
and saner to get these globals set up before doing other things.

While at it, drop the page_size parameter of transact_test(), which is
actually unnecessary.

Link: https://lore.kernel.org/20260908134405.84448-1-zenghui.yu@linux.dev
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
  Link: https://lore.kernel.org/20260628111329.9cfcd9c67925869307020aba@linux-foundation.org/
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-init-page-sizes-early-in-pagemap_ioctl-test
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1488,7 +1488,7 @@ static void *thread_proc(void *mem)
 	return NULL;
 }
 
-static void transact_test(int page_size)
+static void transact_test(void)
 {
 	unsigned int i, count, extra_pages;
 	unsigned int c;
@@ -1652,6 +1652,9 @@ int main(int __attribute__((unused)) arg
 
 	ksft_print_header();
 
+	page_size = getpagesize();
+	hpage_size = read_pmd_pagesize();
+
 	if (init_uffd())
 		ksft_exit_skip("Failed to initialize userfaultfd\n");
 
@@ -1660,9 +1663,6 @@ int main(int __attribute__((unused)) arg
 
 	ksft_set_plan(119);
 
-	page_size = getpagesize();
-	hpage_size = read_pmd_pagesize();
-
 	pagemap_fd = open(PAGEMAP, O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_msg("Failed to open " PAGEMAP "\n");
@@ -1822,7 +1822,7 @@ int main(int __attribute__((unused)) arg
 	mprotect_tests();
 
 	/* 13. Transact test */
-	transact_test(page_size);
+	transact_test();
 
 	/* 14. Sanity testing */
 	sanity_tests();
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

selftests-mm-fix-incorrect-skip-output-in-pkey_sighandler_tests.patch
mm-damon-core-remove-declaration-of-__damon_commit_ctx.patch
selftests-mm-remove-unreachable-returns-after-ksft-exit-helpers.patch
docs-mm-damon-design-fix-broken-ref-usage-and-a-typo.patch
selftests-mm-fix-size-truncation-in-pagemap_ioctl-test.patch
selftests-mm-mark-file-local-symbols-of-pagemap_ioctlc-static.patch
selftests-mm-init-page-sizes-early-in-pagemap_ioctl-test.patch

