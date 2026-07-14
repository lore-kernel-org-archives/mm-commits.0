Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C578D1D130E
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 00:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783989464; cv=none; b=AHTHsSMXx/cDsbmcoUF4A8zOvHJ3VpIxpl1Cny1zFw5jv4CaB8rrsVW5OATWnD30y0GTXOTO/+R+apTRdIXIN3gmhrh+thvjQQcGyBZ8iO5A1LHotou8M3xWTRkd0yNHyHsZy/olv8ZQXttHAsesvbJBluAkhvLlqN59+6yMaFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783989464; c=relaxed/simple;
	bh=VO61VTbbxy3YQdNCg7OCLcbAbD5GLlbe7c6lY7s9Slg=;
	h=Date:To:From:Subject:Message-Id; b=D9Vv8+1JTqoiaevyr/zTjCy++JF2VGtTlTVlTz8iykLqNMbX4AxxMgKH4DVwUFvl5zHkOGxojyBNLPvo++nqGn10IDJmjIkWjnocPSmNp905SU9mYhs34clh3z1JgocsZk6q94qiJK12UgaCD9Whr0s5LBSrF9EYkFPsxsCeGxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GbAA6qN3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GbAA6qN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9C01F000E9;
	Tue, 14 Jul 2026 00:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783989462;
	bh=UHaQ5BRp+AuNn3j/mSb44Nge5HwazdpH2kV4UxZpRmI=;
	h=Date:To:From:Subject;
	b=GbAA6qN3db5v/dwoPVKWC4JY2eN64Ck347YlCx2gHMRuGgu4jvaH8WDuSsO00Lrt3
	 Cf4owHFMVx8yRQf3umIv9OCoCfLfzTnv0gMleSWgky+tW9d/Ic+CHQS6l4QtTP5+Rt
	 6Grzt8q3mb3UafpswIh0CI3xWJpzYCXltMt58/Co=
Date: Mon, 13 Jul 2026 17:37:41 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,geert@linux-m68k.org,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-test-kmemleaks-n-consecutive-scan-leak-confirmation.patch added to mm-new branch
Message-Id: <20260714003742.4E9C01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: mm: test kmemleak's N-consecutive-scan leak confirmation
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-test-kmemleaks-n-consecutive-scan-leak-confirmation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-test-kmemleaks-n-consecutive-scan-leak-confirmation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Cc: Catalin Marinas <catalin.marinas@arm.com>
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
@@ -150,6 +150,7 @@ TEST_PROGS += ksft_gup_test.sh
 TEST_PROGS += ksft_hmm.sh
 TEST_PROGS += ksft_hugetlb.sh
 TEST_PROGS += ksft_hugevm.sh
+TEST_PROGS += ksft_kmemleak_confirm.sh
 TEST_PROGS += ksft_kmemleak_dedup.sh
 TEST_PROGS += ksft_ksm.sh
 TEST_PROGS += ksft_ksm_numa.sh
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-avoid-soft-lockup-when-scanning-task-stacks.patch
mm-kmemleak-stop-the-task-stack-scan-early-when-interrupted.patch
mm-kmemleak-stop-the-per-cpu-and-struct-page-scans-early-too.patch
mm-memory-failure-drop-dead-error_states-entry-for-reserved-pages.patch
mm-memory-failure-surface-unhandlable-kernel-pages-as-enotrecoverable.patch
mm-memory-failure-report-mf_msg_kernel-for-unrecoverable-kernel-pages.patch
mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch
documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch
selftests-mm-add-hwpoison-panic-destructive-test.patch
mm-kmemleak-skip-the-remaining-scan-phases-when-interrupted.patch
radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans.patch
mm-kmemleak-factor-leak-confirmation-into-a-helper.patch
selftests-mm-test-kmemleaks-n-consecutive-scan-leak-confirmation.patch

