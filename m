Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9452F7AC1
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 14:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776955669; cv=none; b=LtmnFMwAbR6WwAGzEs5s0P+At0GCxvqrZAP1htgXRNqGMNGeb4yPYAT6Y0CsG0ZfbPFw5c5gTAjFcZvwhEx5kP3fyfEL50vWZmeTl9pgIKlBx7vEL4KptzEa/TyCAbq+WqMsdCr8QJFCYF0ezhA1deP+YE3M1EbYPl21FY/f9T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776955669; c=relaxed/simple;
	bh=r8Z4OD6FAdfLDJR/oEIrkF0P0NgqSWM50Di9PGKELjQ=;
	h=Date:To:From:Subject:Message-Id; b=tf6LlE5KovlbnF0D2ZzLQC/huoK0mYMst8vNkwSLj++xUTxh5t8vFB/YETKYu5J2PqnAopLSahRPEE5F+6pubJ5LtNzMmiXPDJRu4Rp8cai9m6G46nbIfjreSzom7GO2a8ayfbLZW20ltRmo/Evj6OZa3gLMlyamZJX4L60GM88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iWPxg+5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iWPxg+5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C58C2BCAF;
	Thu, 23 Apr 2026 14:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776955668;
	bh=r8Z4OD6FAdfLDJR/oEIrkF0P0NgqSWM50Di9PGKELjQ=;
	h=Date:To:From:Subject:From;
	b=iWPxg+5xm2vOc5gj87UQdnfQBotsGupYNGDBTLUJ8zJa7pyd7kuDpJyA1OukeC2xu
	 Vps7SSPl8p8hxPldHTV3t58rKyGaoKakirSaZ9NNRUDbaBeAsCLHnaoFyTBxyqusSX
	 rowoxxz7cfy2k6h7Msbq4BTr8hjkvo2BawO/IKX8=
Date: Thu, 23 Apr 2026 07:47:48 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-kmemleak-verbose-dedup-test.patch added to mm-new branch
Message-Id: <20260423144748.B4C58C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add kmemleak verbose dedup test
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-kmemleak-verbose-dedup-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-kmemleak-verbose-dedup-test.patch

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
Subject: selftests/mm: add kmemleak verbose dedup test
Date: Tue, 21 Apr 2026 06:45:05 -0700

Exercise the per-scan dedup of kmemleak's verbose leak output added in the
previous commit.  The test depends on the kmemleak-test sample module
(CONFIG_SAMPLE_KMEMLEAK=m); load it and unload it to orphan ten list
entries from a single kzalloc() call site that all share one stackdepot
trace_handle, trigger two scans, and assert that the number of
"unreferenced object" lines printed in dmesg is strictly less than the
number of leaks reported.  Skip cleanly when kmemleak is absent, disabled
at runtime, or CONFIG_SAMPLE_KMEMLEAK is not built in.

Link: https://lore.kernel.org/20260421-kmemleak_dedup-v1-2-65e31c6cdf0c@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/test_kmemleak_dedup.sh |   86 ++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/tools/testing/selftests/mm/test_kmemleak_dedup.sh a/tools/testing/selftests/mm/test_kmemleak_dedup.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/test_kmemleak_dedup.sh
@@ -0,0 +1,86 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Verify that kmemleak's verbose scan output deduplicates leaks that share
+# the same allocation backtrace. The kmemleak-test module leaks 10 list
+# entries from a single kzalloc() call site, so they share one stackdepot
+# trace_handle. With dedup, only one "unreferenced object" line should be
+# printed for that backtrace per scan, while the per-scan leak counter
+# still accounts for every object.
+#
+# The expected output is something like:
+#   PASS: kmemleak verbose output deduplicated (11 printed for 61 leaks)
+#
+# Author: Breno Leitao <leitao@debian.org>
+
+ksft_skip=4
+KMEMLEAK=/sys/kernel/debug/kmemleak
+VERBOSE_PARAM=/sys/module/kmemleak/parameters/verbose
+MODULE=kmemleak-test
+
+skip() {
+	echo "SKIP: $*"
+	exit $ksft_skip
+}
+
+fail() {
+	echo "FAIL: $*"
+	exit 1
+}
+
+[ "$(id -u)" -eq 0 ] || skip "must run as root"
+[ -r "$KMEMLEAK" ] || skip "no kmemleak debugfs (CONFIG_DEBUG_KMEMLEAK)"
+[ -w "$VERBOSE_PARAM" ] || skip "kmemleak verbose param missing"
+modinfo "$MODULE" >/dev/null 2>&1 ||
+	skip "$MODULE not built (CONFIG_SAMPLE_KMEMLEAK)"
+
+# kmemleak can be present but disabled at runtime (boot arg kmemleak=off,
+# or it self-disabled after an internal error). In that state writes other
+# than "clear" return EPERM, so probe once and skip if so.
+if ! echo scan > "$KMEMLEAK" 2>/dev/null; then
+	skip "kmemleak is disabled (check dmesg or kmemleak= boot arg)"
+fi
+
+prev_verbose=$(cat "$VERBOSE_PARAM")
+cleanup() {
+	echo "$prev_verbose" > "$VERBOSE_PARAM" 2>/dev/null
+	rmmod "$MODULE" 2>/dev/null
+}
+trap cleanup EXIT
+
+echo 1 > "$VERBOSE_PARAM"
+
+# Drain the existing leak set so the next scan only reports our objects.
+echo clear > "$KMEMLEAK"
+
+modprobe "$MODULE" || fail "failed to load $MODULE"
+# Removing the module orphans the list elements without freeing them.
+rmmod "$MODULE"    || fail "failed to unload $MODULE"
+
+# Two scans: kmemleak requires the object to survive a full scan cycle
+# before it is reported as unreferenced.
+dmesg -C >/dev/null
+echo scan > "$KMEMLEAK"; sleep 6
+echo scan > "$KMEMLEAK"; sleep 6
+
+log=$(dmesg)
+
+new_leaks=$(echo "$log" |
+	sed -n 's/.*kmemleak: \([0-9]\+\) new suspected.*/\1/p' | tail -1)
+[ -n "$new_leaks" ] || fail "no 'new suspected memory leaks' line found"
+
+# Count "unreferenced object" lines emitted in verbose output.
+printed=$(echo "$log" | grep -c 'kmemleak: unreferenced object')
+
+echo "new_leaks=$new_leaks printed=$printed"
+
+# The kzalloc(sizeof(*elem)) loop alone contributes 10 leaks sharing one
+# backtrace, so without dedup printed >= 10. With dedup the printed count
+# must be strictly less than the reported leak total.
+[ "$new_leaks" -ge 10 ] || fail "expected >=10 new leaks, got $new_leaks"
+[ "$printed"   -lt "$new_leaks" ] || \
+	fail "no dedup: printed=$printed new_leaks=$new_leaks"
+
+echo "PASS: kmemleak verbose output deduplicated" \
+	"($printed printed for $new_leaks leaks)"
+exit 0
_

Patches currently in -mm which might be from leitao@debian.org are

kho-fix-error-handling-in-kho_add_subtree.patch
mm-kmemleak-dedupe-verbose-scan-output-by-allocation-backtrace.patch
selftests-mm-add-kmemleak-verbose-dedup-test.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

