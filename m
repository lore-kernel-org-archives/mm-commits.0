Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155E13815DB
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 12:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777035108; cv=none; b=GnhF1pwEwDJU/LwQhzd3LjPGFJhZMy9HPbYEFGbDBE1g8XY4KbyWtyPo/yp/vuNjpDOuafBBn0nSTAgyQqjn6+RFwCxUE/rTW/4isNiL1YBYf2GgtfGCkn1+MwhWv1HhFoknyYReS1tbJqqe5/pBof2Nc/68ZIy6q3I7nwLkzD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777035108; c=relaxed/simple;
	bh=OTkhxAxaG6vpwGyblOHzlxRQBw6DtFqIwrweeJytg8Q=;
	h=Date:To:From:Subject:Message-Id; b=h/BpQc93SILyJ9HTI8OdBk9m7TbXYVG62VO7aLmeixS10ArgMh/nHgxBakuC1X8lHUWbToBR0FK2ASbrscPKLJaqUhVmSIRLY+Wjjz78aOAX08rLjVBFdreIcU2ahV2qBdDWqAg802/B5tjIh3f9gqQnYovIsYpZR3e7Snri44s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dUrV9gQ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dUrV9gQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A580EC19425;
	Fri, 24 Apr 2026 12:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777035107;
	bh=OTkhxAxaG6vpwGyblOHzlxRQBw6DtFqIwrweeJytg8Q=;
	h=Date:To:From:Subject:From;
	b=dUrV9gQ8SydQP8XjiefmOPx7n/UiD/j/ojkVqH391a0OVCKY0JF+yx0x0HaWMBaMp
	 JWoqYrwgcapN2xcPTfnw2XXO41ZbfB/4R327Qrq5ONgleq3WoGXnGEzo+pgo7LNQY0
	 I7UP5T5Xy2ecKoPCp3ben5wOUsEnVmqYVgutvsgU=
Date: Fri, 24 Apr 2026 05:51:47 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,nao.horiguchi@gmail.com,mhocko@suse.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,david@kernel.org,corbet@lwn.net,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch added to mm-new branch
Message-Id: <20260424125147.A580EC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: document panic_on_unrecoverable_memory_failure sysctl
has been added to the -mm mm-new branch.  Its filename is
     documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch

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
Subject: Documentation: document panic_on_unrecoverable_memory_failure sysctl
Date: Fri, 24 Apr 2026 05:24:01 -0700

Add documentation for the new vm.panic_on_unrecoverable_memory_failure
sysctl, describing the three categories of failures that trigger a panic
and noting which kernel page types are not yet covered.

Link: https://lore.kernel.org/20260424-ecc_panic-v5-3-a35f4b50425c@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |   65 ++++++++++++++++++++++
 1 file changed, 65 insertions(+)

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
@@ -925,6 +926,70 @@ panic_on_oom=2+kdump gives you very stro
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
+When enabled, this sysctl triggers a panic on three categories of
+unrecoverable failures: reserved kernel pages, non-buddy kernel pages
+with zero refcount (e.g. tail pages of high-order allocations), and
+pages whose state cannot be classified as recoverable.
+
+Note that some kernel page types — such as slab objects, vmalloc
+allocations, kernel stacks, and page tables — share a failure path
+with transient refcount races and are not currently covered by this
+option. I.e, do not panic when not confident of the page status.
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

kho-fix-error-handling-in-kho_add_subtree.patch
mm-memory-failure-report-mf_msg_kernel-for-reserved-pages.patch
mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch
documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch
selftests-mm-regression-test-for-panic_on_unrecoverable_memory_failure.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

