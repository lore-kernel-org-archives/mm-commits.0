Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7538F365A19
	for <mm-commits@vger.kernel.org>; Fri,  2 Oct 2026 21:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790976125; cv=none; b=oIBxCgaJyGfeZJVXwsQyFD7xZEvS0YiQO5CPvu5VOCjVt8suX3Kng497hHGlSOQVbiF+jOk2F7gEaLgOfDLZvUvYt+M+1WCrCRhVfQU0HDcw4NEHy16phkfp+5q0Lw/oY5k64JwJgTtiFfLzb+MHx0bAEtvgMsyZmt/U6HZ/v9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790976125; c=relaxed/simple;
	bh=38jtKKBwOGSIDZHqXZbIM1V9bOyVLl/YeouMFahNmcI=;
	h=Date:To:From:Subject:Message-Id; b=YaOFK9xY0E63eoEQ6FqUKmMXqb0VyW1bTw4gYpwOhirMSZZM3/DUdoPpEMl/xnvaU1mxzR7eO7DNTi2BC9OcUSBVoYq17WO0Ag8uR9lMDccdClR0DR+lGc+vB2g9VOM+4qMCLXRhgJcIFvfeEa16W27xbQ+0uhEVrCbr6SNN0bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cHiVdsm5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cHiVdsm5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115121F000FF;
	Fri,  2 Oct 2026 21:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790976122;
	bh=oO+DjsdVCRmDi7kyiKrBuIypwsnnP0gdj7rr80dVOSk=;
	h=Date:To:From:Subject;
	b=cHiVdsm5LnUZFfdVVZwmUAL6xy5iRjh1I+ouA3brLPjjNXM5xow7aMhHUostzoxTJ
	 +BwE4V18LfdXTI/v84Hc6rDCpoXnbd0F7dGeAganoSDdMrMtVNFPtJKp4NvqoTp5AH
	 UcccvjHERAV8ZVA5BI6EHGIJbypWYWp1mC/NNymU=
Date: Fri, 02 Oct 2026 14:22:01 -0700
To: mm-commits@vger.kernel.org,tglx@kernel.org,include@grrlz.net,glider@google.com,elver@google.com,dvyukov@google.com,brads@mainlining.org,andreyknvl@gmail.com,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-report-spurious-pcs-in-the-interrupt-selftest.patch added to mm-nonmm-unstable branch
Message-Id: <20261002212202.115121F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kcov: report spurious PCs in the interrupt selftest
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kcov-report-spurious-pcs-in-the-interrupt-selftest.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-report-spurious-pcs-in-the-interrupt-selftest.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Karl Mehltretter <kmehltretter@gmail.com>
Subject: kcov: report spurious PCs in the interrupt selftest
Date: Fri,  2 Oct 2026 20:13:57 +0200

The KCOV interrupt selftest enables KCOV_MODE_TRACE_PC without a coverage
area so that spurious coverage causes a fault.  If the fault path is
instrumented, the coverage callback faults recursively.  Observed failure
modes include a stack overflow on x86_64 and arm32 getting stuck in abort
handling, neither of which identifies the original coverage event.

The recursive failure is not new, but commit 9a79524d1420 ("kcov: use
WRITE_ONCE() for selftest mode stores") made the selftest effective on
configurations where the compiler had previously removed the mode store,
exposing it more broadly.

Replace the open-coded kcov_mode stores with kcov_start() and kcov_stop(),
passing a 16-word buffer that records up to 15 spurious PCs, with the
first word holding the count.  Keep KCOV enabled for the original 300 ms
window, then disable it, print all recorded PCs and panic if any were
recorded.  Once the buffer fills, further PCs are discarded by the
existing coverage callback.  This preserves the selftest's hard failure
while avoiding the recursive fault path.

Add decanonicalize_ip() as the inverse of canonicalize_ip(), which
subtracts kaslr_offset() from recorded PCs.  Restore that offset before
printing the PCs with %pB, since KCOV records return addresses.

Link: https://lore.kernel.org/20261002181357.14293-1-kmehltretter@gmail.com
Fixes: 6cd0dd934b03 ("kcov: Add interrupt handling self test")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Bradley Morgan <brads@mainlining.org> # Power10
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Assisted-by: LLM
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Bradley Morgan <include@grrlz.net>
Cc: Thomas Gleixner <tglx@kernel.org>
---

 kernel/kcov.c |   35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

--- a/kernel/kcov.c~kcov-report-spurious-pcs-in-the-interrupt-selftest
+++ a/kernel/kcov.c
@@ -198,6 +198,16 @@ static notrace unsigned long canonicaliz
 	return ip;
 }
 
