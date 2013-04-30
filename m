From: akpm@linux-foundation.org
Subject: [merged] mm-remove-config_hotplug-ifdefs.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:49:04 -0700
Message-ID: <20130430184904.7654131C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:46206 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab3D3StF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:49:05 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so85151vcb.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:49:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangyijing@huawei.com, gregkh@linuxfoundation.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove CONFIG_HOTPLUG ifdefs
has been removed from the -mm tree.  Its filename was
     mm-remove-config_hotplug-ifdefs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yijing Wang <wangyijing@huawei.com>
Subject: mm: remove CONFIG_HOTPLUG ifdefs

CONFIG_HOTPLUG is going away as an option, cleanup CONFIG_HOTPLUG
ifdefs in mm files.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    7 +------
 mm/vmstat.c            |    2 --
 2 files changed, 1 insertion(+), 8 deletions(-)

diff -puN include/linux/vmstat.h~mm-remove-config_hotplug-ifdefs include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-remove-config_hotplug-ifdefs
+++ a/include/linux/vmstat.h
@@ -48,13 +48,8 @@ static inline void count_vm_events(enum
 }
 
 extern void all_vm_events(unsigned long *);
-#ifdef CONFIG_HOTPLUG
+
 extern void vm_events_fold_cpu(int cpu);
-#else
-static inline void vm_events_fold_cpu(int cpu)
-{
-}
-#endif
 
 #else
 
diff -puN mm/vmstat.c~mm-remove-config_hotplug-ifdefs mm/vmstat.c
--- a/mm/vmstat.c~mm-remove-config_hotplug-ifdefs
+++ a/mm/vmstat.c
@@ -52,7 +52,6 @@ void all_vm_events(unsigned long *ret)
 }
 EXPORT_SYMBOL_GPL(all_vm_events);
 
-#ifdef CONFIG_HOTPLUG
 /*
  * Fold the foreign cpu events into our own.
  *
@@ -69,7 +68,6 @@ void vm_events_fold_cpu(int cpu)
 		fold_state->event[i] = 0;
 	}
 }
-#endif /* CONFIG_HOTPLUG */
 
 #endif /* CONFIG_VM_EVENT_COUNTERS */
 
_

Patches currently in -mm which might be from wangyijing@huawei.com are

origin.patch
linux-next.patch

