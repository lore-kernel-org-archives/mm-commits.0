Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E643B2D38
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068038; cv=none; b=YopJA5yhsrRZGrcGlBPC2t7T1lV4jgo0O4DNCdso8CmpTBj0IYof1eAZ1B2A8c5kftKFMLCPtC+AnK0rkUvttOx3PzD2+Hat1fXsFXBm66yfG40YtstcRlKaFgSskd9MweEx+hVTG6Lw9VxLAN0+sv4Vc99T1yBAObkBz4CzRFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068038; c=relaxed/simple;
	bh=IhYTXMBlxTMewBrbKeLcb7CzKK2u10hrhXbKD619+Is=;
	h=Date:To:From:Subject:Message-Id; b=kcWZpwximmqTVNXHO5FdmRnyhkz5FPVsimofOdrsG2Tzke0cvZ0c3Ga8yyG771lLt1qJ3yp5NHADormCAF/5PeGx60hRxKLAeh0w7DBwAO6XF6nQs43CtHDjWjosxqBhdCaPy+hd72KRXZff6BL6eb2tUuducuZ2m+zCIx1KFD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xX0ZanaB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xX0ZanaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FB51F00A3D;
	Fri,  7 Aug 2026 02:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068032;
	bh=Eq/IWuqgFzkh5f+F+Lgk0tRkZVYRBE144MIvvNPvwzQ=;
	h=Date:To:From:Subject;
	b=xX0ZanaB4KOZigHJcJOt2tvX03Jmzbsuy2uPWniV6iSy9ITZlmN02MUPmZS1yQAhO
	 HdowJlwAYhxEQC/mxwyznF1u6+7NEivCEt5zPO5TUcrff0mU40X/bgMqW4gs451CxC
	 CJMxSAYTJCKECYjJ/y05n942vraOUdExY+aA2cRo=
Date: Thu, 06 Aug 2026 19:00:32 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rafael@kernel.org,pankaj.gupta@amd.com,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hare@suse.de,gregkh@linuxfoundation.org,djbw@kernel.org,david@kernel.org,dave.jiang@intel.com,dakr@kernel.org,alison.schofield@intel.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-export-mhp_get_default_online_type.patch removed from -mm tree
Message-Id: <20260807020032.88FB51F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: export mhp_get_default_online_type
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-export-mhp_get_default_online_type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: mm/memory_hotplug: export mhp_get_default_online_type
Date: Sun, 12 Jul 2026 11:44:58 -0400

Drivers which may pass hotplug policy down to DAX need MMOP_ symbols and
the mhp_get_default_online_type function for hotplug use cases.

Some drivers (cxl) co-mingle their hotplug and devdax use-cases into the
same driver code, and chose the dax_kmem path as the default driver path -
making it difficult to require hotplug as a predicate to building the
overall driver (it may break other non-hotplug use-cases).

Export mhp_get_default_online_type function to allow these drivers to
build when hotplug is disabled and still use the DAX use case.

In the built-out case we simply return MMOP_OFFLINE as it's
non-destructive.  The internal function can never return -1 either, so we
choose this to allow for defining the function with 'enum mmop'.

Link: https://lore.kernel.org/20260712154505.3564379-5-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <djbw@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Danilo Krummrich <dakr@kernel.org>
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

 include/linux/memory_hotplug.h |    2 ++
 mm/memory_hotplug.c            |    1 +
 2 files changed, 3 insertions(+)

--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-export-mhp_get_default_online_type
+++ a/include/linux/memory_hotplug.h
@@ -317,6 +317,8 @@ extern struct zone *zone_for_pfn_range(e
 extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
 				      struct mhp_params *params);
 void arch_remove_linear_mapping(u64 start, u64 size);
+#else
+static inline enum mmop mhp_get_default_online_type(void) { return MMOP_OFFLINE; }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
--- a/mm/memory_hotplug.c~mm-memory_hotplug-export-mhp_get_default_online_type
+++ a/mm/memory_hotplug.c
@@ -241,6 +241,7 @@ enum mmop mhp_get_default_online_type(vo
 
 	return mhp_default_online_type;
 }
+EXPORT_SYMBOL_GPL(mhp_get_default_online_type);
 
 void mhp_set_default_online_type(enum mmop online_type)
 {
_

Patches currently in -mm which might be from gourry@gourry.net are


