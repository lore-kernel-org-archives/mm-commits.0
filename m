From: akpm@linux-foundation.org
Subject: + pagemap-export-kpf_thp.patch added to -mm tree
Date: Thu, 09 Feb 2012 16:28:06 -0800
Message-ID: <20120210002806.ADE99A04C2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:56915 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757729Ab2BJA2H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2012 19:28:07 -0500
Received: by ggnp1 with SMTP id p1so250115ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 09 Feb 2012 16:28:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, andi@firstfloor.org, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com


The patch titled
     Subject: pagemap: export KPF_THP
has been added to the -mm tree.  Its filename is
     pagemap-export-kpf_thp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: pagemap: export KPF_THP

This flag shows that a given page is a subpage of a transparent hugepage. 
It helps us debug and test the kernel by showing physical address of thp.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c                    |    2 ++
 include/linux/kernel-page-flags.h |    1 +
 2 files changed, 3 insertions(+)

diff -puN fs/proc/page.c~pagemap-export-kpf_thp fs/proc/page.c
--- a/fs/proc/page.c~pagemap-export-kpf_thp
+++ a/fs/proc/page.c
@@ -115,6 +115,8 @@ u64 stable_page_flags(struct page *page)
 		u |= 1 << KPF_COMPOUND_TAIL;
 	if (PageHuge(page))
 		u |= 1 << KPF_HUGE;
+	else if (PageTransCompound(page))
+		u |= 1 << KPF_THP;
 
 	/*
 	 * Caveats on high order pages: page->_count will only be set
diff -puN include/linux/kernel-page-flags.h~pagemap-export-kpf_thp include/linux/kernel-page-flags.h
--- a/include/linux/kernel-page-flags.h~pagemap-export-kpf_thp
+++ a/include/linux/kernel-page-flags.h
@@ -30,6 +30,7 @@
 #define KPF_NOPAGE		20
 
 #define KPF_KSM			21
+#define KPF_THP			22
 
 /* kernel hacking assistances
  * WARNING: subject to change, never rely on them!
_
Subject: Subject: pagemap: export KPF_THP

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
mm-introduce-pmd_to_pte_t.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch

