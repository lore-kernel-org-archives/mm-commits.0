Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B54A296169
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 19:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745866897; cv=none; b=ouqZ3lQdbERZTnd4WsO6BgAo/qttcIyrP5YImN4Y4f0dUPv7Z+kO61XkpD0BhAUPLmaGCPW1J+VDhwHomaKbpgD8w7UjNaETEaYdR9D/hSuF3gllvjRYGzTKbk1ORVmDkwWqUKueQtS2ZMSg9TeOW4u/ZSgxpfycTalUv8qadDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745866897; c=relaxed/simple;
	bh=rnjitNXZPHSb0y/j0Z1/7YLvtJc+YLzNMCPkHNLvOVo=;
	h=Date:To:From:Subject:Message-Id; b=h6NVhBxHAiUZ9onNs6qRkKLCvad9X5R11//oq8QMhgf76mlE+22fSwPYcYfiz08I5+1803bW8nBaUevI7CAvo8sNlZAshrezK6n9ib00jjvzXAPMskwKqzGbDGYeQwgsNrk6VHYVm2fI9uSV+j1XUmB1qxZxALRTmo/8rs55t1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xhpQrwDp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xhpQrwDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E754C4CEE4;
	Mon, 28 Apr 2025 19:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745866897;
	bh=rnjitNXZPHSb0y/j0Z1/7YLvtJc+YLzNMCPkHNLvOVo=;
	h=Date:To:From:Subject:From;
	b=xhpQrwDp44eoAm3sGYHvo88zK0tR0eWLwQopT/NYtP2nEcY7rQwzth5FYTkmDfHEc
	 o8iSxRWgjls7BWjmZe3zMSuZXqGRRgtXTNP+OOFJLWrlxTUMqbNiwDBioWDT0kzl6C
	 7vtLRAu3MaOJ/5+dsxGbsOA+R51Nj9fbQm5/R/MA=
Date: Mon, 28 Apr 2025 12:01:36 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,usamaarif642@gmail.com,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,shuah@kernel.org,ryan.roberts@arm.com,rostedt@goodmis.org,rientjes@google.com,rdunlap@infradead.org,raquini@redhat.com,peterx@redhat.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kirill.shutemov@linux.intel.com,jack@suse.cz,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,corbet@lwn.net,cl@gentwo.org,catalin.marinas@arm.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,bagasdotme@gmail.com,anshuman.khandual@arm.com,aarcange@redhat.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch added to mm-new branch
Message-Id: <20250428190137.4E754C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: khugepaged: avoid unnecessary mTHP collapse attempts
has been added to the -mm mm-new branch.  Its filename is
     khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch

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
From: Nico Pache <npache@redhat.com>
Subject: khugepaged: avoid unnecessary mTHP collapse attempts
Date: Mon, 28 Apr 2025 12:12:15 -0600

There are cases where, if an attempted collapse fails, all subsequent
orders are guaranteed to also fail.  Avoid these collapse attempts by
bailing out early.

Link: https://lkml.kernel.org/r/20250428181218.85925-10-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Reported-by:Takashi Iwai <tiwai@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Hellstrom <thomas.hellstrom@linux.intel.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/mm/khugepaged.c~khugepaged-avoid-unnecessary-mthp-collapse-attempts
+++ a/mm/khugepaged.c
@@ -1365,6 +1365,23 @@ static int khugepaged_scan_bitmap(struct
 				collapsed += (1 << order);
 				continue;
 			}
+			/*
+			 * Some ret values indicate all lower order will also
+			 * fail, dont trying to collapse smaller orders
+			 */
+			if (ret == SCAN_EXCEED_NONE_PTE ||
+				ret == SCAN_EXCEED_SWAP_PTE ||
+				ret == SCAN_EXCEED_SHARED_PTE ||
+				ret == SCAN_PTE_NON_PRESENT ||
+				ret == SCAN_PTE_UFFD_WP ||
+				ret == SCAN_ALLOC_HUGE_PAGE_FAIL ||
+				ret == SCAN_CGROUP_CHARGE_FAIL ||
+				ret == SCAN_COPY_MC ||
+				ret == SCAN_PAGE_LOCK ||
+				ret == SCAN_PAGE_COUNT)
+				goto next;
+			else
+				break;
 		}
 
 next:
_

Patches currently in -mm which might be from npache@redhat.com are

khugepaged-rename-hpage_collapse_-to-khugepaged_.patch
introduce-khugepaged_collapse_single_pmd-to-unify-khugepaged-and-madvise_collapse.patch
khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support.patch
khugepaged-generalize-__collapse_huge_page_-for-mthp-support.patch
khugepaged-introduce-khugepaged_scan_bitmap-for-mthp-support.patch
khugepaged-add-mthp-support.patch
khugepaged-skip-collapsing-mthp-to-smaller-orders.patch
khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch
khugepaged-improve-tracepoints-for-mthp-orders.patch
khugepaged-add-per-order-mthp-khugepaged-stats.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse.patch
mm-defer-thp-insertion-to-khugepaged.patch
mm-document-mthp-defer-usage.patch
khugepaged-add-defer-option-to-mthp-options.patch
selftests-mm-add-defer-to-thp-setting-parser.patch

