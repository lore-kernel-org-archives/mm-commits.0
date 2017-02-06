From: akpm@linux-foundation.org
Subject: + cpumask-use-nr_cpumask_bits-for-parsing-functions.patch added
 to -mm tree
Date: Mon, 06 Feb 2017 14:47:20 -0800
Message-ID: <5898fcf8.dyXD85UIli9z8c56%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33186 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751748AbdBFWrV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2017 17:47:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, ben.hutchings@codethink.co.uk, martin.steigerwald@teamix.de, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cpumask: use nr_cpumask_bits for parsing functions
has been added to the -mm tree.  Its filename is
     cpumask-use-nr_cpumask_bits-for-parsing-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cpumask-use-nr_cpumask_bits-for-parsing-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cpumask-use-nr_cpumask_bits-for-parsing-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: cpumask: use nr_cpumask_bits for parsing functions

513e3d2d11c9 ("cpumask: always use nr_cpu_ids in formatting and parsing
functions") converted both cpumask printing and parsing functions to use
nr_cpu_ids instead of nr_cpumask_bits.  While this was okay for the
printing functions as it just picked one of the two output formats that we
were alternating between depending on a kernel config, doing the same for
parsing wasn't okay.

nr_cpumask_bits can be either nr_cpu_ids or NR_CPUS.  We can always use
nr_cpu_ids but that is a variable while NR_CPUS is a constant, so it can
be more efficient to use NR_CPUS when we can get away with it.  Converting
the printing functions to nr_cpu_ids makes sense because it affects how
the masks get presented to userspace and doesn't break anything; however,
using nr_cpu_ids for parsing functions can incorrectly leave the higher
bits uninitialized while reading in these masks from userland.  As all
testing and comparison functions use nr_cpumask_bits which can be larger
than nr_cpu_ids, the parsed cpumasks can erroneously yield false negative
results.

This made the taskstats interface incorrectly return -EINVAL even when the
inputs were correct.

Fix it by restoring the parse functions to use nr_cpumask_bits instead of
nr_cpu_ids.

Link: http://lkml.kernel.org/r/20170206182442.GB31078@htj.duckdns.org
Fixes: 513e3d2d11c9 ("cpumask: always use nr_cpu_ids in formatting and parsing functions")
Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Martin Steigerwald <martin.steigerwald@teamix.de>
Debugged-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc: <stable@vger.kernel.org>	[4.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/cpumask.h~cpumask-use-nr_cpumask_bits-for-parsing-functions include/linux/cpumask.h
--- a/include/linux/cpumask.h~cpumask-use-nr_cpumask_bits-for-parsing-functions
+++ a/include/linux/cpumask.h
@@ -560,7 +560,7 @@ static inline void cpumask_copy(struct c
 static inline int cpumask_parse_user(const char __user *buf, int len,
 				     struct cpumask *dstp)
 {
-	return bitmap_parse_user(buf, len, cpumask_bits(dstp), nr_cpu_ids);
+	return bitmap_parse_user(buf, len, cpumask_bits(dstp), nr_cpumask_bits);
 }
 
 /**
@@ -575,7 +575,7 @@ static inline int cpumask_parselist_user
 				     struct cpumask *dstp)
 {
 	return bitmap_parselist_user(buf, len, cpumask_bits(dstp),
-				     nr_cpu_ids);
+				     nr_cpumask_bits);
 }
 
 /**
@@ -590,7 +590,7 @@ static inline int cpumask_parse(const ch
 	char *nl = strchr(buf, '\n');
 	unsigned int len = nl ? (unsigned int)(nl - buf) : strlen(buf);
 
-	return bitmap_parse(buf, len, cpumask_bits(dstp), nr_cpu_ids);
+	return bitmap_parse(buf, len, cpumask_bits(dstp), nr_cpumask_bits);
 }
 
 /**
@@ -602,7 +602,7 @@ static inline int cpumask_parse(const ch
  */
 static inline int cpulist_parse(const char *buf, struct cpumask *dstp)
 {
-	return bitmap_parselist(buf, cpumask_bits(dstp), nr_cpu_ids);
+	return bitmap_parselist(buf, cpumask_bits(dstp), nr_cpumask_bits);
 }
 
 /**
_

Patches currently in -mm which might be from tj@kernel.org are

cpumask-use-nr_cpumask_bits-for-parsing-functions.patch
revert-slub-move-synchronize_sched-out-of-slab_mutex-on-shrink.patch
slub-separate-out-sysfs_slab_release-from-sysfs_slab_remove.patch
slab-remove-synchronous-rcu_barrier-call-in-memcg-cache-release-path.patch
slab-reorganize-memcg_cache_params.patch
slab-link-memcg-kmem_caches-on-their-associated-memory-cgroup.patch
slab-implement-slab_root_caches-list.patch
slab-introduce-__kmemcg_cache_deactivate.patch
slab-remove-synchronous-synchronize_sched-from-memcg-cache-deactivation-path.patch
slab-remove-slub-sysfs-interface-files-early-for-empty-memcg-caches.patch
slab-use-memcg_kmem_cache_wq-for-slab-destruction-operations.patch

