Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205D0439F7E
	for <mm-commits@vger.kernel.org>; Tue, 11 Aug 2026 17:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786469107; cv=none; b=u8gD0shYD7x4xJi2R1jXgWfmDbEOeJOCW1OgyHKeSFkb5Lncu/Z+q3YXT1xDMb9FBnyot2Z2zQShUV3/tEE4/z78HN1B4/PlWb0rXmb5skAxRv5pBio92yQw+a4KYKwf/mUryZQ1veSBmb6aC+V5CaQakbs6BTAGVCefrhIshgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786469107; c=relaxed/simple;
	bh=hIsuiI7Usb100O95tTgigjaCz3U3sJTV5X2TV52mlUU=;
	h=Date:To:From:Subject:Message-Id; b=GNt1QlcCs3MmiACTZpjHQ1MweImYF5OkSh9JcDR0NLu7ADppJ096tEZq5XlZGE/s0AoWvaoAI3aLwBZeJoWHJuvxcNTQrpuf+twO4W2B9L+VWoNc1FhvvpYedpaUwgbud8NQJP5Kgn8EumwgN/Iu9PO6NjI8JE7f2YDKSQpFgac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xk6sci0a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xk6sci0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854D21F000E9;
	Tue, 11 Aug 2026 17:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786469105;
	bh=t5Pm5UWxEwHkYBfCtkVAunW3CDTAVdAa1tmUsyE16PM=;
	h=Date:To:From:Subject;
	b=xk6sci0a9pXk3+Ubt58Xry1VK4TCVUxtwACucwkU+6J818VX9astgS9NC1cz7Hacy
	 WcxJBvLnaFjnYsVhCscZZNuzsFIXQt1Kf3QyJWcBHPXGJeFKnF0N7SXS3VIrQ+lTUN
	 rV39O2/Dt91rTL6Ljs19S3eniWey0VmP/aV7liv4=
Date: Tue, 11 Aug 2026 10:25:05 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,kent.overstreet@linux.dev,catalin.marinas@arm.com,bigeasy@linutronix.de,arnd@arndb.de,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch removed from -mm tree
Message-Id: <20260811172505.854D21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: radix-tree: fix kmemleak false positives on tree head reassignment
has been removed from the -mm tree.  Its filename was
     radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch

This patch was dropped because it was withdrawn

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

mm-vmscan-report-rcu-tasks-quiescent-states-in-shrink_lruvec.patch
mm-kmemleak-report-rcu-tasks-quiescent-states-during-the-scan.patch
mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans.patch
mm-kmemleak-factor-leak-confirmation-into-a-helper.patch
selftests-mm-test-kmemleaks-n-consecutive-scan-leak-confirmation.patch
mm-kmemleak-default-min_unref_scans-to-2-for-verbose-auto-scan.patch
documentation-kmemleak-document-the-conditional-min_unref_scans-default.patch
selftests-mm-kmemleak-drop-stale-min_unref_scans-default-from-comments.patch

