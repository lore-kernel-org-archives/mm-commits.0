Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D5B331A78
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 19:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353485; cv=none; b=ZODLeiKeyEiNet9vfehS4qrYw5c7RFxCtu/81/w/UjX1OEn215HmvCtdx8r2vLVE36DyZT/jdR20OS97x9s4ZKWDLdnYO6g2QmuBkBnsog58oxZbKTHvSrqQCvXG7M4yMvZ0Ma0dQe6Q7kS3RKxotKF9hNi5s+LtBsPhTA8um3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353485; c=relaxed/simple;
	bh=r06YnNQoTc6om61chQHcra/Xc/+KWnOeq9dI+vvy25A=;
	h=Date:To:From:Subject:Message-Id; b=RwxXVHNR47xlwFb9vr/qAmYKew+YQR1zQpmfOg0+78w6319+ma/y8Q2eRjqIKqoOXtqFwp4kIYHa33/SrhbegWJ7QNgOJsUJpTHTkgYgi8AowvuhD9If+bh7Ydxsu7UR/Opptjo83Zj1uoqEsI8rbV6TrlFsyI9bE7HsRSpIu3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CNUxEdG3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CNUxEdG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7771F000E9;
	Wed, 29 Jul 2026 19:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785353480;
	bh=ieRj8wwuymbeogIsZllcpX2WIe8CDq0BJve1lY2Xf+4=;
	h=Date:To:From:Subject;
	b=CNUxEdG3qiD3ZQkfE2yC4NuRiV6A+0LSJ/FElfInmra7TZqqUEZMuDWeQE4xna/9c
	 iogx1i79AiUWeZMci4P2eCoRrOVUPQgEiSlgcCFDktEhqsAV+BdfAaB3/mvHxkwamv
	 xbgC9bmXNzt4oZPpzPP3KMmMVvZWAF7VBO//rd6c=
Date: Wed, 29 Jul 2026 12:31:19 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,nao.horiguchi@gmail.com,mhocko@suse.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,david@kernel.org,usama.anjum@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-unpoison-pages-in-memory-failure-teardown.patch added to mm-new branch
Message-Id: <20260729193120.5A7771F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: unpoison pages in memory-failure teardown
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-unpoison-pages-in-memory-failure-teardown.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-unpoison-pages-in-memory-failure-teardown.patch

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
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: selftests/mm: unpoison pages in memory-failure teardown
Date: Wed, 29 Jul 2026 10:11:26 +0100

The memory-failure tests call cleanup() only after all result checks.  A
failed ASSERT_* invokes fixture teardown and aborts the test, so it skips
cleanup() and leaves the injected page hardware-poisoned.

Invoke cleanup() from FIXTURE_TEARDOWN() instead.  Guard it with
self->injection_attempted so tests that exit before injection do not try
to unpoison a page when no injection was attempted.  Injection can poison
a page before returning an error or delivering SIGBUS, so teardown must
clean up after every injection attempt.  This runs the existing HWPoison
and HardwareCorrupted checks on both normal and assertion-failure paths.

Link: https://lore.kernel.org/20260729091127.1001179-1-usama.anjum@arm.com
Fixes: ff4ef2fbd101 ("selftests/mm: add memory failure anonymous page test")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/memory-failure.c |   44 +++++++++---------
 1 file changed, 22 insertions(+), 22 deletions(-)

--- a/tools/testing/selftests/mm/memory-failure.c~selftests-mm-unpoison-pages-in-memory-failure-teardown
+++ a/tools/testing/selftests/mm/memory-failure.c
@@ -46,7 +46,7 @@ FIXTURE(memory_failure)
 	unsigned long pfn;
 	int pagemap_fd;
 	int kpageflags_fd;
-	bool triggered;
+	bool injection_attempted;
 };
 
 FIXTURE_VARIANT(memory_failure)
@@ -122,13 +122,6 @@ static void teardown_sighandler(void)
 	sigaction(SIGBUS, &sa, NULL);
 }
 
