From: akpm@linux-foundation.org
Subject: +
 hotplug-make-register-and-unregister-notifier-api-symmetric.patch added to
 -mm tree
Date: Wed, 07 Dec 2016 08:56:23 -0800
Message-ID: <58483f37.kwr3sSg/vT5FJn0D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46998 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932511AbcLGQ4Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Dec 2016 11:56:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, ddstreet@ieee.org, stable@vger.kernel.org, tglx@linutronix.de, yuzhao@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hotplug: make register and unregister notifier API symmetric
has been added to the -mm tree.  Its filename is
     hotplug-make-register-and-unregister-notifier-api-symmetric.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hotplug-make-register-and-unregister-notifier-api-symmetric.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hotplug-make-register-and-unregister-notifier-api-symmetric.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: hotplug: make register and unregister notifier API symmetric

Yu Zhao has noticed that __unregister_cpu_notifier() only unregisters its
notifiers when HOTPLUG_CPU=y while the registration might succeed even
when HOTPLUG_CPU=n if MODULE is enabled.  This means that e.g.  zswap
might keep a stale notifier on the list on the manual clean up during the
pool tear down and thus corrupt the list.  Resulting in the following

[  144.964346] BUG: unable to handle kernel paging request at ffff880658a2be78
[  144.971337] IP: [<ffffffffa290b00b>] raw_notifier_chain_register+0x1b/0x40
<snipped>
[  145.122628] Call Trace:
[  145.125086]  [<ffffffffa28e5cf8>] __register_cpu_notifier+0x18/0x20
[  145.131350]  [<ffffffffa2a5dd73>] zswap_pool_create+0x273/0x400
[  145.137268]  [<ffffffffa2a5e0fc>] __zswap_param_set+0x1fc/0x300
[  145.143188]  [<ffffffffa2944c1d>] ? trace_hardirqs_on+0xd/0x10
[  145.149018]  [<ffffffffa2908798>] ? kernel_param_lock+0x28/0x30
[  145.154940]  [<ffffffffa2a3e8cf>] ? __might_fault+0x4f/0xa0
[  145.160511]  [<ffffffffa2a5e237>] zswap_compressor_param_set+0x17/0x20
[  145.167035]  [<ffffffffa2908d3c>] param_attr_store+0x5c/0xb0
[  145.172694]  [<ffffffffa290848d>] module_attr_store+0x1d/0x30
[  145.178443]  [<ffffffffa2b2b41f>] sysfs_kf_write+0x4f/0x70
[  145.183925]  [<ffffffffa2b2a5b9>] kernfs_fop_write+0x149/0x180
[  145.189761]  [<ffffffffa2a99248>] __vfs_write+0x18/0x40
[  145.194982]  [<ffffffffa2a9a412>] vfs_write+0xb2/0x1a0
[  145.200122]  [<ffffffffa2a9a732>] SyS_write+0x52/0xa0
[  145.205177]  [<ffffffffa2ff4d97>] entry_SYSCALL_64_fastpath+0x12/0x17

This can be even triggered manually by changing
/sys/module/zswap/parameters/compressor multiple times.

Fix this issue by making unregister APIs symmetric to the register so
there are no surprises.

Fixes: 47e627bc8c9a ("[PATCH] hotplug: Allow modules to use the cpu hotplug notifiers even if !CONFIG_HOTPLUG_CPU")
Link: http://lkml.kernel.org/r/20161207135438.4310-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Yu Zhao <yuzhao@google.com>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: <stable@vger.kernel.org>	[zswap requires for 4.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu.h |   15 ++++-----------
 kernel/cpu.c        |    2 +-
 2 files changed, 5 insertions(+), 12 deletions(-)

diff -puN include/linux/cpu.h~hotplug-make-register-and-unregister-notifier-api-symmetric include/linux/cpu.h
--- a/include/linux/cpu.h~hotplug-make-register-and-unregister-notifier-api-symmetric
+++ a/include/linux/cpu.h
@@ -93,22 +93,16 @@ extern bool cpuhp_tasks_frozen;
 		{ .notifier_call = fn, .priority = pri };	\
 	__register_cpu_notifier(&fn##_nb);			\
 }
-#else /* #if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE) */
-#define cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
-#define __cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
-#endif /* #else #if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE) */
 
-#ifdef CONFIG_HOTPLUG_CPU
 extern int register_cpu_notifier(struct notifier_block *nb);
 extern int __register_cpu_notifier(struct notifier_block *nb);
 extern void unregister_cpu_notifier(struct notifier_block *nb);
 extern void __unregister_cpu_notifier(struct notifier_block *nb);
-#else
 
-#ifndef MODULE
-extern int register_cpu_notifier(struct notifier_block *nb);
-extern int __register_cpu_notifier(struct notifier_block *nb);
-#else
+#else /* #if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE) */
+#define cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
+#define __cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
+
 static inline int register_cpu_notifier(struct notifier_block *nb)
 {
 	return 0;
@@ -118,7 +112,6 @@ static inline int __register_cpu_notifie
 {
 	return 0;
 }
-#endif
 
 static inline void unregister_cpu_notifier(struct notifier_block *nb)
 {
diff -puN kernel/cpu.c~hotplug-make-register-and-unregister-notifier-api-symmetric kernel/cpu.c
--- a/kernel/cpu.c~hotplug-make-register-and-unregister-notifier-api-symmetric
+++ a/kernel/cpu.c
@@ -659,7 +659,6 @@ void __init cpuhp_threads_init(void)
 	kthread_unpark(this_cpu_read(cpuhp_state.thread));
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
 EXPORT_SYMBOL(register_cpu_notifier);
 EXPORT_SYMBOL(__register_cpu_notifier);
 void unregister_cpu_notifier(struct notifier_block *nb)
@@ -676,6 +675,7 @@ void __unregister_cpu_notifier(struct no
 }
 EXPORT_SYMBOL(__unregister_cpu_notifier);
 
+#ifdef CONFIG_HOTPLUG_CPU
 /**
  * clear_tasks_mm_cpumask - Safely clear tasks' mm_cpumask for a CPU
  * @cpu: a CPU id
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-compaction-allow-compaction-for-gfp_nofs-requests.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist.patch
hotplug-make-register-and-unregister-notifier-api-symmetric.patch

