From: akpm@linux-foundation.org
Subject: + remove-__get_cpu_var-and-__raw_get_cpu_var-macros.patch added
 to -mm tree
Date: Tue, 02 Dec 2014 13:27:51 -0800
Message-ID: <547e2ed7.yzBGvnwLCcTagE40%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932844AbaLBV1w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2014 16:27:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: percpu: remove __get_cpu_var and __raw_get_cpu_var macros
has been added to the -mm tree.  Its filename is
     remove-__get_cpu_var-and-__raw_get_cpu_var-macros.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/remove-__get_cpu_var-and-__raw_get_cpu_var-macros.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/remove-__get_cpu_var-and-__raw_get_cpu_var-macros.patch

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
Subject: percpu: remove __get_cpu_var and __raw_get_cpu_var macros

No user is left in the kernel source tree.  Therefore we can drop the
definitions.

This is the final merge of the transition away from __get_cpu_var.  After
this patch the kernel will not build if anyone uses __get_cpu_var.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu-defs.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/percpu-defs.h~remove-__get_cpu_var-and-__raw_get_cpu_var-macros include/linux/percpu-defs.h
--- a/include/linux/percpu-defs.h~remove-__get_cpu_var-and-__raw_get_cpu_var-macros
+++ a/include/linux/percpu-defs.h
@@ -254,8 +254,6 @@ do {									\
 #endif	/* CONFIG_SMP */
 
 #define per_cpu(var, cpu)	(*per_cpu_ptr(&(var), cpu))
-#define __raw_get_cpu_var(var)	(*raw_cpu_ptr(&(var)))
-#define __get_cpu_var(var)	(*this_cpu_ptr(&(var)))
 
 /*
  * Must be an lvalue. Since @var must be a simple identifier,
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

