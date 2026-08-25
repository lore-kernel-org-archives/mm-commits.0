Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BE434751F
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622908; cv=none; b=uZ0fCiPcFXKjVajTBKNKCjHjCxoPY3RXwBwjV3kTL5Dmvs/6jdZ8WlPcr0ajSAWDi9yNPBu7lqHYoYN5XqmlPN1W2dGqPVX6iEnB53mrsxHfy+21aAD7yKzFfRZ9JDC6o/s34sq/CEbEI5yn3EEHWdIGK8QtrKvIo5a7afsn4KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622908; c=relaxed/simple;
	bh=ORVdzxgELM22tMGAx5Tab6DVYCfJzC3PUoOmO+aHbg0=;
	h=Date:To:From:Subject:Message-Id; b=YaxKZbA4lcTqVsweuWa3qupDaKRkWgXaHPMDs3651hgxh2hJPJWVKFHdZt7U8YRmIQ01mEwWL7jBregO879u9kH7cLZ8QwxBDsAbBkK0jzbErgaSFeVOGDV71ZYiYGDlcjEgi5TpD6QxM1wXavClLKD2PBsJw2t97megPrOcMmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iWIfPmoi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iWIfPmoi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C321F000E9;
	Tue, 25 Aug 2026 01:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622907;
	bh=06eUtONaOKP73lTofjr8eDkcrQdFV81k1A4vjiT6Q0Y=;
	h=Date:To:From:Subject;
	b=iWIfPmoiEerSF1ISKYGuWQKMXffQEKt7WFf5jVGCWFKC5gGBIFg5dg9HNvt29epna
	 sckPNSeOLEDBsmcE41+HGKWs3dfnp3PZrQ08/b+OU5gfODOAzt99DGGB5BEb9D5nwb
	 mogLhVUAF52Z8/zQnnL6ttImBF0qQ9qeRHb1doFY=
Date: Mon, 24 Aug 2026 18:55:06 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,geert@linux-m68k.org,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-test-kmemleaks-n-consecutive-scan-leak-confirmation.patch removed from -mm tree
Message-Id: <20260825015506.F1C321F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mm: test kmemleak's N-consecutive-scan leak confirmation
has been removed from the -mm tree.  Its filename was
     selftests-mm-test-kmemleaks-n-consecutive-scan-leak-confirmation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: selftests: mm: test kmemleak's N-consecutive-scan leak confirmation
Date: Mon, 13 Jul 2026 04:48:07 -0700

Add a functional test for the min_unref_scans kmemleak module parameter. 
Using samples/kmemleak's helper module it checks that min_unref_scans=1
reports an orphan on the first scan, min_unref_scans=2 reports nothing on
the first scan but does on the second, and that the parameter reads back
what was written.

It counts only the helper module's own orphans (matched by their
[kmemleak_test] backtrace, with the module kept loaded so the symbols
resolve) so unrelated leaks already present on the system do not perturb
the result.  The test skips when run as non-root, without
CONFIG_DEBUG_KMEMLEAK / CONFIG_SAMPLE_KMEMLEAK, on a kernel without the
parameter, or when the helper yields no detectable orphan.

Link: https://lore.kernel.org/20260713-catalin_pto-v1-4-5b93b1131089@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile                 |    1 
 tools/testing/selftests/mm/ksft_kmemleak_confirm.sh |  132 ++++++++++
 2 files changed, 133 insertions(+)

