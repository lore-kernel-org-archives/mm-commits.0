Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239B01DFDE;
	Tue, 28 Apr 2026 13:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777381533; cv=none; b=gzuH2Sm19lKnJt8qmfC2g7HQ3uGe92AXC9osiHw5k2rgOpKvA2uFRp6fBgKu8fvWSGpRmhiKiHLBa+u2EBboIUJnHGtHTXY1IQbQzM8N4S0Xm4hR1HWGNNDnTE+FzITI7dJc1TcaRlA1Erd4wIeWX1d3uLv1lyxeHsIW6qR7Bf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777381533; c=relaxed/simple;
	bh=WwF/5E/tdY45pHiWq0hqN824Nr8wukjnuKlIZQMWIhw=;
	h=Date:To:From:Subject:Message-Id; b=mFzyH1wbaZp3bLnJMiNscTmJc2eQlW1Y4BYClQveeoKUA/0634bW1Lp8OGMPjLEr0tsFQZvdPdwshs3IGYH1BPOUs5VkL4oSxgOxriXfKpYPIki7fqsPx5LepZF2Xw8XKZpYyqgPX/XsF2jDcNkso+Q2xXZwXlPQQObm8iUWi5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HRnwPTuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HRnwPTuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4516C2BCAF;
	Tue, 28 Apr 2026 13:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777381532;
	bh=WwF/5E/tdY45pHiWq0hqN824Nr8wukjnuKlIZQMWIhw=;
	h=Date:To:From:Subject:From;
	b=HRnwPTuGsCP2T65QDGHCB6e6ftRI3rWdzmk/Z++hoFpx6/bvsW2YzkHXzBjfV0b/7
	 V3wxVnjpw/xyvB9BnRyaulQq4fXUFU2wW5+TK6qmWYLe27hghNib0pfyYiaFt8HCnb
	 Jm8I32Qpt45vgTSKXAAddT+tn9qnLB4hUWFiDPhs=
Date: Tue, 28 Apr 2026 06:05:32 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,stable@vger.kernel.org,rafael@kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,huang.ying.caritas@gmail.com,gregkh@linuxfoundation.org,david@kernel.org,dakr@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] drivers-base-memory-fix-memory-block-reference-leak-in-poison-accounting.patch removed from -mm tree
Message-Id: <20260428130532.A4516C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/base/memory: fix memory block reference leak in poison accounting
has been removed from the -mm tree.  Its filename was
     drivers-base-memory-fix-memory-block-reference-leak-in-poison-accounting.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: drivers/base/memory: fix memory block reference leak in poison accounting
Date: Sun, 26 Apr 2026 22:44:47 +0800

memblk_nr_poison_inc() and memblk_nr_poison_sub() look up a memory block
via find_memory_block_by_id(), which acquires a reference to the memory
block device.

Both helpers use the returned memory block without dropping that
reference, leaking the device reference on each successful lookup.  Drop
the reference after updating nr_hwpoison.

Link: https://lore.kernel.org/20260426144447.817722-2-songmuchun@bytedance.com
Fixes: 5033091de814 ("mm/hwpoison: introduce per-memory_block hwpoison counter")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Huang, Ying" <huang.ying.caritas@gmail.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>
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

