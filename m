Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC58828980A
	for <mm-commits@vger.kernel.org>; Mon, 15 Dec 2025 18:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765822383; cv=none; b=CTVgfNCAdmGbVt266oYAgJDxxOdmUa2Vrvg9q6RcG4/0zXoSpffcantXDx5osImE2Pa2/zwPmGOQQsfyDsR86a8WVf1mpswoD1arysCvsaUQfFnKDNwspiUCd4oMGqnOqoOxiGCB0382ef+gXtSbEsZUSUp83oy84TqGTeiYps0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765822383; c=relaxed/simple;
	bh=+M7zQuCRQEJnXko+xtxuRsLj4emSe8Hx2Yhef6Erna8=;
	h=Date:To:From:Subject:Message-Id; b=cra89uCDD4m8pWS17oEoyW5Z8409YjBW7bBXe+5vAEOYy2Do54ETEYpK8gzUpKVOrCPMe/6iOWPGZ8MlmdNiSMKx2S67R5aHifhZTaabEF24x2cwakqhNP8Z+Qtf0rpi+/8bRpd3aNOnAJtqbGvy/w1NCjuDftzBqQADFeY29iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DgJ8kOpt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DgJ8kOpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB70C4CEF5;
	Mon, 15 Dec 2025 18:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765822383;
	bh=+M7zQuCRQEJnXko+xtxuRsLj4emSe8Hx2Yhef6Erna8=;
	h=Date:To:From:Subject:From;
	b=DgJ8kOptWaXXaLoNwt66ZB8zdfrKWavCfQ4UlePii6KUt6GSEuJ1do7SKVjj3xn4O
	 SbKINL2YN8Z4DUVbDE4eUQKGNWnCiF8zRTeLlttKnHIV8xXfcG7A/jvOMgLq7pidvB
	 Jr0XBPzVQBpZxYENLsEd2b+NHitDV+Y2Xeg1san4=
Date: Mon, 15 Dec 2025 10:13:02 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,ryan.roberts@arm.com,rostedt@goodmis.org,npache@redhat.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,Branden.Moore@amd.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-retry-with-sync-writeback-for-madv_collapse.patch added to mm-new branch
Message-Id: <20251215181303.2CB70C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: retry with sync writeback for MADV_COLLAPSE
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-retry-with-sync-writeback-for-madv_collapse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-retry-with-sync-writeback-for-madv_collapse.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Shivank Garg <shivankg@amd.com>
Subject: mm/khugepaged: retry with sync writeback for MADV_COLLAPSE
Date: Mon, 15 Dec 2025 08:46:19 +0000

When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
text sections), the pages may still be dirty from recent writes. 
collapse_file() will trigger async writeback and fail with
SCAN_PAGE_DIRTY_OR_WRITEBACK (-EAGAIN).

MADV_COLLAPSE is a synchronous operation where userspace expects immediate
results.  If the collapse fails due to dirty pages, perform synchronous
writeback on the specific range and retry once.

This avoids spurious failures for freshly written executables while
avoiding unnecessary synchronous I/O for mappings that are already clean.

Link: https://lkml.kernel.org/r/20251215084615.5283-7-shivankg@amd.com
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
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: wang lian <lianux.mm@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-retry-with-sync-writeback-for-madv_collapse
+++ a/mm/khugepaged.c
@@ -22,6 +22,7 @@
 #include <linux/dax.h>
 #include <linux/ksm.h>
 #include <linux/pgalloc.h>
+#include <linux/backing-dev.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -2787,9 +2788,11 @@ int madvise_collapse(struct vm_area_stru
 	hend = end & HPAGE_PMD_MASK;
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
+		bool retried = false;
 		int result = SCAN_FAIL;
 
 		if (!mmap_locked) {
+retry:
 			cond_resched();
 			mmap_read_lock(mm);
 			mmap_locked = true;
@@ -2819,6 +2822,43 @@ int madvise_collapse(struct vm_area_stru
 		if (!mmap_locked)
 			*lock_dropped = true;
 
+		/*
+		 * If the file-backed VMA has dirty pages, the scan triggers
+		 * async writeback and returns SCAN_PAGE_DIRTY_OR_WRITEBACK.
+		 * Since MADV_COLLAPSE is sync, we force sync writeback and
+		 * retry once.
+		 */
+		if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !retried) {
+			/*
+			 * File scan drops the lock. We must re-acquire it to
+			 * safely inspect the VMA and hold the file reference.
+			 */
+			if (!mmap_locked) {
+				cond_resched();
+				mmap_read_lock(mm);
+				mmap_locked = true;
+				result = hugepage_vma_revalidate(mm, addr, false, &vma, cc);
+				if (result != SCAN_SUCCEED)
+					goto handle_result;
+			}
+
+			if (!vma_is_anonymous(vma) && vma->vm_file &&
+			    mapping_can_writeback(vma->vm_file->f_mapping)) {
+				struct file *file = get_file(vma->vm_file);
+				pgoff_t pgoff = linear_page_index(vma, addr);
+				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
+				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
+
+				mmap_read_unlock(mm);
+				mmap_locked = false;
+				*lock_dropped = true;
+				filemap_write_and_wait_range(file->f_mapping, lstart, lend);
+				fput(file);
+				retried = true;
+				goto retry;
+			}
+		}
+
 handle_result:
 		switch (result) {
 		case SCAN_SUCCEED:
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-khugepaged-map-dirty-writeback-pages-failures-to-eagain.patch
mm-khugepaged-retry-with-sync-writeback-for-madv_collapse.patch

