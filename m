From: akpm@linux-foundation.org
Subject: + mm-tune-vm_committed_as-percpu_counter-batching-size.patch
 added to -mm tree
Date: Wed, 29 May 2013 12:26:11 -0700
Message-ID: <51a65653.0CnBkuB8wd64e0Lz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966032Ab3E2T0M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 May 2013 15:26:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, eric.dumazet@gmail.com, dave.hansen@intel.com, ak@linux.intel.com, tim.c.chen@linux.intel.com

Subject: + mm-tune-vm_committed_as-percpu_counter-batching-size.patch added to -mm tree
To: tim.c.chen@linux.intel.com,ak@linux.intel.com,dave.hansen@intel.com,eric.dumazet@gmail.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 29 May 2013 12:26:11 -0700


The patch titled
     Subject: mm: tune vm_committed_as percpu_counter batching size
has been added to the -mm tree.  Its filename is
     mm-tune-vm_committed_as-percpu_counter-batching-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: mm: tune vm_committed_as percpu_counter batching size

Currently the per cpu counter's batch size for memory accounting is
configured as twice the number of cpus in the system.  However, for system
with very large memory, it is more appropriate to make it proportional to
the memory size per cpu in the system.

For example, for a x86_64 system with 64 cpus and 128 GB of memory, the
batch size is only 2*64 pages (0.5 MB).  So any memory accounting changes
of more than 0.5MB will overflow the per cpu counter into the global
counter.  Instead, for the new scheme, the batch size is configured to be
0.4% of the memory/cpu = 8MB (128 GB/64 /256), which is more inline with
the memory size.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mman.h |    8 ++++++
 mm/mm_init.c         |   47 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 1 deletion(-)

diff -puN include/linux/mman.h~mm-tune-vm_committed_as-percpu_counter-batching-size include/linux/mman.h
--- a/include/linux/mman.h~mm-tune-vm_committed_as-percpu_counter-batching-size
+++ a/include/linux/mman.h
@@ -11,11 +11,17 @@ extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
 extern struct percpu_counter vm_committed_as;
 
+#ifdef CONFIG_SMP
+extern s32 vm_committed_as_batch;
+#else
+#define vm_committed_as_batch 0
+#endif
+
 unsigned long vm_memory_committed(void);
 
 static inline void vm_acct_memory(long pages)
 {
-	percpu_counter_add(&vm_committed_as, pages);
+	__percpu_counter_add(&vm_committed_as, pages, vm_committed_as_batch);
 }
 
 static inline void vm_unacct_memory(long pages)
diff -puN mm/mm_init.c~mm-tune-vm_committed_as-percpu_counter-batching-size mm/mm_init.c
--- a/mm/mm_init.c~mm-tune-vm_committed_as-percpu_counter-batching-size
+++ a/mm/mm_init.c
@@ -9,6 +9,8 @@
 #include <linux/init.h>
 #include <linux/kobject.h>
 #include <linux/export.h>
+#include <linux/memory.h>
+#include <linux/notifier.h>
 #include "internal.h"
 
 #ifdef CONFIG_DEBUG_MEMORY_INIT
@@ -147,6 +149,51 @@ early_param("mminit_loglevel", set_mmini
 struct kobject *mm_kobj;
 EXPORT_SYMBOL_GPL(mm_kobj);
 
+#ifdef CONFIG_SMP
+s32 vm_committed_as_batch = 32;
+
+static void __meminit mm_compute_batch(void)
+{
+	u64 memsized_batch;
+	s32 nr = num_present_cpus();
+	s32 batch = max_t(s32, nr*2, 32);
+
+	/* batch size set to 0.4% of (total memory/#cpus), or max int32 */
+	memsized_batch = min_t(u64, (totalram_pages/nr)/256, 0x7fffffff);
+
+	vm_committed_as_batch = max_t(s32, memsized_batch, batch);
+}
+
+static int __meminit mm_compute_batch_notifier(struct notifier_block *self,
+					unsigned long action, void *arg)
+{
+	switch (action) {
+	case MEM_ONLINE:
+	case MEM_OFFLINE:
+		mm_compute_batch();
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block compute_batch_nb = {
+	.notifier_call = mm_compute_batch_notifier,
+	.priority = IPC_CALLBACK_PRI, /* use lowest priority */
+};
+
+static int __init mm_compute_batch_init(void)
+{
+	mm_compute_batch();
+	register_hotmemory_notifier(&compute_batch_nb);
+
+	return 0;
+}
+
+__initcall(mm_compute_batch_init);
+
+#endif
+
 static int __init mm_sysfs_init(void)
 {
 	mm_kobj = kobject_create_and_add("mm", kernel_kobj);
_

Patches currently in -mm which might be from tim.c.chen@linux.intel.com are

origin.patch
linux-next.patch
mm-tune-vm_committed_as-percpu_counter-batching-size.patch

