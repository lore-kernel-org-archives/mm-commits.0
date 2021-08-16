Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6587AC4338F
	for <mm-commits@archiver.kernel.org>; Mon, 16 Aug 2021 20:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49A0C60F55
	for <mm-commits@archiver.kernel.org>; Mon, 16 Aug 2021 20:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhHPUff (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Aug 2021 16:35:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231748AbhHPUfe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Aug 2021 16:35:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96E3B60F46;
        Mon, 16 Aug 2021 20:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629146102;
        bh=jaMmKOuf7B+xixpeGSvw39Z97dM2bM7T060oLBIdzG0=;
        h=Date:From:To:Subject:From;
        b=p3COeQqu8t5lSP+Ig+3LMlzdly1qQu0I8rDqDrYB3qzk+/6t2eFqcXLDD0Dbx2AFb
         ek6fk/fWT2f/24gwj+YjAgxSOzz0q8kkNKeelgs/PxmdtaeeZl4bSSTzum4HIg5Sg3
         7/a+t/G3dWI+lu/+6v6y8FAVPxHJPTeEamf+IjyM=
Date:   Mon, 16 Aug 2021 13:35:02 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, vbabka@suse.cz,
        vinmenon@codeaurora.org, vjitta@codeaurora.org
Subject:  [merged]
 mm-slub-fix-slub_debug-disablement-for-list-of-slabs.patch removed from -mm
 tree
Message-ID: <20210816203502.-0qRv_WiD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slub: fix slub_debug disabling for list of slabs
has been removed from the -mm tree.  Its filename was
     mm-slub-fix-slub_debug-disablement-for-list-of-slabs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: slub: fix slub_debug disabling for list of slabs

Vijayanand Jitta reports:

  Consider the scenario where CONFIG_SLUB_DEBUG_ON is set
  and we would want to disable slub_debug for few slabs.
  Using boot parameter with slub_debug=-,slab_name syntax
  doesn't work as expected i.e; only disabling debugging for
  the specified list of slabs. Instead it disables debugging
  for all slabs, which is wrong.

This patch fixes it by delaying the moment when the global slub_debug
flags variable is updated.  In case a "slub_debug=-,slab_name" has been
passed, the global flags remain as initialized (depending on
CONFIG_SLUB_DEBUG_ON enabled or disabled) and are not simply reset to 0.

Link: https://lkml.kernel.org/r/8a3d992a-473a-467b-28a0-4ad2ff60ab82@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Vijayanand Jitta <vjitta@codeaurora.org>
Reviewed-by: Vijayanand Jitta <vjitta@codeaurora.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/slub.c~mm-slub-fix-slub_debug-disablement-for-list-of-slabs
+++ a/mm/slub.c
@@ -1400,12 +1400,13 @@ check_slabs:
 static int __init setup_slub_debug(char *str)
 {
 	slab_flags_t flags;
+	slab_flags_t global_flags;
 	char *saved_str;
 	char *slab_list;
 	bool global_slub_debug_changed = false;
 	bool slab_list_specified = false;
 
-	slub_debug = DEBUG_DEFAULT_FLAGS;
+	global_flags = DEBUG_DEFAULT_FLAGS;
 	if (*str++ != '=' || !*str)
 		/*
 		 * No options specified. Switch on full debugging.
@@ -1417,7 +1418,7 @@ static int __init setup_slub_debug(char
 		str = parse_slub_debug_flags(str, &flags, &slab_list, true);
 
 		if (!slab_list) {
-			slub_debug = flags;
+			global_flags = flags;
 			global_slub_debug_changed = true;
 		} else {
 			slab_list_specified = true;
@@ -1426,16 +1427,18 @@ static int __init setup_slub_debug(char
 
 	/*
 	 * For backwards compatibility, a single list of flags with list of
-	 * slabs means debugging is only enabled for those slabs, so the global
-	 * slub_debug should be 0. We can extended that to multiple lists as
+	 * slabs means debugging is only changed for those slabs, so the global
+	 * slub_debug should be unchanged (0 or DEBUG_DEFAULT_FLAGS, depending
+	 * on CONFIG_SLUB_DEBUG_ON). We can extended that to multiple lists as
 	 * long as there is no option specifying flags without a slab list.
 	 */
 	if (slab_list_specified) {
 		if (!global_slub_debug_changed)
-			slub_debug = 0;
+			global_flags = slub_debug;
 		slub_debug_string = saved_str;
 	}
 out:
+	slub_debug = global_flags;
 	if (slub_debug != 0 || slub_debug_string)
 		static_branch_enable(&slub_debug_enabled);
 	else
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-dont-call-flush_all-from-slab_debug_trace_open.patch
mm-slub-allocate-private-object-map-for-debugfs-listings.patch
mm-slub-allocate-private-object-map-for-validate_slab_cache.patch
mm-slub-dont-disable-irq-for-debug_check_no_locks_freed.patch
mm-slub-remove-redundant-unfreeze_partials-from-put_cpu_partial.patch
mm-slub-unify-cmpxchg_double_slab-and-__cmpxchg_double_slab.patch
mm-slub-extract-get_partial-from-new_slab_objects.patch
mm-slub-dissolve-new_slab_objects-into-___slab_alloc.patch
mm-slub-return-slab-page-from-get_partial-and-set-c-page-afterwards.patch
mm-slub-restructure-new-page-checks-in-___slab_alloc.patch
mm-slub-simplify-kmem_cache_cpu-and-tid-setup.patch
mm-slub-move-disabling-enabling-irqs-to-___slab_alloc.patch
mm-slub-do-initial-checks-in-___slab_alloc-with-irqs-enabled.patch
mm-slub-move-disabling-irqs-closer-to-get_partial-in-___slab_alloc.patch
mm-slub-restore-irqs-around-calling-new_slab.patch
mm-slub-validate-slab-from-partial-list-or-page-allocator-before-making-it-cpu-slab.patch
mm-slub-check-new-pages-with-restored-irqs.patch
mm-slub-stop-disabling-irqs-around-get_partial.patch
mm-slub-move-reset-of-c-page-and-freelist-out-of-deactivate_slab.patch
mm-slub-make-locking-in-deactivate_slab-irq-safe.patch
mm-slub-call-deactivate_slab-without-disabling-irqs.patch
mm-slub-move-irq-control-into-unfreeze_partials.patch
mm-slub-discard-slabs-in-unfreeze_partials-without-irqs-disabled.patch
mm-slub-detach-whole-partial-list-at-once-in-unfreeze_partials.patch
mm-slub-separate-detaching-of-partial-list-in-unfreeze_partials-from-unfreezing.patch
mm-slub-only-disable-irq-with-spin_lock-in-__unfreeze_partials.patch
mm-slub-dont-disable-irqs-in-slub_cpu_dead.patch
mm-slab-make-flush_slab-possible-to-call-with-irqs-enabled.patch
mm-slub-move-flush_cpu_slab-invocations-__free_slab-invocations-out-of-irq-context-fix.patch
mm-slub-move-flush_cpu_slab-invocations-__free_slab-invocations-out-of-irq-context-fix-2.patch
mm-slub-optionally-save-restore-irqs-in-slab_lock.patch
mm-slub-make-slab_lock-disable-irqs-with-preempt_rt.patch
mm-slub-protect-put_cpu_partial-with-disabled-irqs-instead-of-cmpxchg.patch
mm-slub-use-migrate_disable-on-preempt_rt.patch
mm-slub-convert-kmem_cpu_slab-protection-to-local_lock.patch

