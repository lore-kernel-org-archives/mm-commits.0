Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354973DD500
	for <mm-commits@vger.kernel.org>; Thu,  3 Sep 2026 20:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788468463; cv=none; b=h00QhEXtkj/66q/H1Adnmrowe66iFLQuIh1iFVSC2vYX6J0BMedd5Zfx7k59kNLXcQf6hfOK1m60eNj506Akg0HpR2NnwiNda/lm4W46zeJA64WclEPxnssI54/9iJ9z1pLrZJyhzPcmW3p4FoVLdfBG3sr7Zd+qC3q2e1tpfQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788468463; c=relaxed/simple;
	bh=f44ZqkwPKBH5Pq59HUtCQWzqxMrNZFNN6zcuDrA61Cw=;
	h=Date:To:From:Subject:Message-Id; b=tWv+2uP5hr/QFU8Q/niAAts73Cs4BESG0bHOSMvrfO0Y4Pdnrnui0oVFS1/8fYDKiqg+SgECbZjxPGOERMp4hFZsaGy8sqHY6/3ckVeBEqNnlI3xqUvVHhi8OdD3VuT2gUp75cr/f7VoTjhVdQqRVGMtS6ODnVK15cpSTtxTKGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=shin9OW/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="shin9OW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7FB1F000E9;
	Thu,  3 Sep 2026 20:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788468452;
	bh=IJmXObvNz9E7N4AhgVR6Sk6lLAkHkYISSppmMpvNSh4=;
	h=Date:To:From:Subject;
	b=shin9OW/nZg2viJRi9HS2JXiJPJCJeV6j1Dgn8aILsTA9W8Vbgr7B8ZgMeQ+RJf9D
	 6f8oRyWWM3yan1Y5D8fV/uZ5vPCu8FbNkjU3nF+ehZrH5RTMZGC4GQyoCxua+cyjMz
	 4t2x/D7ZHmXE7srgKctSHgJDddQpKa9dIRKqScms=
Date: Thu, 03 Sep 2026 13:47:31 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,david@kernel.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-factor-out-node_is_memoryless.patch added to mm-new branch
Message-Id: <20260903204732.5F7FB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory_hotplug: factor out node_is_memoryless()
has been added to the -mm mm-new branch.  Its filename is
     mm-memory_hotplug-factor-out-node_is_memoryless.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-factor-out-node_is_memoryless.patch

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
From: Gregory Price <gourry@gourry.net>
Subject: mm/memory_hotplug: factor out node_is_memoryless()
Date: Wed, 2 Sep 2026 15:55:07 -0400

A memoryless node neither spans present pages (populated or ZONE_DEVICE)
nor has an offline-but-added memory block still linked to it in sysfs.

try_offline_node() presently open-codes this memoryless check.

Pull that into a node_is_memoryless() helper and pull the existing
check_no_memblock_for_node_cb() helper ahead of the add/online path so
it's clearer what is happening here.

No functional change.

Link: https://lore.kernel.org/20260902195507.88655-1-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   60 +++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 29 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-factor-out-node_is_memoryless
+++ a/mm/memory_hotplug.c
@@ -1491,6 +1491,36 @@ out:
 	return ret;
 }
 
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
  * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
  * and online/offline operations (triggered e.g. by sysfs).
@@ -2214,18 +2244,6 @@ static int check_cpu_on_node(int nid)
 	return 0;
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
 /**
  * try_offline_node
  * @nid: the node ID
@@ -2237,23 +2255,7 @@ static int check_no_memblock_for_node_cb
  */
 void try_offline_node(int nid)
 {
-	int rc;
-
-	/*
-	 * If the node still spans pages (especially ZONE_DEVICE), don't
-	 * offline it. A node spans memory after move_pfn_range_to_zone(),
-	 * e.g., after the memory block was onlined.
-	 */
-	if (node_spanned_pages(nid))
-		return;
-
-	/*
-	 * Especially offline memory blocks might not be spanned by the
-	 * node. They will get spanned by the node once they get onlined.
-	 * However, they link to the node in sysfs and can get onlined later.
-	 */
-	rc = for_each_memory_block(&nid, check_no_memblock_for_node_cb);
-	if (rc)
+	if (!node_is_memoryless(nid))
 		return;
 
 	if (check_cpu_on_node(nid))
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-mempolicy-take-a-cpuset-cookie-for-the-interleave-node-count.patch
mm-mempolicy-use-srcu-for-the-weighted-interleave-state.patch
mm-mempolicy-stop-copying-the-nodemask-in-the-interleave-paths.patch
mm-huge_memory-skip-zone-device-folios-in-madvise_free_huge_pmd.patch
mm-madvise-skip-zone-device-folios-in-cold-pageout-pmd-range.patch
mm-mempolicy-skip-zone-device-folios-when-queueing-folios.patch
mm-memory_hotplug-factor-out-node_is_memoryless.patch

