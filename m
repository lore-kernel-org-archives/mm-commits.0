Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0091E515
	for <mm-commits@vger.kernel.org>; Sat, 10 Jan 2026 23:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768089152; cv=none; b=ZoVGrdDWJCZ1rgDi6G7ilpS668co5zcv+J83gYXFOR2CPsY+l0h8SktJYOBHwweEubpiGGwws3YyGBiZZ2d84K/s+dLCaO8ntdg8Nvn7XUOBfHNZ+865gpXuplG9l3bho84lCKU0x32aAnnFbC/5VF/DXagKZy+HJ2V3afppxTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768089152; c=relaxed/simple;
	bh=yksyR+pgtVj1aDHaNgZ7muXayQ90GyPQYgRivpj9a+o=;
	h=Date:To:From:Subject:Message-Id; b=c/KRPb0pAsAuNgN3a/VbwnhuqzHoeDVd2Bb3bb8yCIi4BWg35PLeoFuTbw41+/LEoyq6SOi0Kcp5X0XtjbGU8xD74w/FIJeMkiZLOmAec+4H9VBfBPk6ps9csRJrQZL81yErVu3ROT0TXlRv5Knp98ugYCuw8qZuFmjV/Yix054=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A8uKIQm9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A8uKIQm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8040BC4CEF1;
	Sat, 10 Jan 2026 23:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768089152;
	bh=yksyR+pgtVj1aDHaNgZ7muXayQ90GyPQYgRivpj9a+o=;
	h=Date:To:From:Subject:From;
	b=A8uKIQm9yLmMoGuXTSg+g+Tv08ZTtDLv9sytsGfIgOJjryAI40sd8mATOsICvpQKx
	 5Ej3S/JUpV0IOZsaQPTbhpwmsOViQ24PxBK001cPZq/78wATiIy+1QPRmHdGX2fvCE
	 4zJyaVQr8gfYLosdVbjA8V7LIhx9ADY42hlMIZYo=
Date: Sat, 10 Jan 2026 15:52:32 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,nao.horiguchi@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] selftests-mm-add-memory-failure-dirty-pagecache-test.patch removed from -mm tree
Message-Id: <20260110235232.8040BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add memory failure dirty pagecache test
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-memory-failure-dirty-pagecache-test.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: selftests/mm: add memory failure dirty pagecache test
Date: Wed, 7 Jan 2026 17:37:10 +0800

This patch adds a new testcase to validate memory failure handling for
dirty pagecache.  This performs similar operations as clean pagecaches
except fsync() is not used to keep pages dirty.

This test helps ensure that memory failure handling for dirty pagecache
works correctly, including proper SIGBUS delivery, page isolation, and
recovery paths.

Link: https://lkml.kernel.org/r/20260107093710.3928374-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/memory-failure.c |   58 ++++++++++++++++--
 1 file changed, 54 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/memory-failure.c~selftests-mm-add-memory-failure-dirty-pagecache-test
+++ a/tools/testing/selftests/mm/memory-failure.c
@@ -26,8 +26,10 @@ enum inject_type {
 enum result_type {
 	MADV_HARD_ANON,
 	MADV_HARD_CLEAN_PAGECACHE,
+	MADV_HARD_DIRTY_PAGECACHE,
 	MADV_SOFT_ANON,
 	MADV_SOFT_CLEAN_PAGECACHE,
+	MADV_SOFT_DIRTY_PAGECACHE,
 };
 
 static jmp_buf signal_jmp_buf;
@@ -159,6 +161,7 @@ static void check(struct __test_metadata
 	case MADV_SOFT_ANON:
 	case MADV_HARD_CLEAN_PAGECACHE:
 	case MADV_SOFT_CLEAN_PAGECACHE:
+	case MADV_SOFT_DIRTY_PAGECACHE:
 		/* It is not expected to receive a SIGBUS signal. */
 		ASSERT_EQ(setjmp, 0);
 
@@ -169,6 +172,7 @@ static void check(struct __test_metadata
 		ASSERT_NE(pagemap_get_pfn(self->pagemap_fd, vaddr), self->pfn);
 		break;
 	case MADV_HARD_ANON:
+	case MADV_HARD_DIRTY_PAGECACHE:
 		/* The SIGBUS signal should have been received. */
 		ASSERT_EQ(setjmp, 1);
 
@@ -241,18 +245,27 @@ TEST_F(memory_failure, anon)
 	ASSERT_EQ(munmap(addr, self->page_size), 0);
 }
 
+static int prepare_file(const char *fname, unsigned long size)
+{
+	int fd;
+
+	fd = open(fname, O_RDWR | O_CREAT, 0664);
+	if (fd >= 0) {
+		unlink(fname);
+		ftruncate(fd, size);
+	}
+	return fd;
+}
+
 TEST_F(memory_failure, clean_pagecache)
 {
-	const char *fname = "./clean-page-cache-test-file";
 	int fd;
 	char *addr;
 	int ret;
 
-	fd = open(fname, O_RDWR | O_CREAT, 0664);
+	fd = prepare_file("./clean-page-cache-test-file", self->page_size);
 	if (fd < 0)
 		SKIP(return, "failed to open test file.\n");
-	unlink(fname);
-	ftruncate(fd, self->page_size);
 
 	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
 		    MAP_SHARED, fd, 0);
@@ -277,6 +290,43 @@ TEST_F(memory_failure, clean_pagecache)
 
 	cleanup(_metadata, self, addr);
 
+	ASSERT_EQ(munmap(addr, self->page_size), 0);
+
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST_F(memory_failure, dirty_pagecache)
+{
+	int fd;
+	char *addr;
+	int ret;
+
+	fd = prepare_file("./dirty-page-cache-test-file", self->page_size);
+	if (fd < 0)
+		SKIP(return, "failed to open test file.\n");
+
+	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
+		    MAP_SHARED, fd, 0);
+	if (addr == MAP_FAILED)
+		SKIP(return, "mmap failed, not enough memory.\n");
+	memset(addr, 0xce, self->page_size);
+
+	prepare(_metadata, self, addr);
+
+	ret = sigsetjmp(signal_jmp_buf, 1);
+	if (!self->triggered) {
+		self->triggered = true;
+		ASSERT_EQ(variant->inject(self, addr), 0);
+		FORCE_READ(*addr);
+	}
+
+	if (variant->type == MADV_HARD)
+		check(_metadata, self, addr, MADV_HARD_DIRTY_PAGECACHE, ret);
+	else
+		check(_metadata, self, addr, MADV_SOFT_DIRTY_PAGECACHE, ret);
+
+	cleanup(_metadata, self, addr);
+
 	ASSERT_EQ(munmap(addr, self->page_size), 0);
 
 	ASSERT_EQ(close(fd), 0);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


