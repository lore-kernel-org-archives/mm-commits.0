Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB8B34DCC7
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 20:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782852615; cv=none; b=lwdn43ZC3WrUKmllzgLWvwW9EIcZ5tsq/SmAz3bG+mcXEb2DhBlUX89aBn2hb+cbvCwa2L4GEtsLLGNALFaDzjURX3bB3udYCBGKSUNVwJIOimotbr4Erh/akjfEE1iJl8fZsxgzKTaZ2QcND6QbIeeKyVlf9SVSootus8wudp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782852615; c=relaxed/simple;
	bh=391yj7zibjz37ndqdCWd8e4g02MA6ZqGrNBARH+7MHk=;
	h=Date:To:From:Subject:Message-Id; b=cRDgKnJTH4pKi8Aei8dqfFS7mnmJ6d9VFTDN6GdJlQmcPe6HPs3fBM+X1tzF855YdwB59mHfiJhuz8io3g1sasgj3MgUOjuM5cC+5bqlFw8y3NHexcWe2gejquILeX8aXKk49KiiTc1ITmdA8/F02sEzg3lvsounn+oFEjWaMHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JoE4Y1JS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JoE4Y1JS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB181F000E9;
	Tue, 30 Jun 2026 20:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782852614;
	bh=2Q6rGR7MmYisCymlo9OVzk//XZhDC3LOoNvYBTbFMmA=;
	h=Date:To:From:Subject;
	b=JoE4Y1JSJ/v+hl3zrryqk8gDPaVnkoEJr5rokqTjjUpcjp8srzXAaAN2waqdNWTdS
	 FC2vGk7XSc4DLyYmeQZK5UcaRpbsEYDQiyQl0MuijYa/msSbGDe3FtmI0xCXraGY3u
	 YkwVo3HZ/i9gCU7dIeoCO+0n5bE9Aodl1DshDxDc=
Date: Tue, 30 Jun 2026 13:50:13 -0700
To: mm-commits@vger.kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-failure-report-mf_msg_kernel-for-unrecoverable-kernel-pages.patch removed from -mm tree
Message-Id: <20260630205014.2FB181F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: report MF_MSG_KERNEL for unrecoverable kernel pages
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-report-mf_msg_kernel-for-unrecoverable-kernel-pages.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm/memory-failure: report MF_MSG_KERNEL for unrecoverable kernel pages
Date: Fri, 26 Jun 2026 08:33:17 -0700

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

Link: https://lore.kernel.org/20260626-ecc_panic-v10-3-6dacb8ad024d@debian.org
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
@@ -2434,7 +2434,8 @@ try_again:
 	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
 	 */
 	res = get_hwpoison_page(p, flags);
-	if (!res) {
+	switch (res) {
+	case 0:
 		if (is_free_buddy_page(p)) {
 			if (take_page_off_buddy(p)) {
 				page_ref_inc(p);
@@ -2453,7 +2454,19 @@ try_again:
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

mm-kmemleak-avoid-soft-lockup-when-scanning-task-stacks.patch
mm-kmemleak-stop-the-task-stack-scan-early-when-interrupted.patch
mm-kmemleak-stop-the-per-cpu-and-struct-page-scans-early-too.patch
a.patch
mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch
documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch
selftests-mm-add-hwpoison-panic-destructive-test.patch
mm-kmemleak-skip-the-remaining-scan-phases-when-interrupted.patch

