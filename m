From: akpm@linux-foundation.org
Subject: - powerpc-fix-num_cpus-calculation-in-smp_call_function_map.patch removed from -mm tree
Date: Mon, 06 Aug 2007 00:53:05 -0700
Message-ID: <200708060753.l767r5Am016307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33644 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002AbXHFHxQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 03:53:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kevcorry@us.ibm.com, carll@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     PowerPC: Fix num_cpus calculation in smp_call_function_map()
has been removed from the -mm tree.  Its filename was
     powerpc-fix-num_cpus-calculation-in-smp_call_function_map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PowerPC: Fix num_cpus calculation in smp_call_function_map()
From: Kevin Corry <kevcorry@us.ibm.com>

In smp_call_function_map(), num_cpus is set to the number of online CPUs
minus one.  However, if the CPU mask does not include all CPUs (except the
one we're running on), the routine will hang in the first while() loop
until the 8 second timeout occurs.

The num_cpus should be set to the number of CPUs specified in the mask
passed into the routine, after we've made any modifications to the mask. 
With this change, we can also get rid of the call to cpus_empty() and avoid
adding another pass through the bitmask.

Signed-off-by: Kevin Corry <kevcorry@us.ibm.com>
Signed-off-by: Carl Love <carll@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/smp.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff -puN arch/powerpc/kernel/smp.c~powerpc-fix-num_cpus-calculation-in-smp_call_function_map arch/powerpc/kernel/smp.c
--- a/arch/powerpc/kernel/smp.c~powerpc-fix-num_cpus-calculation-in-smp_call_function_map
+++ a/arch/powerpc/kernel/smp.c
@@ -212,11 +212,6 @@ int smp_call_function_map(void (*func) (
 		atomic_set(&data.finished, 0);
 
 	spin_lock(&call_lock);
-	/* Must grab online cpu count with preempt disabled, otherwise
-	 * it can change. */
-	num_cpus = num_online_cpus() - 1;
-	if (!num_cpus)
-		goto done;
 
 	/* remove 'self' from the map */
 	if (cpu_isset(smp_processor_id(), map))
@@ -224,7 +219,9 @@ int smp_call_function_map(void (*func) (
 
 	/* sanity check the map, remove any non-online processors. */
 	cpus_and(map, map, cpu_online_map);
-	if (cpus_empty(map))
+
+	num_cpus = cpus_weight(map);
+	if (!num_cpus)
 		goto done;
 
 	call_data = &data;
_

Patches currently in -mm which might be from kevcorry@us.ibm.com are
