From: akpm@linux-foundation.org
Subject: + cpuset-fix-regression-when-failed-to-generate-sched-domains.patch added to -mm tree
Date: Mon, 17 Nov 2008 22:21:33 -0800
Message-ID: <200811180621.mAI6LXju009679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761AbYKRGV6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Nov 2008 01:21:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, maxk@qualcomm.com, mingo@elte.hu, stable@kernel.org


The patch titled
     cpuset: fix regression when failed to generate sched domains
has been added to the -mm tree.  Its filename is
     cpuset-fix-regression-when-failed-to-generate-sched-domains.patch

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
Subject: cpuset: fix regression when failed to generate sched domains
From: Li Zefan <lizf@cn.fujitsu.com>

When cpuset failed to generate sched domains due to kmalloc() failure, the
scheduler should fallback to the single partition 'fallback_doms' and
rebuild sched domains, but now it only destroys but not rebuilds sched
domains.

The regression is introduced by:

commit dfb512ec4834116124da61d6c1ee10fd0aa32bd6
Author: Max Krasnyansky <maxk@qualcomm.com>
Date:   Fri Aug 29 13:11:41 2008 -0700

    sched: arch_reinit_sched_domains() must destroy domains to force rebuild

After the above commit, partition_sched_domains(0, NULL, NULL) will
only destroy sched domains and partition_sched_domains(1, NULL, NULL)
will create the default sched domain.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>		[2.6.27.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   12 ++++++++----
 kernel/sched.c  |   13 +++++++------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff -puN kernel/cpuset.c~cpuset-fix-regression-when-failed-to-generate-sched-domains kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-fix-regression-when-failed-to-generate-sched-domains
+++ a/kernel/cpuset.c
@@ -588,7 +588,6 @@ static int generate_sched_domains(cpumas
 	int ndoms;		/* number of sched domains in result */
 	int nslot;		/* next empty doms[] cpumask_t slot */
 
-	ndoms = 0;
 	doms = NULL;
 	dattr = NULL;
 	csa = NULL;
@@ -675,10 +674,8 @@ restart:
 	 * Convert <csn, csa> to <ndoms, doms> and populate cpu masks.
 	 */
 	doms = kmalloc(ndoms * sizeof(cpumask_t), GFP_KERNEL);
-	if (!doms) {
-		ndoms = 0;
+	if (!doms)
 		goto done;
-	}
 
 	/*
 	 * The rest of the code, including the scheduler, can deal with
@@ -733,6 +730,13 @@ restart:
 done:
 	kfree(csa);
 
+	/*
+	 * Fallback to the default domain if kmalloc() failed.
+	 * See comments in partition_sched_domains().
+	 */
+	if (doms == NULL)
+		ndoms = 1;
+
 	*domains    = doms;
 	*attributes = dattr;
 	return ndoms;
diff -puN kernel/sched.c~cpuset-fix-regression-when-failed-to-generate-sched-domains kernel/sched.c
--- a/kernel/sched.c~cpuset-fix-regression-when-failed-to-generate-sched-domains
+++ a/kernel/sched.c
@@ -7798,13 +7798,14 @@ static int dattrs_equal(struct sched_dom
  *
  * The passed in 'doms_new' should be kmalloc'd. This routine takes
  * ownership of it and will kfree it when done with it. If the caller
- * failed the kmalloc call, then it can pass in doms_new == NULL,
- * and partition_sched_domains() will fallback to the single partition
- * 'fallback_doms', it also forces the domains to be rebuilt.
+ * failed the kmalloc call, then it can pass in doms_new == NULL &&
+ * ndoms_new == 1, and partition_sched_domains() will fallback to
+ * the single partition 'fallback_doms', it also forces the domains
+ * to be rebuilt.
  *
- * If doms_new==NULL it will be replaced with cpu_online_map.
- * ndoms_new==0 is a special case for destroying existing domains.
- * It will not create the default domain.
+ * If doms_new == NULL it will be replaced with cpu_online_map.
+ * ndoms_new == 0 is a special case for destroying existing domains,
+ * and it will not create the default domain.
  *
  * Call with hotplug lock held
  */
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

linux-next.patch
cgroup-fix-potential-deadlock-in-pre_destroy-v2.patch
cpuset-fix-regression-when-failed-to-generate-sched-domains.patch
memcg-memory-hotplug-fix-for-notifier-callback.patch
memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-handle-swap-caches.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-swap-cgroup-for-remembering-usage-fix.patch
memcg-swap-cgroup-for-remembering-usage-fix-2.patch
memcg-swap-cgroup-for-remembering-usage-fix-3.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-synchronized-lru.patch
memcg-add-mem_cgroup_disabled.patch
memcg-add-mem_cgroup_disabled-fix.patch

