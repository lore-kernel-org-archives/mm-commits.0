Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA13A37D101
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439012; cv=none; b=UPzINdg2UWorCv02AHgDaxNm/xHXYnBLSjb54EaXoR04V7ek4l3Zomkwt1HZDxXS91zr8VYW3AgI6bZHOI3RWHmlaBIuIbKqCCxbbMWKTrK9GI+YkSXAU1NGmOzgrkZ0KeqdtaLu/h9/u/DlFJwJDf0eImcAG6hOtRBUA0NsHNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439012; c=relaxed/simple;
	bh=XZ0M63/JRO1bSUpXcElf3Cq7RA5P7hPMjNBieRwsCWI=;
	h=Date:To:From:Subject:Message-Id; b=RH78EE9gVXjJVSV0Tljk0xIsodyXvMLn4uzMriW5dQRUxsXoOxdCd8ycWETkaWGVZheprqxy2va601NI9Qs5zu1t/1bJ0UYeKr3xRO9uvzJ/qfypW3TBNm2MeaYT4xCPz+SzGz1cxA2ovKmkUjhh5Bwe08wZtbSP9j4qRa4Kn+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FxdjDn+l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FxdjDn+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2AB1F00893;
	Tue,  2 Jun 2026 22:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439010;
	bh=IvcTEZsxSX8FF8wxPYhnJIEV3V6sh66saNvrrthdOws=;
	h=Date:To:From:Subject;
	b=FxdjDn+lTsrUAMKcrj+KRWnzTQTyvI42n4ewoVKHf4NgXNr/vbrAiv4rJIeVZcouB
	 +ATEU16/JSOnYk1x5Y4JVBJDXw8/yfxl972BEOXrmxF29f+T7TT0zx4bm2aUOInPJB
	 G1aAb53fv4jzD4On+ZIv+v6VstSh9EhnFaycJN0k=
Date: Tue, 02 Jun 2026 15:23:30 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,donettom@linux.ibm.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-factor-out-altmap-freeing-checks.patch removed from -mm tree
Message-Id: <20260602222330.8E2AB1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: factor out altmap freeing checks
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-factor-out-altmap-freeing-checks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/memory_hotplug: factor out altmap freeing checks
Date: Mon, 11 May 2026 16:43:07 +0800

Use a small helper to centralize altmap freeing after verifying that all
vmemmap pages were released.  This keeps the check consistent between the
normal teardown path and the memory hotplug error paths.

Link: https://lore.kernel.org/20260511084307.1827127-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-factor-out-altmap-freeing-checks
+++ a/mm/memory_hotplug.c
@@ -1403,6 +1403,12 @@ bool mhp_supports_memmap_on_memory(void)
 }
 EXPORT_SYMBOL_GPL(mhp_supports_memmap_on_memory);
 
+static void altmap_free(struct vmem_altmap *altmap)
+{
+	WARN_ONCE(altmap->alloc, "Altmap not fully unmapped");
+	kfree(altmap);
+}
+
 static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
 {
 	unsigned long memblock_size = memory_block_size_bytes();
@@ -1427,12 +1433,8 @@ static void remove_memory_blocks_and_alt
 		put_device(&mem->dev);
 
 		remove_memory_block_devices(cur_start, memblock_size);
-
 		arch_remove_memory(cur_start, memblock_size, altmap, NULL);
-
-		/* Verify that all vmemmap pages have actually been freed. */
-		WARN(altmap->alloc, "Altmap not fully unmapped");
-		kfree(altmap);
+		altmap_free(altmap);
 	}
 }
 
@@ -1463,7 +1465,7 @@ static int create_altmaps_and_memory_blo
 		/* call arch's memory hotadd */
 		ret = arch_add_memory(nid, cur_start, memblock_size, &params);
 		if (ret < 0) {
-			kfree(params.altmap);
+			altmap_free(params.altmap);
 			goto out;
 		}
 
@@ -1472,7 +1474,7 @@ static int create_altmaps_and_memory_blo
 						  params.altmap, group);
 		if (ret) {
 			arch_remove_memory(cur_start, memblock_size, params.altmap, NULL);
-			kfree(params.altmap);
+			altmap_free(params.altmap);
 			goto out;
 		}
 	}
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-sparse-vmemmap-provide-generic-vmemmap_set_pmd-and-vmemmap_check_pmd.patch
arm64-mm-drop-vmemmap_pmd-helpers-and-use-generic-code.patch
riscv-mm-drop-vmemmap_pmd-helpers-and-use-generic-code.patch
loongarch-mm-drop-vmemmap_check_pmd-helper-and-use-generic-code.patch
sparc-mm-drop-vmemmap_check_pmd-helper-and-use-generic-code.patch

