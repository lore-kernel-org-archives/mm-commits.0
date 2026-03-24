Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348873644BE
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388565; cv=none; b=ahbl1CsOmCPgYi4NfYzYYwf6Dxaw7Y1Nou755ZbNTEa6xkjPKKZryrW2KlrD2QKMmWAlr0fut2qn0bhL35973zui3xZKmMeMyX+6VDRdr9Ss66KlxmBKhGzs9+KuiHTGcG2943a44rZjmSvhOqWMF090+zHSWUpv8AUqaXiUmHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388565; c=relaxed/simple;
	bh=thWwKpQL0ZGztaFm+NnvtieMMP5PB9rvzRwgTXw0DJk=;
	h=Date:To:From:Subject:Message-Id; b=n706xz07Q7PqfwSInn2Z5/F+gnoRRhxtsS4KZ/hHNaSPmiUbekEdxV0/zxUUv/REsbVg8ZQEx270kJxFOl4WEd+GPXXxmKAOAH0KbMk7mlQLBjhBiZ4OAPbOLgAMWkIhmfMFReS5hHHVdSbY4hcFEzD4yP2WKmjmUi7MApMf2QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jgtwVpF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jgtwVpF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9CAC2BC9E;
	Tue, 24 Mar 2026 21:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388565;
	bh=thWwKpQL0ZGztaFm+NnvtieMMP5PB9rvzRwgTXw0DJk=;
	h=Date:To:From:Subject:From;
	b=jgtwVpF40FpLqVvA/8qUWZ75iPgTv/SVm+s+N4fbaTq2lGcJelwJvadcle5W63Lor
	 yUwqQhal6F2+MomQ+LvHpkj8gsIQCDlEEfjgkTmMCRz+aQCqmjjTbA13p2ycEDwXfS
	 ud2SL1g/03LGMFWAWcOPGDNB81/3rWMRG4+f9Gns=
Date: Tue, 24 Mar 2026 14:42:44 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jonathan.cameron@huawei.com,gregkh@linuxfoundation.org,david@kernel.org,dave@stgolabs.net,dave.jiang@intel.com,dakr@kernel.org,benjamin.cheatham@amd.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-name-the-anonymous-mmop-enum-as-enum-mmop.patch removed from -mm tree
Message-Id: <20260324214245.0D9CAC2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: name the anonymous MMOP enum as enum mmop
has been removed from the -mm tree.  Its filename was
     mm-name-the-anonymous-mmop-enum-as-enum-mmop.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: mm: name the anonymous MMOP enum as enum mmop
Date: Wed, 11 Feb 2026 16:54:47 -0500

Give the MMOP enum (MMOP_OFFLINE, MMOP_ONLINE, etc) a proper type name so
the compiler can help catch invalid values being assigned to variables of
this type.

Leave the existing functions returning int alone to allow for
value-or-error pattern to remain unchanged without churn.

mmop_default_online_type is left as int because it uses the -1 sentinal
value to signal it hasn't been initialized yet.

Keep the uint8_t buffer in offline_and_remove_memory() as-is for space
efficiency, with an explicit cast when we consume the value.

Move the enum definition before the CONFIG_MEMORY_HOTPLUG guard so it is
unconditionally available for struct memory_block in memory.h.

No functional change.

Link: https://lore.kernel.org/linux-mm/3424eba7-523b-4351-abd0-3a888a3e5e61@kernel.org/
Link: https://lkml.kernel.org/r/20260211215447.2194189-1-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Suggested-by: "David Hildenbrand (arm)" <david@kernel.org>
Reviewed-by: Ben Cheatham <benjamin.cheatham@amd.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |    2 +-
 include/linux/memory.h         |    3 ++-
 include/linux/memory_hotplug.h |   16 ++++++++--------
 mm/memory_hotplug.c            |   10 +++++-----
 4 files changed, 16 insertions(+), 15 deletions(-)

