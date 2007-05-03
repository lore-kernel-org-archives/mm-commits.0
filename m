From: akpm@linux-foundation.org
Subject: + cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix.patch added to -mm tree
Date: Thu, 03 May 2007 01:20:58 -0700
Message-ID: <200705030820.l438Kwqc007978@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751110AbXECIVI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 04:21:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, clameter@engr.sgi.com, menage@google.com, pj@sgi.com


The patch titled
     cpusets-allow-empty-cpusmems_allowed-to-be-set-for fix
has been added to the -mm tree.  Its filename is
     cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpusets-allow-empty-cpusmems_allowed-to-be-set-for fix
From: David Rientjes <rientjes@google.com>

Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/cpuset.c~cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix
+++ a/kernel/cpuset.c
@@ -772,7 +772,7 @@ static int update_cpumask(struct cpuset 
 	 * tasks, we'll catch it later when we validate the change and return
 	 * -ENOSPC.
 	 */
-	if (!*buf) {
+	if (!buf[0] || (buf[0] == '\n' && !buf[1])) {
 		cpus_clear(trialcs.cpus_allowed);
 	} else {
 		retval = cpulist_parse(buf, trialcs.cpus_allowed);
@@ -877,7 +877,7 @@ static int update_nodemask(struct cpuset
 	 * tasks, we'll catch it later when we validate the change and return
 	 * -ENOSPC.
 	 */
-	if (!*buf) {
+	if (!buf[0] || (buf[0] == '\n' && !buf[1])) {
 		nodes_clear(trialcs.mems_allowed);
 	} else {
 		retval = nodelist_parse(buf, trialcs.mems_allowed);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
cpusets-allow-tif_memdie-threads-to-allocate-anywhere.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
oom-fix-constraint-deadlock.patch
git-cpufreq.patch
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
cpusets-allow-empty-cpusmems_allowed-to-be-set-for.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix.patch
