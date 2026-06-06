Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A035A21C16A
	for <mm-commits@vger.kernel.org>; Sat,  6 Jun 2026 00:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780705103; cv=none; b=feX6nGv4S/EU0E9/jBr2u6XryAZdNaRDpoTypZVyi35q6NpL7PJnHfLtuzKr7thyqQmZ6tfKQzO7bz4AaiKCnDCXeknG8nW1J7yHosNf6RdzxOyM6XeB71pJlBOZbzvSUUSCV3sZMraaWi59NtZgwGXVx/BcoRlE6d9b3kUqaNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780705103; c=relaxed/simple;
	bh=TTvv5RYPTXmw9Vei2raWWDKB3knLdR31SyIcjXPFJVw=;
	h=Date:To:From:Subject:Message-Id; b=FcPmHDzMM6D6tpfWf49MFZr11hgk1FHccHobf8xxUFU/UTLydq9G8MxTWOvp4ygbiz/ZwggrlejByg+wX89ZA1ZLh5Hl6obUDDKmmY2V69ZjvbICuSWk3kLLLXuvpzRcHYJuzxX1rQcARtLBP4tmJ4esiqgOvBODsqALb27GYfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pSHmluSz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pSHmluSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756031F00898;
	Sat,  6 Jun 2026 00:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780705101;
	bh=j6dloXrZA2L6baq4OtDt1Yb7ryKqVUegUz8PzdUH8bE=;
	h=Date:To:From:Subject;
	b=pSHmluSzcBjXJ9rJJ/57ivYE+PYRHSydJYWXSPOYdEZM7vtTB/hSr6k28awM2uGqn
	 NIvsv+rOq7B/+XBT7yFWTsKCVeFCso5pC2wGSNJYjcDKp9V57tOzZ50enhvGHnf4TV
	 +J5iQ8QfZ8hke7MCo2yX17KnBfD8EhU7umviks1Y=
Date: Fri, 05 Jun 2026 17:18:21 -0700
To: mm-commits@vger.kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] documentation-mm-update-the-admin-guide-for-mthp-collapse.patch removed from -mm tree
Message-Id: <20260606001821.756031F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: mm: update the admin guide for mTHP collapse
has been removed from the -mm tree.  Its filename was
     documentation-mm-update-the-admin-guide-for-mthp-collapse.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: Documentation: mm: update the admin guide for mTHP collapse
Date: Fri, 22 May 2026 09:00:09 -0600

Now that we can collapse to mTHPs lets update the admin guide to reflect
these changes and provide proper guidance on how to utilize it.

[npache@redhat.com: add back note and edit doc about khugepaged limits]
  Link: https://lore.kernel.org/b457f6e9-ae12-4e1f-8484-f3043ca62276@redhat.com
Link: https://lore.kernel.org/20260522150009.121603-15-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Takashi Iwai (SUSE) <tiwai@suse.de>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |   49 ++++++++++++-------
 1 file changed, 32 insertions(+), 17 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~documentation-mm-update-the-admin-guide-for-mthp-collapse
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -63,7 +63,8 @@ often.
 THP can be enabled system wide or restricted to certain tasks or even
 memory ranges inside task's address space. Unless THP is completely
 disabled, there is ``khugepaged`` daemon that scans memory and
-collapses sequences of basic pages into PMD-sized huge pages.
+collapses sequences of basic pages into huge pages of either PMD size
+or mTHP sizes, if the system is configured to do so.
 
 The THP behaviour is controlled via :ref:`sysfs <thp_sysfs>`
 interface and using madvise(2) and prctl(2) system calls.
@@ -219,10 +220,10 @@ this behaviour by writing 0 to shrink_un
 	echo 0 > /sys/kernel/mm/transparent_hugepage/shrink_underused
 	echo 1 > /sys/kernel/mm/transparent_hugepage/shrink_underused
 
-khugepaged will be automatically started when PMD-sized THP is enabled
+khugepaged will be automatically started when any THP size is enabled
 (either of the per-size anon control or the top-level control are set
 to "always" or "madvise"), and it'll be automatically shutdown when
-PMD-sized THP is disabled (when both the per-size anon control and the
+all THP sizes are disabled (when both the per-size anon control and the
 top-level control are "never")
 
 process THP controls
@@ -265,8 +266,8 @@ Khugepaged controls
 -------------------
 
 .. note::
-   khugepaged currently only searches for opportunities to collapse to
-   PMD-sized THP and no attempt is made to collapse to other THP
+   khugepaged currently only searches for opportunities to collapse file/shmem
+   to PMD-sized THP. Only anonymous memory will attempt to collapse to other THP
    sizes.
 
 khugepaged runs usually at low frequency so while one may not want to
@@ -296,11 +297,11 @@ allocation failure to throttle the next
 The khugepaged progress can be seen in the number of pages collapsed (note
 that this counter may not be an exact count of the number of pages
 collapsed, since "collapsed" could mean multiple things: (1) A PTE mapping
-being replaced by a PMD mapping, or (2) All 4K physical pages replaced by
-one 2M hugepage. Each may happen independently, or together, depending on
-the type of memory and the failures that occur. As such, this value should
-be interpreted roughly as a sign of progress, and counters in /proc/vmstat
-consulted for more accurate accounting)::
+being replaced by a PMD mapping, or (2) physical pages replaced by one
+hugepage of various sizes (PMD-sized or mTHP). Each may happen independently,
+or together, depending on the type of memory and the failures that occur.
+As such, this value should be interpreted roughly as a sign of progress,
+and counters in /proc/vmstat consulted for more accurate accounting)::
 
 	/sys/kernel/mm/transparent_hugepage/khugepaged/pages_collapsed
 
@@ -308,16 +309,21 @@ for each pass::
 
 	/sys/kernel/mm/transparent_hugepage/khugepaged/full_scans
 
-``max_ptes_none`` specifies how many extra small pages (that are
-not already mapped) can be allocated when collapsing a group
-of small pages into one large page::
+``max_ptes_none`` specifies how many empty (none/zero) pages are allowed
+when collapsing a group of small pages into one large page::
 
 	/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none
 
-A higher value leads to use additional memory for programs.
-A lower value leads to gain less thp performance. Value of
-max_ptes_none can waste cpu time very little, you can
-ignore it.
+For PMD-sized THP collapse, this directly limits the number of empty pages
+allowed in the 2MB region.
+
+For mTHP collapse, only 0 or (HPAGE_PMD_NR - 1) are supported. At
+HPAGE_PMD_NR - 1, we collapse to the highest possible order. Any intermediate
+value will emit a warning and mTHP collapse will default to max_ptes_none=0.
+
+A higher value allows more empty pages, potentially leading to more memory
+usage but better THP performance. A lower value is more conservative and
+may result in fewer THP collapses.
 
 ``max_ptes_swap`` specifies how many pages can be brought in from
 swap when collapsing a group of pages into a transparent huge page::
@@ -337,6 +343,15 @@ that THP is shared. Exceeding the number
 
 A higher value may increase memory footprint for some workloads.
 
+.. note::
+   For mTHP collapse, khugepaged does not support collapsing regions that
+   contain shared or swapped out pages, as this could lead to continuous
+   promotion to higher orders. The collapse will fail if any shared or
+   swapped PTEs are encountered during the scan.
+
+   Currently, madvise_collapse only supports collapsing to PMD-sized THPs
+   and does not attempt mTHP collapses.
+
 Boot parameters
 ===============
 
_

Patches currently in -mm which might be from npache@redhat.com are