--- a/drivers/base/memory.c~mm-name-the-anonymous-mmop-enum-as-enum-mmop
+++ a/drivers/base/memory.c
@@ -452,7 +452,7 @@ static ssize_t phys_device_show(struct d
 static int print_allowed_zone(char *buf, int len, int nid,
 			      struct memory_group *group,
 			      unsigned long start_pfn, unsigned long nr_pages,
-			      int online_type, struct zone *default_zone)
+			      enum mmop online_type, struct zone *default_zone)
 {
 	struct zone *zone;
 
--- a/include/linux/memory.h~mm-name-the-anonymous-mmop-enum-as-enum-mmop
+++ a/include/linux/memory.h
@@ -19,6 +19,7 @@
 #include <linux/node.h>
 #include <linux/compiler.h>
 #include <linux/mutex.h>
+#include <linux/memory_hotplug.h>
 
 #define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
 
@@ -77,7 +78,7 @@ enum memory_block_state {
 struct memory_block {
 	unsigned long start_section_nr;
 	enum memory_block_state state;	/* serialized by the dev->lock */
-	int online_type;		/* for passing data to online routine */
+	enum mmop online_type;	/* for passing data to online routine */
 	int nid;			/* NID for this memory block */
 	/*
 	 * The single zone of this memory block if all PFNs of this memory block
--- a/include/linux/memory_hotplug.h~mm-name-the-anonymous-mmop-enum-as-enum-mmop
+++ a/include/linux/memory_hotplug.h
@@ -16,11 +16,8 @@ struct resource;
 struct vmem_altmap;
 struct dev_pagemap;
 
-#ifdef CONFIG_MEMORY_HOTPLUG
-struct page *pfn_to_online_page(unsigned long pfn);
-
 /* Types for control the zone type of onlined and offlined memory */
-enum {
+enum mmop {
 	/* Offline the memory. */
 	MMOP_OFFLINE = 0,
 	/* Online the memory. Zone depends, see default_zone_for_pfn(). */
@@ -31,6 +28,9 @@ enum {
 	MMOP_ONLINE_MOVABLE,
 };
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+struct page *pfn_to_online_page(unsigned long pfn);
+
 /* Flags for add_memory() and friends to specify memory hotplug details. */
 typedef int __bitwise mhp_t;
 
@@ -286,8 +286,8 @@ static inline void __remove_memory(u64 s
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 /* Default online_type (MMOP_*) when new memory blocks are added. */
-extern int mhp_get_default_online_type(void);
-extern void mhp_set_default_online_type(int online_type);
+extern enum mmop mhp_get_default_online_type(void);
+extern void mhp_set_default_online_type(enum mmop online_type);
 extern void __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
 extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
@@ -310,8 +310,8 @@ extern void sparse_remove_section(unsign
 				  struct vmem_altmap *altmap);
 extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
 					  unsigned long pnum);
-extern struct zone *zone_for_pfn_range(int online_type, int nid,
-		struct memory_group *group, unsigned long start_pfn,
+extern struct zone *zone_for_pfn_range(enum mmop online_type,
+		int nid, struct memory_group *group, unsigned long start_pfn,
 		unsigned long nr_pages);
 extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
 				      struct mhp_params *params);
--- a/mm/memory_hotplug.c~mm-name-the-anonymous-mmop-enum-as-enum-mmop
+++ a/mm/memory_hotplug.c
@@ -221,7 +221,7 @@ void put_online_mems(void)
 bool movable_node_enabled = false;
 
 static int mhp_default_online_type = -1;
-int mhp_get_default_online_type(void)
+enum mmop mhp_get_default_online_type(void)
 {
 	if (mhp_default_online_type >= 0)
 		return mhp_default_online_type;
@@ -240,7 +240,7 @@ int mhp_get_default_online_type(void)
 	return mhp_default_online_type;
 }
 
-void mhp_set_default_online_type(int online_type)
+void mhp_set_default_online_type(enum mmop online_type)
 {
 	mhp_default_online_type = online_type;
 }
@@ -1046,7 +1046,7 @@ static inline struct zone *default_zone_
 	return movable_node_enabled ? movable_zone : kernel_zone;
 }
 
-struct zone *zone_for_pfn_range(int online_type, int nid,
+struct zone *zone_for_pfn_range(enum mmop online_type, int nid,
 		struct memory_group *group, unsigned long start_pfn,
 		unsigned long nr_pages)
 {
@@ -2305,7 +2305,7 @@ EXPORT_SYMBOL_GPL(remove_memory);
 
 static int try_offline_memory_block(struct memory_block *mem, void *arg)
 {
-	uint8_t online_type = MMOP_ONLINE_KERNEL;
+	enum mmop online_type = MMOP_ONLINE_KERNEL;
 	uint8_t **online_types = arg;
 	struct page *page;
 	int rc;
@@ -2338,7 +2338,7 @@ static int try_reonline_memory_block(str
 	int rc;
 
 	if (**online_types != MMOP_OFFLINE) {
-		mem->online_type = **online_types;
+		mem->online_type = (enum mmop)**online_types;
 		rc = device_online(&mem->dev);
 		if (rc < 0)
 			pr_warn("%s: Failed to re-online memory: %d",
_

Patches currently in -mm which might be from gourry@gourry.net are


