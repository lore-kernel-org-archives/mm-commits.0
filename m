Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC6F32143D
	for <mm-commits@vger.kernel.org>; Mon, 11 May 2026 23:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778543272; cv=none; b=fAT79a0pUUWgynFBO1u+csyi9TvQG2z5IuJUifhu0qoMi2FEEwLfrsTCJhTcsEDCNbZ1nuP9aMkTE+Ot7GCb2U9B9WFcbwef0glOItbnf7e1o6D5KBYS0DXJRBCtySMc9Mrv3ELkgZYF4omRpYF35RTZ6X2YIi8FB6Zn4YUpurE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778543272; c=relaxed/simple;
	bh=NVV+tcLGxpHKT1uHaCTuRAgchlUjFhAAvvvWDOkyNEs=;
	h=Date:To:From:Subject:Message-Id; b=oPRCgWA6cme5gMx++NgroE3MpgW88coSPKSia6F57O2PW/iAwSWWkhGnBhtP59LtZWRi26TkAdbyIrF8l/pdvouKFNg5mXNmNZBs9yoSSmbpMPqm4FFUDERCMtaztP7Cx9R6bTNHfZJm58Z9l6zs6qgAWI8gHSFI6D0whm9zey8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VrbZ28dX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VrbZ28dX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CF8C2BCB0;
	Mon, 11 May 2026 23:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778543272;
	bh=NVV+tcLGxpHKT1uHaCTuRAgchlUjFhAAvvvWDOkyNEs=;
	h=Date:To:From:Subject:From;
	b=VrbZ28dX5Z+feEVxR+JgyLOaS/Z/6OL5zhjvmuZhEcN5LjO/G3X8YDY3HBVbyysm9
	 C1dyLjcr9owKRqOH6GSOEp9vFXC5rO1lHJzOWWeNmek1RjU3jucG3koh9jT5lumLsM
	 V7xpCIIZivaTFh3i5JAOUGfdG4HtAlUqwdocmsqw=
Date: Mon, 11 May 2026 16:47:51 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,donettom@linux.ibm.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-factor-out-altmap-freeing-checks.patch added to mm-new branch
Message-Id: <20260511234752.13CF8C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory_hotplug: factor out altmap freeing checks
has been added to the -mm mm-new branch.  Its filename is
     mm-memory_hotplug-factor-out-altmap-freeing-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-factor-out-altmap-freeing-checks.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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

mm-memory_hotplug-fix-memory-block-reference-leak-on-remove.patch
drivers-base-memory-fix-memory-block-reference-leak-in-poison-accounting.patch
mm-sparse-remove-sparse-buffer-pre-allocation-mechanism.patch
mm-sparse-vmemmap-fix-vmemmap-accounting-underflow.patch
mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch
mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths.patch
mm-sparse-vmemmap-fix-dax-vmemmap-accounting-with-optimization.patch
mm-mm_init-fix-pageblock-migratetype-for-zone_device-compound-pages.patch
mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch
mm-memory_hotplug-factor-out-altmap-freeing-checks.patch

