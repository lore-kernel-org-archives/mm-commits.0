Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58913FA5E9;
	Tue, 28 Apr 2026 13:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777381476; cv=none; b=pb06nb5UX0UH6Bmv14qJsSCCbrls/TnBr1Q5EwFn4WIDGW2S/zBFGIqXbJTiTofzace6hyfx7W9l4+1DIUku0rpHiOSZQz/9iseU1V5m5vEezWb3w/clgHnrihcGzb5v1JI5xjxw+KGlPuWH1Xb6lGV8hJ/5Dyx6/VEXo1PcJAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777381476; c=relaxed/simple;
	bh=Qjzk/xfoblUOAwdeLxe0QrrfqmF43qujdooiW3bYNlw=;
	h=Date:To:From:Subject:Message-Id; b=WljDh3YGvKqZVbC6Ze18r6tyGIwm5ibYG1cRd74oyxBNkAVAom58r6hrXeT6C9+dxOIIRzBJsgJTrtUAMaqjSuZ+rxEqJaiJ7UTo1yOoeOoqe7B6N16UL6/i9xU9ybhuxKR36czbp/tzinMnjo3jxOD8+UvgV7CHQgu5ey5168Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zTJkSSvG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zTJkSSvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07DAC2BCB5;
	Tue, 28 Apr 2026 13:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777381475;
	bh=Qjzk/xfoblUOAwdeLxe0QrrfqmF43qujdooiW3bYNlw=;
	h=Date:To:From:Subject:From;
	b=zTJkSSvGecySVL6KTYSCDGBqwXxKAc5UbFLSVDDtQFA375Zzg1P7skdJExU9aTA8W
	 uKYfc6eXK7JTTvUG4jPmJxF7wAOqZZTo4U/2WAgMys3IO3oxY1f4UGTJUOtid+ITGW
	 g4UaxrfdCBOIZA0iXaZqs/cUGys5EuXzCo6k/8kc=
Date: Tue, 28 Apr 2026 06:04:35 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,stable@vger.kernel.org,rafael@kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,huang.ying.caritas@gmail.com,gregkh@linuxfoundation.org,david@kernel.org,dakr@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory_hotplug-fix-memory-block-reference-leak-on-remove.patch removed from -mm tree
Message-Id: <20260428130435.A07DAC2BCB5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: fix memory block reference leak on remove
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-fix-memory-block-reference-leak-on-remove.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/memory_hotplug: fix memory block reference leak on remove
Date: Sun, 26 Apr 2026 22:44:46 +0800

remove_memory_blocks_and_altmaps() looks up each memory block with
find_memory_block(), which acquires a reference to the memory block
device.

That reference is never dropped on this path, resulting in a leaked device
reference when removing memory blocks and their altmaps.  Drop the
reference after retrieving mem->altmap and clearing mem->altmap, before
removing the memory block device.

Link: https://lore.kernel.org/20260426144447.817722-1-songmuchun@bytedance.com
Fixes: 6b8f0798b85a ("mm/memory_hotplug: split memmap_on_memory requests across memblocks")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Huang, Ying" <huang.ying.caritas@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-memory-block-reference-leak-on-remove
+++ a/mm/memory_hotplug.c
@@ -1422,6 +1422,7 @@ static void remove_memory_blocks_and_alt
 
 		altmap = mem->altmap;
 		mem->altmap = NULL;
+		put_device(&mem->dev);
 
 		remove_memory_block_devices(cur_start, memblock_size);
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

drivers-base-memory-fix-memory-block-reference-leak-in-poison-accounting.patch
mm-sparse-remove-sparse-buffer-pre-allocation-mechanism.patch
mm-sparse-vmemmap-fix-vmemmap-accounting-underflow.patch
mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch
mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths.patch
mm-sparse-vmemmap-fix-dax-vmemmap-accounting-with-optimization.patch
mm-mm_init-fix-pageblock-migratetype-for-zone_device-compound-pages.patch
mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch

