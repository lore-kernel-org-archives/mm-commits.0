Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517CF14AD2B
	for <mm-commits@vger.kernel.org>; Fri,  1 Aug 2025 21:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754083485; cv=none; b=SnCkCJfItNxLEWcNz4qHBlYUwKK87dvl6y4YN5nzTV0kZ0cl+ZMq2jhiMPffM5dhr0hrAbtX4ibHsOP0x3o3yKN1xxn4FBcxGjuBOxNVfDbOfUcble0/3+XCL70L5lXaU/bVRvtMJkPHN0HVRxn8FYOCBckzH7lBh1kdO+BJ7nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754083485; c=relaxed/simple;
	bh=g5vFR/LzMRs96jwRVMU73n1twKc0Q1iwwyP0Saj/IzE=;
	h=Date:To:From:Subject:Message-Id; b=lUZdi6dfgJpSwWk6ga711603ys5Jz6EOTISDoJNd81vFP9OxLSmkZTjgmvSo7Ud4Mrh1H/0s+8tRaaDvC8pevBXxgie+rjKiJ6zSi7kUx4dq54/IXuEitp5iSKr8tdG95mRP818/kf1UOnNv6ecCT4dSs9rVIBeOlZBCi/RR6I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W9dFBr5s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W9dFBr5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75A0C4CEF4;
	Fri,  1 Aug 2025 21:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754083484;
	bh=g5vFR/LzMRs96jwRVMU73n1twKc0Q1iwwyP0Saj/IzE=;
	h=Date:To:From:Subject:From;
	b=W9dFBr5sC5zRdPjxhegEjRR+Tg/FiSNNnX/6sgQzAF6aND3cXZkUkejdu3nSGE88Y
	 C5LJNrNqNuyqm5iRsR9V11jMPXZg5/0DMSGO//miGeeZU9TMf5NfkbDxv/5c7Bbvz2
	 RMrCLt1Z9sTFAr50XV2ps69uysWNEAogcPI5V+hY=
Date: Fri, 01 Aug 2025 14:24:44 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,lorenzo.stoakes@oracle.com,gregkh@linuxfoundation.org,david@redhat.com,arnd@arndb.de,zhangqilong3@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dev-zero-try-to-align-pmd_size-for-private-mapping.patch added to mm-new branch
Message-Id: <20250801212444.D75A0C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: /dev/zero: try to align PMD_SIZE for private mapping
has been added to the -mm mm-new branch.  Its filename is
     dev-zero-try-to-align-pmd_size-for-private-mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dev-zero-try-to-align-pmd_size-for-private-mapping.patch

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
From: Zhang Qilong <zhangqilong3@huawei.com>
Subject: /dev/zero: try to align PMD_SIZE for private mapping
Date: Thu, 31 Jul 2025 20:23:05 +0800

Attempt to map aligned to huge page size for private mapping which could
achieve performance gains, the mprot_tw4m in libMicro average execution
time on arm64:

  - Test case:        mprot_tw4m
  - Before the patch:   22 us
  - After the patch:    17 us

If THP config is not set, we fall back to system page size mappings.

Link: https://lkml.kernel.org/r/20250731122305.2669090-1-zhangqilong3@huawei.com
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/char/mem.c~dev-zero-try-to-align-pmd_size-for-private-mapping
+++ a/drivers/char/mem.c
@@ -512,11 +512,18 @@ static int mmap_zero(struct file *file,
 	return 0;
 }
 
+#ifndef CONFIG_MMU
+static unsigned long get_unmapped_area_zero(struct file *file,
+				unsigned long addr, unsigned long len,
+				unsigned long pgoff, unsigned long flags)
+{
+	return -ENOSYS;
+}
+#else
 static unsigned long get_unmapped_area_zero(struct file *file,
 				unsigned long addr, unsigned long len,
 				unsigned long pgoff, unsigned long flags)
 {
-#ifdef CONFIG_MMU
 	if (flags & MAP_SHARED) {
 		/*
 		 * mmap_zero() will call shmem_zero_setup() to create a file,
@@ -527,12 +534,18 @@ static unsigned long get_unmapped_area_z
 		return shmem_get_unmapped_area(NULL, addr, len, pgoff, flags);
 	}
 
-	/* Otherwise flags & MAP_PRIVATE: with no shmem object beneath it */
-	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
+	/*
+	 * Otherwise flags & MAP_PRIVATE: with no shmem object beneath it,
+	 * attempt to map aligned to huge page size if possible, otherwise we
+	 * fall back to system page size mappings.
+	 */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	return thp_get_unmapped_area(file, addr, len, pgoff, flags);
 #else
-	return -ENOSYS;
+	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
 #endif
 }
+#endif /* CONFIG_MMU */
 
 static ssize_t write_full(struct file *file, const char __user *buf,
 			  size_t count, loff_t *ppos)
_

Patches currently in -mm which might be from zhangqilong3@huawei.com are

dev-zero-try-to-align-pmd_size-for-private-mapping.patch

