From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch removed
 from -mm tree
Date: Thu, 06 Jul 2017 15:10:10 -0700
Message-ID: <595eb542.1EceFwiptar/BLm/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58740 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751974AbdGFWKM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:10:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, richard.weiyang@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix
has been removed from the -mm tree.  Its filename was
     mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch

This patch was dropped because it was folded into mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix

avoid strange 80-col tricks

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/slub.c~mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix mm/slub.c
--- a/mm/slub.c~mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix
+++ a/mm/slub.c
@@ -4982,8 +4982,9 @@ static ssize_t slabs_cpu_partial_show(st
 	int len;
 
 	for_each_online_cpu(cpu) {
-		struct page *page =
-			slub_percpu_partial(per_cpu_ptr(s->cpu_slab, cpu));
+		struct page *page;
+
+		page = slub_percpu_partial(per_cpu_ptr(s->cpu_slab, cpu));
 
 		if (page) {
 			pages += page->pages;
@@ -4995,8 +4996,9 @@ static ssize_t slabs_cpu_partial_show(st
 
 #ifdef CONFIG_SMP
 	for_each_online_cpu(cpu) {
-		struct page *page =
-			slub_percpu_partial(per_cpu_ptr(s->cpu_slab, cpu));
+		struct page *page;
+
+		page = slub_percpu_partial(per_cpu_ptr(s->cpu_slab, cpu));
 
 		if (page && len < PAGE_SIZE - 20)
 			len += sprintf(buf + len, " C%d=%d(%d)", cpu,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online-fix-2-fix.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix.patch
mm-swap-sort-swap-entries-before-free-fix.patch

