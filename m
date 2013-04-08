From: akpm@linux-foundation.org
Subject: + mm-remove-config_hotplug-ifdefs.patch added to -mm tree
Date: Mon, 08 Apr 2013 13:58:25 -0700
Message-ID: <20130408205825.810DB31C336@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:59180 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936171Ab3DHU61 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Apr 2013 16:58:27 -0400
Received: by mail-ob0-f202.google.com with SMTP id va7so448117obc.3
        for <mm-commits@vger.kernel.org>; Mon, 08 Apr 2013 13:58:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wangyijing@huawei.com, gregkh@linuxfoundation.org, riel@redhat.com


The patch titled
     Subject: mm: remove CONFIG_HOTPLUG ifdefs
has been added to the -mm tree.  Its filename is
     mm-remove-config_hotplug-ifdefs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
mm-remove-config_hotplug-ifdefs.patch

