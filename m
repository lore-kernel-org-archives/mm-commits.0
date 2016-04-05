From: akpm@linux-foundation.org
Subject: + huge-tmpfs-show-page-team-flag-in-pageflags.patch added to -mm
 tree
Date: Tue, 05 Apr 2016 16:16:19 -0700
Message-ID: <57044743.xouDqby9GM2uxY+U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbcDEXQV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 19:16:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreslc@google.com, aarcange@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, quning@gmail.com, rientjes@google.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: show page team flag in pageflags
has been added to the -mm tree.  Its filename is
     huge-tmpfs-show-page-team-flag-in-pageflags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/huge-tmpfs-show-page-team-flag-in-pageflags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/huge-tmpfs-show-page-team-flag-in-pageflags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andres Lagar-Cavilla <andreslc@google.com>
Subject: huge tmpfs: show page team flag in pageflags

For debugging and testing.

Signed-off-by: Andres Lagar-Cavilla <andreslc@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/pagemap.txt           |    2 ++
 fs/proc/page.c                         |    6 ++++++
 include/uapi/linux/kernel-page-flags.h |    3 ++-
 tools/vm/page-types.c                  |    2 ++
 4 files changed, 12 insertions(+), 1 deletion(-)

diff -puN Documentation/vm/pagemap.txt~huge-tmpfs-show-page-team-flag-in-pageflags Documentation/vm/pagemap.txt
--- a/Documentation/vm/pagemap.txt~huge-tmpfs-show-page-team-flag-in-pageflags
+++ a/Documentation/vm/pagemap.txt
@@ -71,6 +71,8 @@ There are four components to pagemap:
     23. BALLOON
     24. ZERO_PAGE
     25. IDLE
+    26. TEAM
+    27. TEAM_PMD_MMAP (only if the whole team is mapped as a pmd at least once)
 
  * /proc/kpagecgroup.  This file contains a 64-bit inode number of the
    memory cgroup each page is charged to, indexed by PFN. Only available when
diff -puN fs/proc/page.c~huge-tmpfs-show-page-team-flag-in-pageflags fs/proc/page.c
--- a/fs/proc/page.c~huge-tmpfs-show-page-team-flag-in-pageflags
+++ a/fs/proc/page.c
@@ -12,6 +12,7 @@
 #include <linux/memcontrol.h>
 #include <linux/mmu_notifier.h>
 #include <linux/page_idle.h>
+#include <linux/pageteam.h>
 #include <linux/kernel-page-flags.h>
 #include <asm/uaccess.h>
 #include "internal.h"
@@ -112,6 +113,11 @@ u64 stable_page_flags(struct page *page)
 	if (PageKsm(page))
 		u |= 1 << KPF_KSM;
 
+	if (PageTeam(page)) {
+		u |= 1 << KPF_TEAM;
+		if (page == team_head(page) && team_pmd_mapped(page))
+			u |= 1 << KPF_TEAM_PMD_MMAP;
+	}
 	/*
 	 * compound pages: export both head/tail info
 	 * they together define a compound page's start/end pos and order
diff -puN include/uapi/linux/kernel-page-flags.h~huge-tmpfs-show-page-team-flag-in-pageflags include/uapi/linux/kernel-page-flags.h
--- a/include/uapi/linux/kernel-page-flags.h~huge-tmpfs-show-page-team-flag-in-pageflags
+++ a/include/uapi/linux/kernel-page-flags.h
@@ -34,6 +34,7 @@
 #define KPF_BALLOON		23
 #define KPF_ZERO_PAGE		24
 #define KPF_IDLE		25
-
+#define KPF_TEAM		26
+#define KPF_TEAM_PMD_MMAP	27
 
 #endif /* _UAPILINUX_KERNEL_PAGE_FLAGS_H */
diff -puN tools/vm/page-types.c~huge-tmpfs-show-page-team-flag-in-pageflags tools/vm/page-types.c
--- a/tools/vm/page-types.c~huge-tmpfs-show-page-team-flag-in-pageflags
+++ a/tools/vm/page-types.c
@@ -133,6 +133,8 @@ static const char * const page_flag_name
 	[KPF_BALLOON]		= "o:balloon",
 	[KPF_ZERO_PAGE]		= "z:zero_page",
 	[KPF_IDLE]              = "i:idle_page",
+	[KPF_TEAM]		= "y:team",
+	[KPF_TEAM_PMD_MMAP]	= "Y:team_pmd_mmap",
 
 	[KPF_RESERVED]		= "r:reserved",
 	[KPF_MLOCKED]		= "m:mlocked",
_

Patches currently in -mm which might be from andreslc@google.com are

tmpfs-mem_cgroup-charge-fault-to-vm_mm-not-current-mm.patch
kvm-plumb-return-of-hva-when-resolving-page-fault.patch
kvm-teach-kvm-to-map-page-teams-as-huge-pages.patch
huge-tmpfs-mem_cgroup-shmem_pmdmapped-accounting.patch
huge-tmpfs-mem_cgroup-shmem_hugepages-accounting.patch
huge-tmpfs-show-page-team-flag-in-pageflags.patch
huge-tmpfs-no-kswapd-by-default-on-sync-allocations.patch

