From: akpm@linux-foundation.org
Subject: + allow-compaction-of-unevictable-pages.patch added to -mm tree
Date: Fri, 20 Mar 2015 15:19:31 -0700
Message-ID: <550c9cf3.qGDjKWLH6fVi98Qt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54071 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbbCTWTc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Mar 2015 18:19:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@akamai.com, cl@linux.com, mgorman@suse.de, mhocko@suse.cz, peterz@infradead.org, riel@redhat.com, rientjes@google.com, tglx@linutronix.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: Allow compaction of unevictable pages
has been added to the -mm tree.  Its filename is
     allow-compaction-of-unevictable-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/allow-compaction-of-unevictable-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/allow-compaction-of-unevictable-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric B Munson <emunson@akamai.com>
Subject: Allow compaction of unevictable pages

Currently, pages which are marked as unevictable are protected from
compaction, but not from other types of migration.  The POSIX real time
extension explicitly states that mlock() will prevent a major page fault,
but the spirit of this is that mlock() should give a process the ability
to control sources of latency, including minor page faults.  However, the
mlock manpage only explicitly says that a locked page will not be written
to swap and this can cause some confusion.  The compaction code today does
not give a developer who wants to avoid swap but wants to have large
contiguous areas available any method to achieve this state.  This patch
introduces a sysctl for controlling compaction behavior with respect to
the unevictable lru.  Users that demand no page faults after a page is
present can set compact_unevictable_allowed to 0 and users who need the
large contiguous areas can enable compaction on locked memory by leaving
the default value of 1.

To illustrate this problem I wrote a quick test program that mmaps a large
number of 1MB files filled with random data.  These maps are created
locked and read only.  Then every other mmap is unmapped and I attempt to
allocate huge pages to the static huge page pool.  When the
compact_unevictable_allowed sysctl is 0, I cannot allocate hugepages after
fragmenting memory.  When the value is set to 1, allocations succeed.

Signed-off-by: Eric B Munson <emunson@akamai.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   11 +++++++++++
 include/linux/compaction.h  |    1 +
 kernel/sysctl.c             |    9 +++++++++
 mm/compaction.c             |    7 +++++++
 4 files changed, 28 insertions(+)

diff -puN Documentation/sysctl/vm.txt~allow-compaction-of-unevictable-pages Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~allow-compaction-of-unevictable-pages
+++ a/Documentation/sysctl/vm.txt
@@ -21,6 +21,7 @@ Currently, these files are in /proc/sys/
 - admin_reserve_kbytes
 - block_dump
 - compact_memory
+- compact_unevictable_allowed
 - dirty_background_bytes
 - dirty_background_ratio
 - dirty_bytes
@@ -106,6 +107,16 @@ huge pages although processes will also
 
 ==============================================================
 
+compact_unevictable_allowed
+
+Available only when CONFIG_COMPACTION is set. When set to 1, compaction is
+allowed to examine the unevictable lru (mlocked pages) for pages to compact.
+This should be used on systems where stalls for minor page faults are an
+acceptable trade for large contiguous free memory.  Set to 0 to prevent
+compaction from moving pages that are unevictable.  Default value is 1.
+
+==============================================================
+
 dirty_background_bytes
 
 Contains the amount of dirty memory at which the background kernel
diff -puN include/linux/compaction.h~allow-compaction-of-unevictable-pages include/linux/compaction.h
--- a/include/linux/compaction.h~allow-compaction-of-unevictable-pages
+++ a/include/linux/compaction.h
@@ -34,6 +34,7 @@ extern int sysctl_compaction_handler(str
 extern int sysctl_extfrag_threshold;
 extern int sysctl_extfrag_handler(struct ctl_table *table, int write,
 			void __user *buffer, size_t *length, loff_t *ppos);
+extern int sysctl_compact_unevictable_allowed;
 
 extern int fragmentation_index(struct zone *zone, unsigned int order);
 extern unsigned long try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
diff -puN kernel/sysctl.c~allow-compaction-of-unevictable-pages kernel/sysctl.c
--- a/kernel/sysctl.c~allow-compaction-of-unevictable-pages
+++ a/kernel/sysctl.c
@@ -1326,6 +1326,15 @@ static struct ctl_table vm_table[] = {
 		.extra1		= &min_extfrag_threshold,
 		.extra2		= &max_extfrag_threshold,
 	},
+	{
+		.procname	= "compact_unevictable_allowed",
+		.data		= &sysctl_compact_unevictable_allowed,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 
 #endif /* CONFIG_COMPACTION */
 	{
diff -puN mm/compaction.c~allow-compaction-of-unevictable-pages mm/compaction.c
--- a/mm/compaction.c~allow-compaction-of-unevictable-pages
+++ a/mm/compaction.c
@@ -1047,6 +1047,12 @@ typedef enum {
 } isolate_migrate_t;
 
 /*
+ * Allow userspace to control policy on scanning the unevictable LRU for
+ * compactable pages.
+ */
+int sysctl_compact_unevictable_allowed __read_mostly = 1;
+
+/*
  * Isolate all pages that can be migrated from the first suitable block,
  * starting at the block pointed to by the migrate scanner pfn within
  * compact_control.
@@ -1057,6 +1063,7 @@ static isolate_migrate_t isolate_migrate
 	unsigned long low_pfn, end_pfn;
 	struct page *page;
 	const isolate_mode_t isolate_mode =
+		(sysctl_compact_unevictable_allowed ? ISOLATE_UNEVICTABLE : 0) |
 		(cc->mode == MIGRATE_ASYNC ? ISOLATE_ASYNC_MIGRATE : 0);
 
 	/*
_

Patches currently in -mm which might be from emunson@akamai.com are

allow-compaction-of-unevictable-pages.patch

