From: akpm@linux-foundation.org
Subject: + mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-update.patch added to -mm tree
Date: Mon, 06 Feb 2012 15:31:11 -0800
Message-ID: <20120206233111.D7BACA01F8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:39524 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab2BFXbM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 18:31:12 -0500
Received: by yhgm50 with SMTP id m50so704886yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 06 Feb 2012 15:31:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gilad@benyossef.com


The patch titled
     Subject: mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-update
has been added to the -mm tree.  Its filename is
     mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-update

Patches currently in -mm which might be from gilad@benyossef.com are

smp-introduce-a-generic-on_each_cpu_mask-function.patch
arm-move-arm-over-to-generic-on_each_cpu_mask.patch
tile-move-tile-to-use-generic-on_each_cpu_mask.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-update.patch
slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch
fs-only-send-ipi-to-invalidate-lru-bh-when-needed.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-update.patch

