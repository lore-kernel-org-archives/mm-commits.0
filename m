Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2FB2110E
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976882; cv=none; b=W2/9+e4odP+oKHnblVv6uzSC6EIYEh2Cw3mOSSaR4G5gkzz8rpPJAGtfB2JKtR/eujaULPK6e4QbZwrdgAM2/Gp0W946EeuT2j5xF15qHqbQFrfDDt8lzQrbE85DMPRSbQ/2teI7UYcPLSezQ531i+d8whe675vBVhsPRxrZcPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976882; c=relaxed/simple;
	bh=MR/LhlHgXTBqw2fKophPsWZ/3sEyP1CYsHeCMKHUWkQ=;
	h=Date:To:From:Subject:Message-Id; b=kpCTdYJKUqsHw/WM/9/jrad1X18WlwxTXcgkCBYCc6q3UgYNH817H3AwAG97hLnslFD6+BhZ5OZm0uLOcDcB3uWLSgLlgXVJkGekFfU88pka9/VywVyw1Attg3jY9JX2fdTl9Rjd9th0e/O/dbWr8dJjtIf5/8ydsawneHHSstQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n+W1/6Vx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n+W1/6Vx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1ECCC4CEE3;
	Sun, 20 Jul 2025 02:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976882;
	bh=MR/LhlHgXTBqw2fKophPsWZ/3sEyP1CYsHeCMKHUWkQ=;
	h=Date:To:From:Subject:From;
	b=n+W1/6Vx/1gzyZIxciQuIbN5IhXaoC97w69rtYATTO4nwPwFbjLz9Mcm6a1S98S3g
	 etYHDH4WPHHp0N7MNOf4PUwfpFtmNiufZ7hQVVF8arlPajtWMmFz4rM9Sc9bkhFb7j
	 WGYdMEt4NZCMg1+NWF4EHhMqCwuuRm5XIOX9Gjqk=
Date: Sat, 19 Jul 2025 19:01:22 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rdunlap@infradead.org,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,koct9i@gmail.com,hannes@cmpxchg.org,david@redhat.com,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmstat-fix-build-with-memcg=y-and-vm_event_counters=n.patch removed from -mm tree
Message-Id: <20250720020122.A1ECCC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmstat: make MEMCG select VM_EVENT_COUNTERS
has been removed from the -mm tree.  Its filename was
     mm-vmstat-fix-build-with-memcg=y-and-vm_event_counters=n.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm/vmstat: make MEMCG select VM_EVENT_COUNTERS
Date: Wed, 4 Jun 2025 12:51:11 +0300

The vmstat_text array contains labels for counters displayed in
/proc/vmstat.  It is important to keep the labels in sync with the
counters.

There is a BUILD_BUG_ON() check in vmstat_start() that ensures the size of
the vmstat_text is not smaller than VM_EVENT_COUNTERS.  This helps to
catch cases where a new counter is added but the label is not.  However,
it does not help if a counter is removed but the label remains.

It would be nice to make the BUILD_BUG_ON() check more strict to catch
such cases.  However, when compiling with MEMCG enabled but
VM_EVENT_COUNTERS disabled, the vmstat_text array is larger than
NR_VMSTAT_ITEMS.

This issue arises because some elements of the vmstat_text array are
present when either MEMCG or VM_EVENT_COUNTERS is enabled, but
NR_VMSTAT_ITEMS only accounts for these elements if VM_EVENT_COUNTERS is
enabled.

Instead of adjusting the NR_VMSTAT_ITEMS definition to account for MEMCG,
make MEMCG select VM_EVENT_COUNTERS.  VM_EVENT_COUNTERS is enabled in most
configurations anyway.

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
@@ -992,6 +992,7 @@ config MEMCG
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
@@ -1475,7 +1475,7 @@ const char * const vmstat_text[] = {
 	"kstack_rest",
 #endif
 #endif
-#endif /* CONFIG_VM_EVENT_COUNTERS || CONFIG_MEMCG */
+#endif /* CONFIG_VM_EVENT_COUNTERS */
 };
 #endif /* CONFIG_PROC_FS || CONFIG_SYSFS || CONFIG_NUMA || CONFIG_MEMCG */
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


