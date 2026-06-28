Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6961017BA6
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 01:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782611169; cv=none; b=T0GapsFN+ffD0Y5dSC5FbDfLsqHS5R98lS5NTq0eYSWnsGhJ9IcmfCLebiku7iLStUHYoShmEFiN3YUfWTUPQB3tg/1VvJSTtrGWc5gjZva0hGLo7+61dvbKPWmvFmkIux1FrEdjsHy10dP3rIAe7RJqPHSwcoVLzgJ8u0TEsOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782611169; c=relaxed/simple;
	bh=2iXpWJLV52KvmZzmTCyhGb2QY2jFkHia6V5QYS0lbx8=;
	h=Date:To:From:Subject:Message-Id; b=Xoup19r1Z0xfEPPjY3re73BxQ9zJkfmP5tbwcvnL/sr/XKmObXrk5T3ca32n76sGHmPFx8ytXY3RBBsUnup9cFKIgD1gJ3xcT6MYqr03LIx0gEx9h7yfx4Cd1DZeHZuOHD0daa4q0sh+gWc+faRORZh0yd8y8rnqISO8A2yKJ4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yXjrM/ng; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yXjrM/ng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5871F000E9;
	Sun, 28 Jun 2026 01:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782611168;
	bh=luB/kH272on34DxfIa2nQ2nRFRGkDlNIRgWquJn5JWs=;
	h=Date:To:From:Subject;
	b=yXjrM/ngcMKLEJDyfvmktJr6rG53WVxspisPAZxdQahFKJAYpoPwPNEK15mXIn7YF
	 n+VmM43KuPNKS2vHK6kWZgWEaZ+BFSAsavRn46uQT93DWyMlC3edO7gX1N6rwPJH97
	 74C4qd34ku3MQgldRUa3hfphQRLp44ZY9muIQU68=
Date: Sat, 27 Jun 2026 18:46:07 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,manuelebner@mailbox.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-fix-brackets.patch added to mm-new branch
Message-Id: <20260628014607.EF5871F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs/mm: fix brackets
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-fix-brackets.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-fix-brackets.patch

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

docs-mm-fix-brackets.patch

