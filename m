Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA74D34750B
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 16:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777305609; cv=none; b=n6bjHxBFJoH9itZ8ZOn+XLDiMsZFefMFDaP+fagYYLFCOkYCzu5VqxnNQLvGS1BrUfUwMUGBSt8WiPS0fyzvJyUrUO08cqVuH6+vmqfqwZjj8tzZiLi06UwC/cu7EoIbBntZiTbZjg+9iZecytwUCRa1r1ZadK7LRrutq0g0UTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777305609; c=relaxed/simple;
	bh=IT/ZUIGgrC5Pmy+1qfTD3+DeHjae/oNLIWKouVVM1bo=;
	h=Date:To:From:Subject:Message-Id; b=P40MdWtH/vSvk0akaghsKhqu/4Nx0939PqfOawAXJw1/+4v0kSlew3DZopo6GFiNAvunU6OayULuhJ1bnYoEbz+ptJ9E1x0TBdRikwPH6eSuJvr5kljpXvB90x5xHmDI71tduyBrPwQZMnGCBIBOKbQuvRO3KiuQqBnQL8a2xr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t2SWxKir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t2SWxKir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25E1C19425;
	Mon, 27 Apr 2026 16:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777305609;
	bh=IT/ZUIGgrC5Pmy+1qfTD3+DeHjae/oNLIWKouVVM1bo=;
	h=Date:To:From:Subject:From;
	b=t2SWxKirl1JMCl9ePW4gEa4XLaBsdHnnd+Ve3TeYMlFqvT0hrR4s4C4xINU7RP3Pl
	 jzMuAH2Jjp/nZr55f9TdKTg27/uEMs5DIhj8eQssY7gYWDvZBYHr3UtgOTEwNwAUqb
	 aso2m89gw+N/h+ec9e+Q9X3wTfaoeAUZhuAsZG1w=
Date: Mon, 27 Apr 2026 09:00:09 -0700
To: mm-commits@vger.kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch removed from -mm tree
Message-Id: <20260427160009.B25E1C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: document panic_on_unrecoverable_memory_failure sysctl
has been removed from the -mm tree.  Its filename was
     documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch

This patch was dropped because an updated version will be issued

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
Cc: Lance Yang <lance.yang@linux.dev>
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

selftests-mm-regression-test-for-panic_on_unrecoverable_memory_failure.patch
mm-huge_memory-use-sysfs_match_string-in-defrag_store.patch
mm-huge_memory-refactor-defrag_show-to-use-defrag_flags.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

