Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B6D3D332B
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 22:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783032136; cv=none; b=Mt/mtDO0u+W7rNWQq1C474EO6opmdAm0PCBqDz+4ZZL6hasosFQu2DWRtiWA2VFLjaD84RhNGDdF4cnIJyZg8v0/XJvgdSEqy7DswsfJby1cZrn9JVoyEBNWXAylPkV7ZpEMfhsubDi0SwS6BQY7N1QBLWR5c2RyEWSPeeMAjWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783032136; c=relaxed/simple;
	bh=CccCQ/gfqjgYOcoFhzW5AHsZ7BFoSW/QxcEnb3iJkPI=;
	h=Date:To:From:Subject:Message-Id; b=NCY74t8zARO+T6DlZJ8AQs27gl88o6sVI+F1tlgf9JMRW8zGUawegM3y1AM2Hy8v+rgHXoG0zZIczDqtu4C1BnLAMtGSiSOkstpgld8uSVCotLEsHo4iismhqzn+YNVaTNucUXu/89tgVnEsICEqb5esWDH79i3stIPMaaSSG1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a/dzBoNl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a/dzBoNl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE791F000E9;
	Thu,  2 Jul 2026 22:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783032131;
	bh=3sG5lWENbLIEmNOU2FAUQbdRgNAiLgeVqfmxh5/37mw=;
	h=Date:To:From:Subject;
	b=a/dzBoNlaCYaaoENXSKudIjOcND0AxG0IhZY6S3FBpUgcpq6uG8Bz0K/2QPH55AJQ
	 RhaxYYxs6mLbF2FBjarG7NcKF7JQnOzWJaY28BRsyGSw8/M2qPh+6wsNVqkHG0Y6pv
	 DJ3u6vcCgkd6kOVzYHWcD94AWauCf12BlWXo8Luw=
Date: Thu, 02 Jul 2026 15:42:11 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,catalin.marinas@arm.com,bigeasy@linutronix.de,arnd@arndb.de,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch added to mm-new branch
Message-Id: <20260702224211.8EE791F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: radix-tree: fix kmemleak false positives on tree head reassignment
has been added to the -mm mm-new branch.  Its filename is
     radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch

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
Subject: radix-tree: fix kmemleak false positives on tree head reassignment
Date: Thu, 02 Jul 2026 05:58:34 -0700

Kmemleak periodically reports transient false positives for radix tree
nodes allocated through the IDR, for example:

  unreferenced object 0xffff0004d6ac4200 (size 576):
    comm "tcpeventd", pid 6412
    backtrace (crc 335d668a):
      kmem_cache_alloc_noprof
      radix_tree_node_alloc
      radix_tree_extend
      idr_get_free
      idr_alloc_cyclic
      map_create
      __sys_bpf

radix_tree_extend() (grow) and radix_tree_shrink() (shrink) repoint
root->xa_head to a new node.  If a kmemleak scan has already walked past
root->xa_head, the new head is not reachable from any scanned pointer
until the following scan, so kmemleak reports it as leaked even though it
is live.

This is the same race fixed for the XArray API in commit a1a029bcea59
("XArray: fix kmemleak false positive in xas_shrink()").  The IDR uses the
radix tree API directly and hits it on both the grow and the shrink path,
so mark the new head as a transient leak in both.

Link: https://lore.kernel.org/20260702-radix-tree-v1-1-a87c125b0f96@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/lib/radix-tree.c~radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment
+++ a/lib/radix-tree.c
@@ -455,6 +455,8 @@ static int radix_tree_extend(struct radi
 		node->slots[0] = (void __rcu *)entry;
 		entry = node_to_entry(node);
 		rcu_assign_pointer(root->xa_head, entry);
+		/* new head may be missed by an in-progress kmemleak scan */
+		kmemleak_transient_leak(node);
 		shift += RADIX_TREE_MAP_SHIFT;
 	} while (shift <= maxshift);
 out:
@@ -495,8 +497,11 @@ static inline bool radix_tree_shrink(str
 		if (!node->shift && is_idr(root))
 			break;
 
-		if (radix_tree_is_internal_node(child))
+		if (radix_tree_is_internal_node(child)) {
 			entry_to_node(child)->parent = NULL;
+			/* new head may be missed by an in-progress kmemleak scan */
+			kmemleak_transient_leak(entry_to_node(child));
+		}
 
 		/*
 		 * We don't need rcu_assign_pointer(), since we are simply
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

