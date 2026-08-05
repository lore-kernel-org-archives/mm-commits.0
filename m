Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9883BCD23
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896564; cv=none; b=pvZd25D24NrE7bAjJmRvjouLjCSuGHojPMYsKmH4XEuhhrvHZzpfwtQ8qPb0yJdogHNXBK1cOnxf8UF1qYx9pyC3cPFPnqxItZwR7z9jrbA7s247GY57LQEl8JO4MiVNNHRHV6ZSsLfO6SqJuoyumOgRPCiINc3BGdL2L6e8WnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896564; c=relaxed/simple;
	bh=p5OOaO9cBisPmbBFswXOWpxicWW2qBRV59MXLsHcbog=;
	h=Date:To:From:Subject:Message-Id; b=DJrIvJiUVNUn2Jxz0tbuAj3bcaL4VYKoUYDwcRHn+iw/so9hoqTuuzR4MjX6+rg5EplWuMgtonyCtoJhj64tXoh5FxdcSwQydmiaqPTuN/9ZcAAv7cvyGnn9w7GawEHcp86nu6U8Nhr9nXbQb0NxDd66CBSXB97cZWuB3nyj6XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XskPG4Wy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XskPG4Wy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05221F000E9;
	Wed,  5 Aug 2026 02:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896562;
	bh=cEiPpCRWjaNagnkmxO5Qwd8NIBK9XPMc6/47gasiO6M=;
	h=Date:To:From:Subject;
	b=XskPG4WyTSuw8FrwnvuYrB8TeTtla5V+vZE1mYexg6iDC7pZyjHNwZyBTL/lY+44x
	 EOVh7Qes0cKf5A5j7uQaOCsdJFMRU+J9GtaP2IUA6scrz0dJk6WAL+qXxYeL1XotgX
	 4Dlw2t60g2ODlMCVvOhQkzNUBnYYnxGHnmWzD7Xw=
Date: Tue, 04 Aug 2026 19:22:42 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rostedt@goodmis.org,nao.horiguchi@gmail.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,david@kernel.org,corbet@lwn.net,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch removed from -mm tree
Message-Id: <20260805022242.B05221F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: document panic_on_unrecoverable_memory_failure sysctl
has been removed from the -mm tree.  Its filename was
     documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: Documentation: document panic_on_unrecoverable_memory_failure sysctl
Date: Tue, 30 Jun 2026 05:46:08 -0700

Add documentation for the new vm.panic_on_unrecoverable_memory_failure
sysctl, describing which failures trigger a panic (kernel-owned pages the
handler cannot recover) and which are intentionally left out (transient
allocator races and unclassified pages).

Link: https://lore.kernel.org/20260630-ecc_panic-v10-5-c6ed5b62eea2@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |   80 ++++++++++++++++++++++
 1 file changed, 80 insertions(+)

--- a/Documentation/admin-guide/sysctl/vm.rst~documentation-document-panic_on_unrecoverable_memory_failure-sysctl
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -67,6 +67,7 @@ Currently, these files are in /proc/sys/
 - page-cluster
 - page_lock_unfairness
 - panic_on_oom
+- panic_on_unrecoverable_memory_failure
 - percpu_pagelist_high_fraction
 - stat_interval
 - stat_refresh
@@ -925,6 +926,85 @@ panic_on_oom=2+kdump gives you very stro
 why oom happens. You can get snapshot.
 
 
+panic_on_unrecoverable_memory_failure
+======================================
+
+When a hardware memory error (e.g. multi-bit ECC) hits a kernel page
+that cannot be recovered by the memory failure handler, the default
+behaviour is to ignore the error and continue operation.  This is
+dangerous because the corrupted data remains accessible to the kernel,
+risking silent data corruption or a delayed crash when the poisoned
+memory is next accessed.
+
+When enabled, this sysctl triggers a panic on memory failure events
+hitting kernel-owned pages that the handler cannot recover:
+``PageReserved`` (firmware reservations, kernel image, vDSO, zero
+page, and similar memblock-reserved regions), ``PageSlab``,
+``PageTable``, and ``PageLargeKmalloc``.  These are owned by the
+kernel and the memory failure handler cannot reliably evict their
+contents.
+
+Other unrecoverable kernel-owned populations (vmalloc allocations,
+kernel stack pages, ...) are not currently covered because the
+handler has no page-type signal that distinguishes them from a
+userspace folio temporarily off the LRU during migration or
+compaction.  Such pages still go through the standard
+MF_MSG_GET_HWPOISON path: ``PG_hwpoison`` is set on them and a
+delayed crash on the next access remains possible.  Coverage may
+grow as the handler gains stronger kernel-ownership signals.
+
+Recoverable failure paths are also intentionally left out: in-flight
+buddy allocations and other transient races with the page allocator
+can reach the same diagnostic, and panicking on them would risk
+killing the box for a page destined for userspace where the standard
+SIGBUS recovery path applies.  Pages whose state could not be
+classified at all are not covered either, since an unknown state is
+not a sound basis for a panic decision.
+
+For many environments it is preferable to panic immediately with a clean
+crash dump that captures the original error context, rather than to
+continue and face a random crash later whose cause is difficult to
+diagnose.
+
+Use cases
+---------
+
+This option is most useful in environments where unattributed crashes
+are expensive to debug or where data integrity must take precedence
+over availability:
+
+* Large fleets, where multi-bit ECC errors on kernel pages are observed
+  regularly and post-mortem analysis of an unrelated downstream crash
+  (often seconds to minutes after the original error) consumes
+  significant engineering effort.
+
+* Systems configured with kdump, where panicking at the moment of the
+  hardware error produces a vmcore that still contains the faulting
+  address, the affected page state, and the originating MCE/GHES
+  record — context that is typically lost by the time a delayed crash
+  occurs.
+
+* High-availability clusters that rely on fast, deterministic node
+  failure for failover, and prefer an immediate panic over silent data
+  corruption propagating to replicas or persistent storage.
+
+* Kernel and platform developers reproducing hwpoison issues with
+  tools such as ``mce-inject`` or error-injection debugfs interfaces,
+  where panicking on the unrecoverable path makes regressions
+  immediately visible instead of surfacing as later, unrelated
+  failures.
+
+= =====================================================================
+0 Try to continue operation (default).
+1 Panic immediately.  If the ``panic`` sysctl is also non-zero then the
+  machine will be rebooted.
+= =====================================================================
+
+Example::
+
+     echo 1 > /proc/sys/vm/panic_on_unrecoverable_memory_failure
+
+
 percpu_pagelist_high_fraction
 =============================
 
_

Patches currently in -mm which might be from leitao@debian.org are

mm-migrate-report-rcu-tasks-quiescent-states-in-migrate_pages_batch.patch
mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans.patch
mm-kmemleak-factor-leak-confirmation-into-a-helper.patch
selftests-mm-test-kmemleaks-n-consecutive-scan-leak-confirmation.patch
radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
mm-kmemleak-report-rcu-tasks-quiescent-states-during-the-scan.patch
mm-kmemleak-default-min_unref_scans-to-2-for-verbose-auto-scan.patch
documentation-kmemleak-document-the-conditional-min_unref_scans-default.patch
selftests-mm-kmemleak-drop-stale-min_unref_scans-default-from-comments.patch

