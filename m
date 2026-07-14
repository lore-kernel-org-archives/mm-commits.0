Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C251360EC4
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 01:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783993174; cv=none; b=q28VV9TCP1+akNfyk1itqoMMngrlRjui+B0BI0Iol8ngw2H8PYbjwu+0/rNLxo2uzn64B6X20aLTC6KyiPDR++C3eplT2mawDw8NJH2sj6v654frXzw8N3BvlIT6Y/fAHbFwiX+FzCiofhV3SLuuB836NLrjb8pVtr7Cm28Vy1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783993174; c=relaxed/simple;
	bh=nn1v4quED/0f7FXOHAckSiK/9sZkbEka2XNWRoUYh9s=;
	h=Date:To:From:Subject:Message-Id; b=A5EkeICWXwHSEFC2+VieyVqtQdMx/uZfoUF37w2d1TKXMGHeEXd43WV0Vsqjmg2Uyy8NS0ULx+ZyP9BjtblkwIReMj79EirxT6vZapbYmuV86Gq49+oiH+HLA+MQ0woMqFEPxNTaFj2WOo8TAazqsYmzKaijRer/+F2pF7CWEMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zKp+JvdF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zKp+JvdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FF81F000E9;
	Tue, 14 Jul 2026 01:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783993167;
	bh=+jk/5be2Vzl+OkknQ9LZHDZ0gzkg0gkz3ki4WgwOuYI=;
	h=Date:To:From:Subject;
	b=zKp+JvdFKOOxUuF7I2vIfUcy9yIMPlZn06vLmDlLQItZTdOXr3M9fE4MAYbPSJ/o7
	 P+Zq9zwwwbXcqH8g1jgnvGHtr4oyG25ZTvrebaWDA6+7Dl5icK97729x9Zkda6qEJ8
	 F/KPcwKPcMdFFVjN6o3drzI8QeCvziJh5TobiT7c=
Date: Mon, 13 Jul 2026 18:39:27 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rafael@kernel.org,pankaj.gupta@amd.com,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hare@suse.de,gregkh@linuxfoundation.org,djbw@kernel.org,david@kernel.org,dave.jiang@intel.com,dakr@kernel.org,alison.schofield@intel.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dax-kmem-resolve-default-online-type-at-probe-time.patch added to mm-new branch
Message-Id: <20260714013927.D8FF81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dax/kmem: resolve default online type at probe time
has been added to the -mm mm-new branch.  Its filename is
     dax-kmem-resolve-default-online-type-at-probe-time.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dax-kmem-resolve-default-online-type-at-probe-time.patch

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
Subject: dax/kmem: resolve default online type at probe time
Date: Sun, 12 Jul 2026 11:45:01 -0400

Resolve the default online type in kmem at probe time explicitly instead
of implicitly inheriting the system default by calling
add_memory_driver_managed().

No behavioral change at this point (still system default).

Link: https://lore.kernel.org/20260712154505.3564379-8-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dan Williams <djbw@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/kmem.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/dax/kmem.c~dax-kmem-resolve-default-online-type-at-probe-time
+++ a/drivers/dax/kmem.c
@@ -73,6 +73,7 @@ static int dev_dax_kmem_probe(struct dev
 	mhp_t mhp_flags;
 	int numa_node;
 	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
+	int online_type = mhp_get_default_online_type();
 
 	/*
 	 * Ensure good NUMA information for the persistent memory.
@@ -172,8 +173,9 @@ static int dev_dax_kmem_probe(struct dev
 		 * Ensure that future kexec'd kernels will not treat
 		 * this as RAM automatically.
 		 */
-		rc = add_memory_driver_managed(data->mgid, range.start,
-				range_len(&range), kmem_name, mhp_flags);
+		rc = __add_memory_driver_managed(data->mgid, range.start,
+				range_len(&range), kmem_name, mhp_flags,
+				online_type);
 
 		if (rc) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
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

