From: akpm@linux-foundation.org
Subject: + update-local_opstxt-to-reflect-this_cpu-operations.patch added
 to -mm tree
Date: Tue, 02 Dec 2014 13:27:53 -0800
Message-ID: <547e2ed9.p0kf1Y4VPJwbsVGB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932844AbaLBV1y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2014 16:27:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: percpu: update local_ops.txt to reflect this_cpu operations
has been added to the -mm tree.  Its filename is
     update-local_opstxt-to-reflect-this_cpu-operations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/update-local_opstxt-to-reflect-this_cpu-operations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/update-local_opstxt-to-reflect-this_cpu-operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: percpu: update local_ops.txt to reflect this_cpu operations

Update the documentation to reflect changes due to the availability of
this_cpu operations.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/local_ops.txt |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN Documentation/local_ops.txt~update-local_opstxt-to-reflect-this_cpu-operations Documentation/local_ops.txt
--- a/Documentation/local_ops.txt~update-local_opstxt-to-reflect-this_cpu-operations
+++ a/Documentation/local_ops.txt
@@ -8,6 +8,11 @@ to implement them for any given architec
 properly. It also stresses on the precautions that must be taken when reading
 those local variables across CPUs when the order of memory writes matters.
 
+Note that local_t based operations are not recommended for general kernel use.
+Please use the this_cpu operations instead unless there is really a special purpose.
+Most uses of local_t in the kernel have been replaced by this_cpu operations.
+this_cpu operations combine the relocation with the local_t like semantics in
+a single instruction and yield more compact and faster executing code.
 
 
 * Purpose of local atomic operations
@@ -87,10 +92,10 @@ the per cpu variable. For instance :
 	local_inc(&get_cpu_var(counters));
 	put_cpu_var(counters);
 
-If you are already in a preemption-safe context, you can directly use
-__get_cpu_var() instead.
+If you are already in a preemption-safe context, you can use
+this_cpu_ptr() instead.
 
-	local_inc(&__get_cpu_var(counters));
+	local_inc(this_cpu_ptr(&counters));
 
 
 
@@ -134,7 +139,7 @@ static void test_each(void *info)
 {
 	/* Increment the counter from a non preemptible context */
 	printk("Increment on cpu %d\n", smp_processor_id());
-	local_inc(&__get_cpu_var(counters));
+	local_inc(this_cpu_ptr(&counters));
 
 	/* This is what incrementing the variable would look like within a
 	 * preemptible context (it disables preemption) :
_

Patches currently in -mm which might be from cl@linux.com are

origin.patch
mm-slab-slub-coding-style-whitespaces-and-tabs-mixture.patch
slab-print-slabinfo-header-in-seq-show.patch
mm-slab-reverse-iteration-on-find_mergeable.patch
mm-slub-fix-format-mismatches-in-slab_err-callers.patch
slab-improve-checking-for-invalid-gfp_flags.patch
slab-replace-smp_read_barrier_depends-with-lockless_dereference.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking-fix.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-always-update-cached-scanner-positions-fix.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
mm-compaction-more-focused-lru-and-pcplists-draining-fix.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch
linux-next.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch
remove-__get_cpu_var-and-__raw_get_cpu_var-macros.patch
update-local_opstxt-to-reflect-this_cpu-operations.patch
ia64-update-comment-that-references-__get_cpu_var.patch
parisc-update-comments-refereing-to-__get_cpu_var.patch

