Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CA3143C6A
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291637; cv=none; b=N4zX/PGOxNvMfVg2bfHALsk4F2QJgXLZy+iSHAMXmmYMrGOu8oRxrj3hbVQbj3Xi10GwItAO51YCw4AWHcUt//FwP8JQUha/rph3l/MaGuWm7V4zsc2cpLMwxto9YM0oWAhnUGEbp1dc2peVu8jQ/KLB5OIdBW1q9F2dOmkKhAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291637; c=relaxed/simple;
	bh=aIScmXD/Xl2Ix/yOUSBzo6mcuvztjFBIkOyJUewTZKM=;
	h=Date:To:From:Subject:Message-Id; b=XcIlOe2WDpfZT3xujeZfrr18+McMhQhA0VQySi+fULoUYhzLwnJwulTNARbOZmortzesF9SjLwseJOWnqUoVDbBg6Xbu4dFUF8Nqy5j3FBnWOdsysb2xkzQ5w9Ba5qVQkFICRoptI1bOBgu4tgjzMnrO80tBgKKUhS4VBEJLRFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hwbtgk/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hwbtgk/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB36C32782;
	Tue, 25 Jun 2024 05:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291637;
	bh=aIScmXD/Xl2Ix/yOUSBzo6mcuvztjFBIkOyJUewTZKM=;
	h=Date:To:From:Subject:From;
	b=hwbtgk/wwPoFrZ3bo21BI8gl/X+mzXPjhCkbAkz1jQ5NokVu888mmnV5KvBQCTFEB
	 QfGZZygJMfgzPcFvKlwCxdupZDeG86C07WcGvtMXAo9U56BArVOzxnfaILdOLtjK0T
	 IGd4aQSTjd6PdTCJMqAHzCORLptaV9S+HIe46/94=
Date: Mon, 24 Jun 2024 22:00:36 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch removed from -mm tree
Message-Id: <20240625050037.3AB36C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: add mTHP size alignment in shmem_get_unmapped_area
has been removed from the -mm tree.  Its filename was
     mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: add mTHP size alignment in shmem_get_unmapped_area
Date: Tue, 11 Jun 2024 18:11:09 +0800

Although the top-level hugepage allocation can be turned off, anonymous
shmem can still use mTHP by configuring the sysfs interface located at
'/sys/kernel/mm/transparent_hugepage/hugepage-XXkb/shmem_enabled'. 
Therefore, add alignment for mTHP size to provide a suitable alignment
address in shmem_get_unmapped_area().

Link: https://lkml.kernel.org/r/0c549b57cf7db07503af692d8546ecfad0fcce52.1718090413.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Lance Yang <ioworker0@gmail.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

--- a/mm/shmem.c~mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area
+++ a/mm/shmem.c
@@ -2393,6 +2393,7 @@ unsigned long shmem_get_unmapped_area(st
 	unsigned long inflated_len;
 	unsigned long inflated_addr;
 	unsigned long inflated_offset;
+	unsigned long hpage_size;
 
 	if (len > TASK_SIZE)
 		return -ENOMEM;
@@ -2411,8 +2412,6 @@ unsigned long shmem_get_unmapped_area(st
 
 	if (shmem_huge == SHMEM_HUGE_DENY)
 		return addr;
-	if (len < HPAGE_PMD_SIZE)
-		return addr;
 	if (flags & MAP_FIXED)
 		return addr;
 	/*
@@ -2424,8 +2423,11 @@ unsigned long shmem_get_unmapped_area(st
 	if (uaddr == addr)
 		return addr;
 
+	hpage_size = HPAGE_PMD_SIZE;
 	if (shmem_huge != SHMEM_HUGE_FORCE) {
 		struct super_block *sb;
+		unsigned long __maybe_unused hpage_orders;
+		int order = 0;
 
 		if (file) {
 			VM_BUG_ON(file->f_op != &shmem_file_operations);
@@ -2438,18 +2440,38 @@ unsigned long shmem_get_unmapped_area(st
 			if (IS_ERR(shm_mnt))
 				return addr;
 			sb = shm_mnt->mnt_sb;
+
+			/*
+			 * Find the highest mTHP order used for anonymous shmem to
+			 * provide a suitable alignment address.
+			 */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+			hpage_orders = READ_ONCE(huge_shmem_orders_always);
+			hpage_orders |= READ_ONCE(huge_shmem_orders_within_size);
+			hpage_orders |= READ_ONCE(huge_shmem_orders_madvise);
+			if (SHMEM_SB(sb)->huge != SHMEM_HUGE_NEVER)
+				hpage_orders |= READ_ONCE(huge_shmem_orders_inherit);
+
+			if (hpage_orders > 0) {
+				order = highest_order(hpage_orders);
+				hpage_size = PAGE_SIZE << order;
+			}
+#endif
 		}
-		if (SHMEM_SB(sb)->huge == SHMEM_HUGE_NEVER)
+		if (SHMEM_SB(sb)->huge == SHMEM_HUGE_NEVER && !order)
 			return addr;
 	}
 
-	offset = (pgoff << PAGE_SHIFT) & (HPAGE_PMD_SIZE-1);
-	if (offset && offset + len < 2 * HPAGE_PMD_SIZE)
+	if (len < hpage_size)
+		return addr;
+
+	offset = (pgoff << PAGE_SHIFT) & (hpage_size - 1);
+	if (offset && offset + len < 2 * hpage_size)
 		return addr;
-	if ((addr & (HPAGE_PMD_SIZE-1)) == offset)
+	if ((addr & (hpage_size - 1)) == offset)
 		return addr;
 
-	inflated_len = len + HPAGE_PMD_SIZE - PAGE_SIZE;
+	inflated_len = len + hpage_size - PAGE_SIZE;
 	if (inflated_len > TASK_SIZE)
 		return addr;
 	if (inflated_len < len)
@@ -2462,10 +2484,10 @@ unsigned long shmem_get_unmapped_area(st
 	if (inflated_addr & ~PAGE_MASK)
 		return addr;
 
-	inflated_offset = inflated_addr & (HPAGE_PMD_SIZE-1);
+	inflated_offset = inflated_addr & (hpage_size - 1);
 	inflated_addr += offset - inflated_offset;
 	if (inflated_offset > offset)
-		inflated_addr += HPAGE_PMD_SIZE;
+		inflated_addr += hpage_size;
 
 	if (inflated_addr > TASK_SIZE - len)
 		return addr;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


