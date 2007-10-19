From: akpm@linux-foundation.org
Subject: - redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:45:01 -0700
Message-ID: <200710190345.l9J3j1lt013187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39991 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934351AbXJSDzf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Redefine {un}register_hotcpu_notifier() !HOTPLUG_CPU stubs
has been removed from the -mm tree.  Its filename was
     redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Redefine {un}register_hotcpu_notifier() !HOTPLUG_CPU stubs
From: Satyam Sharma <satyam@infradead.org>

The return of the present "do {} while" based stub definition of
register_hotcpu_notifier() cannot be checked.  This makes the stub
asymmetric w.r.t.  the real HOTPLUG_CPU=y implementation that is
int-returning.  So let us redefine this to be consistent with the full
version.  Also do the same for unregister_hotcpu_notifier().

We cannot define these as static inline functions due to an existing GCC
bug (#33172).  So define as macros that return appropriately instead (int
'0' for the register_hotcpu_notifier case and void for
unregister_hotcpu_notifier).

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/cpu.h~redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs include/linux/cpu.h
--- a/include/linux/cpu.h~redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs
+++ a/include/linux/cpu.h
@@ -119,8 +119,9 @@ static inline void cpuhotplug_mutex_unlo
 #define lock_cpu_hotplug()	do { } while (0)
 #define unlock_cpu_hotplug()	do { } while (0)
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
-#define register_hotcpu_notifier(nb)	do { (void)(nb); } while (0)
-#define unregister_hotcpu_notifier(nb)	do { (void)(nb); } while (0)
+/* These aren't inline functions due to a GCC bug. */
+#define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
+#define unregister_hotcpu_notifier(nb)	({ (void)(nb); })
 
 /* CPUs don't go offline once they're online w/o CONFIG_HOTPLUG_CPU */
 static inline int cpu_is_offline(int cpu) { return 0; }
_

Patches currently in -mm which might be from satyam@infradead.org are

origin.patch
git-watchdog.patch
