From: akpm@linux-foundation.org
Subject: [merged] cpumask-add-cpumask_var_t-documentation.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:28:56 -0700
Message-ID: <201107271927.p6RJRgiv003234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754864Ab1G0T2E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:28:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, tfransosi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     cpumask: add cpumask_var_t documentation
has been removed from the -mm tree.  Its filename was
     cpumask-add-cpumask_var_t-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpumask: add cpumask_var_t documentation
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

cpumask_var_t has one notable difference from cpumask_t.  Add the
explanation.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Thiago Farina <tfransosi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN include/linux/cpumask.h~cpumask-add-cpumask_var_t-documentation include/linux/cpumask.h
--- a/include/linux/cpumask.h~cpumask-add-cpumask_var_t-documentation
+++ a/include/linux/cpumask.h
@@ -617,6 +617,20 @@ static inline size_t cpumask_size(void)
  *	  ... use 'tmpmask' like a normal struct cpumask * ...
  *
  *	free_cpumask_var(tmpmask);
+ *
+ *
+ * However, one notable exception is there. alloc_cpumask_var() allocates
+ * only nr_cpumask_bits bits (in the other hand, real cpumask_t always has
+ * NR_CPUS bits). Therefore you don't have to dereference cpumask_var_t.
+ *
+ *	cpumask_var_t tmpmask;
+ *	if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL))
+ *		return -ENOMEM;
+ *
+ *	var = *tmpmask;
+ *
+ * This code makes NR_CPUS length memcopy and brings to a memory corruption.
+ * cpumask_copy() provide safe copy functionality.
  */
 #ifdef CONFIG_CPUMASK_OFFSTACK
 typedef struct cpumask *cpumask_var_t;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
slab-use-numa_no_node.patch
kexec-remove-kmsg_dump_kexec.patch

