Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A1813A3F7
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 01:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783993159; cv=none; b=S/1MTG4zYlEXADv9KUKKRMEBl8NPeD/IXH9jrs9z5pA/7u2WBFBuULXayGxvlaizmNWBq/c46bhOAvGA6YkQdkO21sDICRLPbLtY89448Easf/KemDfReAzfVV2JPwik56Q3G6ENnhuYqkyz5IzQ7P2I5Tm6FV3iUt0fQjChnvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783993159; c=relaxed/simple;
	bh=QhCupRuIQkLj+CUD2HnuysaKi+zHmL8c0YIanVRjgJg=;
	h=Date:To:From:Subject:Message-Id; b=MX4RzAGf/fJG0inUMcBnrkZ3GWqJx/d87+XcMMU+ww2xQf9wCma7sd71l16KWFrhujXivHRuxQwCdzVarMqWPnmdQuUcCyfN8dDYMSqz/M2Thsu8BkVd7cfrF0fQgZ+dV5ixe10aCenS9+Joopmw0vOf+Y8mcl+7mrDlQ52GMRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UxLbVBFr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UxLbVBFr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59601F000E9;
	Tue, 14 Jul 2026 01:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783993157;
	bh=ytfsSZR0M8Ab8x+prZBhSsdoxZ8/uvVtZrEnn5Tltmw=;
	h=Date:To:From:Subject;
	b=UxLbVBFri9zzu5vvB+ug6Mj00EoseK6IdGE0D/sC2fNRhGXMwkTqCD8Iij+KIepDR
	 KJnToYtmJPyTrF9LNteub0r63yg5/Qft5zNbKY337bbXj1mn+CpjHXwg/tu3SMKMxk
	 +C6FUMmF2m6lNfhegWUd73+4jkEKRkcR9uN/dC7k=
Date: Mon, 13 Jul 2026 18:39:17 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rafael@kernel.org,pankaj.gupta@amd.com,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hare@suse.de,gregkh@linuxfoundation.org,djbw@kernel.org,david@kernel.org,dave.jiang@intel.com,dakr@kernel.org,alison.schofield@intel.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-pass-online_type-to-online_memory_block-via-arg.patch added to mm-new branch
Message-Id: <20260714013917.B59601F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory_hotplug: pass online_type to online_memory_block() via arg
has been added to the -mm mm-new branch.  Its filename is
     mm-memory_hotplug-pass-online_type-to-online_memory_block-via-arg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-pass-online_type-to-online_memory_block-via-arg.patch

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
Subject: mm/memory_hotplug: pass online_type to online_memory_block() via arg
Date: Sun, 12 Jul 2026 11:44:57 -0400

Modify online_memory_block() to accept the online type through its arg
parameter rather than calling mhp_get_default_online_type() internally.

This prepares for allowing callers to specify explicit online types.

Update the caller in add_memory_resource() to pass the default online
type via a local variable.

No functional change.

Link: https://lore.kernel.org/20260712154505.3564379-4-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <djbw@kernel.org>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-pass-online_type-to-online_memory_block-via-arg
+++ a/mm/memory_hotplug.c
@@ -1340,7 +1340,9 @@ static int check_hotplug_memory_range(u6
 
 static int online_memory_block(struct memory_block *mem, void *arg)
 {
-	mem->online_type = mhp_get_default_online_type();
+	enum mmop *online_type = arg;
+
+	mem->online_type = *online_type;
 	return device_online(&mem->dev);
 }
 
@@ -1497,6 +1499,7 @@ out:
 int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
+	enum mmop online_type = mhp_get_default_online_type();
 	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
 	struct memory_group *group = NULL;
 	u64 start, size;
@@ -1585,7 +1588,8 @@ int add_memory_resource(int nid, struct
 
 	/* online pages if requested */
 	if (mhp_get_default_online_type() != MMOP_OFFLINE)
-		walk_memory_blocks(start, size, NULL, online_memory_block);
+		walk_memory_blocks(start, size, &online_type,
+				   online_memory_block);
 
 	return ret;
 error:
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-vmstat-fold-stranded-per-cpu-node-stats-when-a-node-comes-online.patch
mm-constify-oom_control-scan_control-and-alloc_context-nodemask.patch
mm-mm_init-handle-alloc_percpu-failure-in-free_area_init_core_hotplug.patch
mm-memory-add-memory_block_aligned_range-helper.patch
mm-memory_hotplug-add-mhp_online_type_to_str-and-export-string-helpers.patch
mm-memory_hotplug-pass-online_type-to-online_memory_block-via-arg.patch
mm-memory_hotplug-export-mhp_get_default_online_type.patch
mm-memory_hotplug-add-__add_memory_driver_managed-with-online_type-arg.patch
mm-memory_hotplug-add-offline_and_remove_memory_ranges.patch
dax-kmem-resolve-default-online-type-at-probe-time.patch
dax-kmem-extract-hotplug-hotremove-helper-functions.patch
dax-kmem-add-sysfs-interface-for-atomic-whole-device-hotplug.patch
selftests-dax-add-dax-kmem-hotplug-sysfs-regression-test.patch

