Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B471FB3
	for <mm-commits@vger.kernel.org>; Fri,  6 Jun 2025 04:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749185657; cv=none; b=uX9BzocRJgy8QU9SV2t4HcUvRp2yPyAgkVnKhsSFAi505+8Vmblywgil2zUgdLE+LqiNOdoimHs2FmjQrAiOIjLhb4P94JiEIc3ZnxP0OcKT8sQFneil+cE4niVvfZbDKnpGYzhc/FPAjCOuwlPxHP5IjM3c6CowRwvdThTCr5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749185657; c=relaxed/simple;
	bh=XAZDz2t9nIa90MVHoraQ7xU0TlWp5vYegbOTnAA04xM=;
	h=Date:To:From:Subject:Message-Id; b=AWLU6HzETrQJhRTfbpG+8CPh6VAQAlA5YdSYr1FvAuPDzNs/A9XD3KgFE2vo+J9IJZ7TK/tX9+y49vUO4IdD/ced4gCStNCgXDYrQCdzq5AhYN8Zl5q3ggCtNqj0l5IPL6sO0znbGehCuoHwqOvdEGlvjEz6m75/n2uuqqWwBKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sig9rKC/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sig9rKC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F759C4CEEB;
	Fri,  6 Jun 2025 04:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749185656;
	bh=XAZDz2t9nIa90MVHoraQ7xU0TlWp5vYegbOTnAA04xM=;
	h=Date:To:From:Subject:From;
	b=Sig9rKC/07aGh4IjReJmTBoBPZWJrrgHIqyezaG81DUIwblKMeuv2YyvzRV1mkEdm
	 py0jzL0ROaY5uFPLylvtU/RUfqh95q+G4aD0P9V2AWVn4VDqBQb1kshgzbh+0UMiqZ
	 LKL3KsYoTf7vtKprfX5LfeZBLsfvTA4iNptWjun8=
Date: Thu, 05 Jun 2025 21:54:15 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pulehui@huawei.com,peterz@infradead.org,oleg@redhat.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge-fix.patch removed from -mm tree
Message-Id: <20250606045416.3F759C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge-fix
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge-fix.patch

This patch was dropped because it was folded into selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge-fix
Date: Fri May 30 05:50:22 PM PDT 2025

include sys/syscall.h, per Lorenzo

Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pu Lehui <pulehui@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/merge.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/merge.c~selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge-fix
+++ a/tools/testing/selftests/mm/merge.c
@@ -7,6 +7,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <sys/mman.h>
+#include <sys/syscall.h>
 #include <sys/wait.h>
 #include <linux/perf_event.h>
 #include "vm_util.h"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-2-fix.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch

