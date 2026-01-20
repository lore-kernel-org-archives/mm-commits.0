Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C2F34FF55
	for <mm-commits@vger.kernel.org>; Tue, 20 Jan 2026 17:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768929052; cv=none; b=L4ny5+TxLW2yAbquDNj2QoG+mlEld1Lb9OXmAv+8iF/45bFoq+xbVsh1yn5F8xANeZPbb9YyzVZEOcE8zYnp2+otMdwcSH1aKGigNo9LUw11s04AD0tb2zDAKHczCDBfIvvqsbTJVCs4a22/zU5xOKF1yu7+lwNIWVpNOv2m0Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768929052; c=relaxed/simple;
	bh=wLV/uTxcOUgG3SIitWkrjDIAS65COppC3OJBxOz5G5I=;
	h=Date:To:From:Subject:Message-Id; b=neVBKX6f3GYO6H+Y9kzP2DBKWSNQqm4u5yPoB6HuEfYu6a1v4Qm5JuZNjOsY+fzyrURHul/4df5nExTOOzZ6TEGN9JrhBwba+5hbab7m+8JZfz538X3kH9ilUMCpG2IjjNNzU4foYEjZTuasHUAZ9VDSvkcWqPtcOnLw9uXzThA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GMh98LU/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GMh98LU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D738C16AAE;
	Tue, 20 Jan 2026 17:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768929052;
	bh=wLV/uTxcOUgG3SIitWkrjDIAS65COppC3OJBxOz5G5I=;
	h=Date:To:From:Subject:From;
	b=GMh98LU/PIEAKFA9D50davQzxH/g/VzPV2s2ucDG2ZExikJ5wKZozTZZ5ZUOPkxER
	 xuum299SDdPZp9j9Uhg5+UsYXv0WW8FNUICHSz+KlFdasgDDkKJ+bbZqntLcM6bfDf
	 FS2uQdhae2QrP5i7HY51MF9vUjpfLYfI8Q4qxGiE=
Date: Tue, 20 Jan 2026 09:10:51 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,nao.horiguchi@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-memory-failure-clean-pagecache-test.patch added to mm-new branch
Message-Id: <20260120171052.0D738C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add memory failure clean pagecache test
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-memory-failure-clean-pagecache-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-memory-failure-clean-pagecache-test.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: selftests/mm: add memory failure clean pagecache test
Date: Tue, 20 Jan 2026 20:32:38 +0800

This patch adds a new testcase to validate memory failure handling for
clean pagecache.  This test performs similar operations as anonymous pages
except allocating memory using mmap() with a file fd.

This test helps ensure that memory failure handling for clean pagecache
works correctly, including unchanged page content, page isolation, and
recovery paths.

Link: https://lkml.kernel.org/r/20260120123239.909882-3-linmiaohe@huawei.com
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

 tools/testing/selftests/mm/memory-failure.c |   66 ++++++++++++++++++
 1 file changed, 66 insertions(+)

--- a/tools/testing/selftests/mm/memory-failure.c~selftests-mm-add-memory-failure-clean-pagecache-test
+++ a/tools/testing/selftests/mm/memory-failure.c
@@ -10,10 +10,14 @@
 #include <sys/mman.h>
 #include <linux/mman.h>
 #include <linux/string.h>
+#include <unistd.h>
 #include <signal.h>
 #include <setjmp.h>
 #include <unistd.h>
 #include <fcntl.h>
+#include <sys/vfs.h>
+#include <linux/magic.h>
+#include <errno.h>
 
 #include "vm_util.h"
 
@@ -24,7 +28,9 @@ enum inject_type {
 
 enum result_type {
 	MADV_HARD_ANON,
+	MADV_HARD_CLEAN_PAGECACHE,
 	MADV_SOFT_ANON,
+	MADV_SOFT_CLEAN_PAGECACHE,
 };
 
 static jmp_buf signal_jmp_buf;
@@ -154,6 +160,8 @@ static void check(struct __test_metadata
 
 	switch (type) {
 	case MADV_SOFT_ANON:
+	case MADV_HARD_CLEAN_PAGECACHE:
+	case MADV_SOFT_CLEAN_PAGECACHE:
 		/* It is not expected to receive a SIGBUS signal. */
 		ASSERT_EQ(setjmp, 0);
 
@@ -236,4 +244,62 @@ TEST_F(memory_failure, anon)
 	ASSERT_EQ(munmap(addr, self->page_size), 0);
 }
 
+/* Borrowed from mm/gup_longterm.c. */
+static __fsword_t get_fs_type(int fd)
+{
+	struct statfs fs;
+	int ret;
+
+	do {
+		ret = fstatfs(fd, &fs);
+	} while (ret && errno == EINTR);
+
+	return ret ? 0 : fs.f_type;
+}
+
+TEST_F(memory_failure, clean_pagecache)
+{
+	const char *fname = "./clean-page-cache-test-file";
+	int fd;
+	char *addr;
+	int ret;
+	__fsword_t fs_type;
+
+	fd = open(fname, O_RDWR | O_CREAT, 0664);
+	if (fd < 0)
+		SKIP(return, "failed to open test file.\n");
+	unlink(fname);
+	ftruncate(fd, self->page_size);
+	fs_type = get_fs_type(fd);
+	if (!fs_type || fs_type == TMPFS_MAGIC)
+		SKIP(return, "unsupported filesystem :%lx\n", fs_type);
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

selftests-mm-add-memory-failure-anonymous-page-test.patch
selftests-mm-add-memory-failure-clean-pagecache-test.patch
selftests-mm-add-memory-failure-dirty-pagecache-test.patch