diff --git a/tools/testing/selftests/mm/ksft_kmemleak_confirm.sh a/tools/testing/selftests/mm/ksft_kmemleak_confirm.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_kmemleak_confirm.sh
@@ -0,0 +1,132 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Functional test for kmemleak's N-consecutive-scan leak confirmation
+# (the min_unref_scans module parameter).
+#
+# kmemleak only reports an object once it has stayed unreferenced for
+# min_unref_scans consecutive scans. The default of 1 reports on the first
+# scan (historical behaviour); higher values filter transient false
+# positives where a live object's only reference is briefly invisible to a
+# single scan (e.g. an RCU tree update in flight while the scan runs). The
+# test loads samples/kmemleak's helper module to create orphan allocations
+# and, counting only those orphans (matched by their [kmemleak_test]
+# backtrace so unrelated leaks already present on the system are ignored),
+# checks that:
+#   - a freshly allocated object is greyed on its first scan (its checksum
+#     settles then), so nothing can be reported before that priming scan;
+#     each case below primes once first,
+#   - with the default threshold (min_unref_scans=1) one scan after priming
+#     reports the orphans,
+#   - raising the threshold to 2 needs two scans after priming: one is not
+#     enough, the second reports,
+#   - the parameter reads back what was written.
+#
+# The "one post-prime scan is not enough at min_unref_scans=2" check is the
+# core regression test: raising min_unref_scans must push the report
+# strictly later. Like ksft_kmemleak_dedup.sh, if the module yields no
+# detectable orphan at all in the running environment the test skips rather
+# than failing.
+#
+# Author: Breno Leitao <leitao@debian.org>
+
+# KTAP output helpers (ktap_skip_all, ktap_exit_fail_msg, ktap_test_pass, ...).
+DIR="$(dirname "$(readlink -f "$0")")"
+# shellcheck source=../kselftest/ktap_helpers.sh
+source "${DIR}"/../kselftest/ktap_helpers.sh
+
+KMEMLEAK=/sys/kernel/debug/kmemleak
+PARAM=/sys/module/kmemleak/parameters/min_unref_scans
+MODULE=kmemleak-test
+AGE=6		# seconds; must exceed kmemleak's 5s minimum object age
+
+ktap_print_header
+
+[ "$(id -u)" -eq 0 ] || { ktap_skip_all "must run as root"; exit "$KSFT_SKIP"; }
+[ -r "$KMEMLEAK" ] ||
+	{ ktap_skip_all "no kmemleak debugfs (CONFIG_DEBUG_KMEMLEAK)"; exit "$KSFT_SKIP"; }
+[ -w "$PARAM" ] ||
+	{ ktap_skip_all "min_unref_scans module parameter not present"; exit "$KSFT_SKIP"; }
+modinfo "$MODULE" >/dev/null 2>&1 ||
+	{ ktap_skip_all "$MODULE not built (CONFIG_SAMPLE_KMEMLEAK)"; exit "$KSFT_SKIP"; }
+
+# kmemleak can be present but disabled at runtime (kmemleak=off boot arg,
+# or it self-disabled after an internal error); a "scan" then returns
+# EPERM. Probe once and skip if so.
+echo scan > "$KMEMLEAK" 2>/dev/null ||
+	{ ktap_skip_all "kmemleak is disabled (check dmesg or kmemleak= boot arg)"; exit "$KSFT_SKIP"; }
+
+prev=$(cat "$PARAM")
+# shellcheck disable=SC2317  # invoked indirectly via trap
+cleanup() {
+	echo "$prev" > "$PARAM" 2>/dev/null		# restore the parameter
+	echo scan=on > "$KMEMLEAK" 2>/dev/null		# re-enable auto scan
+	rmmod "$MODULE" 2>/dev/null
+	echo clear > "$KMEMLEAK" 2>/dev/null
+}
+trap cleanup EXIT
+
+# Stop the automatic scan thread: only our manual scans should advance an
+# object's consecutive-unreferenced run. An auto scan landing between two
+# manual scans would change the result and make the test flaky.
+echo scan=off > "$KMEMLEAK" 2>/dev/null
+
+# Create a fresh, aged set of orphan objects from the helper module's init
+# path (its kmalloc/vmalloc/percpu allocations are dropped right away).
+# Pre-existing reported leaks are greyed first ("clear") so only our
+# orphans are counted. The module is left loaded on purpose: once it is
+# unloaded its symbols are gone, so the orphan backtraces no longer resolve
+# to [kmemleak_test] and could not be matched below.
+gen_orphans() {
+	rmmod "$MODULE" 2>/dev/null
+	echo clear > "$KMEMLEAK"
+	modprobe "$MODULE" ||
+		{ ktap_skip_all "failed to load $MODULE"; exit "$KSFT_SKIP"; }
+	sleep "$AGE"
+}
+
+scan() { echo scan > "$KMEMLEAK"; }
+
+# Number of helper-module orphans currently reported by kmemleak. Matching
+# the module's own backtrace ([kmemleak_test]) keeps the count immune to
+# unrelated leaks on the running system. kmemleak only lists an object here
+# once it has been reported, so this reflects the confirmation gating.
+count_orphans() {
+	c=$(grep -c '\[kmemleak_test\]' "$KMEMLEAK" 2>/dev/null)
+	echo "${c:-0}"
+}
+
+# 0) the parameter reads back what was written.
+echo 3 > "$PARAM"
+[ "$(cat "$PARAM")" = "3" ] || ktap_exit_fail_msg "min_unref_scans did not read back as 3"
+
+# Priming scan: kmemleak greys a freshly allocated object on its first scan
+# (its checksum settles then), so nothing can be reported until a second
+# scan. Every case below runs this priming scan before counting.
+prime() { scan; }
+
+# 1) min_unref_scans=1 (default): one scan after priming reports the
+#    orphans. This also establishes that the helper produces detectable
+#    orphans here.
+echo 1 > "$PARAM"
+gen_orphans
+prime
+scan
+first=$(count_orphans)
+[ "$first" -gt 0 ] ||
+	{ ktap_skip_all "$MODULE produced no detectable orphans (cannot test min_unref_scans)"; exit "$KSFT_SKIP"; }
+
+# 2) min_unref_scans=2: after priming, one scan is not enough (still
+#    gated), the second reports. The gated-scan-zero check is the core
+#    regression.
+echo 2 > "$PARAM"
+gen_orphans
+prime
+scan; s1=$(count_orphans)
+scan; s2=$(count_orphans)
+[ "$s1" -eq 0 ] || ktap_exit_fail_msg "min_unref_scans=2: $s1 orphan(s) after 1 post-prime scan (must be 0)"
+[ "$s2" -gt 0 ] || ktap_exit_fail_msg "min_unref_scans=2: no report after 2 post-prime scans (false negative)"
+
+ktap_set_plan 1
+ktap_test_pass "min_unref_scans=1 reported $first orphan(s) one scan after priming; =2 held them one scan longer ($s1 after one scan, $s2 after two); param read-back ok"
+ktap_finished
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-test-kmemleaks-n-consecutive-scan-leak-confirmation
+++ a/tools/testing/selftests/mm/Makefile
@@ -149,6 +149,7 @@ TEST_PROGS += ksft_gup_test.sh
 TEST_PROGS += ksft_hmm.sh
 TEST_PROGS += ksft_hugetlb.sh
 TEST_PROGS += ksft_hugevm.sh
+TEST_PROGS += ksft_kmemleak_confirm.sh
 TEST_PROGS += ksft_kmemleak_dedup.sh
 TEST_PROGS += ksft_ksm.sh
 TEST_PROGS += ksft_ksm_numa.sh
_

Patches currently in -mm which might be from leitao@debian.org are


