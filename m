Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904403EF0C9;
	Tue, 28 Apr 2026 13:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777381904; cv=none; b=UvZIRVIcWHFm7l2o8HzfcdYTrVPUT+m7SiWFpMnlLPboAIy2JzEo6L5wc8veSYkIVts43rXynpbPyqiBvt7s/7x0PspatSJoWmZRlL9gNLpPPJPdQ8UqDc+rFt8CUq/q0Btn4KzZ4F0YN/aoSJs5GIu1Tyy79dexCbplHei/gjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777381904; c=relaxed/simple;
	bh=7bQHRBYiTWl3IzgqvS1ld7tdP9kOvFYogpTV898VrvU=;
	h=Date:To:From:Subject:Message-Id; b=hn7u6p4/zyTrCAZ1ADC7wlM0+MmIBl+JhgxpWxU2x9IVZnmhg/TZ3xEXHf0MP7WGhxZ6GoffPmkPZofmGKSitoObNB6Em65fC8PsjhU8YzNS2VZVU/BdrHHkgb18BgXiqMBKjWXE0Ur1ayV+WVBdDL39MkmIfs9EZxEDltWjmLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f6pv8jv2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f6pv8jv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF6DC2BCAF;
	Tue, 28 Apr 2026 13:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777381904;
	bh=7bQHRBYiTWl3IzgqvS1ld7tdP9kOvFYogpTV898VrvU=;
	h=Date:To:From:Subject:From;
	b=f6pv8jv2P+wOokQHa4l/BdTMLzBm8bKoDSymVNZS8q2xu2sXqQyrxIH9ko3907Q5R
	 +mfnUBT/s9NaJVANRyP999G8KRqvL5+Y5JwrhZ/4l40zzWune87YqLPi6reD0OP7sS
	 +9dYapeBAfKW9+KQzVGwB73ZF+9aRaJhlHUB9jfY=
Date: Tue, 28 Apr 2026 06:11:43 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,stable@vger.kernel.org,rafael@kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,huang.ying.caritas@gmail.com,gregkh@linuxfoundation.org,david@kernel.org,dakr@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-memory-fix-memory-block-reference-leak-in-poison-accounting.patch added to mm-hotfixes-unstable branch
Message-Id: <20260428131144.2CF6DC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/base/memory: fix memory block reference leak in poison accounting
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     drivers-base-memory-fix-memory-block-reference-leak-in-poison-accounting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-base-memory-fix-memory-block-reference-leak-in-poison-accounting.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-memory_hotplug-fix-memory-block-reference-leak-on-remove.patch
drivers-base-memory-fix-memory-block-reference-leak-in-poison-accounting.patch
drivers-base-memory-fix-locking-for-poison-accounting-lookup.patch
mm-sparse-remove-sparse-buffer-pre-allocation-mechanism.patch
mm-sparse-vmemmap-fix-vmemmap-accounting-underflow.patch
mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch
mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths.patch
mm-sparse-vmemmap-fix-dax-vmemmap-accounting-with-optimization.patch
mm-mm_init-fix-pageblock-migratetype-for-zone_device-compound-pages.patch
mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch

