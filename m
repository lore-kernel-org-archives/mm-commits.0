From: akpm@linux-foundation.org
Subject: + mm-drain-percpu-lru-add-rotate-page-vectors-on-cpu-hot-unplug.patch added to -mm tree
Date: Wed, 29 Feb 2012 12:38:36 -0800
Message-ID: <20120229203836.BA902A02DD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:62559 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab2B2Uij (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Feb 2012 15:38:39 -0500
Received: by bkcjm19 with SMTP id jm19so32707bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 29 Feb 2012 12:38:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, cl@linux-foundation.org, dave@linux.vnet.ibm.com, ebmunson@us.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     Subject: mm: drain percpu lru add/rotate page-vectors on cpu hot-unplug
has been added to the -mm tree.  Its filename is
     mm-drain-percpu-lru-add-rotate-page-vectors-on-cpu-hot-unplug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: drain percpu lru add/rotate page-vectors on cpu hot-unplug

This cpu hotplug hook was accidentally removed in commit
v2.6.30-rc4-18-g00a62ce ("mm: fix Committed_AS underflow on large NR_CPUS
environment")

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Eric B Munson <ebmunson@us.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 +
 mm/page_alloc.c      |    1 +
 mm/swap.c            |    4 ++--
 3 files changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/swap.h~mm-drain-percpu-lru-add-rotate-page-vectors-on-cpu-hot-unplug include/linux/swap.h
--- a/include/linux/swap.h~mm-drain-percpu-lru-add-rotate-page-vectors-on-cpu-hot-unplug
+++ a/include/linux/swap.h
@@ -227,6 +227,7 @@ extern void lru_add_page_tail(struct zon
 extern void activate_page(struct page *);
 extern void mark_page_accessed(struct page *);
 extern void lru_add_drain(void);
+extern void lru_add_drain_cpu(int cpu);
 extern int lru_add_drain_all(void);
 extern void rotate_reclaimable_page(struct page *page);
 extern void deactivate_page(struct page *page);
diff -puN mm/page_alloc.c~mm-drain-percpu-lru-add-rotate-page-vectors-on-cpu-hot-unplug mm/page_alloc.c
--- a/mm/page_alloc.c~mm-drain-percpu-lru-add-rotate-page-vectors-on-cpu-hot-unplug
+++ a/mm/page_alloc.c
@@ -4825,6 +4825,7 @@ static int page_alloc_cpu_notify(struct 
 	int cpu = (unsigned long)hcpu;
 
 	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
+		lru_add_drain_cpu(cpu);
 		drain_pages(cpu);
 
 		/*
diff -puN mm/swap.c~mm-drain-percpu-lru-add-rotate-page-vectors-on-cpu-hot-unplug mm/swap.c
--- a/mm/swap.c~mm-drain-percpu-lru-add-rotate-page-vectors-on-cpu-hot-unplug
+++ a/mm/swap.c
@@ -496,7 +496,7 @@ static void lru_deactivate_fn(struct pag
  * Either "cpu" is the current CPU, and preemption has already been
  * disabled; or "cpu" is being hot-unplugged, and is already dead.
  */
-static void drain_cpu_pagevecs(int cpu)
+void lru_add_drain_cpu(int cpu)
 {
 	struct pagevec *pvecs = per_cpu(lru_add_pvecs, cpu);
 	struct pagevec *pvec;
@@ -553,7 +553,7 @@ void deactivate_page(struct page *page)
 
 void lru_add_drain(void)
 {
-	drain_cpu_pagevecs(get_cpu());
+	lru_add_drain_cpu(get_cpu());
 	put_cpu();
 }
 
_
Subject: Subject: mm: drain percpu lru add/rotate page-vectors on cpu hot-unplug

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
mm-add-rss-counters-consistency-check.patch
mm-make-get_mm_counter-static-inline.patch
mm-replace-page_migration-with-is_enabledconfig_migration.patch
mm-drain-percpu-lru-add-rotate-page-vectors-on-cpu-hot-unplug.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
memcg-kill-dead-prev_priority-stubs.patch

