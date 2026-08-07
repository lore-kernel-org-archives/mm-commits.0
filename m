Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E033C10BB
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068169; cv=none; b=paQ5MUZs5BFmpiLtMRdS/oo9l6kUXFzqBTzTGlD5NJcLCF5QWSDVOL7EkzJMLdlpBOzNlCQ+KeTDEf321jcfmC6ASsOvIugocJxav1bnoYTr3GbidCjHuoRHa9qVD5WBpwLTi6moDBzG5UMFv5xmFeNDDbavXKn/1JXOg4TDu+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068169; c=relaxed/simple;
	bh=8ahHQXkjh4x5pvCSu6QCWAFMpUf/qm9lI1Y6kzuyEzI=;
	h=Date:To:From:Subject:Message-Id; b=KpixVXYKfbMU/Abbkke3rrFRSL7IDFOAUgOkGe4W9oQHpPGFvtaO8yjPXs6AxxBZ+c1PTp+8vCULgNZVsdIRDeNsz3u4bibZ5lPSul5215ZyPDxATOa/r0zECUa80V+ggank1mxYgVQxpDB1k9xMvC+UWGEV7K2hBb16I3OZa1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RPbuOyMq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RPbuOyMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B793E1F00A3A;
	Fri,  7 Aug 2026 02:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068167;
	bh=NrNQCU2zE+UVvYunPnXXNdbkQjDVdHwaNI03iQkLTsg=;
	h=Date:To:From:Subject;
	b=RPbuOyMqKqd4/0inwok51CkT4vIrIUwivIpLm+AZu2fImc7806TLV5g3TT9JLZRnd
	 oVBAzwmo2l5WgL6sOxHzBKGeUirMi4QwhH0sIHFAXCaTpWBEjytoWIYfdw3PY0cvB1
	 nC6Yv3y+ELzMoWwwyutWd0DE5jYK7JTa3uCsFVzQ=
Date: Thu, 06 Aug 2026 19:02:47 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,nao.horiguchi@gmail.com,mhocko@suse.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,david@kernel.org,usama.anjum@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-unpoison-pages-in-memory-failure-teardown.patch removed from -mm tree
Message-Id: <20260807020247.B793E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: unpoison pages in memory-failure teardown
has been removed from the -mm tree.  Its filename was
     selftests-mm-unpoison-pages-in-memory-failure-teardown.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
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

selftests-mm-skip-cow-tmpfile-cases-when-fallocate-is-unsupported.patch
selftests-mm-skip-guard-hole-punch-test-if-madv_remove-is-unsupported.patch
selftests-mm-skip-khugepaged-swap-tests-without-swap.patch
selftests-mm-skip-hard-dirty-page-cache-test-on-nfs.patch
selftests-mm-retry-migration-failures-for-the-full-runtime.patch

