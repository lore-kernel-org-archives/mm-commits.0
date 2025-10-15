Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B1E2F90C4
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 21:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760563729; cv=none; b=eUmiryVcMcLsv7I6oGchvUrvlThRZp9aYlmuZ2M8B+vomiOEPpZL+eutDfOo+WHBddpiJXSn7VzdhtlCGjQgTAjWspbd5azSv0YImMFvISIprO7WZ/Rny5wCSukb60bsg6t1ejgxY5tKVhCz45XXLeHYZe3S17gTFISGWBBrZd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760563729; c=relaxed/simple;
	bh=uxQrkv04DETkDhnyW418iSXjWu2kzTGLgsaSHwNAK0Q=;
	h=Date:To:From:Subject:Message-Id; b=PqfgAq0Ffq1V1BLF8bz9P+KPNmfNyLMwyxOq4DZuzOUnVjjvj9NAFPqKIceD/sVzmdl2np9xJYVqHne9byC+w2K8Fzwhcf6lCMk1G05yCt6P0x06TUFwupS/29+vKhyT2EJ8Oqs6oeLzm+oVRKJHAhBAMmvEijmPr1l6i4tTsXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mmbc3dLn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mmbc3dLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D67C4CEF8;
	Wed, 15 Oct 2025 21:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760563728;
	bh=uxQrkv04DETkDhnyW418iSXjWu2kzTGLgsaSHwNAK0Q=;
	h=Date:To:From:Subject:From;
	b=mmbc3dLnemYyVKaCRCWqnF0P0GDpD9kCI/3IWGjP+sFC2yFprAwrySf2VVhRt87SC
	 qiLE1hVM//qeHR3lT2TeaOAVUR7zy9Xa5hA8Eb590HrCKvdE3r0Tpgkcvx/v1vpldt
	 q5Ql61ZwVluucrCeFd9/cBPrIOdVNUDuW64J2rF0=
Date: Wed, 15 Oct 2025 14:28:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vishal.moola@gmail.com,sj@kernel.org,ryan.roberts@arm.com,riel@redhat.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,aarcange@redhat.com,lianux.mm@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-fix-comment-for-default-scan-sleep-duration.patch added to mm-new branch
Message-Id: <20251015212848.81D67C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: fix comment for default scan sleep duration
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-fix-comment-for-default-scan-sleep-duration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-fix-comment-for-default-scan-sleep-duration.patch

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
From: wang lian <lianux.mm@gmail.com>
Subject: mm/khugepaged: fix comment for default scan sleep duration
Date: Wed, 15 Oct 2025 17:29:57 +0800

The comment for khugepaged_scan_sleep_millisecs incorrectly states the
default scan period is 30 seconds.  The actual default value in the code
is 10000ms (10 seconds).

This patch corrects the comment to match the code, preventing potential
confusion.  The incorrect comment has existed since the feature was first
introduced.  While at it, replace the magic value 512 by HPAGE_PMD_NR and
use 'ptes'.

Link: https://lkml.kernel.org/r/20251015092957.37432-1-lianux.mm@gmail.com
Signed-off-by: wang lian <lianux.mm@gmail.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-comment-for-default-scan-sleep-duration
+++ a/mm/khugepaged.c
@@ -67,7 +67,7 @@ enum scan_result {
 static struct task_struct *khugepaged_thread __read_mostly;
 static DEFINE_MUTEX(khugepaged_mutex);
 
-/* default scan 8*512 pte (or vmas) every 30 second */
+/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
 static unsigned int khugepaged_pages_to_scan __read_mostly;
 static unsigned int khugepaged_pages_collapsed;
 static unsigned int khugepaged_full_scans;
_

Patches currently in -mm which might be from lianux.mm@gmail.com are

mm-khugepaged-fix-comment-for-default-scan-sleep-duration.patch

