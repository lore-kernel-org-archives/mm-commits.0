From: akpm@linux-foundation.org
Subject: [folded] memcg-implement-memory-thresholds-checkpatch-fixes-fix.patch removed from -mm tree
Date: Wed, 10 Mar 2010 14:57:02 -0800
Message-ID: <201003102257.o2AMv2GQ008881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757394Ab0CJW5i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 17:57:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     memcg-implement-memory-thresholds-checkpatch-fixes-fix
has been removed from the -mm tree.  Its filename was
     memcg-implement-memory-thresholds-checkpatch-fixes-fix.patch

This patch was dropped because it was folded into memcg-implement-memory-thresholds.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-implement-memory-thresholds-checkpatch-fixes-fix
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Each memcg-implement-memory-thresholds.patch and
memcg-add-interface-to-move-charge-at-task-migration.patch try to add a new
section to Documentation/cgroup/memory.txt, so the document has been a bit
mangled when these patches are merged at the same time.

This patch fixes it.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-implement-memory-thresholds-checkpatch-fixes-fix Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-implement-memory-thresholds-checkpatch-fixes-fix
+++ a/Documentation/cgroups/memory.txt
@@ -458,7 +458,15 @@ Note: Those pages and swaps must be char
 Note: More type of pages(e.g. file cache, shmem,) will be supported by other
       bits in future.
 
-8.3 Memory thresholds
+8.3 TODO
+
+- Add support for other types of pages(e.g. file cache, shmem, etc.).
+- Implement madvise(2) to let users decide the vma to be moved or not to be
+  moved.
+- All of moving charge operations are done under cgroup_mutex. It's not good
+  behavior to hold the mutex too long, so we may need some trick.
+
+9. Memory thresholds
 
 Memory controler implements memory thresholds using cgroups notification
 API (see cgroups.txt). It allows to register multiple memory and memsw
@@ -475,16 +483,7 @@ threshold in any direction.
 
 It's applicable for root and non-root cgroup.
 
-
-8.4 TODO
-
-- Add support for other types of pages(e.g. file cache, shmem, etc.).
-- Implement madvise(2) to let users decide the vma to be moved or not to be
-  moved.
-- All of moving charge operations are done under cgroup_mutex. It's not good
-  behavior to hold the mutex too long, so we may need some trick.
-
-9. TODO
+10. TODO
 
 1. Add support for accounting huge pages (as a separate controller)
 2. Make per-cgroup scanner reclaim not-shared pages first
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

cgroup-introduce-cancel_attach.patch
cgroup-introduce-coalesce-css_get-and-css_put.patch
memcg-add-interface-to-move-charge-at-task-migration.patch
memcg-move-charges-of-anonymous-page.patch
memcg-improve-performance-in-moving-charge.patch
memcg-avoid-oom-during-moving-charge.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-improve-performance-in-moving-swap-charge.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes-fix.patch
memcg-use-generic-percpu-instead-of-private-implementation.patch
memcg-update-threshold-and-softlimit-at-commit-v2.patch
memcg-share-event-counter-rather-than-duplicate-v2.patch
memcg-update-memcg_testtxt.patch
memcg-handle-panic_on_oom=always-case-v2.patch
cgroups-fix-race-between-userspace-and-kernelspace.patch
cgroups-remove-events-before-destroying-subsystem-state-objects.patch
cgroups-add-simple-listener-of-cgroup-events-to-documentation.patch
cgroups-add-simple-listener-of-cgroup-events-to-documentation-fix.patch
memcg-update-memcg_testtxt-to-describe-memory-thresholds.patch
memcg-fix-oom-kill-behavior-v3.patch
memcg-fix-oom-kill-behavior-v4.patch
memcg-update-maintainer-list.patch

