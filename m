From: akpm@linux-foundation.org
Subject: [merged]
 cpumask-nodemask-implement-cpumask-nodemask_pr_args.patch removed from -mm
 tree
Date: Mon, 16 Feb 2015 12:16:02 -0800
Message-ID: <54e25002.fCY7s0qSF6eRyiBJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50942 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbbBPUQj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:16:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, James.Bottomley@HansenPartnership.com, benh@kernel.crashing.org, chris@zankel.net, cl@linux.com, cmetcalf@tilera.com, davem@davemloft.net, dmitry.torokhov@gmail.com, fenghua.yu@intel.com, gregkh@linuxfoundation.org, jcmvbkbc@gmail.com, linux@arm.linux.org.uk, linville@tuxdriver.com, lizefan@huawei.com, mingo@redhat.com, paulmck@linux.vnet.ibm.com, penberg@kernel.org, peterz@infradead.org, rostedt@goodmis.org, rusty@rustcorp.com.au, steffen.klassert@secunet.com, tglx@linutronix.de, tony.luck@intel.com, travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cpumask, nodemask: implement cpumask/nodemask_pr_args()
has been removed from the -mm tree.  Its filename was
     cpumask-nodemask-implement-cpumask-nodemask_pr_args.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: cpumask, nodemask: implement cpumask/nodemask_pr_args()

printf family of functions can now format bitmaps using '%*pb[l]' and
all cpumask and nodemask formatting will be converted to use it.  To
ease printing these masks with '%*pb[l]' which require two params -
the number of bits and the actual bitmap, this patch implement
cpumask_pr_args() and nodemask_pr_args() which can be used to provide
arguments for '%*pb[l]'

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h  |    8 ++++++++
 include/linux/nodemask.h |    8 ++++++++
 2 files changed, 16 insertions(+)

diff -puN include/linux/cpumask.h~cpumask-nodemask-implement-cpumask-nodemask_pr_args include/linux/cpumask.h
--- a/include/linux/cpumask.h~cpumask-nodemask-implement-cpumask-nodemask_pr_args
+++ a/include/linux/cpumask.h
@@ -22,6 +22,14 @@ typedef struct cpumask { DECLARE_BITMAP(
  */
 #define cpumask_bits(maskp) ((maskp)->bits)
 
+/**
+ * cpumask_pr_args - printf args to output a cpumask
+ * @maskp: cpumask to be printed
+ *
+ * Can be used to provide arguments for '%*pb[l]' when printing a cpumask.
+ */
+#define cpumask_pr_args(maskp)		nr_cpu_ids, cpumask_bits(maskp)
+
 #if NR_CPUS == 1
 #define nr_cpu_ids		1
 #else
diff -puN include/linux/nodemask.h~cpumask-nodemask-implement-cpumask-nodemask_pr_args include/linux/nodemask.h
--- a/include/linux/nodemask.h~cpumask-nodemask-implement-cpumask-nodemask_pr_args
+++ a/include/linux/nodemask.h
@@ -98,6 +98,14 @@
 typedef struct { DECLARE_BITMAP(bits, MAX_NUMNODES); } nodemask_t;
 extern nodemask_t _unused_nodemask_arg_;
 
+/**
+ * nodemask_pr_args - printf args to output a nodemask
+ * @maskp: nodemask to be printed
+ *
+ * Can be used to provide arguments for '%*pb[l]' when printing a nodemask.
+ */
+#define nodemask_pr_args(maskp)		MAX_NUMNODES, (maskp)->bits
+
 /*
  * The inline keyword gives the compiler room to decide to inline, or
  * not inline a function as it sees best.  However, as these functions
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch

