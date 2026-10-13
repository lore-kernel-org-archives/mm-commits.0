Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C0B484230
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865987; cv=none; b=N7SeVvcgVMq+rLlUKRi8AB3CEHsu0tqnHhaJgt6P4xInpMvgRWHgdxKqkCEQrqztf2mAO9JT6SygISNmuz1eREsHVMRFri3wMqXCZR6QRpUPVBzkcFkNLoV4UMeHwXSydxg3p5Cd3oVMrWVBCJCtzmyXBue38Kj0FJfLK8G8FOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865987; c=relaxed/simple;
	bh=vXpYiveG5X2tbAJ0yvotW6ZaF9TGhwLhAf5eGmSJrSg=;
	h=Date:To:From:Subject:Message-Id; b=VpQFrgwhPxycKs2L+SnIyZPm1eTxamwL/zR6xh8gJghRv5WhRy87Q3rQ78sF9aZ3aCL22p+03xoUYr8lN9slUwSResTDuQy8RdZ/Oxs3SakLlqug7LKH8HBcBqO7sx4Me1nmCvq3hcDr31TvYCu+pDZqpMpEnzG9lwfPlDeE4a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SYz2OJzi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SYz2OJzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5AB1F00893;
	Tue, 13 Oct 2026 04:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865986;
	bh=YdHbZjC6lmIRENxkbVuh+0JzM0mfQQzmvfk/VLUadiQ=;
	h=Date:To:From:Subject;
	b=SYz2OJziSfs+Zu3nZu8ce3nRR+hiuElRPB9WRjk5ULNk/dgHi9lWDNuB7lDMcIzWG
	 nLpyDUPrKVjd2FUJdAjVbxdAnIj63G7MWMxbmODRUMnWGAhzjb7BjK7pawjBWNHJGs
	 qj3dFO26HAg8/e6eZQBGdqIc6sOn0eLYT4yfc1KE=
Date: Mon, 12 Oct 2026 21:33:06 -0700
To: mm-commits@vger.kernel.org,yu.c.zhang@linux.intel.com,xiaoyao.li@intel.com,vbabka@kernel.org,vannapurve@google.com,tabba@google.com,surenb@google.com,shuah@kernel.org,seanjc@google.com,rppt@kernel.org,rientjes@google.com,riel@redhat.com,pbonzini@redhat.com,nao.horiguchi@gmail.com,michael.roth@amd.com,mhocko@suse.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,jiaqiyan@google.com,isaku.yamahata@intel.com,hughd@google.com,hidehiro.kawai.ez@hitachi.com,david@kernel.org,dave.hansen@linux.intel.com,baolin.wang@linux.alibaba.com,andi@firstfloor.org,ackerleytng@google.com,wyihan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-selftests-add-shmem-into-memory-failure-test.patch removed from -mm tree
Message-Id: <20261013043306.5F5AB1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: selftests: Add shmem into memory failure test
has been removed from the -mm tree.  Its filename was
     mm-selftests-add-shmem-into-memory-failure-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lisa Wang <wyihan@google.com>
Subject: mm: selftests: Add shmem into memory failure test
Date: Thu, 17 Sep 2026 20:43:51 +0000

Add a shmem memory failure selftest to test the shmem memory failure is
correct after modifying shmem return value.

Specifically, test the expected behavior under various scenarios
combining page dirtiness (dirty vs clean) and failure types (hard vs
soft):
+ Dirty + Hard: Trigger a SIGBUS on injection, and trigger another
  SIGBUS when reading the page again.
+ Dirty + Soft: No SIGBUS is triggered, and the original value can be
  read successfully.
+ Clean + Hard: No SIGBUS is triggered on injection, but trigger a
  SIGBUS when trying to read the page again.
+ Clean + Soft: No SIGBUS is triggered, and the page can be read
  successfully.

[akpm@linux-foundation.org: fix comment typo, per Lisa]
Link: https://lore.kernel.org/20260917-memory-failure-mf-delayed-fix-v6-5-4b00856b5364@google.com
Signed-off-by: Lisa Wang <wyihan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michael Roth <michael.roth@amd.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
---

 tools/testing/selftests/mm/memory-failure.c |  114 +++++++++++++++++-
 1 file changed, 111 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/memory-failure.c~mm-selftests-add-shmem-into-memory-failure-test
+++ a/tools/testing/selftests/mm/memory-failure.c
@@ -29,9 +29,14 @@ enum result_type {
 	MADV_HARD_ANON,
 	MADV_HARD_CLEAN_PAGECACHE,
 	MADV_HARD_DIRTY_PAGECACHE,
+	MADV_HARD_CLEAN_SHMEM,
+	MADV_HARD_DIRTY_SHMEM,
 	MADV_SOFT_ANON,
 	MADV_SOFT_CLEAN_PAGECACHE,
 	MADV_SOFT_DIRTY_PAGECACHE,
+	MADV_SOFT_CLEAN_SHMEM,
+	MADV_SOFT_DIRTY_SHMEM,
+	READ_ERROR,
 };
 
 static jmp_buf signal_jmp_buf;
