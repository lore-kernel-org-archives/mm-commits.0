Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99A93CBE78
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 23:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782774735; cv=none; b=PbTMGEl4jg9GBC16YSs0XJQWXDkZd7KRMSPIIwUfrkJxgxwjEB52oA1gUSnMm7QhD7s6ayI2UkvV1mPlPGkKcNuWBe3AEzH/O9qPQfmm/ub/j/C9mw1MnCIjlTdss7MsjjV0jKDXuO7+2anREPSmDqMc7SkdpG5IqH/3R8Tz3vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782774735; c=relaxed/simple;
	bh=/ijmIbRVbZnTZX6t8tEyWiYbsGYzQLN/8h7jZvVteWY=;
	h=Date:To:From:Subject:Message-Id; b=uoZROj+pBVqlWqaSRtMUFlvUIr8oEGwCgk2lyr9CSg5b5nsA0kw+HtEx8Bv+aXi2HLSKNa7uFGlftm966odsAF0glJEg8L+s02Vbvw+gQxcSz+ZG18tzTIMz9EUHfLdtzVQT0h52Vopa4uTATPQlPtS73Kb2KTxjpHqGJOrUQsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qhvrK0aJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qhvrK0aJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DC51F000E9;
	Mon, 29 Jun 2026 23:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782774733;
	bh=xEi8V2107qQuf50M0GBmV6sV+sQLSPcBR5MdMnh20+Q=;
	h=Date:To:From:Subject;
	b=qhvrK0aJrcRexU+O2pzs7wZYTVl6xdcTSFb1/a7gwHI1pDahC2M7oNhY5Y6Tr/GpT
	 ejnBfFdM/eZfTxaMBSKR8Rx4eK5k8e+oHNGyi+O7aVMvF4/fnuvBthMSnpj6Grcckt
	 6mOc0+/bOotYQHwS8YU9dS/1N3MnfRCGSM0iqrd4=
Date: Mon, 29 Jun 2026 16:12:12 -0700
To: mm-commits@vger.kernel.org,manuelebner@mailbox.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] docs-mm-fix-brackets.patch removed from -mm tree
Message-Id: <20260629231213.50DC51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs/mm: fix brackets
has been removed from the -mm tree.  Its filename was
     docs-mm-fix-brackets.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Manuel Ebner <manuelebner@mailbox.org>
Subject: docs/mm: fix brackets
Date: Sat, 27 Jun 2026 11:32:59 +0200

Remove unnecessary ')' and missing '('.

Link: https://lore.kernel.org/20260627093258.31265-2-manuelebner@mailbox.org
Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/hmm.rst           |    4 ++--
 Documentation/mm/process_addrs.rst |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/mm/hmm.rst~docs-mm-fix-brackets
+++ a/Documentation/mm/hmm.rst
@@ -191,7 +191,7 @@ like a CPU page fault. The usage pattern
       mmap_read_unlock(mm);
 
       take_lock(driver->update);
-      if (mmu_interval_read_retry(&ni, range.notifier_seq) {
+      if (mmu_interval_read_retry(&ni, range.notifier_seq)) {
           release_lock(driver->update);
           goto again;
       }
@@ -316,7 +316,7 @@ between device driver specific code and
    system memory and device private memory.
 
    One of the first steps migrate_vma_setup() does is to invalidate other
-   device's MMUs with the ``mmu_notifier_invalidate_range_start(()`` and
+   device's MMUs with the ``mmu_notifier_invalidate_range_start()`` and
    ``mmu_notifier_invalidate_range_end()`` calls around the page table
    walks to fill in the ``args->src`` array with PFNs to be migrated.
    The ``invalidate_range_start()`` callback is passed a
--- a/Documentation/mm/process_addrs.rst~docs-mm-fix-brackets
+++ a/Documentation/mm/process_addrs.rst
@@ -724,7 +724,7 @@ the zap and the invocation of :c:func:`!
 
 Since it is assumed that all such steps have been taken, page table entries are
 cleared without page table locks (in the :c:func:`!pgd_clear`, :c:func:`!p4d_clear`,
-:c:func:`!pud_clear`, and :c:func:`!pmd_clear` functions.
+:c:func:`!pud_clear`, and :c:func:`!pmd_clear` functions).
 
 .. note:: It is possible for leaf page tables to be torn down independent of
           the page tables above it as is done by
_

Patches currently in -mm which might be from manuelebner@mailbox.org are

docs-mm-fix-braces.patch

