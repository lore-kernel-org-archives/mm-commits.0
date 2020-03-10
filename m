From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case-fix.patch added
 to -mm tree
Date: Mon, 09 Mar 2020 17:51:51 -0700
Message-ID: <20200310005151.Whc-0dXm6%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727322AbgCJAvw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 9 Mar 2020 20:51:52 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de, pankaj.gupta.linux@gmail.com, richardw.yang@linux.intel.com, rppt@linux.ibm.com


The patch titled
     Subject: mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case-fix
has been added to the -mm tree.  Its filename is
     mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case-fix

remove unneeded initialization, per David

Cc: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse.c~mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case-fix
+++ a/mm/sparse.c
@@ -734,7 +734,7 @@ static void section_deactivate(unsigned
 	struct mem_section *ms = __pfn_to_section(pfn);
 	bool section_is_early = early_section(ms);
 	struct page *memmap = NULL;
-	bool empty = false;
+	bool empty;
 	unsigned long *subsection_map = ms->usage
 		? &ms->usage->subsection_map[0] : NULL;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case-fix.patch
mm.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
linux-next-git-rejects.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
