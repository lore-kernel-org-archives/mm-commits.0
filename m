Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0E241C63
	for <mm-commits@vger.kernel.org>; Thu, 17 Apr 2025 23:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744932152; cv=none; b=c0CNSOeFzvDxcI9jSdDHAHRDO/ZEw/QLKSO6v/GsOCM+7BaNkct6yQaScKrCJVe7TZSLY30Q5d3g8IqU+GUKzEvJunNtE8vil10spEgzvpCzv0pGqXY/oolDx0XcjiLm6uguQLg3Ea4GSDKjjF4f3QRBxvpK/gzCpgAi4fjCezM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744932152; c=relaxed/simple;
	bh=juW9cSj3Qs6+bUW1UuEakh8xwrLM8Pal7Tkxp/y7IyM=;
	h=Date:To:From:Subject:Message-Id; b=LBPCEKJ8XGSQWel6VLXZAc5UlPHdlmnrbdlTeYbkw3fNbKTmksbadVjiIfbA9KaxuBOslLspM6zfuo+Qf46z0tgabIBnpdwFIQHj/joO6yH4W2Bsn/0V86cDdy8InkQwx4BXqU67vCl/BT209LIblAzT0E6D6mX7nl3n3r4fLvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gKPXxmsb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gKPXxmsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4566C4CEE4;
	Thu, 17 Apr 2025 23:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744932151;
	bh=juW9cSj3Qs6+bUW1UuEakh8xwrLM8Pal7Tkxp/y7IyM=;
	h=Date:To:From:Subject:From;
	b=gKPXxmsbxZR3R59lqS1g6kBub0q09cYH7B2wYv0Ru1A0FIYC/lNYoR4wW+gkKRhHw
	 f25BGSCYIkcXnF+faqLG4POnDugv2Ee44+9uppWJg2oer5Uml/3HTL2OUb97zAKS+d
	 1KJIT9f3YVtH5zaVF/GXA92H8+bKfjwfREc07BSE=
Date: Thu, 17 Apr 2025 16:22:31 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,usamaarif642@gmail.com,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,shuah@kernel.org,ryan.roberts@arm.com,rostedt@goodmis.org,rientjes@google.com,rdunlap@infradead.org,raquini@redhat.com,peterx@redhat.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,kirill.shutemov@linux.intel.com,jack@suse.cz,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,corbet@lwn.net,cl@gentwo.org,catalin.marinas@arm.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshuman.khandual@arm.com,aarcange@redhat.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-mm-update-the-admin-guide-for-mthp-collapse.patch added to mm-new branch
Message-Id: <20250417232231.D4566C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: mm: update the admin guide for mTHP collapse
has been added to the -mm mm-new branch.  Its filename is
     documentation-mm-update-the-admin-guide-for-mthp-collapse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-mm-update-the-admin-guide-for-mthp-collapse.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: Documentation: mm: update the admin guide for mTHP collapse
Date: Wed, 16 Apr 2025 18:02:38 -0600

Now that we can collapse to mTHPs lets update the admin guide to reflect
these changes and provide proper guidence on how to utilize it.

Link: https://lkml.kernel.org/r/20250417000238.74567-13-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
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

 Documentation/admin-guide/mm/transhuge.rst |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~documentation-mm-update-the-admin-guide-for-mthp-collapse
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -63,7 +63,7 @@ often.
 THP can be enabled system wide or restricted to certain tasks or even
 memory ranges inside task's address space. Unless THP is completely
 disabled, there is ``khugepaged`` daemon that scans memory and
-collapses sequences of basic pages into PMD-sized huge pages.
+collapses sequences of basic pages into huge pages.
 
 The THP behaviour is controlled via :ref:`sysfs <thp_sysfs>`
 interface and using madvise(2) and prctl(2) system calls.
@@ -144,6 +144,14 @@ hugepage sizes have enabled="never". If
 sizes, the kernel will select the most appropriate enabled size for a
 given allocation.
 
+khugepaged uses max_ptes_none scaled to the order of the enabled mTHP size to
+determine collapses. When using mTHPs it's recommended to set max_ptes_none
+low-- ideally less than HPAGE_PMD_NR / 2 (255 on 4k page size). This will
+prevent undesired "creep" behavior that leads to continuously collapsing to a
+larger mTHP size. max_ptes_shared and max_ptes_swap have no effect when
+collapsing to a mTHP, and mTHP collapse will fail on shared or swapped out
+pages.
+
 It's also possible to limit defrag efforts in the VM to generate
 anonymous hugepages in case they're not immediately free to madvise
 regions or to never try to defrag memory and simply fallback to regular
_

Patches currently in -mm which might be from npache@redhat.com are

introduce-khugepaged_collapse_single_pmd-to-unify-khugepaged-and-madvise_collapse.patch
khugepaged-rename-hpage_collapse_-to-khugepaged_.patch
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

