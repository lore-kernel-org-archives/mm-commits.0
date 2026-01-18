Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67567212F98
	for <mm-commits@vger.kernel.org>; Sun, 18 Jan 2026 20:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768767372; cv=none; b=E1sI8z1PfXiMlBMzB3YB9WeKdgNh2uWfkzZkfhu5/VKHlTn3LladiUggolAu+Smn++h+QVcD7pT6nIj1tJML+IFi2em4w3Wz/mMmr1BQmLHis47X/EfBuYVCAbuLY7CMQ6AI7vJeR2uAAFUbwMTQ17XcfhRdajZqXlHf/3rvVYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768767372; c=relaxed/simple;
	bh=vbc+zHQTcPQFMEkP/FbfRnpGShnfAJLlD93BF7MTYP0=;
	h=Date:To:From:Subject:Message-Id; b=ig3WIiMnFbhO/I+KrEVRa38a2XzET+OulB+LLKUh18rwtWtEn5WOn6TiX3DKCxFmC8R/mOEYlRVKtPJAm0k25+ZCwIjzY8ZhsSop8inz9VICQDfqKZngHKzdaAgUSfIesXHSNl65JB/sT6xQcUt1gIzBanwYg8dBlYLFJlsRaJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KU/JZomF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KU/JZomF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EE1C116D0;
	Sun, 18 Jan 2026 20:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768767372;
	bh=vbc+zHQTcPQFMEkP/FbfRnpGShnfAJLlD93BF7MTYP0=;
	h=Date:To:From:Subject:From;
	b=KU/JZomFHHLgVQrUXpIM1qGY1qicvoQvcOf4BV3mXsN5vSdemVOxqT1TQndG4of9a
	 ojt/P6MXaLwjP36xFjA9HTE2EtA0TgdSkveb4csZBQj8/N8ZN72/cNZdabaQchx65a
	 Rej9txCQug5MkSoKKTnhozP5PxX4iqRFeTWkW+6I=
Date: Sun, 18 Jan 2026 12:16:11 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,Branden.Moore@amd.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-retry-with-sync-writeback-for-madv_collapse.patch added to mm-unstable branch
Message-Id: <20260118201611.F2EE1C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: retry with sync writeback for MADV_COLLAPSE
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-retry-with-sync-writeback-for-madv_collapse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-retry-with-sync-writeback-for-madv_collapse.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Shivank Garg <shivankg@amd.com>
Subject: mm/khugepaged: retry with sync writeback for MADV_COLLAPSE
Date: Sun, 18 Jan 2026 19:09:43 +0000

When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
text sections), the pages may still be dirty from recent writes. 
collapse_file() will trigger async writeback and fail with
SCAN_PAGE_DIRTY_OR_WRITEBACK (-EAGAIN).

MADV_COLLAPSE is a synchronous operation where userspace expects immediate
results.  If the collapse fails due to dirty pages, perform synchronous
writeback on the specific range and retry once.

This avoids spurious failures for freshly written executables while
avoiding unnecessary synchronous I/O for mappings that are already clean.

Link: https://lkml.kernel.org/r/20260118190939.8986-7-shivankg@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Reported-by: Branden Moore <Branden.Moore@amd.com>
Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
Suggested-by: David Hildenbrand <david@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: wang lian <lianux.mm@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-retry-with-sync-writeback-for-madv_collapse
+++ a/mm/khugepaged.c
@@ -22,6 +22,7 @@
 #include <linux/dax.h>
 #include <linux/ksm.h>
 #include <linux/pgalloc.h>
+#include <linux/backing-dev.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -2788,7 +2789,9 @@ int madvise_collapse(struct vm_area_stru
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		int result = SCAN_FAIL;
+		bool triggered_wb = false;
 
+retry:
 		if (!mmap_locked) {
 			cond_resched();
 			mmap_read_lock(mm);
@@ -2809,8 +2812,20 @@ int madvise_collapse(struct vm_area_stru
 
 			mmap_read_unlock(mm);
 			mmap_locked = false;
+			*lock_dropped = true;
 			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
 							  cc);
+
+			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
+			    mapping_can_writeback(file->f_mapping)) {
+				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
+				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
+
+				filemap_write_and_wait_range(file->f_mapping, lstart, lend);
+				triggered_wb = true;
+				fput(file);
+				goto retry;
+			}
 			fput(file);
 		} else {
 			result = hpage_collapse_scan_pmd(mm, vma, addr,
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-khugepaged-map-dirty-writeback-pages-failures-to-eagain.patch
mm-khugepaged-retry-with-sync-writeback-for-madv_collapse.patch
mm-khugepaged-remove-unnecessary-goto-skip-label.patch
mm-khugepaged-count-small-vmas-towards-scan-limit.patch
mm-khugepaged-count-small-vmas-towards-scan-limit-fix.patch
mm-khugepaged-change-collapse_pte_mapped_thp-to-return-void.patch
mm-khugepaged-use-enum-scan_result-for-result-variables-and-return-types.patch
mm-khugepaged-make-khugepaged_collapse_control-static.patch

