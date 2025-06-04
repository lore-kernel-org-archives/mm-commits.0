Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B71220D4F2
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 21:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749072166; cv=none; b=bf3uBkFrXjVhtWmlrG8KK8rTZIJBhrMFdXnvfipvAZvuIpZADBvthPjQBa8jcVcGLJkhqbjyDAsQK4dEnit9T+5hYe0AdMWifs0eHE7fOLGM7l8f/DVFWguBgtHi55F34B9K9o0Io4/Qea/EHYmvyN2KLHEfis2dnXEy95dgoSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749072166; c=relaxed/simple;
	bh=5ipqfDKFFlS/R+JDCa8srtFOvLBs5YfeUvNwNdoXjpM=;
	h=Date:To:From:Subject:Message-Id; b=jy9wvc6vAUApT0L577uShbAfnu75aHqdSb72kSR5Xs7HJZnUBSK8ygISqUy+Dw9pfeeiXj00P6SSYegvPwNWhlyca6Da5NIV5I+PMT2zvnzb4yAhrypvkme82D2WYndecFQrgMo/qC8398WD4LfWzrv9u4c7c7ZXgCjusqkeFKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2TGgZYHK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2TGgZYHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C87DC4CEE4;
	Wed,  4 Jun 2025 21:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749072164;
	bh=5ipqfDKFFlS/R+JDCa8srtFOvLBs5YfeUvNwNdoXjpM=;
	h=Date:To:From:Subject:From;
	b=2TGgZYHKRRYl25vIPyJCu0U+4rbaeBPnjPkXNHmntNwjqTk3VV4IXy1oUrdUkRk3k
	 zK6v6qAjcdgOSoNuOxHE3f5nbI2arkA1GFnqc6gn38+RsMz8ipa902GcYPoEsohnnp
	 VPDKE9DuL8WeFx8VxV9QZuUNJj62D1CeIsFh47eo=
Date: Wed, 04 Jun 2025 14:22:43 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rdunlap@infradead.org,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,koct9i@gmail.com,hannes@cmpxchg.org,david@redhat.com,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-fix-build-with-memcg=y-and-vm_event_counters=n.patch added to mm-new branch
Message-Id: <20250604212244.7C87DC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmstat: fix build with MEMCG=y and VM_EVENT_COUNTERS=n
has been added to the -mm mm-new branch.  Its filename is
     mm-vmstat-fix-build-with-memcg=y-and-vm_event_counters=n.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-fix-build-with-memcg=y-and-vm_event_counters=n.patch

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
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm/vmstat: fix build with MEMCG=y and VM_EVENT_COUNTERS=n
Date: Wed, 4 Jun 2025 12:51:11 +0300

When compiling with MEMCG enabled but VM_EVENT_COUNTERS disabled,
BUILD_BUG_ON() is triggered in vmstat_start because the vmstat_text array
is larger than NR_VMSTAT_ITEMS.

This issue arises because some elements of the vmstat_text array are
present when either MEMCG or VM_EVENT_COUNTERS is enabled, but
NR_VMSTAT_ITEMS only accounts for these elements if VM_EVENT_COUNTERS is
enabled.

And upcoming change in the BUILD_BUG_ON() check made it more strict,
disallowing extra elements in the array, which revealed the issue.

Instead of adjusting the NR_VMSTAT_ITEMS definition to account for MEMCG,
make MEMCG select VM_EVENT_COUNTERS.  VM_EVENT_COUNTERS is enabled in most
configurations anyway.

There is no need to backport this fix to stable trees.  Without the strict
BUILD_BUG_ON(), the issue is not harmful.  The elements in question would
only be read by the memcg code, not by /proc/vmstat.

Link: https://lkml.kernel.org/r/20250604095111.533783-1-kirill.shutemov@linux.intel.com
Fixes: ebc5d83d0443 ("mm/memcontrol: use vmstat names for printing statistics")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    4 ++--
 init/Kconfig           |    1 +
 mm/vmstat.c            |    4 ++--
 3 files changed, 5 insertions(+), 4 deletions(-)

--- a/include/linux/vmstat.h~mm-vmstat-fix-build-with-memcg=y-and-vm_event_counters=n
+++ a/include/linux/vmstat.h
@@ -507,7 +507,7 @@ static inline const char *lru_list_name(
 	return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
 }
 
-#if defined(CONFIG_VM_EVENT_COUNTERS) || defined(CONFIG_MEMCG)
+#if defined(CONFIG_VM_EVENT_COUNTERS)
 static inline const char *vm_event_name(enum vm_event_item item)
 {
 	return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
@@ -516,7 +516,7 @@ static inline const char *vm_event_name(
 			   NR_VM_STAT_ITEMS +
 			   item];
 }
-#endif /* CONFIG_VM_EVENT_COUNTERS || CONFIG_MEMCG */
+#endif /* CONFIG_VM_EVENT_COUNTERS */
 
 #ifdef CONFIG_MEMCG
 
--- a/init/Kconfig~mm-vmstat-fix-build-with-memcg=y-and-vm_event_counters=n
+++ a/init/Kconfig
@@ -989,6 +989,7 @@ config MEMCG
 	select PAGE_COUNTER
 	select EVENTFD
 	select SLAB_OBJ_EXT
+	select VM_EVENT_COUNTERS
 	help
 	  Provides control over the memory footprint of tasks in a cgroup.
 
--- a/mm/vmstat.c~mm-vmstat-fix-build-with-memcg=y-and-vm_event_counters=n
+++ a/mm/vmstat.c
@@ -1287,7 +1287,7 @@ const char * const vmstat_text[] = {
 	"nr_memmap_pages",
 	"nr_memmap_boot_pages",
 
-#if defined(CONFIG_VM_EVENT_COUNTERS) || defined(CONFIG_MEMCG)
+#if defined(CONFIG_VM_EVENT_COUNTERS)
 	/* enum vm_event_item counters */
 	"pgpgin",
 	"pgpgout",
@@ -1477,7 +1477,7 @@ const char * const vmstat_text[] = {
 	"kstack_rest",
 #endif
 #endif
-#endif /* CONFIG_VM_EVENT_COUNTERS || CONFIG_MEMCG */
+#endif /* CONFIG_VM_EVENT_COUNTERS */
 };
 #endif /* CONFIG_PROC_FS || CONFIG_SYSFS || CONFIG_NUMA || CONFIG_MEMCG */
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-fix-vmstat-after-removing-nr_bounce.patch
mm-vmstat-fix-build-with-memcg=y-and-vm_event_counters=n.patch
mm-strictly-check-vmstat_text-array-size.patch
mm-vmstat-utilize-designated-initializers-for-the-vmstat_text-array.patch

