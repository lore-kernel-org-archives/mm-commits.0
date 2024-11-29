Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2268C155345
	for <mm-commits@vger.kernel.org>; Fri, 29 Nov 2024 10:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732876686; cv=none; b=XrXmVjBo9AqLeFaq1OHFKe0mYrbtQQ6wd8AP7WTFRzBU5bvE783nxugC8G3RbXPGSnGtlWdhwUA8mEkZZajFkR/u4AZtawZE8jf1DzLWAZQ/JIGZYVw+GAFjtEK/EkQ8Bj6eHc5xgdXtkJroHb6M4fdtZPSFIG9xrkYEcW79jf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732876686; c=relaxed/simple;
	bh=l3ty0eaLw4E6M/4PH8uetYbVy/oCmXuTScEJXJvKPbQ=;
	h=Date:To:From:Subject:Message-Id; b=ammxjGy8U+avd12F7Qhq/dW8zEA3h8gHGrHos2XGke6jMmCcV3QjK2YxyG+mpP3NRmCLicqr4/0A4cJUFPhV83TSOj0VoocR5xzOutue0WdMo0HLWC3yzI03OwS5oOac21B6ueinU564Gdd0DCVC6ySJt+vmCIGE45BoYyVkK34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fq4h1NHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fq4h1NHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90986C4CECF;
	Fri, 29 Nov 2024 10:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732876685;
	bh=l3ty0eaLw4E6M/4PH8uetYbVy/oCmXuTScEJXJvKPbQ=;
	h=Date:To:From:Subject:From;
	b=Fq4h1NHJKrnAcykfL4+0RdbBou604IDOAKdl9wAiKeAtL4oAK+0srufHJlXvn0EM6
	 yER47C5uwVQyW00X2D2YFBAAFGOqiFRN6JnoMFYB7nmjxc0ZKDPvEJBJ6Q/KHtXQTi
	 NSJFi5RP5XMmIhTCGa70fV+S4PVrWBmxCqdhJkAU=
Date: Fri, 29 Nov 2024 02:38:05 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-factor-out-the-order-calculation-into-a-new-helper.patch added to mm-unstable branch
Message-Id: <20241129103805.90986C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: factor out the order calculation into a new helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-factor-out-the-order-calculation-into-a-new-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-factor-out-the-order-calculation-into-a-new-helper.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: factor out the order calculation into a new helper
Date: Thu, 28 Nov 2024 15:40:39 +0800

Patch series "Support large folios for tmpfs", v3.

Traditionally, tmpfs only supported PMD-sized large folios.  However
nowadays with other file systems supporting any sized large folios, and
extending anonymous to support mTHP, we should not restrict tmpfs to
allocating only PMD-sized large folios, making it more special.  Instead,
we should allow tmpfs can allocate any sized large folios.

Considering that tmpfs already has the 'huge=' option to control the
PMD-sized large folios allocation, we can extend the 'huge=' option to
allow any sized large folios.  The semantics of the 'huge=' mount option
are:

huge=never: no any sized large folios
huge=always: any sized large folios
huge=within_size: like 'always' but respect the i_size
huge=advise: like 'always' if requested with madvise()

Note: for tmpfs mmap() faults, due to the lack of a write size hint, still
allocate the PMD-sized large folios if huge=always/within_size/advise is
set.

Moreover, the 'deny' and 'force' testing options controlled by
'/sys/kernel/mm/transparent_hugepage/shmem_enabled', still retain the same
semantics.  The 'deny' can disable any sized large folios for tmpfs, while
the 'force' can enable PMD sized large folios for tmpfs.


This patch (of 6):

Factor out the order calculation into a new helper, which can be reused by
shmem in the following patch.

Link: https://lkml.kernel.org/r/cover.1732779148.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/5505f9ea50942820c1924d1803bfdd3a524e54f6.1732779148.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/include/linux/pagemap.h~mm-factor-out-the-order-calculation-into-a-new-helper
+++ a/include/linux/pagemap.h
@@ -727,6 +727,16 @@ typedef unsigned int __bitwise fgf_t;
 
 #define FGP_WRITEBEGIN		(FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE)
 
+static inline unsigned int filemap_get_order(size_t size)
+{
+	unsigned int shift = ilog2(size);
+
+	if (shift <= PAGE_SHIFT)
+		return 0;
+
+	return shift - PAGE_SHIFT;
+}
+
 /**
  * fgf_set_order - Encode a length in the fgf_t flags.
  * @size: The suggested size of the folio to create.
@@ -740,11 +750,11 @@ typedef unsigned int __bitwise fgf_t;
  */
 static inline fgf_t fgf_set_order(size_t size)
 {
-	unsigned int shift = ilog2(size);
+	unsigned int order = filemap_get_order(size);
 
-	if (shift <= PAGE_SHIFT)
+	if (!order)
 		return 0;
-	return (__force fgf_t)((shift - PAGE_SHIFT) << 26);
+	return (__force fgf_t)(order << 26);
 }
 
 void *filemap_get_entry(struct address_space *mapping, pgoff_t index);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-factor-out-the-order-calculation-into-a-new-helper.patch
mm-shmem-change-shmem_huge_global_enabled-to-return-huge-order-bitmap.patch
mm-shmem-add-large-folio-support-for-tmpfs.patch
mm-shmem-add-a-kernel-command-line-to-change-the-default-huge-policy-for-tmpfs.patch
docs-tmpfs-drop-fadvise-from-the-documentation.patch

