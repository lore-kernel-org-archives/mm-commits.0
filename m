Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FF72E5B1B
	for <mm-commits@vger.kernel.org>; Fri,  6 Feb 2026 04:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770353437; cv=none; b=FqyH+O/TvhdRfqOqL/WQoog+aoYI8ZX6UNWpVMyz0upXH81hXDmAdqoPSV8Uhcv8z97K8+40KjkSI5BWwtkdDhqP0qHNx2cSEFrCn8DIMbnkTb2h0xq1brSEVn0vuXemsQwfC0YmJIKwb3vyGuTOWIs1AwLcqSMblZQ4zizQPkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770353437; c=relaxed/simple;
	bh=d0LkHBQ3Gz7HidlGDQWFdXGKT6gug0AXpLnwrwt3Vtk=;
	h=Date:To:From:Subject:Message-Id; b=kAEVm9fG290TUedKkPgUmeLGkRF6IqLnMEKHY2/IfcQUuPkYTwiLjbcwlXU0kPacyiPho2+yxC9HxSJR77PPcX3gpYsyG3I2EUrFNdQd6vlIrdO3ePpaQODcr7EQ5MbRpnwyufZKYxJsFCSq3/JDmhuo6IrtdEjd+haxvrM0kec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UyjsVIY9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UyjsVIY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45260C116C6;
	Fri,  6 Feb 2026 04:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770353437;
	bh=d0LkHBQ3Gz7HidlGDQWFdXGKT6gug0AXpLnwrwt3Vtk=;
	h=Date:To:From:Subject:From;
	b=UyjsVIY90irKg1aB79PzkQkynqzxVEUDZQsfQo9ObFmsUf+AseE0l/xEWVEDupL77
	 MIEJxRHlC3uuZjEjw4M6QXnqMNndNWnHqpKt5kLrwsb1KASqHbiseGj3gZDTIobteC
	 nvMp1xQFQGqyNtNJQWIlIMUEIKVI7qZzPviq5ctY=
Date: Thu, 05 Feb 2026 20:50:36 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,nao.horiguchi@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-add-memory-failure-dirty-pagecache-test.patch removed from -mm tree
Message-Id: <20260206045037.45260C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add memory failure dirty pagecache test
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-memory-failure-dirty-pagecache-test.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: selftests/mm: add memory failure dirty pagecache test
Date: Tue, 20 Jan 2026 20:32:39 +0800

This patch adds a new testcase to validate memory failure handling for
dirty pagecache.  This performs similar operations as clean pagecaches
except fsync() is not used to keep pages dirty.

This test helps ensure that memory failure handling for dirty pagecache
works correctly, including proper SIGBUS delivery, page isolation, and
recovery paths.

Link: https://lkml.kernel.org/r/20260120123239.909882-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
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

 tools/testing/selftests/mm/memory-failure.c |   62 ++++++++++++++++--
 1 file changed, 58 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/memory-failure.c~selftests-mm-add-memory-failure-dirty-pagecache-test
+++ a/tools/testing/selftests/mm/memory-failure.c
@@ -29,8 +29,10 @@ enum inject_type {
 enum result_type {
 	MADV_HARD_ANON,
 	MADV_HARD_CLEAN_PAGECACHE,
+	MADV_HARD_DIRTY_PAGECACHE,
 	MADV_SOFT_ANON,
 	MADV_SOFT_CLEAN_PAGECACHE,
+	MADV_SOFT_DIRTY_PAGECACHE,
 };
 
 static jmp_buf signal_jmp_buf;
@@ -162,6 +164,7 @@ static void check(struct __test_metadata
 	case MADV_SOFT_ANON:
 	case MADV_HARD_CLEAN_PAGECACHE:
 	case MADV_SOFT_CLEAN_PAGECACHE:
+	case MADV_SOFT_DIRTY_PAGECACHE:
 		/* It is not expected to receive a SIGBUS signal. */
 		ASSERT_EQ(setjmp, 0);
 
@@ -172,6 +175,7 @@ static void check(struct __test_metadata
 		ASSERT_NE(pagemap_get_pfn(self->pagemap_fd, vaddr), self->pfn);
 		break;
 	case MADV_HARD_ANON:
+	case MADV_HARD_DIRTY_PAGECACHE:
 		/* The SIGBUS signal should have been received. */
 		ASSERT_EQ(setjmp, 1);
 
@@ -244,6 +248,18 @@ TEST_F(memory_failure, anon)
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
 /* Borrowed from mm/gup_longterm.c. */
 static __fsword_t get_fs_type(int fd)
 {
@@ -259,17 +275,14 @@ static __fsword_t get_fs_type(int fd)
 
 TEST_F(memory_failure, clean_pagecache)
 {
-	const char *fname = "./clean-page-cache-test-file";
 	int fd;
 	char *addr;
 	int ret;
 	__fsword_t fs_type;
 
-	fd = open(fname, O_RDWR | O_CREAT, 0664);
+	fd = prepare_file("./clean-page-cache-test-file", self->page_size);
 	if (fd < 0)
 		SKIP(return, "failed to open test file.\n");
-	unlink(fname);
-	ftruncate(fd, self->page_size);
 	fs_type = get_fs_type(fd);
 	if (!fs_type || fs_type == TMPFS_MAGIC)
 		SKIP(return, "unsupported filesystem :%lx\n", fs_type);
@@ -297,6 +310,47 @@ TEST_F(memory_failure, clean_pagecache)
 
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
+	__fsword_t fs_type;
+
+	fd = prepare_file("./dirty-page-cache-test-file", self->page_size);
+	if (fd < 0)
+		SKIP(return, "failed to open test file.\n");
+	fs_type = get_fs_type(fd);
+	if (!fs_type || fs_type == TMPFS_MAGIC)
+		SKIP(return, "unsupported filesystem :%lx\n", fs_type);
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


