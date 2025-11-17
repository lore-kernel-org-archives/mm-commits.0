Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7C330FC13
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 18:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763403373; cv=none; b=hqi7/PuvxYgoPpd4vh/MDbi5k8wFMIFWGf6zXR2s+14tJ7ft0xc0yIzgyRqhKmLA314UYZ5UAQr79F3vDvdWhaZO75AynZhA+hZMRnEqtwpU77yDDlOo0CJlpHuHQUN+VhyS9eRALhHtteuem9PyRi4AIJoYOulSIPqIgTpGuxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763403373; c=relaxed/simple;
	bh=TSOz+RoGSSUcMO+PM0I9rFC7JkwnmRWPyui4kNG9xHQ=;
	h=Date:To:From:Subject:Message-Id; b=Gx2pc/EYnHX5GgeFap8gE9huzpbhyY3VitgB8juGXRh6G8w2IlwvCGHlvid1co12z9OkEa4bFjD4lIPULUbgzdBw1HuIGy6xgMyC+fxS/i9Pn3UgLUbQEqQLpaguPcdXJ+NOY9LmYeTjOP2zuinZ2iyNcEAANBsPTuWyHvnrmsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v3tjiaKg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v3tjiaKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB29C113D0;
	Mon, 17 Nov 2025 18:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763403372;
	bh=TSOz+RoGSSUcMO+PM0I9rFC7JkwnmRWPyui4kNG9xHQ=;
	h=Date:To:From:Subject:From;
	b=v3tjiaKgJmyatK6JkOHGXyOGwKCSq9h6Z/96M5Izejs3J4aZ17dmhKbVyrmCxHgHq
	 iPvyBX5fxAI3GiGxGMRzoRKzLdbKxYdz/9eW2UDsMMeeIMm2yXtaz1ZM3okeSeN0fw
	 hZTfC56aVl1CmIZBJNc3ckv/f0/vMMZTESwv4RvY=
Date: Mon, 17 Nov 2025 10:16:10 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,simona@ffwll.ch,ryan.roberts@arm.com,rcampbell@nvidia.com,rakie.kim@sk.com,osalvador@suse.de,npache@redhat.com,mpenttil@redhat.com,matthew.brost@intel.com,lyude@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,joshua.hahnjy@gmail.com,gourry@gourry.net,francois.dugast@intel.com,dev.jain@arm.com,david@redhat.com,dakr@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,airlied@gmail.com,balbirs@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memoryc-introduce-folio_split_unmapped-v2.patch added to mm-new branch
Message-Id: <20251117181612.1CB29C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-huge_memoryc-introduce-folio_split_unmapped-v2
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memoryc-introduce-folio_split_unmapped-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memoryc-introduce-folio_split_unmapped-v2.patch

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
From: Balbir Singh <balbirs@nvidia.com>
Subject: mm-huge_memoryc-introduce-folio_split_unmapped-v2
Date: Sat, 15 Nov 2025 19:40:41 +1100

- Fix a bug reported by kernel-test-robot, nr_shmem_dropped needs to
  be updated and returned from the helper function

- Add a debug warning folio_split_unmapped() should be called only on
  anonymous folios

Link: https://lkml.kernel.org/r/20251115084041.3914728-1-balbirs@nvidia.com
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Suggested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memoryc-introduce-folio_split_unmapped-v2
+++ a/mm/huge_memory.c
@@ -3743,12 +3743,11 @@ static int __folio_freeze_and_split_unma
 					     struct page *split_at, struct xa_state *xas,
 					     struct address_space *mapping, bool do_lru,
 					     struct list_head *list, enum split_type split_type,
-					     pgoff_t end, int extra_pins)
+					     pgoff_t end, int *nr_shmem_dropped, int extra_pins)
 {
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
 	int old_order = folio_order(folio);
-	int nr_shmem_dropped = 0;
 	int ret = 0;
 	struct deferred_split *ds_queue;
 
@@ -3851,9 +3850,10 @@ static int __folio_freeze_and_split_unma
 				continue;
 			}
 
+			VM_WARN_ON_ONCE(!nr_shmem_dropped);
 			/* Drop folio beyond EOF: ->index >= end */
-			if (shmem_mapping(mapping))
-				nr_shmem_dropped += nr_pages;
+			if (shmem_mapping(mapping) && nr_shmem_dropped)
+				*nr_shmem_dropped += nr_pages;
 			else if (folio_test_clear_dirty(new_folio))
 				folio_account_cleaned(
 					new_folio, inode_to_wb(mapping->host));
@@ -4041,7 +4041,8 @@ static int __folio_split(struct folio *f
 	}
 
 	ret = __folio_freeze_and_split_unmapped(folio, new_order, split_at, &xas, mapping,
-						true, list, split_type, end, extra_pins);
+						true, list, split_type, end, &nr_shmem_dropped,
+						extra_pins);
 fail:
 	if (mapping)
 		xas_unlock(&xas);
@@ -4106,9 +4107,10 @@ int folio_split_unmapped(struct folio *f
 {
 	int extra_pins, ret = 0;
 
-	VM_WARN_ON_FOLIO(folio_mapped(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_anon(folio), folio);
 
 	if (!can_split_folio(folio, 1, &extra_pins))
 		return -EAGAIN;
@@ -4116,7 +4118,7 @@ int folio_split_unmapped(struct folio *f
 	local_irq_disable();
 	ret = __folio_freeze_and_split_unmapped(folio, new_order, &folio->page, NULL,
 						NULL, false, NULL, SPLIT_TYPE_UNIFORM,
-						0, extra_pins);
+						0, NULL, extra_pins);
 	local_irq_enable();
 	return ret;
 }
_

Patches currently in -mm which might be from balbirs@nvidia.com are

mm-zone_device-support-large-zone-device-private-folios.patch
mm-zone_device-rename-page_free-callback-to-folio_free.patch
mm-huge_memory-add-device-private-thp-support-to-pmd-operations.patch
mm-rmap-extend-rmap-and-migration-support-device-private-entries.patch
mm-rmap-extend-rmap-and-migration-support-device-private-entries-fix.patch
mm-rmap-extend-rmap-and-migration-support-device-private-entries-fix-2.patch
mm-huge_memory-implement-device-private-thp-splitting.patch
mm-migrate_device-handle-partially-mapped-folios-during-collection.patch
mm-migrate_device-implement-thp-migration-of-zone-device-pages.patch
mm-memory-fault-add-thp-fault-handling-for-zone-device-private-pages.patch
lib-test_hmm-add-zone-device-private-thp-test-infrastructure.patch
mm-memremap-add-driver-callback-support-for-folio-splitting.patch
mm-migrate_device-add-thp-splitting-during-migration.patch
lib-test_hmm-add-large-page-allocation-failure-testing.patch
selftests-mm-hmm-tests-new-tests-for-zone-device-thp-migration.patch
selftests-mm-hmm-tests-new-throughput-tests-including-thp.patch
gpu-drm-nouveau-enable-thp-support-for-gpu-memory-migration.patch
gpu-drm-nouveau-enable-thp-support-for-gpu-memory-migration-fix.patch
mm-huge_memoryc-introduce-folio_split_unmapped.patch
mm-huge_memoryc-introduce-folio_split_unmapped-v2.patch

