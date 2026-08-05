Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC723B5E01
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896560; cv=none; b=V8Cus3skEMk2OKRwgX/7exmNN/hVMlMofb8lb6tOnYuiJ4qcZxHQVH4vAurywgckfnTARQ/wTCL89mmkR/qJ4SetA7ZfqkTY389rSg9CHs9MVCb9ZT2kKcR4dJmHbT+SuPJVLM3TEB+LOW7Rt3FjG62z3EDU6qh/yY6+Fve5drc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896560; c=relaxed/simple;
	bh=LYwYCxETZ+K6+FCJ37ZonmHdNvO8yZHRbbF474OQaIs=;
	h=Date:To:From:Subject:Message-Id; b=SjEGhpJWE2pBYgdM8EGCrJ6UULAdF/OYs8Gn2fc5AOphJmn6ZTEw3EZ+kCPBnCFih8RIldzz/GUfntep713G6CYdA/aVEeIz+bLgXGjlhXnK6ygWBa/L5bgQWRZdMe0E7mQzfRR5XQEYUdJOxEZQLhnaMGHHj/y/tBhDQcPFXxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I1WH9x8Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I1WH9x8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30D51F000E9;
	Wed,  5 Aug 2026 02:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896559;
	bh=R27l7GqZqul08uJBvdXj5AUpfZSyJ0kkEZG0KO07lCM=;
	h=Date:To:From:Subject;
	b=I1WH9x8Y6QRdDqpb+T+ClJgJSq3sX3M8848UKCfpNV2eAXZMKMh2b/z7U+qWvNpdY
	 HgD7KxolG81z56dCMEzYk8EytU/gbcnC1J8M1Lcbr+IPHqXxfLBKhCpeIh21ikK7vF
	 zHLDt9P1JleCKQs9nm78rPE/XRVoNXq2Mzq1jpzk=
Date: Tue, 04 Aug 2026 19:22:38 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rostedt@goodmis.org,nao.horiguchi@gmail.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,david@kernel.org,corbet@lwn.net,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-report-mf_msg_kernel-for-unrecoverable-kernel-pages.patch removed from -mm tree
Message-Id: <20260805022238.E30D51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: report MF_MSG_KERNEL for unrecoverable kernel pages
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-report-mf_msg_kernel-for-unrecoverable-kernel-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm/memory-failure: report MF_MSG_KERNEL for unrecoverable kernel pages
Date: Tue, 30 Jun 2026 05:46:06 -0700

The previous patch teaches get_any_page() to return -ENOTRECOVERABLE for
stable unhandlable kernel pages (PG_reserved, slab, page tables,
large-kmalloc).  memory_failure() still folds every negative return into
MF_MSG_GET_HWPOISON, so callers that want to react to the unrecoverable
cases (a panic option, smarter logging) cannot tell them apart from
transient page-allocator races.

Turn the post-call branch into a switch over the get_hwpoison_page()
return code: map -ENOTRECOVERABLE to MF_MSG_KERNEL and any other negative
return to MF_MSG_GET_HWPOISON.  case 0 keeps the existing free-buddy /
kernel-high-order handling and case 1 falls through to the rest of
memory_failure() unchanged.

The MF_MSG_KERNEL label and tracepoint string are kept as "reserved kernel
page" to avoid breaking userspace tools that match on those literals; the
enum value still adequately tags the failure even though it now also
covers slab, page tables and large-kmalloc pages.

Link: https://lore.kernel.org/20260630-ecc_panic-v10-3-c6ed5b62eea2@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
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

 mm/memory-failure.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-report-mf_msg_kernel-for-unrecoverable-kernel-pages
+++ a/mm/memory-failure.c
@@ -2437,7 +2437,8 @@ try_again:
 	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
 	 */
 	res = get_hwpoison_page(p, flags);
-	if (!res) {
+	switch (res) {
+	case 0:
 		if (is_free_buddy_page(p)) {
 			if (take_page_off_buddy(p)) {
 				page_ref_inc(p);
@@ -2456,7 +2457,19 @@ try_again:
 			res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
 		}
 		goto unlock_mutex;
-	} else if (res < 0) {
+	case 1:
+		/* Got a refcount on a handlable page. */
+		break;
+	case -ENOTRECOVERABLE:
+		/*
+		 * Stable unhandlable kernel-owned page (PG_reserved,
+		 * slab, page tables, large-kmalloc).
+		 * No recovery possible.
+		 */
+		res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
+		goto unlock_mutex;
+	default:
+		/* Transient lifecycle race with the page allocator. */
 		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
 		goto unlock_mutex;
 	}
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

