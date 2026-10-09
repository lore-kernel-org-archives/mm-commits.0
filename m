Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC06440099C
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525451; cv=none; b=MuLr9iG3JJSI9H/45Twak2FqZur4Gqf2/XJeIYZr7xpb14irQAU1VjrX4C73597p9kHvf3TOqNFN25gJ6mL9EgWSGkzAsCQmESgFa38RhA1ojqzHlVwz1l6mCltUvxAnCXOpD9TAySXpnsvg74rijAF2GCBbdN8kFF9oRkSu8HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525451; c=relaxed/simple;
	bh=v6ORvWOSfNTMSGplXUdf4sQ8UMp5Nw14w83OH0RhYLk=;
	h=Date:To:From:Subject:Message-Id; b=j8iApEj83hMNXKd6l2JVusdvIQuxONm1ogzUowW05wQJy8q4Toadbxobv92ltb3lPlIYR/xhuZLyC9EjgiOffq8HAwA6i5MnvvgyEAG3bQuCM34Zl83d4vMuafjQDwJM0JmHQY7yVPfT/gYlU6GiJN0rKYAz0fVRWz2nIQJplD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rcXaBQs2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rcXaBQs2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A021F000FF;
	Fri,  9 Oct 2026 05:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525450;
	bh=jaCYELhIWj6f8JhRLWK0emXi5DoeR/DdejU1axiwtBI=;
	h=Date:To:From:Subject;
	b=rcXaBQs2TP0wdD4hqfd/HQcyB/uUWpHj6xu2X40Tm0i25cBttVoNeSGuxW8KPKvKa
	 md/a+CuVmXYqJOPkZDaUIwNW98xQgE3TilYbfoOvooxj4P4EASHYra28YrDchYMTb8
	 3+01GLvDJStejx/t36OFgqvMD/Qu0Tbex6Sq/Liw=
Date: Thu, 08 Oct 2026 22:57:30 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gourry@gourry.net,david@kernel.org,akpm@linux-foundation.org,zenghui.yu@linux.dev
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-init-page-sizes-early-in-pagemap_ioctl-test.patch removed from -mm tree
Message-Id: <20261009055730.81A021F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: init page sizes early in pagemap_ioctl test
has been removed from the -mm tree.  Its filename was
     selftests-mm-init-page-sizes-early-in-pagemap_ioctl-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
---

 tools/testing/selftests/mm/pagemap_ioctl.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-init-page-sizes-early-in-pagemap_ioctl-test
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1489,7 +1489,7 @@ static void *thread_proc(void *mem)
 	return NULL;
 }
 
-static void transact_test(int page_size)
+static void transact_test(void)
 {
 	unsigned int i, count, extra_pages;
 	unsigned int c;
@@ -1653,6 +1653,9 @@ int main(int __attribute__((unused)) arg
 
 	ksft_print_header();
 
+	page_size = getpagesize();
+	hpage_size = read_pmd_pagesize();
+
 	if (init_uffd())
 		ksft_exit_skip("Failed to initialize userfaultfd\n");
 
@@ -1661,9 +1664,6 @@ int main(int __attribute__((unused)) arg
 
 	ksft_set_plan(119);
 
-	page_size = getpagesize();
-	hpage_size = read_pmd_pagesize();
-
 	pagemap_fd = open(PAGEMAP, O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_msg("Failed to open " PAGEMAP "\n");
@@ -1823,7 +1823,7 @@ int main(int __attribute__((unused)) arg
 	mprotect_tests();
 
 	/* 13. Transact test */
-	transact_test(page_size);
+	transact_test();
 
 	/* 14. Sanity testing */
 	sanity_tests();
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

selftests-damon-stop-kdamond-on-error-exits-of-no-op-commit-test.patch
selftests-damon-ignore-test-generated-damon_dump_output.patch
mm-damon-api-remove-unused-nr_damos_-enumerators.patch

