Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACF447B41D
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 20:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782852941; cv=none; b=Xm28f0ZJA+ATZNNPBYqxiSF5jVR7b0MN9tXAZxHjEA23srpz8bZkIgVXo2WqAx1tLHtAOCMgFsJO3vM2K4aXzuJzrhVchp/jWWRG2siv3HzF8ZOAUfsX31D4iIxjrH/z7wM6vz9NDgMdjscJOlSGV5CCxuIQPAQ834jeE4Qc0Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782852941; c=relaxed/simple;
	bh=unPopeq45hlPPtVKSvbLrVw/+0vFSKMQI38lqEISzaQ=;
	h=Date:To:From:Subject:Message-Id; b=TyL5YvfKrNhNpQzBy285uyptFffmva6AohpOke55JaTxErOxa7zIVcNtBXiUxq8Jdlkoe+zXWhkgK+iPTliIC4Ut5JcNQRnPuXre5mKKFIWWm/qGFrNSzGtpoh80XsyC8s5sU6shOm/xuKzdauIgc1/CWMkC2n0+bKJKJtvHCr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ct3ITeHd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ct3ITeHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F01D1F000E9;
	Tue, 30 Jun 2026 20:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782852940;
	bh=iiOkMT4VHK+kgs5pBi2wOea6bi4sMASV1WhMYRMW2+Y=;
	h=Date:To:From:Subject;
	b=ct3ITeHdfZStQsfZpIhtoKbwfRmdPvcAgkKjAMd63SB2/qHQoGblPW/bqkvCjEJc+
	 4t27F39NwF0o0AYpeJemaM0LCaBFNSOGmamDe21M1t6M5CgwWhlmi7d50uLYD6sShZ
	 qKzocZI5wyGttpnm5ys4UCHQeoyr8q6QwIZ3gaFE=
Date: Tue, 30 Jun 2026 13:55:39 -0700
To: mm-commits@vger.kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-report-mf_msg_kernel-for-unrecoverable-kernel-pages.patch added to mm-unstable branch
Message-Id: <20260630205540.2F01D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: report MF_MSG_KERNEL for unrecoverable kernel pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-report-mf_msg_kernel-for-unrecoverable-kernel-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-report-mf_msg_kernel-for-unrecoverable-kernel-pages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2436,7 +2436,8 @@ try_again:
 	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
 	 */
 	res = get_hwpoison_page(p, flags);
-	if (!res) {
+	switch (res) {
+	case 0:
 		if (is_free_buddy_page(p)) {
 			if (take_page_off_buddy(p)) {
 				page_ref_inc(p);
@@ -2455,7 +2456,19 @@ try_again:
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
mm-memory-failure-drop-dead-error_states-entry-for-reserved-pages.patch
mm-memory-failure-surface-unhandlable-kernel-pages-as-enotrecoverable.patch
mm-memory-failure-report-mf_msg_kernel-for-unrecoverable-kernel-pages.patch
mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch
documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch
selftests-mm-add-hwpoison-panic-destructive-test.patch
mm-kmemleak-skip-the-remaining-scan-phases-when-interrupted.patch

