Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0307D369D64
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622954; cv=none; b=bOPFuRx/+PsA0vEYfupY84e2+l0eQviHmRkJZuXEEuPiN33f7J3zGvli6wS//7GV4rwGMAnY2J1xeXwx0hl5RKpQ6Nzl0ybbJQ+njOFdswBxuCctO0RXOP8WyoupcB6Vhc8ISwA8Osu6YCCHtxtDG4rO0JBjj1dHQdyZkeWE+0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622954; c=relaxed/simple;
	bh=8K+qxdwCzCFUx2cNaxlibh98gdAKCFQZskjFnaA9714=;
	h=Date:To:From:Subject:Message-Id; b=LYksuxg7U2pp1gUR+64sgBYgq/zLTdYzD8ESh1HSfUG3ssu+RFE1HDY/x4c3zItQsxo8UW3sxp73n6Qrq3cCrSyqg2aa0IKnQYuWyvFVHdEbkWQ9XbohK6LyxwSoXQWeX2fm8ebZYexjDJep0Tqejg4h0cXIj5k0zvfUCOaTRTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uudghGz6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uudghGz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7BC1F000E9;
	Tue, 25 Aug 2026 01:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622952;
	bh=KEgP8DIy3PS6mUG+CvavVRhvmED+rGGKv0lzIjMezKg=;
	h=Date:To:From:Subject;
	b=uudghGz6enLMF45tguGhwGbu6LEyZXCjD8DuvwrYRCvq6S0JaVWeCDWq1Ys2wrHUg
	 yH/4qxykD8t8IA5snz/IgLipWhjUosa+ij1hNB5sS5Ddf/qQ8CsOMZIlvqGGOj7bMd
	 VB4mExasiMZshLLseffJFoy54HzhHjlHyoUnQUm0=
Date: Mon, 24 Aug 2026 18:55:52 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@arm.com,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,anshuman.khandual@arm.com,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-drop-redundant-open-in-mprotect_tests.patch removed from -mm tree
Message-Id: <20260825015552.CD7BC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: drop redundant open() in mprotect_tests()
has been removed from the -mm tree.  Its filename was
     selftests-mm-drop-redundant-open-in-mprotect_tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/mm: drop redundant open() in mprotect_tests()
Date: Mon, 17 Aug 2026 16:06:16 +0800

Remove duplicate open() for local pagemap_fd in mprotect_tests() that
shadows the global pagemap_fd already opened in main().  The local fd is
never used in the function.

Link: https://lore.kernel.org/20260817080616.52946-1-hongfu.li@linux.dev
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-drop-redundant-open-in-mprotect_tests
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1332,12 +1332,6 @@ int mprotect_tests(void)
 	int ret;
 	char *mem, *mem2;
 	struct page_region vec;
-	int pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
-
-	if (pagemap_fd < 0) {
-		fprintf(stderr, "open() failed\n");
-		exit(1);
-	}
 
 	/* 1. Map two pages */
 	mem = mmap(0, 2 * page_size, PROT_READ|PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-use-a-folio-in-the-softleaf_is_device_private-path.patch

