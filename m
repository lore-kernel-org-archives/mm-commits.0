Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA14FC0B;
	Tue, 31 Dec 2024 01:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735610393; cv=none; b=JfyBnmAldiZcKMs4klqzu/Y2WulkppXiUXtgIos1v5Sf5Qp8O12/4Mkq5Uzup0CT46t3TU6gMCj0r6aWdaFuGzhroKrTRcSMSMWNvcp0tlfn6Q/VRzftsdLMnqoJe4LmwiqC6shZ9xIB7zdgHIOW2YBHS+5jtRPPN7w8N1zIfms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735610393; c=relaxed/simple;
	bh=9idB0Cn5ug2Q+nok94ViGE5A1Kspr+YZFJqzVFTHQwk=;
	h=Date:To:From:Subject:Message-Id; b=MGaTUppizk8+NbBBg125Q5GDyGKIqghZdE2gzBJMUQl9K191ioq5RwFYX6a0GQyQffV3lC2eUYJJOS7i7aJbowiBwWLMULoG9Vo9hBM4IHVLxEXWbC+qrJTj9as/uHp2SnUuI3Uk94wQJXnmJzNxQsj6dpSL8+ksaeKfkznWMF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pyspbTy4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pyspbTy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8F2C4CED0;
	Tue, 31 Dec 2024 01:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735610393;
	bh=9idB0Cn5ug2Q+nok94ViGE5A1Kspr+YZFJqzVFTHQwk=;
	h=Date:To:From:Subject:From;
	b=pyspbTy4a3mio+AfvXtBX5VZkSjCK0xV+jVoVJe5q7E8fWXkPaeCY2NELs6s9bOIR
	 L+61Qtw9woPCzvk2T+4k2bPBeISZmzeptok946cL5oW6qcwXf0Mjmb/v1jz+dkvmt8
	 Rka2i/eo19U9pjAPrVu0WEaLdwUHwe0l246/wJ/A=
Date: Mon, 30 Dec 2024 17:59:52 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,oliver.sang@intel.com,david@redhat.com,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-readahead-fix-large-folio-support-in-async-readahead.patch removed from -mm tree
Message-Id: <20241231015953.5F8F2C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/readahead: fix large folio support in async readahead
has been removed from the -mm tree.  Its filename was
     mm-readahead-fix-large-folio-support-in-async-readahead.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm/readahead: fix large folio support in async readahead
Date: Fri, 6 Dec 2024 16:30:25 +0800

When testing large folio support with XFS on our servers, we observed that
only a few large folios are mapped when reading large files via mmap. 
After a thorough analysis, I identified it was caused by the
`/sys/block/*/queue/read_ahead_kb` setting.  On our test servers, this
parameter is set to 128KB.  After I tune it to 2MB, the large folio can
work as expected.  However, I believe the large folio behavior should not
be dependent on the value of read_ahead_kb.  It would be more robust if
the kernel can automatically adopt to it.

With /sys/block/*/queue/read_ahead_kb set to 128KB and performing a
sequential read on a 1GB file using MADV_HUGEPAGE, the differences in
/proc/meminfo are as follows:

- before this patch
  FileHugePages:     18432 kB
  FilePmdMapped:      4096 kB

- after this patch
  FileHugePages:   1067008 kB
  FilePmdMapped:   1048576 kB

This shows that after applying the patch, the entire 1GB file is mapped to
huge pages.  The stable list is CCed, as without this patch, large folios
don't function optimally in the readahead path.

It's worth noting that if read_ahead_kb is set to a larger value that
isn't aligned with huge page sizes (e.g., 4MB + 128KB), it may still fail
to map to hugepages.

Link: https://lkml.kernel.org/r/20241108141710.9721-1-laoar.shao@gmail.com
Link: https://lkml.kernel.org/r/20241206083025.3478-1-laoar.shao@gmail.com
Fixes: 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file mappings")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Tested-by: kernel test robot <oliver.sang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/readahead.c~mm-readahead-fix-large-folio-support-in-async-readahead
+++ a/mm/readahead.c
@@ -646,7 +646,11 @@ void page_cache_async_ra(struct readahea
 			1UL << order);
 	if (index == expected) {
 		ra->start += ra->size;
-		ra->size = get_next_ra_size(ra, max_pages);
+		/*
+		 * In the case of MADV_HUGEPAGE, the actual size might exceed
+		 * the readahead window.
+		 */
+		ra->size = max(ra->size, get_next_ra_size(ra, max_pages));
 		ra->async_size = ra->size;
 		goto readit;
 	}
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

kernel-remove-get_task_comm-and-print-task-comm-directly.patch
arch-remove-get_task_comm-and-print-task-comm-directly.patch
net-remove-get_task_comm-and-print-task-comm-directly.patch
security-remove-get_task_comm-and-print-task-comm-directly.patch
drivers-remove-get_task_comm-and-print-task-comm-directly.patch

