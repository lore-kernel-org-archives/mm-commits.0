Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F668383
	for <mm-commits@vger.kernel.org>; Sat,  9 Aug 2025 00:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754700202; cv=none; b=gD4h4bfEwPSzwv+lBW1cOCaogVWOoxMeE7R+GRQZbN1K+Rs3qD/Fyry8lTj0jmVqPimiSDLY3xhOFslBJMcmt5/MQG8Acw8FEjfWH2PNMMEw6vduPL3GA3/Y8c735vCF3hQs/7GS9oP5ZJVjJd+NovlsCDt3/OxkWBLtsdVcrLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754700202; c=relaxed/simple;
	bh=6w7CR2Y2z4sg7ifYy18TwrgckSrxseTUexyUhAvmPLc=;
	h=Date:To:From:Subject:Message-Id; b=lydIJ19cDnDfOzVUkyaEBFCHi3ImTtrueznnbd6VUEF9Uf8rYi5rTml6Q+P0tscnAMYOH3Fw/dOvgqYfGx7QDjarX4GH7NXlR9FH736YbLKZzg5rLTHjz6HqrKWQyNk1BUuxYcep8ycnCQVNYDFXoclboi03OT5C0Nc/oYriORE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HNvZsSFT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HNvZsSFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2D9C4CEF4;
	Sat,  9 Aug 2025 00:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754700202;
	bh=6w7CR2Y2z4sg7ifYy18TwrgckSrxseTUexyUhAvmPLc=;
	h=Date:To:From:Subject:From;
	b=HNvZsSFTT/eytcRaFzAkJcOhTWXd6273T+PTrIjweHYIUys1neMn2fiNHPf4aH+tX
	 StlMlsfvrU2GB1XCis+WppL639RTInYJqvulUT15SMlxiezOdibG5RvGC4tnHN3X5x
	 FBYO0Zq5sCGGAGyqR9bVYrJ/UVaLl6Rpv+69rlS0=
Date: Fri, 08 Aug 2025 17:43:21 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,richard.weiyang@gmail.com,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-add-new_order-and-offset-to-split_huge_pages-pr_debug.patch added to mm-new branch
Message-Id: <20250809004322.5E2D9C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: add new_order and offset to split_huge_pages*() pr_debug.
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-add-new_order-and-offset-to-split_huge_pages-pr_debug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-add-new_order-and-offset-to-split_huge_pages-pr_debug.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: add new_order and offset to split_huge_pages*() pr_debug.
Date: Fri, 8 Aug 2025 15:01:42 -0400

Patch series "Better split_huge_page_test result check", v2.

This patchset uses kpageflags to get after-split folio orders for a better
split_huge_page_test result check[1].  The added gather_folio_orders()
scans through a VPN range and collects the numbers of folios at different
orders.  check_folio_orders() compares the result of gather_folio_orders()
to a given list of numbers of different orders.

This patchset also added new order and in folio offset to the split huge
page debugfs's pr_debug()s;


This patch (of 3):

They are useful information for debugging split huge page tests.

Link: https://lkml.kernel.org/r/20250808190144.797076-1-ziy@nvidia.com
Link: https://lkml.kernel.org/r/20250808190144.797076-2-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-add-new_order-and-offset-to-split_huge_pages-pr_debug
+++ a/mm/huge_memory.c
@@ -4327,8 +4327,8 @@ static int split_huge_pages_pid(int pid,
 		goto out;
 	}
 
-	pr_debug("Split huge pages in pid: %d, vaddr: [0x%lx - 0x%lx]\n",
-		 pid, vaddr_start, vaddr_end);
+	pr_debug("Split huge pages in pid: %d, vaddr: [0x%lx - 0x%lx], new_order: %u, in_folio_offset: %ld\n",
+		 pid, vaddr_start, vaddr_end, new_order, in_folio_offset);
 
 	mmap_read_lock(mm);
 	/*
@@ -4438,8 +4438,8 @@ static int split_huge_pages_in_file(cons
 	if (IS_ERR(candidate))
 		goto out;
 
-	pr_debug("split file-backed THPs in file: %s, page offset: [0x%lx - 0x%lx]\n",
-		 file_path, off_start, off_end);
+	pr_debug("split file-backed THPs in file: %s, page offset: [0x%lx - 0x%lx], new_order: %u, in_folio_offset: %ld\n",
+		 file_path, off_start, off_end, new_order, in_folio_offset);
 
 	mapping = candidate->f_mapping;
 	min_order = mapping_min_folio_order(mapping);
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-fix-force_read-to-read-input-value-correctly.patch
mm-huge_memory-add-new_order-and-offset-to-split_huge_pages-pr_debug.patch
selftests-mm-add-check_folio_orders-helper.patch
selftests-mm-check-after-split-folio-orders-in-split_huge_page_test.patch

