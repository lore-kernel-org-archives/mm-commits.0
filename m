From: akpm@linux-foundation.org
Subject: + parisc-update-comments-refereing-to-__get_cpu_var.patch added
 to -mm tree
Date: Tue, 02 Dec 2014 13:27:57 -0800
Message-ID: <547e2edd.PypnTmoG21ApjES9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933089AbaLBV16 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2014 16:27:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, James.Bottomley@HansenPartnership.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: parisc: percpu: update comments refereing to __get_cpu_var
has been added to the -mm tree.  Its filename is
     parisc-update-comments-refereing-to-__get_cpu_var.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/parisc-update-comments-refereing-to-__get_cpu_var.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/parisc-update-comments-refereing-to-__get_cpu_var.patch

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
Subject: parisc: percpu: update comments refereing to __get_cpu_var

__get_cpu_var was removed. Update comments to refer to
this_cpu_ptr() instead.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/lib/fixup.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/parisc/lib/fixup.S~parisc-update-comments-refereing-to-__get_cpu_var arch/parisc/lib/fixup.S
--- a/arch/parisc/lib/fixup.S~parisc-update-comments-refereing-to-__get_cpu_var
+++ a/arch/parisc/lib/fixup.S
@@ -38,14 +38,14 @@
 	LDREGX \t2(\t1),\t2 
 	addil LT%exception_data,%r27
 	LDREG RT%exception_data(%r1),\t1
-	/* t1 = &__get_cpu_var(exception_data) */
+	/* t1 = this_cpu_ptr(&exception_data) */
 	add,l \t1,\t2,\t1
 	/* t1 = t1->fault_ip */
 	LDREG EXCDATA_IP(\t1), \t1
 	.endm
 #else
 	.macro  get_fault_ip t1 t2
-	/* t1 = &__get_cpu_var(exception_data) */
+	/* t1 = this_cpu_ptr(&exception_data) */
 	addil LT%exception_data,%r27
 	LDREG RT%exception_data(%r1),\t2
 	/* t1 = t2->fault_ip */
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

