Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E47B45D933
	for <mm-commits@vger.kernel.org>; Sun, 11 Oct 2026 22:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791757214; cv=none; b=k4vQJvzKaH5/3Z0dJfVmyDCqP/QB6fyE5kqTZRPkz9kIji3EliUGq60FCmh/S3Badfzm/zxO+vIdfv9wflaibjwkGWACG7YasHnbJawqLK1FN/+47y76K+xZUlo8Blq2ijQ9Z5kM+ES3fA5ANchscibkBag9oJdHte/8jwx7JCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791757214; c=relaxed/simple;
	bh=SYfdOEJbIFdmTZ+DdUqisZeMfbfoZjNFfWKyXj73M8U=;
	h=Date:To:From:Subject:Message-Id; b=YiWcwBVP36NhmCzXybo/lZ8fUCX3gzbBKaIStYDW+YcwUul8M8OIoSkBfWRlcu8GHB8hbwkqDwpAUGkXMVwpin+IYNITEahl+jzvZF+JbA7JhpoGK35XlgQCW06CHd73wQvgljk0NMjEPsDjaQY2tkS8t+TJ0TlbLIfqjSzR2SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2vs26hoP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2vs26hoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B961F0089C;
	Sun, 11 Oct 2026 22:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791757210;
	bh=WSyCyTOmAIyAYnPOmXK6XeUsnlspeQmmpNAxL8qoLsE=;
	h=Date:To:From:Subject;
	b=2vs26hoPWJ82sIImp4d2BXBw7YxmmeltrNXioCqc+BMFazvDbmLT0/AMgMdbzQ/MD
	 E54EPnVVzL5cD2W36VTXiFFP7+ZwFjN6+v/aOj+rr4Qfdr7FBEEvX9/SokCIIZg7dt
	 Xb2tUtQBESPYRzcLh7aL9bOL0MDYt0wXe6xsvhrM=
Date: Sun, 11 Oct 2026 15:20:09 -0700
To: mm-commits@vger.kernel.org,tglx@kernel.org,include@grrlz.net,glider@google.com,elver@google.com,dvyukov@google.com,brads@mainlining.org,andreyknvl@gmail.com,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kcov-report-spurious-pcs-in-the-interrupt-selftest.patch removed from -mm tree
Message-Id: <20261011222010.22B961F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kcov: report spurious PCs in the interrupt selftest
has been removed from the -mm tree.  Its filename was
     kcov-report-spurious-pcs-in-the-interrupt-selftest.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-secretmem-fix-the-enable-parameter-description.patch
mm-damon-core-preserve-the-quota-passed-to-damon_new_scheme.patch
mm-damon-tests-core-kunit-test-preservation-of-quota-state.patch
mm-damon-tests-core-kunit-test-psi-goal-values-with-explicit-samples.patch
squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch
squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch

