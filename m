From: akpm@linux-foundation.org
Subject: [folded] smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch removed from -mm tree
Date: Wed, 28 Mar 2012 14:30:56 -0700
Message-ID: <20120328213056.6207DA0496@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:63942 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249Ab2C1Va5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Mar 2012 17:30:57 -0400
Received: by vbnl22 with SMTP id l22so185851vbn.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Mar 2012 14:30:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gilad@benyossef.com, a.p.zijlstra@chello.nl, akpm@linux-foundation.org, andi@firstfloor.org, avi@redhat.com, cl@linux-foundation.org, cmetcalf@tilera.com, fweisbec@gmail.com, kosaki.motohiro@gmail.com, levinsasha928@gmail.com, linux@arm.linux.org.uk, miltonm@bga.com, mina86@mina86.com, mpm@selenic.com, penberg@kernel.org, riel@redhat.com, srivatsa.bhat@linux.vnet.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: smp: add func to IPI cpus based on parameter func
has been removed from the -mm tree.  Its filename was
     smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch

This patch was dropped because it was folded into smp-add-func-to-ipi-cpus-based-on-parameter-func.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: smp: add func to IPI cpus based on parameter func

Add the on_each_cpu_cond() function that wraps on_each_cpu_mask()
and calculates the cpumask of cpus to IPI by calling a function supplied
as a parameter in order to determine whether to IPI each specific cpu.

The function works around allocation failure of cpumask variable in
CONFIG_CPUMASK_OFFSTACK=y by itereating over cpus sending an IPI a
time via smp_call_function_single().

The function is useful since it allows to seperate the specific
code that decided in each case whether to IPI a specific cpu for
a specific request from the common boilerplate code of handling
creating the mask, handling failures etc.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-mm@kvack.org
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Sasha Levin <levinsasha928@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: Avi Kivity <avi@redhat.com>
Cc: Kosaki Motohiro <kosaki.motohiro@gmail.com>
Cc: Milton Miller <miltonm@bga.com>
---

index d0adb78..46e2267 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/smp.c~smp-add-func-to-ipi-cpus-based-on-parameter-func-v9 kernel/smp.c
--- a/kernel/smp.c~smp-add-func-to-ipi-cpus-based-on-parameter-func-v9
+++ a/kernel/smp.c
@@ -752,7 +752,9 @@ EXPORT_SYMBOL(on_each_cpu_mask);
  * The function might sleep if the GFP flags indicates a non
  * atomic allocation is allowed.
  *
- * Preemption is disabled to protect against a hotplug event.
+ * Preemption is disabled to protect against CPU going offline but not
+ * online. CPUs going online during the call will not be seen or sent
+ * an IPI.
  *
  * You must not call this function with disabled interrupts or
  * from a hardware interrupt handler or from a bottom half handler.
_

Patches currently in -mm which might be from gilad@benyossef.com are

smp-introduce-a-generic-on_each_cpu_mask-function.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9-fix.patch
slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch
fs-only-send-ipi-to-invalidate-lru-bh-when-needed.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-update.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-v9.patch

