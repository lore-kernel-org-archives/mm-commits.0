From: akpm@linux-foundation.org
Subject: + proc-export-idle-flag-via-kpageflags.patch added to -mm tree
Date: Tue, 21 Jul 2015 16:34:06 -0700
Message-ID: <55aed6ee.LPjM+DfjYOzv8qW+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44095 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933904AbbGUXeH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jul 2015 19:34:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, andreslc@google.com, corbet@lwn.net, gorcunov@openvz.org, gthelen@google.com, hannes@cmpxchg.org, mhocko@suse.cz, minchan@kernel.org, raghavendra.kt@linux.vnet.ibm.com, rientjes@google.com, walken@google.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: export idle flag via kpageflags
has been added to the -mm tree.  Its filename is
     proc-export-idle-flag-via-kpageflags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-export-idle-flag-via-kpageflags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-export-idle-flag-via-kpageflags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 Documentation/vm/pagemap.txt           |    6 ++++++
 fs/proc/page.c                         |    3 +++
 include/uapi/linux/kernel-page-flags.h |    1 +
 3 files changed, 10 insertions(+)

diff -puN Documentation/vm/pagemap.txt~proc-export-idle-flag-via-kpageflags Documentation/vm/pagemap.txt
--- a/Documentation/vm/pagemap.txt~proc-export-idle-flag-via-kpageflags
+++ a/Documentation/vm/pagemap.txt
@@ -70,6 +70,7 @@ There are five components to pagemap:
     22. THP
     23. BALLOON
     24. ZERO_PAGE
+    25. IDLE
 
  * /proc/kpagecgroup.  This file contains a 64-bit inode number of the
    memory cgroup each page is charged to, indexed by PFN. Only available when
@@ -130,6 +131,11 @@ Short descriptions to the page flags:
 24. ZERO_PAGE
     zero page for pfn_zero or huge_zero page
 
+25. IDLE
+    page has not been accessed since it was marked idle (see /proc/kpageidle)
+    Note that this flag may be stale in case the page was accessed via a PTE.
+    To make sure the flag is up-to-date one has to read /proc/kpageidle first.
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

memcg-export-struct-mem_cgroup.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
memcg-get-rid-of-mem_cgroup_root_css-for-config_memcg.patch
memcg-get-rid-of-extern-for-functions-in-memcontrolh.patch
memcg-restructure-mem_cgroup_can_attach.patch
memcg-tcp_kmem-check-for-cg_proto-in-sock_update_memcg.patch
memcg-add-page_cgroup_ino-helper.patch
hwpoison-use-page_cgroup_ino-for-filtering-by-memcg.patch
memcg-zap-try_get_mem_cgroup_from_page.patch
proc-add-kpagecgroup-file.patch
mmu-notifier-add-clear_young-callback.patch
proc-add-kpageidle-file.patch
proc-export-idle-flag-via-kpageflags.patch
proc-add-cond_resched-to-proc-kpage-read-write-loop.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-swap-zswap-maybe_preload-refactoring.patch

