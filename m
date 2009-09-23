From: akpm@linux-foundation.org
Subject: [folded] memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 23 Sep 2009 15:29:51 -0700
Message-ID: <200909232229.n8NMTped017956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751453AbZIWW3u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 18:29:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg-add-comments-explaining-memory-barriers-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch

This patch was dropped because it was folded into memcg-add-comments-explaining-memory-barriers.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-add-comments-explaining-memory-barriers-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#22: FILE: mm/memcontrol.c:1138:
+ ^I * We access a page_cgroup asynchronously without lock_page_cgroup().$

ERROR: code indent should use tabs where possible
#23: FILE: mm/memcontrol.c:1139:
+ ^I * Especially when a page_cgroup is taken from a page, pc->mem_cgroup$

ERROR: code indent should use tabs where possible
#24: FILE: mm/memcontrol.c:1140:
+ ^I * is accessed after testing USED bit. To make pc->mem_cgroup visible$

ERROR: code indent should use tabs where possible
#25: FILE: mm/memcontrol.c:1141:
+ ^I * before USED bit, we need memory barrier here.$

ERROR: code indent should use tabs where possible
#26: FILE: mm/memcontrol.c:1142:
+ ^I * See mem_cgroup_add_lru_list(), etc.$

ERROR: code indent should use tabs where possible
#27: FILE: mm/memcontrol.c:1143:
+ ^I */$

total: 6 errors, 0 warnings, 13 lines checked

./patches/memcg-add-comments-explaining-memory-barriers.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-add-comments-explaining-memory-barriers-checkpatch-fixes mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-comments-explaining-memory-barriers-checkpatch-fixes
+++ a/mm/memcontrol.c
@@ -1135,11 +1135,11 @@ static void __mem_cgroup_commit_charge(s
 
 	pc->mem_cgroup = mem;
 	/*
- 	 * We access a page_cgroup asynchronously without lock_page_cgroup().
- 	 * Especially when a page_cgroup is taken from a page, pc->mem_cgroup
- 	 * is accessed after testing USED bit. To make pc->mem_cgroup visible
- 	 * before USED bit, we need memory barrier here.
- 	 * See mem_cgroup_add_lru_list(), etc.
+	 * We access a page_cgroup asynchronously without lock_page_cgroup().
+	 * Especially when a page_cgroup is taken from a page, pc->mem_cgroup
+	 * is accessed after testing USED bit. To make pc->mem_cgroup visible
+	 * before USED bit, we need memory barrier here.
+	 * See mem_cgroup_add_lru_list(), etc.
  	 */
 	smp_wmb();
 	switch (ctype) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
page-types-add-feature-for-walking-process-address-space.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-add-comments-explaining-memory-barriers.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memcg-improve-resource-counter-scalability-checkpatch-fixes.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch

