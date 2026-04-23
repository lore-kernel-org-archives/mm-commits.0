Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBCB361660
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 16:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776960259; cv=none; b=LlJiD0FAC76PfarIG1/DJeRVtHdTwG4I/XvSmNn/ca+eDzu5zAJTX2YHRd5l6QbPjFK5fNKHwZzlrLq3nx1pKiKw/UcMBizRhIbwRD2WEO0PIMM5jN9t31mIZQEL5nwg+wmw1wh8BgTCssIwDTezCwgmlB3bcchtmlLXV7hPPE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776960259; c=relaxed/simple;
	bh=aDJmwkvTTcW5wLlwNBGXUw2inAvb7eJ0rxbvcudoFMs=;
	h=Date:To:From:Subject:Message-Id; b=YDN6Du9NhVDf9Zp0Cu041t83HjlEIGmIiZFr8IKZq2RPg7a9U70ETfPAhQc7dwzuFNV7J4H/DV8ahjQs+uNVH7Ha0aTIxS8NIO44poEG0yC7u1TYoIv68lV2af58X0cYYE4meNbzwvsS6Sz1Em2EFR6YR37JU9VLFQyz2ll4hpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c/pgDMQP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c/pgDMQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2AFC2BCAF;
	Thu, 23 Apr 2026 16:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776960258;
	bh=aDJmwkvTTcW5wLlwNBGXUw2inAvb7eJ0rxbvcudoFMs=;
	h=Date:To:From:Subject:From;
	b=c/pgDMQPoRHLM3Y2ys63gojsWvJDWhdv5UMVZsoB9lVRtBXyDfPlhNoZsPDz/Llh/
	 peKzCZbwexleC3me+nE7pmh/KomDLbP24NJl6i8VyTWca5lLMCHoFAgxsPc0Sb9QJz
	 qitQQ9cIGaJoSEr7q88isbYAHkdk3gvvpHUu6ngw=
Date: Thu, 23 Apr 2026 09:04:18 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-add-kmemleak-verbose-dedup-test.patch removed from -mm tree
Message-Id: <20260423160418.CC2AFC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add kmemleak verbose dedup test
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-kmemleak-verbose-dedup-test.patch

This patch was dropped because an updated version will be issued

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
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

