Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F872F0C5B
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939869; cv=none; b=YknaOAsaDc4hrM+RGW5AcPqcpIAZoV3vLLlSUT4Z3AoJq59/ZIvMfJf6mnDzTkSjREVpnqqIcOXWZCXUSIabXoKBF7KVohe3gjQ6LRqeLnz+TW3HktsrJymhF7/dfSMgMYCGNTGGwqwMoJDzlZaQBgWUoyk4NzuQzqZVnR5wXS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939869; c=relaxed/simple;
	bh=6ECzSgFtfiCcWeEjA4iJ5MmURNxf+H8aaEpq2YGsAuk=;
	h=Date:To:From:Subject:Message-Id; b=j1/qQ8z+VduumB4+GsKUgLNAUJNQ0eaKk9ssgo1bDqM61VClCgHOf76r+rgevsJuJ5dDL+9oY7VK8d4DceAs2Hkx4/x7X9RbxEyiLbhhf8+cBmPlbahB2+fIebhkeS8PaaYgEJqfz2QYk99OjwLlKrXSzfRZsn7S75Icm2tud8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OJ13xvRd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OJ13xvRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA659C4CEF7;
	Thu, 12 Feb 2026 23:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939868;
	bh=6ECzSgFtfiCcWeEjA4iJ5MmURNxf+H8aaEpq2YGsAuk=;
	h=Date:To:From:Subject:From;
	b=OJ13xvRdpwaMaKE7NicnN8cnj2XCXAOFtkW8NsviizOayhM5XcFuc2isbGEg5ezvf
	 /ULjE7nVxdSJvW0HVw2mHfBGgrWfNa9aDerpqJUy/vbF0YmCPSYGMktycC+TrAtfkc
	 MkPjs8qNFdHFlHPs94EEo9HEQJ54xuR3gmy5NEyo=
Date: Thu, 12 Feb 2026 15:44:28 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,nao.horiguchi@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,lkp@intel.com,liam.howlett@oracle.com,david@kernel.org,broonie@kernel.org,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-memory-failure-clean-pagecache-test.patch removed from -mm tree
Message-Id: <20260212234428.BA659C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add memory failure clean pagecache test
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-memory-failure-clean-pagecache-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: selftests/mm: add memory failure clean pagecache test
Date: Fri, 6 Feb 2026 11:16:38 +0800

This patch adds a new testcase to validate memory failure handling for
clean pagecache.  This test performs similar operations as anonymous pages
except allocating memory using mmap() with a file fd.

This test helps ensure that memory failure handling for clean pagecache
works correctly, including unchanged page content, page isolation, and
recovery paths.

Link: https://lkml.kernel.org/r/20260206031639.2707102-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601221142.mDWA1ucw-lkp@intel.com/
Cc: David Hildenbrand <david@kernel.org>
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
+static int get_fs_type(int fd)
+{
+	struct statfs fs;
+	int ret;
+
+	do {
+		ret = fstatfs(fd, &fs);
+	} while (ret && errno == EINTR);
+
+	return ret ? 0 : (int)fs.f_type;
+}
+
+TEST_F(memory_failure, clean_pagecache)
+{
+	const char *fname = "./clean-page-cache-test-file";
+	int fd;
+	char *addr;
+	int ret;
+	int fs_type;
+
+	fd = open(fname, O_RDWR | O_CREAT, 0664);
+	if (fd < 0)
+		SKIP(return, "failed to open test file.\n");
+	unlink(fname);
+	ftruncate(fd, self->page_size);
+	fs_type = get_fs_type(fd);
+	if (!fs_type || fs_type == TMPFS_MAGIC)
+		SKIP(return, "unsupported filesystem :%x\n", fs_type);
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


