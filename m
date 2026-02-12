Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CE428505E
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939870; cv=none; b=Z1gwaXTjv9qHPz3LlaPs+UTSnIig4WMoQnzVu07P1XQ+bhZXy1naUMBd8PsIxzf6NmzST7cvf/QPcfp0jh0NCOVvm3pRIO2NePuD1wQmj9Pg6ZNS3SJyoSJAgeu+FTwepEdbibzk1EWXHeDpKJffYrcLQBEmxIAPnm1KZmmK1ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939870; c=relaxed/simple;
	bh=2VkEzhZMg9BcMY+JhiMTo69PYsa/bP8xeF7X2lJfAKo=;
	h=Date:To:From:Subject:Message-Id; b=iYDAo8PCf42QVcELeUKxXTed4C/px+HTBTElb2+dlFDM2VdKt+Schu6PKR22cPyG3yDJlHUHXdC+/4M1dD75NEPh72Hb+2Vvqq5F1hxzt9ti0HWo+VRWzEDoIfqfht/u1u+nRGhiXhbIit/LAG/6p2I2zxXwZZhImMfvxfT4B4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pfbddi88; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pfbddi88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A484C4CEF7;
	Thu, 12 Feb 2026 23:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939870;
	bh=2VkEzhZMg9BcMY+JhiMTo69PYsa/bP8xeF7X2lJfAKo=;
	h=Date:To:From:Subject:From;
	b=Pfbddi88r4qugrNq+Au/4lStPS94iUXWrPJeVwI31cYZQOgwyDn9fdbkDNtWcXN7F
	 N5mX3HosPYsPHqR1ufzHMXEdGlIzF/+1Qx5HcrGkDv8DPcEkx+Mrt+ogk7mcvu0dHS
	 JzdebCCRLNcnR40JDP51UG0314ePx4zQb87gYihw=
Date: Thu, 12 Feb 2026 15:44:29 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,nao.horiguchi@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,lkp@intel.com,liam.howlett@oracle.com,david@kernel.org,broonie@kernel.org,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-memory-failure-dirty-pagecache-test.patch removed from -mm tree
Message-Id: <20260212234430.5A484C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add memory failure dirty pagecache test
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-memory-failure-dirty-pagecache-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: selftests/mm: add memory failure dirty pagecache test
Date: Fri, 6 Feb 2026 11:16:39 +0800

This patch adds a new testcase to validate memory failure handling for
dirty pagecache.  This performs similar operations as clean pagecaches
except fsync() is not used to keep pages dirty.

This test helps ensure that memory failure handling for dirty pagecache
works correctly, including proper SIGBUS delivery, page isolation, and
recovery paths.

Link: https://lkml.kernel.org/r/20260206031639.2707102-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kernel test robot <lkp@intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
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
 static int get_fs_type(int fd)
 {
@@ -259,17 +275,14 @@ static int get_fs_type(int fd)
 
 TEST_F(memory_failure, clean_pagecache)
 {
-	const char *fname = "./clean-page-cache-test-file";
 	int fd;
 	char *addr;
 	int ret;
 	int fs_type;
 
-	fd = open(fname, O_RDWR | O_CREAT, 0664);
+	fd = prepare_file("./clean-page-cache-test-file", self->page_size);
 	if (fd < 0)
 		SKIP(return, "failed to open test file.\n");
-	unlink(fname);
-	ftruncate(fd, self->page_size);
 	fs_type = get_fs_type(fd);
 	if (!fs_type || fs_type == TMPFS_MAGIC)
 		SKIP(return, "unsupported filesystem :%x\n", fs_type);
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
+	int fs_type;
+
+	fd = prepare_file("./dirty-page-cache-test-file", self->page_size);
+	if (fd < 0)
+		SKIP(return, "failed to open test file.\n");
+	fs_type = get_fs_type(fd);
+	if (!fs_type || fs_type == TMPFS_MAGIC)
+		SKIP(return, "unsupported filesystem :%x\n", fs_type);
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


