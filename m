Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B0A360EC4
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 01:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783993156; cv=none; b=hzM9p4wCVbBiRcqbFCMZG0aUY9DeJTm/IrfcwhJbuJ1sjkBclCr2FobwExPU2sXQF7aAOb07vrUy7FEHx/SGrTrNYkNbWl43i/Jac6bn6gHNdlTVxVxnjDq1HG+N34YXjKfeSeSgIZ1TS2rrs1MbNm5F/zI4vZpc3K9z3iUETfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783993156; c=relaxed/simple;
	bh=3wFUUMmLGg8HOTzcQHE6JDn/Pq3OwOhDsexBe0Dx3cY=;
	h=Date:To:From:Subject:Message-Id; b=b6DUE1F9L3/YauRbETPSYhLcJRnaDH1eCQfaLu/ye4QkKLPbw8Jf5EaswbpDQure3G/GQJMVXMFWAJkZNPIz5kiVoUGKcVuMe4HXXl5HYRlhgBxdcsTBFoWxLQOOq6kP8sc1gFNSQfsSqICzWf8W2Jh1SeBFuWptlI4uJmcKKEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lU7JYpeq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lU7JYpeq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2351F000E9;
	Tue, 14 Jul 2026 01:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783993155;
	bh=zR02EgOrBbe4wWb/MSds96mQSp8Di9Qwm7HcKwlHcVk=;
	h=Date:To:From:Subject;
	b=lU7JYpeqoIdM836H/QdqOlvSt2mPxRop4EDRlgcIyGKg+xAspfqLv+4yZLauiZt7l
	 pZCTO7HfgNJ18Y5zsHihAwkP/Gh5WkQGlMg/VA/P3FLTUxf0hMoK8LvD9ofFPse4+j
	 S0EmWp+iMlRELXWUeo4ghxDR8FTAVRWilHjTz2OU=
Date: Mon, 13 Jul 2026 18:39:14 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rafael@kernel.org,pankaj.gupta@amd.com,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hare@suse.de,gregkh@linuxfoundation.org,djbw@kernel.org,david@kernel.org,dave.jiang@intel.com,dakr@kernel.org,alison.schofield@intel.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-add-mhp_online_type_to_str-and-export-string-helpers.patch added to mm-new branch
Message-Id: <20260714013915.1D2351F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory_hotplug: add mhp_online_type_to_str() and export string helpers
has been added to the -mm mm-new branch.  Its filename is
     mm-memory_hotplug-add-mhp_online_type_to_str-and-export-string-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-add-mhp_online_type_to_str-and-export-string-helpers.patch

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
Subject: mm/memory_hotplug: add mhp_online_type_to_str() and export string helpers
Date: Sun, 12 Jul 2026 11:44:56 -0400

Add mhp_online_type_to_str() as the inverse of mhp_online_type_from_str(),
and export both so a driver can render and parse the memory online type
through its own sysfs interface.

Link: https://lore.kernel.org/20260712154505.3564379-3-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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
Cc: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |    9 +++++++++
 include/linux/memory_hotplug.h |    1 +
 2 files changed, 10 insertions(+)

--- a/drivers/base/memory.c~mm-memory_hotplug-add-mhp_online_type_to_str-and-export-string-helpers
+++ a/drivers/base/memory.c
@@ -46,6 +46,15 @@ int mhp_online_type_from_str(const char
 	}
 	return -EINVAL;
 }
+EXPORT_SYMBOL_GPL(mhp_online_type_from_str);
+
+const char *mhp_online_type_to_str(int online_type)
+{
+	if (online_type < 0 || online_type >= (int)ARRAY_SIZE(online_type_to_str))
+		return NULL;
+	return online_type_to_str[online_type];
+}
+EXPORT_SYMBOL_GPL(mhp_online_type_to_str);
 
 #define to_memory_block(dev) container_of(dev, struct memory_block, dev)
 
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-add-mhp_online_type_to_str-and-export-string-helpers
+++ a/include/linux/memory_hotplug.h
@@ -127,6 +127,7 @@ extern int arch_add_memory(int nid, u64
 extern u64 max_mem_size;
 
 extern int mhp_online_type_from_str(const char *str);
+const char *mhp_online_type_to_str(int online_type);
 
 /* If movable_node boot option specified */
 extern bool movable_node_enabled;
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