-FIXTURE_TEARDOWN(memory_failure)
-{
-	close(self->kpageflags_fd);
-	close(self->pagemap_fd);
-	teardown_sighandler();
-}
-
 static void prepare(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure) * self,
 		    void *vaddr)
 {
@@ -200,8 +193,7 @@ static void check(struct __test_metadata
 	ASSERT_EQ(pfn_flags & KPF_HWPOISON, KPF_HWPOISON);
 }
 
-static void cleanup(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure) * self,
-		    void *vaddr)
+static void cleanup(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure) * self)
 {
 	unsigned long size;
 	uint64_t pfn_flags;
@@ -217,6 +209,20 @@ static void cleanup(struct __test_metada
 	ASSERT_EQ(size, self->corrupted_size);
 }
 
+FIXTURE_TEARDOWN(memory_failure)
+{
+	/*
+	 * Injection may poison the page before failing or delivering SIGBUS, so
+	 * clean up after every injection attempt.
+	 */
+	if (self->injection_attempted)
+		cleanup(_metadata, self);
+
+	close(self->kpageflags_fd);
+	close(self->pagemap_fd);
+	teardown_sighandler();
+}
+
 TEST_F(memory_failure, anon)
 {
 	char *addr;
@@ -231,8 +237,8 @@ TEST_F(memory_failure, anon)
 	prepare(_metadata, self, addr);
 
 	ret = sigsetjmp(signal_jmp_buf, 1);
-	if (!self->triggered) {
-		self->triggered = true;
+	if (!self->injection_attempted) {
+		self->injection_attempted = true;
 		ASSERT_EQ(variant->inject(self, addr), 0);
 		FORCE_READ(*addr);
 	}
@@ -242,8 +248,6 @@ TEST_F(memory_failure, anon)
 	else
 		check(_metadata, self, addr, MADV_SOFT_ANON, ret);
 
-	cleanup(_metadata, self, addr);
-
 	ASSERT_EQ(munmap(addr, self->page_size), 0);
 }
 
@@ -296,8 +300,8 @@ TEST_F(memory_failure, clean_pagecache)
 	prepare(_metadata, self, addr);
 
 	ret = sigsetjmp(signal_jmp_buf, 1);
-	if (!self->triggered) {
-		self->triggered = true;
+	if (!self->injection_attempted) {
+		self->injection_attempted = true;
 		ASSERT_EQ(variant->inject(self, addr), 0);
 		FORCE_READ(*addr);
 	}
@@ -307,8 +311,6 @@ TEST_F(memory_failure, clean_pagecache)
 	else
 		check(_metadata, self, addr, MADV_SOFT_CLEAN_PAGECACHE, ret);
 
-	cleanup(_metadata, self, addr);
-
 	ASSERT_EQ(munmap(addr, self->page_size), 0);
 
 	ASSERT_EQ(close(fd), 0);
@@ -337,8 +339,8 @@ TEST_F(memory_failure, dirty_pagecache)
 	prepare(_metadata, self, addr);
 
 	ret = sigsetjmp(signal_jmp_buf, 1);
-	if (!self->triggered) {
-		self->triggered = true;
+	if (!self->injection_attempted) {
+		self->injection_attempted = true;
 		ASSERT_EQ(variant->inject(self, addr), 0);
 		FORCE_READ(*addr);
 	}
@@ -348,8 +350,6 @@ TEST_F(memory_failure, dirty_pagecache)
 	else
 		check(_metadata, self, addr, MADV_SOFT_DIRTY_PAGECACHE, ret);
 
-	cleanup(_metadata, self, addr);
-
 	ASSERT_EQ(munmap(addr, self->page_size), 0);
 
 	ASSERT_EQ(close(fd), 0);
_

Patches currently in -mm which might be from usama.anjum@arm.com are

selftests-mm-unpoison-pages-in-memory-failure-teardown.patch

