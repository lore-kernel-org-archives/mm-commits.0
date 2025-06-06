Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FC81C27
	for <mm-commits@vger.kernel.org>; Fri,  6 Jun 2025 04:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749185777; cv=none; b=jSl3kqnOSY/uNGlM8tptgYkhx0E6SAyepDXugEodSjEwWQrxwJDogD3F8XyD9C5m2Jegzk+8RiXaJi6f3Kj6ikJhhFqYuyKiHJnpbORwmRRjUd26me9I0w+WiJsvuCbFZdecesEhddeCw5Lh+F1rtp3WbHeClReHpsvG9GPO/L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749185777; c=relaxed/simple;
	bh=BzhPN8GkbdMLpY21JxK/eDj9lVA/GEGaNHaniCKVoTI=;
	h=Date:To:From:Subject:Message-Id; b=pJivqNAeoN+3/tB5W27mDhF0j45g+Hh++BlCUBjTxaXAe6JrobGiDgzJjQlXPERL0GpiprBmTzdCsqn/VGi/ToUBEQzdohJN3+/ky3mt18MlFRqbHB3FDmEGlQJl8G6skn7REinff82BYu7ACs3j0SdQlBH/ZtYauK0GDlkAxIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pccsVExH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pccsVExH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61943C4CEED;
	Fri,  6 Jun 2025 04:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749185776;
	bh=BzhPN8GkbdMLpY21JxK/eDj9lVA/GEGaNHaniCKVoTI=;
	h=Date:To:From:Subject:From;
	b=pccsVExHeL8a7EHtzQbnviU95v1m6KG6Go4iL6evoWPaXH5sxX7/vkyV1pCjkTNLv
	 9iAYEDVQ7W3G2VYFVJ+fHxiEZqM1Ifo9sp700oopin8JTOyxsnkjztpdlVXQOud5zo
	 gNfuI+vJEUdfEp9cWba5dmFE/83OS/Us8fPdJS6g=
Date: Thu, 05 Jun 2025 21:56:15 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterz@infradead.org,oleg@redhat.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,pulehui@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge.patch removed from -mm tree
Message-Id: <20250606045616.61943C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add test about uprobe pte be orphan during vma merge
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pu Lehui <pulehui@huawei.com>
Subject: selftests/mm: add test about uprobe pte be orphan during vma merge
Date: Thu, 29 May 2025 15:56:50 +0000

Add test about uprobe pte be orphan during vma merge.

[akpm@linux-foundation.org: include sys/syscall.h, per Lorenzo]
Link: https://lkml.kernel.org/r/20250529155650.4017699-5-pulehui@huaweicloud.com
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/merge.c |   43 +++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

--- a/tools/testing/selftests/mm/merge.c~selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge
+++ a/tools/testing/selftests/mm/merge.c
@@ -2,11 +2,14 @@
 
 #define _GNU_SOURCE
 #include "../kselftest_harness.h"
+#include <fcntl.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <sys/mman.h>
+#include <sys/syscall.h>
 #include <sys/wait.h>
+#include <linux/perf_event.h>
 #include "vm_util.h"
 
 FIXTURE(merge)
@@ -452,4 +455,44 @@ TEST_F(merge, forked_source_vma)
 	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr2 + 5 * page_size);
 }
 
+TEST_F(merge, handle_uprobe_upon_merged_vma)
+{
+	const size_t attr_sz = sizeof(struct perf_event_attr);
+	unsigned int page_size = self->page_size;
+	const char *probe_file = "./foo";
+	char *carveout = self->carveout;
+	struct perf_event_attr attr;
+	unsigned long type;
+	void *ptr1, *ptr2;
+	int fd;
+
+	fd = open(probe_file, O_RDWR|O_CREAT, 0600);
+	ASSERT_GE(fd, 0);
+
+	ASSERT_EQ(ftruncate(fd, page_size), 0);
+	ASSERT_EQ(read_sysfs("/sys/bus/event_source/devices/uprobe/type", &type), 0);
+
+	memset(&attr, 0, attr_sz);
+	attr.size = attr_sz;
+	attr.type = type;
+	attr.config1 = (__u64)(long)probe_file;
+	attr.config2 = 0x0;
+
+	ASSERT_GE(syscall(__NR_perf_event_open, &attr, 0, -1, -1, 0), 0);
+
+	ptr1 = mmap(&carveout[page_size], 10 * page_size, PROT_EXEC,
+		    MAP_PRIVATE | MAP_FIXED, fd, 0);
+	ASSERT_NE(ptr1, MAP_FAILED);
+
+	ptr2 = mremap(ptr1, page_size, 2 * page_size,
+		      MREMAP_MAYMOVE | MREMAP_FIXED, ptr1 + 5 * page_size);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	ASSERT_NE(mremap(ptr2, page_size, page_size,
+			 MREMAP_MAYMOVE | MREMAP_FIXED, ptr1), MAP_FAILED);
+
+	close(fd);
+	remove(probe_file);
+}
+
 TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from pulehui@huawei.com are