+#ifdef CONFIG_KCOV_SELFTEST
+static unsigned long __init decanonicalize_ip(unsigned long ip)
+{
+#ifdef CONFIG_RANDOMIZE_BASE
+	ip += kaslr_offset();
+#endif
+	return ip;
+}
+#endif
+
 /*
  * Entry point from instrumented code.
  * This is called once per basic-block/edge.
@@ -1107,9 +1117,11 @@ struct kcov_common_handle_id kcov_common
 EXPORT_SYMBOL(kcov_common_handle);
 
 #ifdef CONFIG_KCOV_SELFTEST
+static unsigned long selftest_area[16] __initdata;
+
 static void __init selftest(void)
 {
-	unsigned long start;
+	unsigned long start, i, ip, count;
 
 	pr_err("running self test\n");
 	/*
@@ -1119,15 +1131,26 @@ static void __init selftest(void)
 	 * leaks out of that section and leads to spurious coverage.
 	 * It's hard to call the actual interrupt handler directly,
 	 * so we just loop here for a bit waiting for a timer interrupt.
-	 * We set kcov_mode to enable tracing, but don't setup the area,
-	 * so any attempt to trace will crash. Note: we must not call any
+	 * A small coverage area records the PCs of any leaks. The first word
+	 * holds the count, leaving room for 15 PCs. Note: we must not call any
 	 * potentially traced functions in this region.
 	 */
+	kcov_start(current, NULL, ARRAY_SIZE(selftest_area),
+		   selftest_area, KCOV_MODE_TRACE_PC, 0);
 	start = jiffies;
-	WRITE_ONCE(current->kcov_mode, KCOV_MODE_TRACE_PC);
 	while ((jiffies - start) * MSEC_PER_SEC / HZ < 300)
-		;
-	WRITE_ONCE(current->kcov_mode, 0);
+		cpu_relax();
+	kcov_stop(current);
+
+	count = READ_ONCE(selftest_area[0]);
+	if (count) {
+		pr_err("spurious coverage detected during interrupt selftest:\n");
+		for (i = 1; i <= count; i++) {
+			ip = decanonicalize_ip(selftest_area[i]);
+			pr_err("  %pB\n", (void *)ip);
+		}
+		panic("kcov: interrupt selftest detected spurious coverage");
+	}
 	pr_err("done running self test\n");
 }
 #endif
_

Patches currently in -mm which might be from kmehltretter@gmail.com are

mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total-fix.patch
docs-mm-ksm-use-the-renamed-ksm-structure-names.patch
mm-secretmem-fix-the-enable-parameter-description.patch
mm-damon-core-preserve-the-quota-passed-to-damon_new_scheme.patch
mm-damon-tests-core-kunit-test-preservation-of-quota-state.patch
mm-damon-tests-core-kunit-test-psi-goal-values-with-explicit-samples.patch
klist-avoid-accesses-after-waking-klist_remove.patch
squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch
squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch
fork-honor-task_structs-declared-alignment.patch
ocfs2-cluster-hold-a-reference-on-the-heartbeat-thread.patch
resource-kunit-stop-selecting-get_free_region.patch
kcov-report-spurious-pcs-in-the-interrupt-selftest.patch

