Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146DC20FAA9
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188557; cv=none; b=peydMVCcEFPGVo7IJDNIG+FxUPPjIGXqcjGnfr1INGbj3CTfPy3RMal7xaUDxE5TPrZ6iZHgT5ExX97otgNj1m+LQV615Q4phsofTEsg7aynNRTWME82UwuZ2cn/wctJ1PKeOFz3ktvMlr0RS3UFmFpd4ik2QqpHv0zXC+MxmHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188557; c=relaxed/simple;
	bh=YbCvXXeMdf+NAQFj5vwvcZJm+XAPET2ql8vC4+SIt+Q=;
	h=Date:To:From:Subject:Message-Id; b=r4frjU2CNjzx2zv6FU6uK9JIom68xg5ct5iVKnXYsMJu/uUSbfCMGnluQLmXistV/iNbm+L9Vn8irEkAV97ORKmsEvqQSdNq9CpjmDL5HY7lCNo7xbXTxiSkzxMXgnxpfmtLn3xjxelU9Ytjwqf9Ib8ggitoUYOcZwy8FFKMSKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jP7JZjyF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jP7JZjyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC29C4CEEC;
	Mon, 17 Mar 2025 05:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188557;
	bh=YbCvXXeMdf+NAQFj5vwvcZJm+XAPET2ql8vC4+SIt+Q=;
	h=Date:To:From:Subject:From;
	b=jP7JZjyFaHjOxmOLf0FJEAM+p3RdhPpmrEEtpwj0nmQ/mbEGXtSt9UPDKE4tvZIon
	 K4H0J1HbVFqagQZLUPUlI13qo92FMGy7kgjgjj5YckWsJinBVhy51IiJB9tV9pb6ra
	 WWH/TPB8om9VnCDfPnFJIxmvjTJuFbL6iCfqU+FQ=
Date: Sun, 16 Mar 2025 22:15:56 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-drop-the-unused-macro.patch removed from -mm tree
Message-Id: <20250317051556.DCC29C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: drop the unused macro
has been removed from the -mm tree.  Its filename was
     mm-shmem-drop-the-unused-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: drop the unused macro
Date: Fri, 7 Feb 2025 17:44:17 +0800

Patch series "Some trivial cleanups for shmem".

Patch 1 - Patch 5 do some trivial cleanups and refactoring for shmem.
Patch 6 adds myself as shmem reviewer.


This patch (of 6):

Drop the unused 'BLOCKS_PER_PAGE' macro.

Link: https://lkml.kernel.org/r/cover.1738918357.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/69264cee1d938442477e657004e4924f8a5c4dd4.1738918357.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-drop-the-unused-macro
+++ a/mm/shmem.c
@@ -86,7 +86,6 @@ static struct vfsmount *shm_mnt __ro_aft
 
 #include "internal.h"
 
-#define BLOCKS_PER_PAGE  (PAGE_SIZE/512)
 #define VM_ACCT(size)    (PAGE_ALIGN(size) >> PAGE_SHIFT)
 
 /* Pretend that each entry is of this size in directory's i_size */
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


