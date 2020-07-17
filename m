Return-Path: <SRS0=ColI=A4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 265F6C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 20:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0069620704
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 20:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595018944;
	bh=7SmbfJTg4dXryQVkdQyP3mvY1qV5EPnRZE1qLd+jgTo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ygP+h5XxZX/nHS7FBqFvRq88Vlzxj+xEpqXL0ji69ccsMh+x0WiC4lRotO/0lC6/r
	 6ON8AejMWLW9X7in7y9AWCsQlqEo7Sebpf/mvn/P8VOOC2fVlDDbG7/K1HXvNgptWr
	 Pe+JR57/tQDSRViAmw4J5SibZizcDhO2MICXfu4o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgGQUtD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jul 2020 16:49:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbgGQUtD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Jul 2020 16:49:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82C2120691;
        Fri, 17 Jul 2020 20:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595018942;
        bh=7SmbfJTg4dXryQVkdQyP3mvY1qV5EPnRZE1qLd+jgTo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UqDm3OB8rIZDMtEI8GkZ+f1cSbYZROXljxG/ryFP6Dzi/S8f8SRtnzfDdGnPpTrxC
         fqi1agfp4TMxZZ0he7jSACUBIyqueec8enUWrSeEkoE+S6m3B9EGDeKl5Us9sUCOk1
         YZ8OboCPUejIT2tLQGRzZjeDGslOEr4HfoYqcMDM=
Date:   Fri, 17 Jul 2020 13:49:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     guro@fb.com, mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  +
 mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch
 added to -mm tree
Message-ID: <20200717204902.TVUSZsJuX%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix
has been added to the -mm tree.  Its filename is
     mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix

fix warnings

Link: http://lkml.kernel.org/r/20200717174705.GA55916@carbon.DHCP.thefacebook.com
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix
+++ a/mm/vmstat.c
@@ -168,9 +168,12 @@ EXPORT_SYMBOL(vm_numa_stat);
 EXPORT_SYMBOL(vm_node_stat);
 
 #ifdef CONFIG_SMP
-
 #define MAX_THRESHOLD 125
+#else
+#define MAX_THRESHOLD 0
+#endif
 
+#ifdef CONFIG_SMP
 int calculate_pressure_threshold(struct zone *zone)
 {
 	int threshold;
@@ -611,8 +614,6 @@ void dec_node_page_state(struct page *pa
 EXPORT_SYMBOL(dec_node_page_state);
 #else
 
-#define MAX_THRESHOLD 0
-
 /*
  * Use interrupt disable to serialize counter updates
  */
_

Patches currently in -mm which might be from guro@fb.com are

mm-kmem-make-memcg_kmem_enabled-irreversible.patch
mm-memcg-factor-out-memcg-and-lruvec-level-changes-out-of-__mod_lruvec_state.patch
mm-memcg-prepare-for-byte-sized-vmstat-items.patch
mm-memcg-convert-vmstat-slab-counters-to-bytes.patch
mm-slub-implement-slub-version-of-obj_to_index.patch
mm-memcg-slab-obj_cgroup-api.patch
mm-memcg-slab-allocate-obj_cgroups-for-non-root-slab-pages.patch
mm-memcg-slab-save-obj_cgroup-for-non-root-slab-objects.patch
mm-memcg-slab-charge-individual-slab-objects-instead-of-pages.patch
mm-memcg-slab-deprecate-memorykmemslabinfo.patch
mm-memcg-slab-move-memcg_kmem_bypass-to-memcontrolh.patch
mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-accounted-allocations.patch
mm-memcg-slab-simplify-memcg-cache-creation.patch
mm-memcg-slab-remove-memcg_kmem_get_cache.patch
mm-memcg-slab-deprecate-slab_root_caches.patch
mm-memcg-slab-remove-redundant-check-in-memcg_accumulate_slabinfo.patch
mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-allocations.patch
kselftests-cgroup-add-kernel-memory-accounting-tests.patch
tools-cgroup-add-memcg_slabinfopy-tool.patch
percpu-return-number-of-released-bytes-from-pcpu_free_area.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics-v3.patch
mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch
kselftests-cgroup-add-perpcu-memory-accounting-test.patch
mm-memcg-slab-remove-unused-argument-by-charge_slab_page.patch
mm-slab-rename-uncharge_slab_page-to-unaccount_slab_page.patch
mm-kmem-switch-to-static_branch_likely-in-memcg_kmem_enabled.patch
mm-memcontrol-avoid-workload-stalls-when-lowering-memoryhigh.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