@@ -157,17 +162,22 @@ static void check(struct __test_metadata
 	case MADV_HARD_CLEAN_PAGECACHE:
 	case MADV_SOFT_CLEAN_PAGECACHE:
 	case MADV_SOFT_DIRTY_PAGECACHE:
-		/* It is not expected to receive a SIGBUS signal. */
-		ASSERT_EQ(setjmp, 0);
-
+	case MADV_SOFT_DIRTY_SHMEM:
 		/* The page content should remain unchanged. */
 		ASSERT_TRUE(check_memory(vaddr, self->page_size));
+		/* FALLTHROUGH */
+	case MADV_HARD_CLEAN_SHMEM:
+	case MADV_SOFT_CLEAN_SHMEM:
+		/* It is not expected to receive a SIGBUS signal. */
+		ASSERT_EQ(setjmp, 0);
 
 		/* The backing pfn of addr should have changed. */
 		ASSERT_NE(pagemap_get_pfn(self->pagemap_fd, vaddr), self->pfn);
 		break;
 	case MADV_HARD_ANON:
 	case MADV_HARD_DIRTY_PAGECACHE:
+	case MADV_HARD_DIRTY_SHMEM:
+	case READ_ERROR:
 		/* The SIGBUS signal should have been received. */
 		ASSERT_EQ(setjmp, 1);
 
@@ -263,6 +273,20 @@ static int prepare_file(const char *fnam
 	return fd;
 }
 
+static int prepare_shmem(const char *fname, unsigned long size)
+{
+	int fd;
+
+	fd = memfd_create(fname, 0);
+	if (fd < 0)
+		return -1;
+	if (ftruncate(fd, size) < 0) {
+		close(fd);
+		return -1;
+	}
+	return fd;
+}
+
 /* Borrowed from mm/gup_longterm.c. */
 static int get_fs_type(int fd)
 {
@@ -362,6 +386,90 @@ TEST_F(memory_failure, dirty_pagecache)
 
 	ASSERT_EQ(munmap(addr, self->page_size), 0);
 
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST_F(memory_failure, dirty_shmem)
+{
+	int fd;
+	char *addr;
+	int ret;
+
+	fd = prepare_shmem("shmem-file", self->page_size);
+	if (fd < 0)
+		SKIP(return, "failed to open test shmem-file.\n");
+
+	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
+		    MAP_SHARED, fd, 0);
+	if (addr == MAP_FAILED) {
+		close(fd);
+		SKIP(return, "mmap failed, not enough memory.\n");
+	}
+	memset(addr, 0xce, self->page_size);
+
+	prepare(_metadata, self, addr);
+
+	ret = sigsetjmp(signal_jmp_buf, 1);
+	if (!ret && !self->injection_attempted) {
+		self->injection_attempted = true;
+		ASSERT_EQ(variant->inject(self, addr), 0);
+	}
+
+	if (variant->type == MADV_HARD) {
+		check(_metadata, self, addr, MADV_HARD_DIRTY_SHMEM, ret);
+		ret = sigsetjmp(signal_jmp_buf, 1);
+		if (ret == 0)
+			FORCE_READ(*addr);
+		check(_metadata, self, addr, READ_ERROR, ret);
+	} else {
+		check(_metadata, self, addr, MADV_SOFT_DIRTY_SHMEM, ret);
+	}
+
+	ASSERT_EQ(munmap(addr, self->page_size), 0);
+
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST_F(memory_failure, clean_shmem)
+{
+	int fd;
+	char *addr;
+	int ret;
+
+	fd = prepare_shmem("shmem-file", self->page_size);
+	if (fd < 0)
+		SKIP(return, "failed to open test shmem-file.\n");
+
+	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
+		    MAP_SHARED, fd, 0);
+	if (addr == MAP_FAILED) {
+		close(fd);
+		SKIP(return, "mmap failed, not enough memory.\n");
+	}
+	FORCE_READ(*addr);
+
+	prepare(_metadata, self, addr);
+
+	ret = sigsetjmp(signal_jmp_buf, 1);
+	if (!ret && !self->injection_attempted) {
+		self->injection_attempted = true;
+		ASSERT_EQ(variant->inject(self, addr), 0);
+	}
+
+	if (variant->type == MADV_HARD) {
+		check(_metadata, self, addr, MADV_HARD_CLEAN_SHMEM, ret);
+		ret = sigsetjmp(signal_jmp_buf, 1);
+		if (ret == 0)
+			FORCE_READ(*addr);
+		check(_metadata, self, addr, READ_ERROR, ret);
+	} else {
+		/* Test the address accessability without check_memory(). */
+		FORCE_READ(*addr);
+		check(_metadata, self, addr, MADV_SOFT_CLEAN_SHMEM, ret);
+	}
+
+	ASSERT_EQ(munmap(addr, self->page_size), 0);
+
 	ASSERT_EQ(close(fd), 0);
 }
 
_

Patches currently in -mm which might be from wyihan@google.com are


