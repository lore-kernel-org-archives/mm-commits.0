From: akpm@linux-foundation.org
Subject: [merged] oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:42:12 -0700
Message-ID: <200909222042.n8MKgCEX009082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752696AbZIVUmP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     oom: move oom_killer_enable()/oom_killer_disable to where they belong
has been removed from the -mm tree.  Its filename was
     oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: move oom_killer_enable()/oom_killer_disable to where they belong
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
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
acpi-switch-proc-acpi-debug_layerdebug_level-to-seq_file.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
cpqarray-switch-to-seq_file.patch
dac960-switch-to-seq_file.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
procfs-provide-stack-information-for-threads-v08.patch
procfs-provide-stack-information-for-threads-v011.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
viafb-switch-to-seq_file.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
sysctl-remove-struct-file-argument-of-proc_handler.patch
aio-ifdef-fields-in-mm_struct.patch
gru-use-proc_create.patch

