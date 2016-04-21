From: akpm@linux-foundation.org
Subject: [to-be-updated] huge-tmpfs-show-page-team-flag-in-pageflags.patch removed from -mm tree
Date: Thu, 21 Apr 2016 13:46:39 -0700
Message-ID: <57193c2f.8YUzMneheRPZMfG0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbcDUUqk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 16:46:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreslc@google.com, aarcange@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, quning@gmail.com, rientjes@google.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: show page team flag in pageflags
has been removed from the -mm tree.  Its filename was
     huge-tmpfs-show-page-team-flag-in-pageflags.patch

This patch was dropped because an updated version will be merged

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
