Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BB328686
	for <mm-commits@vger.kernel.org>; Fri, 16 Oct 2026 00:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792111123; cv=none; b=P8abZ8cvAc2QHzeCOi638JH0PHAS2iBgBmvu+HgW3XNGQNrw9nTI0InUWeF6l63MvTtLKz7lwF4769Yh0mrCHR/KCgy8ZcyxmWKWIrFaFBUY9cpefXSJM7F6g1ZIu7MHOqd0Hsw5W6iu/PEM6oqe88iYvyI24/FCa6Sreva5ms0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792111123; c=relaxed/simple;
	bh=sLThFNE9RcxlOtDz1xWW+qgf221i+nomAWJYVhcbfAs=;
	h=Date:To:From:Subject:Message-Id; b=UiQ4XRIaCkPVCRjNencQkNtrfFel/t1uaw7V/mdOdbCOPgpHMzm9cUNFEK3TBHn5+Iej+EpIFM9hC6t1sw3xE/0Gt+mua7tM9olmWUf2lKCKHKiQrjyujgVen89qVFr2nIUNIla3lHMUQZWy+jMwuZzhFlptEliDJKFt+wSuhwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ft+Z98Pq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ft+Z98Pq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB671F000C4;
	Fri, 16 Oct 2026 00:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792111121;
	bh=Xo9wkTvneCOtK9hZounkq31lRkKBh2V6tlP36HHjMCA=;
	h=Date:To:From:Subject;
	b=ft+Z98PqqTsSMMNWcPS99M+hL7Jb7xCupdJsSnHsPmYGNa+zkftw0Dot+l3A13ZUm
	 BwSUvglH20o1wgP8UECH4OZISgwENm1ULF7H/q/higqWQ7hjZF4ppZsmFSicv3LS6N
	 zo02Rgufr8B2UWDOtgecCK24N656iVMsRcvKVovM=
Date: Thu, 15 Oct 2026 17:38:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,skhan@linuxfoundation.org,ryan.roberts@arm.com,rppt@kernel.org,rdunlap@infradead.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,hannes@cmpxchg.org,dev.jain@arm.com,david.laight.linux@gmail.com,david@kernel.org,corbet@lwn.net,brendan.jackman@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,noren@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-stop-recalculating-min_free_kbytes-once-set-by-userspace.patch added to mm-unstable branch
Message-Id: <20261016003841.AEB671F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: stop recalculating min_free_kbytes once set by userspace
has been added to the -mm mm-unstable branch.  Its filename is
     mm-stop-recalculating-min_free_kbytes-once-set-by-userspace.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-stop-recalculating-min_free_kbytes-once-set-by-userspace.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Nimrod Oren <noren@nvidia.com>
Subject: mm: stop recalculating min_free_kbytes once set by userspace
Date: Wed, 14 Oct 2026 17:08:59 +0300

min_free_kbytes is recalculated on memory hotplug and on THP sysfs writes.
The new value comes from calculate_min_free_kbytes() or, while THP is
enabled, from set_recommended_min_free_kbytes().  A value written to the
vm.min_free_kbytes sysctl is replaced whenever the new value is higher, so
a lower value does not stick.  This matters most when THP is enabled on
configurations with large pageblocks, where the new value can be excessive
[1].

For example, with default arm64 pageblock sizes, the THP recommendation
can reach 5.5 GiB per eligible zone with 64 KiB pages vs 22 MiB with 4 KiB
pages.  This keeps a significant amount of memory free, reducing what
applications can use and triggering reclaim much earlier.  Users can lower
vm.min_free_kbytes to avoid this, but the lower value only sticks until
the next recalculation.

Stop recalculating min_free_kbytes once a value has been written to the
sysctl.  Systems where the sysctl is never written keep the current
behavior.

Link: https://lore.kernel.org/20261014140859.1006967-1-noren@nvidia.com
Link: https://lore.kernel.org/r/20260716173504.760369-1-noren@nvidia.com/ [1]
Signed-off-by: Nimrod Oren <noren@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Link: https://lore.kernel.org/r/d202dcc3-d7d7-4e98-a9a5-3137cfbfd041@kernel.org/
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: David Laight <david.laight.linux@gmail.com>
---

 Documentation/admin-guide/sysctl/vm.rst |    7 +++++++
 mm/khugepaged.c                         |    7 +------
 mm/page_alloc.c                         |    6 +-----
 3 files changed, 9 insertions(+), 11 deletions(-)

--- a/Documentation/admin-guide/sysctl/vm.rst~mm-stop-recalculating-min_free_kbytes-once-set-by-userspace
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -539,6 +539,13 @@ watermark[WMARK_MIN] value for each lowm
 Each lowmem zone gets a number of reserved free pages based
 proportionally on its size.
 
+By default, the kernel sets this value based on the amount of lowmem
+and recalculates it on memory hotplug.  When Transparent Hugepage (THP)
+support is enabled through global or per-size controls, the kernel may
+also raise it to help keep pageblocks free and reduce fragmentation for
+THP allocations.  Once a value is written to this file, the kernel no
+longer adjusts it automatically.
+
 Some minimal amount of memory is needed to satisfy PF_MEMALLOC
 allocations; if you set this to lower than 1024KB, your system will
 become subtly broken, and prone to deadlock under high loads.
--- a/mm/khugepaged.c~mm-stop-recalculating-min_free_kbytes-once-set-by-userspace
+++ a/mm/khugepaged.c
@@ -3148,13 +3148,8 @@ void set_recommended_min_free_kbytes(voi
 			      (unsigned long) nr_free_buffer_pages() / 20);
 	recommended_min <<= (PAGE_SHIFT-10);
 
-	if (recommended_min > min_free_kbytes) {
-		if (user_min_free_kbytes >= 0)
-			pr_info_ratelimited("raising min_free_kbytes from %d to %lu to help transparent hugepage allocations\n",
-					    min_free_kbytes, recommended_min);
-
+	if (user_min_free_kbytes < 0 && recommended_min > min_free_kbytes)
 		min_free_kbytes = recommended_min;
-	}
 
 update_wmarks:
 	setup_per_zone_wmarks();
--- a/mm/page_alloc.c~mm-stop-recalculating-min_free_kbytes-once-set-by-userspace
+++ a/mm/page_alloc.c
@@ -6737,12 +6737,8 @@ void calculate_min_free_kbytes(void)
 	lowmem_kbytes = nr_free_buffer_pages() * (PAGE_SIZE >> 10);
 	new_min_free_kbytes = int_sqrt(lowmem_kbytes * 16);
 
-	if (new_min_free_kbytes > user_min_free_kbytes)
+	if (user_min_free_kbytes < 0)
 		min_free_kbytes = clamp(new_min_free_kbytes, 128, 262144);
-	else
-		pr_warn_ratelimited("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
-				    new_min_free_kbytes, user_min_free_kbytes);
-
 }
 
 int __meminit init_per_zone_wmark_min(void)
_

Patches currently in -mm which might be from noren@nvidia.com are

mm-stop-recalculating-min_free_kbytes-once-set-by-userspace.patch

