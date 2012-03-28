From: akpm@linux-foundation.org
Subject: [folded] mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-update.patch removed from -mm tree
Date: Wed, 28 Mar 2012 14:32:15 -0700
Message-ID: <20120328213215.7AE93A0496@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:54683 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068Ab2C1VcQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Mar 2012 17:32:16 -0400
Received: by ghbz15 with SMTP id z15so193300ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Mar 2012 14:32:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gilad@benyossef.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-update
has been removed from the -mm tree.  Its filename was
     mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-update.patch

This patch was dropped because it was folded into mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-update

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-update mm/page_alloc.c
--- a/mm/page_alloc.c~mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-update
+++ a/mm/page_alloc.c
@@ -1174,7 +1174,13 @@ void drain_local_pages(void *arg)
 }
 
 /*
- * Spill all the per-cpu pages from all CPUs back into the buddy allocator
+ * Spill all the per-cpu pages from all CPUs back into the buddy allocator.
+ *
+ * Note that this code is protected against sending an IPI to an offline
+ * CPU but does not guarantee sending an IPI to newly hotplugged CPUs:
+ * on_each_cpu_mask() blocks hotplug and won't talk to offlined CPUs but
+ * nothing keeps CPUs from showing up after we populated the cpumask and
+ * before the call to on_each_cpu_mask().
  */
 void drain_all_pages(void)
 {
_

Patches currently in -mm which might be from gilad@benyossef.com are

smp-introduce-a-generic-on_each_cpu_mask-function.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch
fs-only-send-ipi-to-invalidate-lru-bh-when-needed.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-v9.patch

