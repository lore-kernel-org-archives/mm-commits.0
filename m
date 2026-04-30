Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65AC44BCB0;
	Thu, 30 Apr 2026 15:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777564171; cv=none; b=ZXZt2ElqBOIq7vO1G1wVmkplzGTMfmlGBhdODCR0rdE3uvhODUkqni6CC3WM4LMy+g7XGfX2TRtc1Tu1a/e4ovcrV1vYSYBQI54meyGV2GgLRBHQS73R2VNxd1G4DbpzGbL3LKe0o/OSghwReGxy32/oIVY8MT+e0f/JWqaL5Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777564171; c=relaxed/simple;
	bh=U9cfvuAJYm3hSOhlE8bKK8zVYOpVn7y76zVweeYTk34=;
	h=Date:To:From:Subject:Message-Id; b=LdgkIeYVGpXNdtNbpvDTRrjDuqQU1VUxWaDxyZI7FrQUsu/zPUAdO30hOfttguj+/hswxDh6/se4wUYdOtyXY6EeJ6EQQANoJ/Z4XNb9/vEHmxi0LhFk61rvnTss27rHWFSqYfKLhLZwULxwc1BQXNQMaBuV2lNJbxZgdEUBiPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FU9Sc0Z5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FU9Sc0Z5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCB9C2BCB3;
	Thu, 30 Apr 2026 15:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777564171;
	bh=U9cfvuAJYm3hSOhlE8bKK8zVYOpVn7y76zVweeYTk34=;
	h=Date:To:From:Subject:From;
	b=FU9Sc0Z5rvBYi+MTmjeTVoaP1QiH391AvO+4oq05iVnAdzZSrYBE7V75oJLtoLqPK
	 ck/1fxgZTcshfYzIhW/OezKwwYvRKEUJSxyjrpJl+CX1R+SbvWTxnLfwyTAb7wVesE
	 jcgawwjh4MCOEHEhNJDPzsowoQFSH1sB5lNWQJD0=
Date: Thu, 30 Apr 2026 08:49:29 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,stable@vger.kernel.org,rafael@kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,huang.ying.caritas@gmail.com,gregkh@linuxfoundation.org,david@kernel.org,dakr@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] drivers-base-memory-fix-locking-for-poison-accounting-lookup.patch removed from -mm tree
Message-Id: <20260430154931.3DCB9C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/base/memory: fix locking for poison accounting lookup
has been removed from the -mm tree.  Its filename was
     drivers-base-memory-fix-locking-for-poison-accounting-lookup.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: drivers/base/memory: fix locking for poison accounting lookup
Date: Tue, 28 Apr 2026 16:52:19 +0800

memblk_nr_poison_inc() and memblk_nr_poison_sub() call
find_memory_block_by_id(), which requires device_hotplug_lock to serialize
the xarray lookup against memory block removal.

Take device_hotplug_lock around the lookup and nr_hwpoison update so the
memory block cannot disappear between xa_load() and get_device().

Link: https://lore.kernel.org/20260428085219.1316047-4-songmuchun@bytedance.com
Fixes: 5033091de814 ("mm/hwpoison: introduce per-memory_block hwpoison counter")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Huang, Ying" <huang.ying.caritas@gmail.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memory-fix-locking-for-poison-accounting-lookup
+++ a/drivers/base/memory.c
@@ -1228,23 +1228,29 @@ int walk_dynamic_memory_groups(int nid,
 void memblk_nr_poison_inc(unsigned long pfn)
 {
 	const unsigned long block_id = pfn_to_block_id(pfn);
-	struct memory_block *mem = find_memory_block_by_id(block_id);
+	struct memory_block *mem;
 
+	lock_device_hotplug();
+	mem = find_memory_block_by_id(block_id);
 	if (mem) {
 		atomic_long_inc(&mem->nr_hwpoison);
 		put_device(&mem->dev);
 	}
+	unlock_device_hotplug();
 }
 
 void memblk_nr_poison_sub(unsigned long pfn, long i)
 {
 	const unsigned long block_id = pfn_to_block_id(pfn);
-	struct memory_block *mem = find_memory_block_by_id(block_id);
+	struct memory_block *mem;
 
+	lock_device_hotplug();
+	mem = find_memory_block_by_id(block_id);
 	if (mem) {
 		atomic_long_sub(i, &mem->nr_hwpoison);
 		put_device(&mem->dev);
 	}
+	unlock_device_hotplug();
 }
 
 static unsigned long memblk_nr_poison(struct memory_block *mem)
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memory_hotplug-fix-memory-block-reference-leak-on-remove.patch
drivers-base-memory-fix-memory-block-reference-leak-in-poison-accounting.patch
mm-sparse-remove-sparse-buffer-pre-allocation-mechanism.patch
mm-sparse-vmemmap-fix-vmemmap-accounting-underflow.patch
mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch
mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths.patch
mm-sparse-vmemmap-fix-dax-vmemmap-accounting-with-optimization.patch
mm-mm_init-fix-pageblock-migratetype-for-zone_device-compound-pages.patch
mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch

