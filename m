From: akpm@linux-foundation.org
Subject: [merged] proc-export-idle-flag-via-kpageflags.patch removed from
 -mm tree
Date: Fri, 11 Sep 2015 11:11:25 -0700
Message-ID: <55f3194d.eMjvTO8PoP7SPJmo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbbIKSL0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:11:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, andreslc@google.com, corbet@lwn.net, gorcunov@openvz.org, gthelen@google.com, hannes@cmpxchg.org, mhocko@suse.cz, minchan@kernel.org, raghavendra.kt@linux.vnet.ibm.com, rientjes@google.com, walken@google.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: export idle flag via kpageflags
has been removed from the -mm tree.  Its filename was
     proc-export-idle-flag-via-kpageflags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: proc: export idle flag via kpageflags

As noted by Minchan, a benefit of reading idle flag from /proc/kpageflags
is that one can easily filter dirty and/or unevictable pages while
estimating the size of unused memory.

Note that idle flag read from /proc/kpageflags may be stale in case the
page was accessed via a PTE, because it would be too costly to iterate
over all page mappings on each /proc/kpageflags read to provide an
up-to-date value.  To make sure the flag is up-to-date one has to read
/proc/kpageidle first.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reviewed-by: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/pagemap.txt           |    7 +++++++
 fs/proc/page.c                         |    3 +++
 include/uapi/linux/kernel-page-flags.h |    1 +
 3 files changed, 11 insertions(+)

diff -puN Documentation/vm/pagemap.txt~proc-export-idle-flag-via-kpageflags Documentation/vm/pagemap.txt
--- a/Documentation/vm/pagemap.txt~proc-export-idle-flag-via-kpageflags
+++ a/Documentation/vm/pagemap.txt
@@ -70,6 +70,7 @@ There are four components to pagemap:
     22. THP
     23. BALLOON
     24. ZERO_PAGE
+    25. IDLE
 
  * /proc/kpagecgroup.  This file contains a 64-bit inode number of the
    memory cgroup each page is charged to, indexed by PFN. Only available when
@@ -120,6 +121,12 @@ Short descriptions to the page flags:
 24. ZERO_PAGE
     zero page for pfn_zero or huge_zero page
 
+25. IDLE
+    page has not been accessed since it was marked idle (see
+    Documentation/vm/idle_page_tracking.txt). Note that this flag may be
+    stale in case the page was accessed via a PTE. To make sure the flag
+    is up-to-date one has to read /sys/kernel/mm/page_idle/bitmap first.
+
     [IO related page flags]
  1. ERROR     IO error occurred
  3. UPTODATE  page has up-to-date data
diff -puN fs/proc/page.c~proc-export-idle-flag-via-kpageflags fs/proc/page.c
--- a/fs/proc/page.c~proc-export-idle-flag-via-kpageflags
+++ a/fs/proc/page.c
@@ -150,6 +150,9 @@ u64 stable_page_flags(struct page *page)
 	if (PageBalloon(page))
 		u |= 1 << KPF_BALLOON;
 
+	if (page_is_idle(page))
+		u |= 1 << KPF_IDLE;
+
 	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
 
 	u |= kpf_copy_bit(k, KPF_SLAB,		PG_slab);
diff -puN include/uapi/linux/kernel-page-flags.h~proc-export-idle-flag-via-kpageflags include/uapi/linux/kernel-page-flags.h
--- a/include/uapi/linux/kernel-page-flags.h~proc-export-idle-flag-via-kpageflags
+++ a/include/uapi/linux/kernel-page-flags.h
@@ -33,6 +33,7 @@
 #define KPF_THP			22
 #define KPF_BALLOON		23
 #define KPF_ZERO_PAGE		24
+#define KPF_IDLE		25
 
 
 #endif /* _UAPILINUX_KERNEL_PAGE_FLAGS_H */
_

Patches currently in -mm which might be from vdavydov@parallels.com are


