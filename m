Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B743D3033CB
	for <mm-commits@vger.kernel.org>; Sat,  5 Sep 2026 01:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788573465; cv=none; b=OrmYFrOjS+CEXZg/mmr3EsvlAZozEL0HcqVLwA+6tpxFdPTpHnUfNNBuyRq/eJRRcowkOsqNY+/3dlxmlk7aMa2whzBkA4xP19ScS7yqrm7bSxMqEbBISa4cg62hZlspLlfre1a94JuDR3K1NKioDgor7I9ZlYY+MarJRrb0ICk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788573465; c=relaxed/simple;
	bh=gKxyQiIdFZDPHdeNqF4JaHdiZh6HPfkebubfkQw3gmU=;
	h=Date:To:From:Subject:Message-Id; b=ExO5TZ5rIAKAGI1mAMKUt12EgCgx12ZTCLdfbn+ZRCM8/cOqdgORitPnw443fntRJePvdoJNCahSAVTkRwVNxptlStJIEZ1KlABjhMKOmbS5U2Zy7dA0rxR6qrlVwkN4BS8ym5OhBffFAshFSjA401bcHD5qKKHSFabvE6G8is0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hA/w5UHT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hA/w5UHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51AC61F00A3D;
	Sat,  5 Sep 2026 01:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788573463;
	bh=hMGFDZQI1mZwF021AcpZhOtrjht/tEyiS92B8PKeAFs=;
	h=Date:To:From:Subject;
	b=hA/w5UHTwswJHmxtKaEck1sQn2V2wfnlK0UBIeoynTnNcvNPjbg405OcfORjLwJ1W
	 ksfA6+Hyb3JUeZBNRChwPWq6meJYKAt3Z3//10fjNjOSGHLstYk/ZcCs5Zxyq4SXKK
	 ZwDvw8GnBrDpKX9PIBKSRXUZr7LcDT86DsR/CpWo=
Date: Fri, 04 Sep 2026 18:57:42 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,lkp@intel.com,gourry@gourry.net,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-factor-out-node_is_memoryless-fix.patch added to mm-new branch
Message-Id: <20260905015743.51AC61F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memory_hotplug-factor-out-node_is_memoryless-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-memory_hotplug-factor-out-node_is_memoryless-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-factor-out-node_is_memoryless-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory_hotplug-factor-out-node_is_memoryless-fix
Date: Fri Sep  4 06:54:43 PM PDT 2026

move node_is_memoryless() inside CONFIG_MEMORY_HOTREMOVE

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609050628.ywCLhOj5-lkp@intel.com/
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   61 +++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 30 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-factor-out-node_is_memoryless-fix
+++ a/mm/memory_hotplug.c
@@ -1491,36 +1491,6 @@ out:
 	return ret;
 }
 
-static int check_no_memblock_for_node_cb(struct memory_block *mem, void *arg)
-{
-	int nid = *(int *)arg;
-
-	/*
-	 * If a memory block belongs to multiple nodes, the stored nid is not
-	 * reliable. However, such blocks are always online (e.g., cannot get
-	 * offlined) and, therefore, are still spanned by the node.
-	 */
-	return mem->nid == nid ? -EEXIST : 0;
-}
-
-/* Caller must hold the memory hotplug lock for this check. */
-static bool node_is_memoryless(int nid)
-{
-	/*
-	 * A node still spanning pages (especially ZONE_DEVICE) is not
-	 * memoryless.  A node spans memory after move_pfn_range_to_zone(),
-	 * e.g. once a memory block has been onlined.
-	 */
-	if (node_spanned_pages(nid))
-		return false;
-	/*
-	 * Offline memory blocks may not be spanned by the node yet, but they
-	 * link to it in sysfs and can be onlined later, so the node is not
-	 * memoryless while any remain.
-	 */
-	return !for_each_memory_block(&nid, check_no_memblock_for_node_cb);
-}
-
 /*
  * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
  * and online/offline operations (triggered e.g. by sysfs).
@@ -1815,6 +1785,37 @@ bool mhp_range_allowed(u64 start, u64 si
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
+
+static int check_no_memblock_for_node_cb(struct memory_block *mem, void *arg)
+{
+	int nid = *(int *)arg;
+
+	/*
+	 * If a memory block belongs to multiple nodes, the stored nid is not
+	 * reliable. However, such blocks are always online (e.g., cannot get
+	 * offlined) and, therefore, are still spanned by the node.
+	 */
+	return mem->nid == nid ? -EEXIST : 0;
+}
+
+/* Caller must hold the memory hotplug lock for this check. */
+static bool node_is_memoryless(int nid)
+{
+	/*
+	 * A node still spanning pages (especially ZONE_DEVICE) is not
+	 * memoryless.  A node spans memory after move_pfn_range_to_zone(),
+	 * e.g. once a memory block has been onlined.
+	 */
+	if (node_spanned_pages(nid))
+		return false;
+	/*
+	 * Offline memory blocks may not be spanned by the node yet, but they
+	 * link to it in sysfs and can be onlined later, so the node is not
+	 * memoryless while any remain.
+	 */
+	return !for_each_memory_block(&nid, check_no_memblock_for_node_cb);
+}
+
 /*
  * Scan pfn range [start,end) to find movable/migratable pages (LRU and
  * hugetlb folio, movable_ops pages). Will skip over most unmovable
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-old-lib-alloc_tagc.patch
mm-memory_hotplug-factor-out-node_is_memoryless-fix.patch
mm-hugetlb-dont-lock-private-resv_map-during-final-unmap.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

