Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C041BC9E2;
	Thu, 19 Dec 2024 23:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734650721; cv=none; b=syJChdXc0yzF2raut2UbJwWMyd9QT+g4ySHvenJV2Wasm/abIvT8k//ONWChDMA8HbPfS12TCjcCGu+oqkeN6bdMQcgW6iimoGa9b8Vn7Nhv6x2jh95KIVqxHqX8ZzW7NjHP0SE030KHhRGONBGyqCR5LqKkx89AzPjJJZH+LW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734650721; c=relaxed/simple;
	bh=QWYUdPaBeOU4p9eYLsrDHrEaTfJPm3+Y1o5uKnJSjrQ=;
	h=Date:To:From:Subject:Message-Id; b=tW504axTfk5icBneqxvhNfCbaC22thTChuPEKetvQcGA8ByVYMEBa3yQsUn7Cnst2Z9NX/8ehPCXzfGDGHfdlExgAPeGb2k3vDGTvpA4qAQajQ9R0/dKNBIkhrYhNxe0780C0oLQnv56n/yWNulFwHwxYXZ1GivaZCY2K5v0WiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QgaWiVvh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QgaWiVvh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA5AC4CECE;
	Thu, 19 Dec 2024 23:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734650720;
	bh=QWYUdPaBeOU4p9eYLsrDHrEaTfJPm3+Y1o5uKnJSjrQ=;
	h=Date:To:From:Subject:From;
	b=QgaWiVvhInSHYN50MFoSvIUx3LZChmS79qJ8nczqZC8VBdP1XhL3NLsa8hJelsypK
	 CIe+foiypILR3seBYKIUM3pNnrO59hyiHG56BsdFQOwQxbd/JOhxV0U9mi9Q1+17PO
	 DJHdK/t/NTM00NALRTaDzsH8vBqkWFxRZVlvB+iw=
Date: Thu, 19 Dec 2024 15:25:20 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-the-update-of-shmem_falloc-nr_unswapped.patch added to mm-hotfixes-unstable branch
Message-Id: <20241219232520.AAA5AC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: fix the update of 'shmem_falloc->nr_unswapped'
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-fix-the-update-of-shmem_falloc-nr_unswapped.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-the-update-of-shmem_falloc-nr_unswapped.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: fix the update of 'shmem_falloc->nr_unswapped'
Date: Thu, 19 Dec 2024 15:30:09 +0800

The 'shmem_falloc->nr_unswapped' is used to record how many writepage
refused to swap out because fallocate() is allocating, but after shmem
supports large folio swap out, the update of 'shmem_falloc->nr_unswapped'
does not use the correct number of pages in the large folio, which may
lead to fallocate() not exiting as soon as possible.

Anyway, this is found through code inspection, and I am not sure whether
it would actually cause serious issues.

Link: https://lkml.kernel.org/r/f66a0119d0564c2c37c84f045835b870d1b2196f.1734593154.git.baolin.wang@linux.alibaba.com
Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-fix-the-update-of-shmem_falloc-nr_unswapped
+++ a/mm/shmem.c
@@ -1535,7 +1535,7 @@ try_split:
 			    !shmem_falloc->waitq &&
 			    index >= shmem_falloc->start &&
 			    index < shmem_falloc->next)
-				shmem_falloc->nr_unswapped++;
+				shmem_falloc->nr_unswapped += nr_pages;
 			else
 				shmem_falloc = NULL;
 			spin_unlock(&inode->i_lock);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

docs-mm-fix-the-incorrect-filehugemapped-field.patch
mm-shmem-fix-incorrect-index-alignment-for-within_size-policy.patch
mm-shmem-fix-the-update-of-shmem_falloc-nr_unswapped.patch
mm-factor-out-the-order-calculation-into-a-new-helper.patch
mm-shmem-change-shmem_huge_global_enabled-to-return-huge-order-bitmap.patch
mm-shmem-add-large-folio-support-for-tmpfs.patch
mm-shmem-add-a-kernel-command-line-to-change-the-default-huge-policy-for-tmpfs.patch
docs-tmpfs-drop-fadvise-from-the-documentation.patch

