From: akpm@linux-foundation.org
Subject: + oom-kill-all-threads-that-share-mm-with-killed-task.patch added to -mm tree
Date: Mon, 23 Apr 2007 22:16:15 -0700
Message-ID: <200704240516.l3O5GFUG001136@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753507AbXDXFQf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Apr 2007 01:16:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, ak@suse.de, clameter@engr.sgi.com


The patch titled
     oom: kill all threads that share mm with killed task
has been added to the -mm tree.  Its filename is
     oom-kill-all-threads-that-share-mm-with-killed-task.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: oom: kill all threads that share mm with killed task
From: David Rientjes <rientjes@google.com>

oom_kill_task() calls __oom_kill_task() to OOM kill a selected task.  When
finding other threads that share an mm with that task, we need to kill
those individual threads and not the same one.

Cc: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/oom_kill.c~oom-kill-all-threads-that-share-mm-with-killed-task mm/oom_kill.c
--- a/mm/oom_kill.c~oom-kill-all-threads-that-share-mm-with-killed-task
+++ a/mm/oom_kill.c
@@ -337,7 +337,7 @@ static int oom_kill_task(struct task_str
 	 */
 	do_each_thread(g, q) {
 		if (q->mm == mm && q->tgid != p->tgid)
-			force_sig(SIGKILL, p);
+			force_sig(SIGKILL, q);
 	} while_each_thread(g, q);
 
 	return 0;
_

Patches currently in -mm which might be from rientjes@google.com are

oom-kill-all-threads-that-share-mm-with-killed-task.patch
x86_64-set-node_possible_map-at-runtime.patch
x86_64-set-node_possible_map-at-runtime-fix.patch
x86_64-set-node_possible_map-at-runtime-fix-2.patch
slab-x86_64-skip-cache_free_alien-on-non-numa.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
smaps-add-clear_refs-file-to-clear-reference-cleanup.patch
smaps-use-ptep_test_and_clear_young.patch
smaps-add-clear_refs-file-to-clear-reference-docs.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
cpusets-allow-tif_memdie-threads-to-allocate-anywhere.patch
