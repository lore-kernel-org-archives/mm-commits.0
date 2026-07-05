Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA479DDCD
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 02:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783217562; cv=none; b=pt+Q8PnxOrDx9AqZ6cT1Q9oeBfrzvJk9MSL98FeOmhceS+1eOTHw14sRVOCVzv0tqIWjuI6ZiWmRldVTb7qdh8XRf8uYLLJF6E08jI5aDvlOLk1OeXXZ2F8H63ZgEx2WkdACnEt+vhS0JXgz0PNA02QAKwMfHFbthSQNJ0YIxcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783217562; c=relaxed/simple;
	bh=MIwZeRxjIdZ5khrsr9m6B6J2+tyl3JbbrfgeW0jGDo0=;
	h=Date:To:From:Subject:Message-Id; b=GrI/o+MN46VbjL5WUrqTYFNYrJmbiao0seQs4xzvaiz5qNxVfNSQ+FS3h0r7aXlSb5QEUucqPx8Sil0T2Ns5MWwWKxQg+ek4PPw5XifefIi45DkJFn2kpTpIHzWjx0OEO+W1BfvX1GK0Y4VI2e6sK2SRr3FGMbHHZM+7kx9dXyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kjHGghCB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kjHGghCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E101F000E9;
	Sun,  5 Jul 2026 02:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783217560;
	bh=gU3lXV1QVdc7Qc4XF01bolUtNCGHqYgUTfJrIwKVemk=;
	h=Date:To:From:Subject;
	b=kjHGghCBaHZoaVKGGluMqCwBICE2pWRTEe+M9PEdOefqQ3VDhPJ/zXQ8Om2pA9dPn
	 /MZ+2FOXn/l4Hsnhwol4b2TjYClJDlj8ikA5Htqg1PYXMsyobbyGsV8nzpnxCL/MbD
	 ogwwfmhXTkEdhPMKJqd5w4vj6S/xv78b3huC8+vE=
Date: Sat, 04 Jul 2026 19:12:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,kent.overstreet@linux.dev,catalin.marinas@arm.com,bigeasy@linutronix.de,arnd@arndb.de,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch added to mm-new branch
Message-Id: <20260705021240.79E101F000E9@smtp.kernel.org>
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
Date: Fri, 03 Jul 2026 08:22:03 -0700

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

Add a matching kmemleak_transient_leak() stub to the radix tree test
harness so the userspace lib/radix-tree.c build keeps building.

Link: https://lore.kernel.org/20260703-radix-tree-v2-1-38bb6efb5f6e@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c                      |    7 ++++++-
 tools/testing/shared/linux/kmemleak.h |    1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

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
--- a/tools/testing/shared/linux/kmemleak.h~radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment
+++ a/tools/testing/shared/linux/kmemleak.h
@@ -1 +1,2 @@
 static inline void kmemleak_update_trace(const void *ptr) { }
+static inline void kmemleak_transient_leak(const void *ptr) { }
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-fix-checksum-computation-for-per-cpu-objects.patch
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

