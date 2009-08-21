From: akpm@linux-foundation.org
Subject: + oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong.patch added to -mm tree
Date: Fri, 21 Aug 2009 14:43:48 -0700
Message-ID: <200908212143.n7LLhmZ1008265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932609AbZHUVoN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Aug 2009 17:44:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, rientjes@google.com


The patch titled
     oom: move oom_killer_enable()/oom_killer_disable to where they belong
has been added to the -mm tree.  Its filename is
     oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: move oom_killer_enable()/oom_killer_disable to where they belong
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h    |   12 ------------
 include/linux/oom.h    |   11 +++++++++++
 kernel/power/process.c |    1 +
 3 files changed, 12 insertions(+), 12 deletions(-)

diff -puN include/linux/gfp.h~oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong include/linux/gfp.h
--- a/include/linux/gfp.h~oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong
+++ a/include/linux/gfp.h
@@ -335,18 +335,6 @@ void drain_zone_pages(struct zone *zone,
 void drain_all_pages(void);
 void drain_local_pages(void *dummy);
 
-extern bool oom_killer_disabled;
-
-static inline void oom_killer_disable(void)
-{
-	oom_killer_disabled = true;
-}
-
-static inline void oom_killer_enable(void)
-{
-	oom_killer_disabled = false;
-}
-
 extern gfp_t gfp_allowed_mask;
 
 static inline void set_gfp_allowed_mask(gfp_t mask)
diff -puN include/linux/oom.h~oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong include/linux/oom.h
--- a/include/linux/oom.h~oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong
+++ a/include/linux/oom.h
@@ -30,5 +30,16 @@ extern void out_of_memory(struct zonelis
 extern int register_oom_notifier(struct notifier_block *nb);
 extern int unregister_oom_notifier(struct notifier_block *nb);
 
+extern bool oom_killer_disabled;
+
+static inline void oom_killer_disable(void)
+{
+	oom_killer_disabled = true;
+}
+
+static inline void oom_killer_enable(void)
+{
+	oom_killer_disabled = false;
+}
 #endif /* __KERNEL__*/
 #endif /* _INCLUDE_LINUX_OOM_H */
diff -puN kernel/power/process.c~oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong kernel/power/process.c
--- a/kernel/power/process.c~oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong
+++ a/kernel/power/process.c
@@ -9,6 +9,7 @@
 #undef DEBUG
 
 #include <linux/interrupt.h>
+#include <linux/oom.h>
 #include <linux/suspend.h>
 #include <linux/module.h>
 #include <linux/syscalls.h>
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong.patch
scripts-get_maintainerpl-add-remove-duplicates.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
procfs-provide-stack-information-for-threads-v08.patch
procfs-provide-stack-information-for-threads-v011.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
sysctl-remove-struct-file-argument-of-proc_handler.patch
aio-ifdef-fields-in-mm_struct.patch

