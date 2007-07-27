From: akpm@linux-foundation.org
Subject: + oom-print-points-as-unsigned-long.patch added to -mm tree
Date: Thu, 26 Jul 2007 21:33:30 -0700
Message-ID: <200707270433.l6R4XUrO005499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39896 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536AbXG0Edm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 00:33:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com


The patch titled
     oom: print points as unsigned long
has been added to the -mm tree.  Its filename is
     oom-print-points-as-unsigned-long.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: oom: print points as unsigned long
From: David Rientjes <rientjes@google.com>

In badness(), the automatic variable 'points' is unsigned long.  Print it
as such.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/oom_kill.c~oom-print-points-as-unsigned-long mm/oom_kill.c
--- a/mm/oom_kill.c~oom-print-points-as-unsigned-long
+++ a/mm/oom_kill.c
@@ -156,7 +156,7 @@ unsigned long badness(struct task_struct
 	}
 
 #ifdef DEBUG
-	printk(KERN_DEBUG "OOMkill: task %d (%s) got %d points\n",
+	printk(KERN_DEBUG "OOMkill: task %d (%s) got %lu points\n",
 	p->pid, p->comm, points);
 #endif
 	return points;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
do-not-trigger-oom-killer-for-high-order-allocation-failures.patch
oom-print-points-as-unsigned-long.patch
try-parent-numa_node-at-first-before-using-default-v2.patch
try-parent-numa_node-at-first-before-using-default-v2-fix.patch
x86_64-clean-up-apicid_to_node-declaration.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
