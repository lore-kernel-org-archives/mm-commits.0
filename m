Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A687139D
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 01:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sDWyzaUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D9DC433C8;
	Wed, 13 Dec 2023 01:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702430444;
	bh=vVoc1GDyBLX5wwxR16N015EkTjrDpZkB8zKXOkhGcAQ=;
	h=Date:To:From:Subject:From;
	b=sDWyzaUmCehPrfPS0fLqs4o6WvPC44E/Es8o9/i5Ugq2lzrFEB2JOwHmpqX+jTY5P
	 N2wOGxfRQUoDNY2UWQAQECBpJvhhQyktKoTQPmcpYGgG0x4ceduG/wIiT0idEsX6wy
	 OipcL1njQ+vLrFBTYFxHY2QEa0FGkITO25qsJJek=
Date: Tue, 12 Dec 2023 17:20:44 -0800
To: mm-commits@vger.kernel.org,stephen.smalley.work@gmail.com,peterz@infradead.org,paul@paul-moore.com,omosnace@redhat.com,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-vma-heap-bounds-checking.patch removed from -mm tree
Message-Id: <20231213012044.83D9DC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix VMA heap bounds checking
has been removed from the -mm tree.  Its filename was
     mm-fix-vma-heap-bounds-checking.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: fix VMA heap bounds checking
Date: Thu, 7 Dec 2023 23:25:25 +0800

After converting selinux to VMA heap check helper, the gcl triggers an
execheap SELinux denial, which is caused by a changed logic check.

Previously selinux only checked that the VMA range was within the VMA heap
range, and the implementation checks the intersection between the two
ranges, but the corner case (vm_end=start_brk, brk=vm_start) isn't handled
correctly.

Since commit 11250fd12eb8 ("mm: factor out VMA stack and heap checks") was
only a function extraction, it seems that the issue was introduced by
commit 0db0c01b53a1 ("procfs: fix /proc/<pid>/maps heap check").  Let's
fix above corner cases, meanwhile, correct the wrong indentation of the
stack and heap check helpers.

Fixes: 11250fd12eb8 ("mm: factor out VMA stack and heap checks")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reported-by: Ondrej Mosnacek <omosnace@redhat.com>
Closes: https://lore.kernel.org/selinux/CAFqZXNv0SVT0fkOK6neP9AXbj3nxJ61JAY4+zJzvxqJaeuhbFw@mail.gmail.com/
Tested-by: Ondrej Mosnacek <omosnace@redhat.com>
Link: https://lkml.kernel.org/r/20231207152525.2607420-1-wangkefeng.wang@huawei.com
Cc: David Hildenbrand <david@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~mm-fix-vma-heap-bounds-checking
+++ a/include/linux/mm.h
@@ -886,8 +886,8 @@ static inline bool vma_is_anonymous(stru
  */
 static inline bool vma_is_initial_heap(const struct vm_area_struct *vma)
 {
-       return vma->vm_start <= vma->vm_mm->brk &&
-		vma->vm_end >= vma->vm_mm->start_brk;
+	return vma->vm_start < vma->vm_mm->brk &&
+		vma->vm_end > vma->vm_mm->start_brk;
 }
 
 /*
@@ -901,8 +901,8 @@ static inline bool vma_is_initial_stack(
 	 * its "stack".  It's not even well-defined for programs written
 	 * languages like Go.
 	 */
-       return vma->vm_start <= vma->vm_mm->start_stack &&
-	       vma->vm_end >= vma->vm_mm->start_stack;
+	return vma->vm_start <= vma->vm_mm->start_stack &&
+		vma->vm_end >= vma->vm_mm->start_stack;
 }
 
 static inline bool vma_is_temporary_stack(struct vm_area_struct *vma)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


