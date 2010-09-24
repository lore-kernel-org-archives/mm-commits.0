From: akpm@linux-foundation.org
Subject: + percpu_counter-add-debugobj-support.patch added to -mm tree
Date: Fri, 24 Sep 2010 15:42:19 -0700
Message-ID: <201009242242.o8OMgJKM029614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758349Ab0IXWmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Sep 2010 18:42:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org


The patch titled
     percpu_counter: add debugobj support
has been added to the -mm tree.  Its filename is
     percpu_counter-add-debugobj-support.patch

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
Subject: percpu_counter: add debugobj support
From: Tejun Heo <tj@kernel.org>

All percpu counters are linked to a global list on initialization and
removed from it on destruction.  The list is walked during CPU up/down. 
If a percpu counter is freed without being properly destroyed, the system
will oops only on the next CPU up/down making it pretty nasty to track
down.  This patch adds debugobj support for percpu counters so that such
problems can be found easily.

As percpu counters don't make sense on stack and can't be statically
initialized, debugobj support is pretty simple.  It's initialized and
activated on counter initialization, and deactivatd and destroyed on
counter destruction.  With this patch applied, the bug fixed by commit
602586a83b719df0fbd94196a1359ed35aeb2df3 (shmem: put_super must
percpu_counter_destroy) triggers the following warning on tmpfs unmount
and the system won't oops on the next cpu up/down operation.

 ------------[ cut here ]------------
 WARNING: at /devel/tj/os/work/lib/debugobjects.c:259 debug_print_object+0x5c/0x70()
 Hardware name: Bochs
 ODEBUG: free active (active state 0) object type: percpu_counter
 Modules linked in:
 Pid: 3999, comm: umount Not tainted 2.6.36-rc2-work+ #5
 Call Trace:
  [<ffffffff81083f7f>] warn_slowpath_common+0x7f/0xc0
  [<ffffffff81084076>] warn_slowpath_fmt+0x46/0x50
  [<ffffffff813b45cc>] debug_print_object+0x5c/0x70
  [<ffffffff813b50e5>] debug_check_no_obj_freed+0x125/0x210
  [<ffffffff811577d3>] kfree+0xb3/0x2f0
  [<ffffffff81132edd>] shmem_put_super+0x1d/0x30
  [<ffffffff81162e96>] generic_shutdown_super+0x56/0xe0
  [<ffffffff81162f86>] kill_anon_super+0x16/0x60
  [<ffffffff81162ff7>] kill_litter_super+0x27/0x30
  [<ffffffff81163295>] deactivate_locked_super+0x45/0x60
  [<ffffffff81163cfa>] deactivate_super+0x4a/0x70
  [<ffffffff8117d446>] mntput_no_expire+0x86/0xe0
  [<ffffffff8117df7f>] sys_umount+0x6f/0x360
  [<ffffffff8103f01b>] system_call_fastpath+0x16/0x1b
 ---[ end trace cce2a341ba3611a7 ]---

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Thomas Gleixner <tglxlinutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug    |    8 ++++++
 lib/percpu_counter.c |   48 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff -puN lib/Kconfig.debug~percpu_counter-add-debugobj-support lib/Kconfig.debug
--- a/lib/Kconfig.debug~percpu_counter-add-debugobj-support
+++ a/lib/Kconfig.debug
@@ -317,6 +317,14 @@ config DEBUG_OBJECTS_RCU_HEAD
 	help
 	  Enable this to turn on debugging of RCU list heads (call_rcu() usage).
 
+config DEBUG_OBJECTS_PERCPU_COUNTER
+	bool "Debug percpu counter objects"
+	depends on DEBUG_OBJECTS
+	help
+	  If you say Y here, additional code will be inserted into the
+	  percpu counter routines to track the life time of percpu counter
+	  objects and validate the percpu counter operations.
+
 config DEBUG_OBJECTS_ENABLE_DEFAULT
 	int "debug_objects bootup default value (0-1)"
         range 0 1
diff -puN lib/percpu_counter.c~percpu_counter-add-debugobj-support lib/percpu_counter.c
--- a/lib/percpu_counter.c~percpu_counter-add-debugobj-support
+++ a/lib/percpu_counter.c
@@ -8,10 +8,53 @@
 #include <linux/init.h>
 #include <linux/cpu.h>
 #include <linux/module.h>
+#include <linux/debugobjects.h>
 
 static LIST_HEAD(percpu_counters);
 static DEFINE_MUTEX(percpu_counters_lock);
 
+#ifdef CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER
+
+static struct debug_obj_descr percpu_counter_debug_descr;
+
+static int percpu_counter_fixup_free(void *addr, enum debug_obj_state state)
+{
+	struct percpu_counter *fbc = addr;
+
+	switch (state) {
+	case ODEBUG_STATE_ACTIVE:
+		percpu_counter_destroy(fbc);
+		debug_object_free(fbc, &percpu_counter_debug_descr);
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+static struct debug_obj_descr percpu_counter_debug_descr = {
+	.name		= "percpu_counter",
+	.fixup_free	= percpu_counter_fixup_free,
+};
+
+static inline void debug_percpu_counter_activate(struct percpu_counter *fbc)
+{
+	debug_object_init(fbc, &percpu_counter_debug_descr);
+	debug_object_activate(fbc, &percpu_counter_debug_descr);
+}
+
+static inline void debug_percpu_counter_deactivate(struct percpu_counter *fbc)
+{
+	debug_object_deactivate(fbc, &percpu_counter_debug_descr);
+	debug_object_free(fbc, &percpu_counter_debug_descr);
+}
+
+#else	/* CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER */
+static inline void debug_percpu_counter_activate(struct percpu_counter *fbc)
+{ }
+static inline void debug_percpu_counter_deactivate(struct percpu_counter *fbc)
+{ }
+#endif	/* CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER */
+
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
 {
 	int cpu;
@@ -75,6 +118,9 @@ int __percpu_counter_init(struct percpu_
 	fbc->counters = alloc_percpu(s32);
 	if (!fbc->counters)
 		return -ENOMEM;
+
+	debug_percpu_counter_activate(fbc);
+
 #ifdef CONFIG_HOTPLUG_CPU
 	INIT_LIST_HEAD(&fbc->list);
 	mutex_lock(&percpu_counters_lock);
@@ -90,6 +136,8 @@ void percpu_counter_destroy(struct percp
 	if (!fbc->counters)
 		return;
 
+	debug_percpu_counter_deactivate(fbc);
+
 #ifdef CONFIG_HOTPLUG_CPU
 	mutex_lock(&percpu_counters_lock);
 	list_del(&fbc->list);
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
percpu-fix-list_head-init-bug-in-__percpu_counter_init.patch
kernel-modulesc-fix-warning.patch
stop_machine-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
percpu_counter-add-debugobj-support.patch
pps-trivial-fixes.patch
pps-declare-variables-where-they-are-used-in-switch.patch
pps-fix-race-in-pps_fetch-handler.patch
pps-unify-timestamp-gathering.patch
pps-access-pps-device-by-direct-pointer.patch
pps-convert-printk-pr_-to-dev_.patch
pps-move-idr-stuff-to-ppsc.patch
pps-add-async-pps-event-handler.patch
pps-add-async-pps-event-handler-fix.patch
pps-dont-disable-interrupts-when-using-spin-locks.patch
pps-use-bug_on-for-kernel-api-safety-checks.patch
pps-simplify-conditions-a-bit.patch
ntp-add-hardpps-implementation.patch
pps-capture-monotonic_raw-timestamps-as-well.patch
pps-add-kernel-consumer-support.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-signal-generator.patch

