From: akpm@linux-foundation.org
Subject: +
 slub-limit-count-of-partial-slabs-scanned-to-gather-statistics.patch added
 to -mm tree
Date: Mon, 04 May 2020 12:57:30 -0700
Message-ID: <20200504195730.3XXBIk2n_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbgEDT5d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 May 2020 15:57:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, iamjoonsoo.kim@lge.com, khlebnikov@yandex-team.ru, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com


The patch titled
     Subject: slub: limit count of partial slabs scanned to gather statistics
has been added to the -mm tree.  Its filename is
     slub-limit-count-of-partial-slabs-scanned-to-gather-statistics.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-limit-count-of-partial-slabs-scanned-to-gather-statistics.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-limit-count-of-partial-slabs-scanned-to-gather-statistics.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: slub: limit count of partial slabs scanned to gather statistics

To get exact count of free and used objects slub have to scan list of
partial slabs.  This may take at long time.  Scanning holds spinlock and
blocks allocations which move partial slabs to per-cpu lists and back.

Example found in the wild:

# cat /sys/kernel/slab/dentry/partial
14478538 N0=7329569 N1=7148969
# time cat /sys/kernel/slab/dentry/objects
286225471 N0=136967768 N1=149257703

real	0m1.722s
user	0m0.001s
sys	0m1.721s

The same problem in slab was addressed in commit f728b0a5d72a ("mm, slab:
faster active and free stats") by adding more kmem cache statistics.  For
slub same approach requires atomic op on fast path when object frees.

Let's simply limit count of scanned slabs and print warning.  Limit set in
/sys/module/slub/parameters/max_partial_to_count.  Default is 10000 which
should be enough for most sane cases.

Return linear approximation if list of partials is longer than limit. 
Nobody should notice difference.

Link: http://lkml.kernel.org/r/158860845968.33385.4165926113074799048.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/mm/slub.c~slub-limit-count-of-partial-slabs-scanned-to-gather-statistics
+++ a/mm/slub.c
@@ -2451,16 +2451,29 @@ static inline unsigned long node_nr_objs
 #endif /* CONFIG_SLUB_DEBUG */
 
 #if defined(CONFIG_SLUB_DEBUG) || defined(CONFIG_SYSFS)
+
+static unsigned long max_partial_to_count __read_mostly = 10000;
+module_param(max_partial_to_count, ulong, 0644);
+
 static unsigned long count_partial(struct kmem_cache_node *n,
 					int (*get_count)(struct page *))
 {
+	unsigned long counted = 0;
 	unsigned long flags;
 	unsigned long x = 0;
 	struct page *page;
 
 	spin_lock_irqsave(&n->list_lock, flags);
-	list_for_each_entry(page, &n->partial, slab_list)
+	list_for_each_entry(page, &n->partial, slab_list) {
 		x += get_count(page);
+
+		if (++counted > max_partial_to_count) {
+			pr_warn_once("SLUB: too much partial slabs to count all objects, increase max_partial_to_count.\n");
+			/* Approximate total count of objects */
+			x = mult_frac(x, n->nr_partial, counted);
+			break;
+		}
+	}
 	spin_unlock_irqrestore(&n->list_lock, flags);
 	return x;
 }
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

kernel-watchdog-flush-all-printk-nmi-buffers-when-hardlockup-detected.patch
slub-limit-count-of-partial-slabs-scanned-to-gather-statistics.patch
