Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E22782D91
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274551; cv=none; b=fA4CdLWe68VftHPPijM4j5FV+VAmFwtnC4SNStB3umTZGgN5f7jTbi5YQFoFGj12O31kqss8ljj+M15eeduXrEsH1iAS64u7Kg/A2d9EgiF0XuOHCbDSAAsQpvO1IBq+6X5Mofw7qyCFQynGg51Y61JyAnwAToRdGB/PgMS7uPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274551; c=relaxed/simple;
	bh=WrYfr+q5QHCvWk5c6I/cmPUlKT4aseZ0zmBAoIxGvEI=;
	h=Date:To:From:Subject:Message-Id; b=MKhD/XfB0x85eOoGXHtZUGTlN3iI65OLzuZp2aajTtSwrcwpV2Fw1IN2EWG8XtLUaqtOBBKCtdbIQtbG+FtDjvOSRgkLZEscPPSJBB6DMN6UB1IclpReyOkv/6xZZ3fq+Nf3zfteEjRjZEJVYfiZCpe+UTMYVKMor4dQxi6BGoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ut/FDQeT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ut/FDQeT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4418EC4CEDD;
	Tue, 18 Mar 2025 05:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274551;
	bh=WrYfr+q5QHCvWk5c6I/cmPUlKT4aseZ0zmBAoIxGvEI=;
	h=Date:To:From:Subject:From;
	b=Ut/FDQeTBfrXzzNHFM6JVKVScrb166K2G0jXW3GkU7fF0dav5QBEMsLvf/FvCsV6U
	 9S1kQ1h6g5s8anPCBOc/72TTd1o/IYud+VSn1uQa5P/9HlC0TjwehG+fmB97ow/hoK
	 nXNvXyOFUgtVqWVTYJmiTgtzX8/f91A5gmrY3Yb8=
Date: Mon, 17 Mar 2025 22:09:10 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tj@kernel.org,tglx@linutronix.de,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizefan.x@bytedance.com,liam.howlett@oracle.com,kirill.shutemov@linux.intel.com,jannh@google.com,ioworker0@gmail.com,hannes@cmpxchg.org,dave.hansen@linux.intel.com,corbet@lwn.net,bp@alien8.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-mapmax-config_no_page_mapcount.patch removed from -mm tree
Message-Id: <20250318050911.4418EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: remove per-page mapcount dependency for "mapmax" (CONFIG_NO_PAGE_MAPCOUNT)
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-mapmax-config_no_page_mapcount.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fs/proc/task_mmu: remove per-page mapcount dependency for "mapmax" (CONFIG_NO_PAGE_MAPCOUNT)
Date: Mon, 3 Mar 2025 17:30:11 +0100

Let's implement an alternative when per-page mapcounts in large folios are
no longer maintained -- soon with CONFIG_NO_PAGE_MAPCOUNT.

For calculating "mapmax", we now use the average per-page mapcount in a
large folio instead of the per-page mapcount.

For hugetlb folios and folios that are not partially mapped into MMs,
there is no change.

Likely, this change will not matter much in practice, and an alternative
might be to simple remove this stat with CONFIG_NO_PAGE_MAPCOUNT. 
However, there might be value to it, so let's keep it like that and
document the behavior.

Link: https://lkml.kernel.org/r/20250303163014.1128035-19-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andy Lutomirks^H^Hski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michal Koutn <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: tejun heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    5 +++++
 fs/proc/task_mmu.c                 |    7 ++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/Documentation/filesystems/proc.rst~fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-mapmax-config_no_page_mapcount
+++ a/Documentation/filesystems/proc.rst
@@ -686,6 +686,11 @@ Where:
 node locality page counters (N0 == node0, N1 == node1, ...) and the kernel page
 size, in KB, that is backing the mapping up.
 
+Note that some kernel configurations do not track the precise number of times
+a page part of a larger allocation (e.g., THP) is mapped. In these
+configurations, "mapmax" might corresponds to the average number of mappings
+per page in such a larger allocation instead.
+
 1.2 Kernel data
 ---------------
 
--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-mapmax-config_no_page_mapcount
+++ a/fs/proc/task_mmu.c
@@ -2863,7 +2863,12 @@ static void gather_stats(struct page *pa
 			unsigned long nr_pages)
 {
 	struct folio *folio = page_folio(page);
-	int count = folio_precise_page_mapcount(folio, page);
+	int count;
+
+	if (IS_ENABLED(CONFIG_PAGE_MAPCOUNT))
+		count = folio_precise_page_mapcount(folio, page);
+	else
+		count = folio_average_page_mapcount(folio);
 
 	md->pages += nr_pages;
 	if (pte_dirty || folio_test_dirty(folio))
_

Patches currently in -mm which might be from david@redhat.com are


