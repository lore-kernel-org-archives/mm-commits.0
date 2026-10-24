Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832513;
	b=IDk2XjYq23wTX0mDlJ6hWkZ712i+PWMaCa+2ANmvLYvHlbhWDmoNXcqzjVCp0pMjFtTy
	 ai5bN35+z/AB9YShGcb7JB8dt5GPDD1yCgzqi6S1AkaLjazsW3uJMOhh3gNRZ0ZNa8ZN9
	 TwuWUBur+k3f1xFHyKfCB8p/0UpJReAEqd7ccKTs2V2rVPGDd43Qwk+3BrYRYsqCcWn4A
	 jTQtHTfdEVqujT1hyouFIg0NAAzquTDJdJUsyGDGCzRuAZFzhigYMZO4MorcvbMwgyU4Z
	 vkn253U7I0Q3plzAcbOS1Sfun8T4u3UvS22K6k63oKKsyQS3ZoQkougC+UH+BYCdIYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832513;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=kcrG8SEYP/9oj8BXL6EXPxBbuFrdUZpdkHO+sid3PuE=;
	b=rv/P4X1LC6nflVlW2pb1ohWctzOsCB74Fe/5DxsScaX4IvJIhkQt2AiU5GV7HhoeF7mf
	 NBeGW/EdZlIzXko0koOLreSaiXFhEvCzYgQD0cjEkqaWvSn1tTZ+Skk3qH9NkvnK89gI3
	 OKiCr6+WRH+4aY/c2yh6n3oFw6twhP5rtGNAQdunELH5p5F1ZGdj1GmkSSEMkyUG7ugTu
	 d5QzFJ4uz8wQIQGBQimcphCRRSBJixNgrm4WvLfhVb0KfU67zMxCiknnISsZDHgZHKY62
	 DkD3rrqAdqgeRyblJXxUvLHLL2mufitlaAMATEw+YcF4VE2+flUtW3hstQLS1wK6izg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=t7vMSTpV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106C7606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=t7vMSTpV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D378D1F01825;
	Sat, 24 Oct 2026 09:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832512;
	bh=kcrG8SEYP/9oj8BXL6EXPxBbuFrdUZpdkHO+sid3PuE=;
	h=Date:To:From:Subject;
	b=t7vMSTpV/bC74YIcDwo8kmtp/ir9cJEJcr5yC74ajuxMxVBrHDzgOg2KUNvlhANnu
	 zfQLlpFm4bsW8pAeB8Nl6+GtxcBTHl15OGa0nhc1wp6mtUm/J62xYeWT1jDcneSUJL
	 qTPPGHUzJ9EtkXjmvUnL8kLVZIEuGvkAc5IE6uaA=
Date: Sat, 24 Oct 2026 02:01:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,skhan@linuxfoundation.org,ryan.roberts@arm.com,rppt@kernel.org,rdunlap@infradead.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,hannes@cmpxchg.org,dev.jain@arm.com,david.laight.linux@gmail.com,david@kernel.org,corbet@lwn.net,brendan.jackman@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,noren@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-stop-recalculating-min_free_kbytes-once-set-by-userspace.patch removed from -mm tree
Message-Id: <20261024090152.D378D1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: stop recalculating min_free_kbytes once set by userspace
has been removed from the -mm tree.  Its filename was
     mm-stop-recalculating-min_free_kbytes-once-set-by-userspace.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3144,13 +3144,8 @@ void set_recommended_min_free_kbytes(voi
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
@@ -6722,12 +6722,8 @@ void calculate_min_free_kbytes(void)
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


