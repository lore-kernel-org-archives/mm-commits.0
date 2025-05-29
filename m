Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8BB4685
	for <mm-commits@vger.kernel.org>; Thu, 29 May 2025 19:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748546814; cv=none; b=onsRBT0Hj6w/QpCbc4UXSwkKYPwqCy1V9e9FkZRw2WNyNd5KGxunpj1whp+9zHff7BTREByBtNq17nT8tcH0AvLGAPgyGgkpW/NDOQGrGfP9iAPG1N3T+eDTgjrGJ7fQ429FjqNFelDp/KXy1LElNiVz48MyVMLkL9HWoPTDLIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748546814; c=relaxed/simple;
	bh=3Jhqo/mzi+YQ1Y2MnKtdckvoCki4Ui5JRshCkeBLI7Y=;
	h=Date:To:From:Subject:Message-Id; b=dAS2dQF7nIvr2TZCnmlxh2A/GjBW8L6P4wil6tciTXFlmvPidunFQyxxwwO3EP8RpWxv2bpQYVIbgXgiurEgwoUE9Vtsa7J3jDTmyVNnI0R/TiWfG3B3Eq6tlnOPaLzrAnAcW0meygcgXXNqQOptA8CLwK4ASVAsmcYMFEVr0ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=taLVL5Yw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="taLVL5Yw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200E2C4CEF1;
	Thu, 29 May 2025 19:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748546814;
	bh=3Jhqo/mzi+YQ1Y2MnKtdckvoCki4Ui5JRshCkeBLI7Y=;
	h=Date:To:From:Subject:From;
	b=taLVL5YwiuiLvckSg29m199qtwAmXgWOXf4+ASSYz+nvEv1QS+G9A5bokmbvgwg8B
	 yPosSPgKrdfs+W+IK53v90Uvt0XgOEWcz3tnDzRL1si6EeUx8o8/GLQ4J1eZDGreEN
	 HIfuD2u8aXZ+JpcvWnKQEElce6i6ZvZy4inHUrTo=
Date: Thu, 29 May 2025 12:26:53 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterz@infradead.org,oleg@redhat.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,pulehui@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge.patch added to mm-unstable branch
Message-Id: <20250529192654.200E2C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: Add test about uprobe pte be orphan during vma merge
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Pu Lehui <pulehui@huawei.com>
Subject: selftests/mm: Add test about uprobe pte be orphan during vma merge
Date: Thu, 29 May 2025 15:56:50 +0000

Add test about uprobe pte be orphan during vma merge.

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

 tools/testing/selftests/mm/merge.c |   42 +++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

--- a/tools/testing/selftests/mm/merge.c~selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge
+++ a/tools/testing/selftests/mm/merge.c
@@ -2,11 +2,13 @@
 
 #define _GNU_SOURCE
 #include "../kselftest_harness.h"
+#include <fcntl.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <sys/mman.h>
 #include <sys/wait.h>
+#include <linux/perf_event.h>
 #include "vm_util.h"
 
 FIXTURE(merge)
@@ -452,4 +454,44 @@ TEST_F(merge, forked_source_vma)
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

mm-fix-uprobe-pte-be-overwritten-when-expanding-vma.patch
mm-expose-abnormal-new_pte-during-move_ptes.patch
selftests-mm-extract-read_sysfs-and-write_sysfs-into-vm_util.patch
selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge.patch

