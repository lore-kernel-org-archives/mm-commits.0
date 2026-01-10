Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B37D1E515
	for <mm-commits@vger.kernel.org>; Sat, 10 Jan 2026 23:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768089151; cv=none; b=CubPMkoFzca86LhividUIa+XI19E958g2Nd9BDBA41GwFVIZXsIr+Xwmkx+pXp2SHf53RXkWYn5K3lW3PM6/iSBWqBZOBYC0vM2cmjF4PZPWeT5x9sDCh2OloKCaOrPusxsriqM54M6ctuAWZq16S6P5GnX/JnKrW0dC/WFCC3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768089151; c=relaxed/simple;
	bh=v+ZeE/Ey7siRSz98D+VSkhLTjuSuW7Dj1Red8VIv44A=;
	h=Date:To:From:Subject:Message-Id; b=CBCTYara1BHv7/TFF+uufMk/jOLSiBXJo1/41KFB0poZFSvIWdMiYvAa7Doy+Cmh1gKZe3qomHIMj2iHX7Fnzh/M+9BfkpO7YM6DmlyP78SMWC026LmWUO1PZlyNey2/ywV+0NrJM6Ane/xePkxUsdZI57JxcFlwl2mHwXIyjfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=obH3wDqB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="obH3wDqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B137C116C6;
	Sat, 10 Jan 2026 23:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768089151;
	bh=v+ZeE/Ey7siRSz98D+VSkhLTjuSuW7Dj1Red8VIv44A=;
	h=Date:To:From:Subject:From;
	b=obH3wDqB0okofOeF/o6NWud68iAYc+sUpFnKdW6b+R5UEzCBOueisxOVSOvkcVaeb
	 avyzJhcq1FfKBjVIyUk8STCB6obr9um8KS000UrDzO4tlpWAuaQXfUswp4yiIj8l3k
	 cifj0N4FFcFu0uGXgjhrdHTu6SphxwsQVwS0Du8s=
Date: Sat, 10 Jan 2026 15:52:30 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,nao.horiguchi@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] selftests-mm-add-memory-failure-clean-pagecache-test.patch removed from -mm tree
Message-Id: <20260110235231.4B137C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add memory failure clean pagecache test
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-memory-failure-clean-pagecache-test.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: selftests/mm: add memory failure clean pagecache test
Date: Wed, 7 Jan 2026 17:37:09 +0800

This patch adds a new testcase to validate memory failure handling for
clean pagecache.  This test performs similar operations as anonymous pages
except allocating memory using mmap() with a file fd.

This test helps ensure that memory failure handling for clean pagecache
works correctly, including unchanged page content, page isolation, and
recovery paths.

Link: https://lkml.kernel.org/r/20260107093710.3928374-3-linmiaohe@huawei.com
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

 tools/testing/selftests/mm/memory-failure.c |   46 ++++++++++++++++++
 1 file changed, 46 insertions(+)

--- a/tools/testing/selftests/mm/memory-failure.c~selftests-mm-add-memory-failure-clean-pagecache-test
+++ a/tools/testing/selftests/mm/memory-failure.c
@@ -10,6 +10,7 @@
 #include <sys/mman.h>
 #include <linux/mman.h>
 #include <linux/string.h>
+#include <unistd.h>
 #include <signal.h>
 #include <setjmp.h>
 #include <unistd.h>
@@ -24,7 +25,9 @@ enum inject_type {
 
 enum result_type {
 	MADV_HARD_ANON,
+	MADV_HARD_CLEAN_PAGECACHE,
 	MADV_SOFT_ANON,
+	MADV_SOFT_CLEAN_PAGECACHE,
 };
 
 static jmp_buf signal_jmp_buf;
@@ -154,6 +157,8 @@ static void check(struct __test_metadata
 
 	switch (type) {
 	case MADV_SOFT_ANON:
+	case MADV_HARD_CLEAN_PAGECACHE:
+	case MADV_SOFT_CLEAN_PAGECACHE:
 		/* It is not expected to receive a SIGBUS signal. */
 		ASSERT_EQ(setjmp, 0);
 
@@ -236,4 +241,45 @@ TEST_F(memory_failure, anon)
 	ASSERT_EQ(munmap(addr, self->page_size), 0);
 }
 
+TEST_F(memory_failure, clean_pagecache)
+{
+	const char *fname = "./clean-page-cache-test-file";
+	int fd;
+	char *addr;
+	int ret;
+
+	fd = open(fname, O_RDWR | O_CREAT, 0664);
+	if (fd < 0)
+		SKIP(return, "failed to open test file.\n");
+	unlink(fname);
+	ftruncate(fd, self->page_size);
+
+	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
+		    MAP_SHARED, fd, 0);
+	if (addr == MAP_FAILED)
+		SKIP(return, "mmap failed, not enough memory.\n");
+	memset(addr, 0xce, self->page_size);
+	fsync(fd);
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
+		check(_metadata, self, addr, MADV_HARD_CLEAN_PAGECACHE, ret);
+	else
+		check(_metadata, self, addr, MADV_SOFT_CLEAN_PAGECACHE, ret);
+
+	cleanup(_metadata, self, addr);
+
+	ASSERT_EQ(munmap(addr, self->page_size), 0);
+
+	ASSERT_EQ(close(fd), 0);
+}
+
 TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

selftests-mm-add-memory-failure-dirty-pagecache-test.patch

