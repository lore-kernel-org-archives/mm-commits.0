Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25D22DF155;
	Thu, 14 May 2026 00:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778719243; cv=none; b=hXKMdQZTCYSh5MSDPSrQtwsML2zfRJjyY5CsPCnUemHQX1XOgqATWGMeDB8pXHhWw4PPg7rNeT9ADilopabZKFwiByq0atUPAVDvMXFjLfmysorruwLbsktHrVYdj8BxXrp04TE9oUz5dtT/N51XmSfYglRWsrw7PxmW3LW9+3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778719243; c=relaxed/simple;
	bh=QFVIvYwLvgHhK6IInnk0IlsrGXoYyYy+7WKfhejoHUs=;
	h=Date:To:From:Subject:Message-Id; b=jWJhp4e/VSELNJOZ5/VnE51/IXQ1+DwsmoI2b7GjYp6bhSCNHSaiaodSfB7/UE3g1rMeH+oLz2XvnaKDWh1V9rdeNRYB+aWB1++/o+ikovfIzoSauv9pCMkwIgrkOlgZSXkCiTGFS+cm3gzV1lcY3SQP2O/3r1Usl8JT2VmkfVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jNmnvH04; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jNmnvH04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456F9C19425;
	Thu, 14 May 2026 00:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778719243;
	bh=QFVIvYwLvgHhK6IInnk0IlsrGXoYyYy+7WKfhejoHUs=;
	h=Date:To:From:Subject:From;
	b=jNmnvH04VxNXSxBoCPIeIV41QFz6XfQ+A5SJ6gNOil21pM0HThcC1NVa+emuA9uOF
	 WECJDpWgCY0EmzU26tCHIS/o+GOw/H/BhSFli+1Z+hYYLH3xX2Zaivk9RIk8Dlnkpo
	 lqC5FwiPRVQbhc6a8+PHTxP50mUmBJggLw37nSQA=
Date: Wed, 13 May 2026 17:40:42 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,stable@vger.kernel.org,rafael@kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,huang.ying.caritas@gmail.com,gregkh@linuxfoundation.org,david@kernel.org,dakr@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] drivers-base-memory-fix-memory-block-reference-leak-in-poison-accounting.patch removed from -mm tree
Message-Id: <20260514004043.456F9C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/base/memory: fix memory block reference leak in poison accounting
has been removed from the -mm tree.  Its filename was
     drivers-base-memory-fix-memory-block-reference-leak-in-poison-accounting.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: drivers/base/memory: fix memory block reference leak in poison accounting
Date: Tue, 28 Apr 2026 16:52:18 +0800

memblk_nr_poison_inc() and memblk_nr_poison_sub() look up a memory block
via find_memory_block_by_id(), which acquires a reference to the memory
block device.

Both helpers use the returned memory block without dropping that
reference, leaking the device reference on each successful lookup.  Drop
the reference after updating nr_hwpoison.

Link: https://lore.kernel.org/20260428085219.1316047-3-songmuchun@bytedance.com
Fixes: 5033091de814 ("mm/hwpoison: introduce per-memory_block hwpoison counter")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Huang, Ying" <huang.ying.caritas@gmail.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memory-fix-memory-block-reference-leak-in-poison-accounting
+++ a/drivers/base/memory.c
@@ -1230,8 +1230,10 @@ void memblk_nr_poison_inc(unsigned long
 	const unsigned long block_id = pfn_to_block_id(pfn);
 	struct memory_block *mem = find_memory_block_by_id(block_id);
 
-	if (mem)
+	if (mem) {
 		atomic_long_inc(&mem->nr_hwpoison);
+		put_device(&mem->dev);
+	}
 }
 
 void memblk_nr_poison_sub(unsigned long pfn, long i)
@@ -1239,8 +1241,10 @@ void memblk_nr_poison_sub(unsigned long
 	const unsigned long block_id = pfn_to_block_id(pfn);
 	struct memory_block *mem = find_memory_block_by_id(block_id);
 
-	if (mem)
+	if (mem) {
 		atomic_long_sub(i, &mem->nr_hwpoison);
+		put_device(&mem->dev);
+	}
 }
 
 static unsigned long memblk_nr_poison(struct memory_block *mem)
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-sparse-remove-sparse-buffer-pre-allocation-mechanism.patch
mm-sparse-vmemmap-fix-vmemmap-accounting-underflow.patch
mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch
mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths.patch
mm-sparse-vmemmap-fix-dax-vmemmap-accounting-with-optimization.patch
mm-mm_init-fix-pageblock-migratetype-for-zone_device-compound-pages.patch
mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch
mm-memory_hotplug-factor-out-altmap-freeing-checks.patch
drivers-base-memory-make-memory-block-get-put-explicit.patch

