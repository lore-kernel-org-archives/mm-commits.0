Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE72C1A9F9A
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 05:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754978396; cv=none; b=W1UrJ2kgi9vUH2WzGAX5dXOOX2/GTdSczZJXaarIoq810qywwReCw6UGR0XBDBcslWNfOO+LVk5OIGESmJ1Al7QWH3ZClUL8bvyOQKTv5yM5E4yn/5U1ZoL9drYf6qb9BRqcu22iq57ZfvveEeLPme5RHn0iNK4TM8WZZxrKj/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754978396; c=relaxed/simple;
	bh=ampaIofpsNeo0hUzB1o9s0mWe719UU7ylF4KmJGyQjY=;
	h=Date:To:From:Subject:Message-Id; b=Wx9FcCTllr0a8UBfH/sTZYFh23Oz9PfjA8MjJe7VgUwXOC+nXkHGAGkE7inRE5Gi5adqXQSMEDE4e+r9g6NrcEXjqsrtznckOeT/V7oQhcYRuJmSgRE48PyNpb2OHFqOK9IWlYbtebuuksbFPkrVahtpoF8q21XH49cE36LNGxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xp4IYfng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xp4IYfng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E87AC4CEF0;
	Tue, 12 Aug 2025 05:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754978396;
	bh=ampaIofpsNeo0hUzB1o9s0mWe719UU7ylF4KmJGyQjY=;
	h=Date:To:From:Subject:From;
	b=Xp4IYfng3AkR2mbAhk8CU4dZjsWBhFiYVCSCnxnxfWhr6uN0mCLC9qMhonjc5F5ne
	 4Wv09VToplbMnIiuH2GphBg5UNAwdR8V0SiQKInzR8ZCvMaPqJfLdjsy3CfSAoxoPW
	 lsQh9MUEBg6H9SlBkThEdjGcR3lhlrYpuepNkuIA=
Date: Mon, 11 Aug 2025 22:59:55 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,lokeshgidra@google.com,david@redhat.com,aarcange@redhat.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry-fix.patch removed from -mm tree
Message-Id: <20250812055956.2E87AC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry-fix
has been removed from the -mm tree.  Its filename was
     userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry-fix.patch

This patch was dropped because it was folded into userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry.patch

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry-fix
Date: Thu, 7 Aug 2025 13:04:18 -0700

remove extra folio check, per David

Link: https://lkml.kernel.org/r/20250807200418.1963585-1-surenb@google.com
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@google.com/
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry-fix
+++ a/mm/userfaultfd.c
@@ -1825,8 +1825,8 @@ ssize_t move_pages(struct userfaultfd_ct
 				if (pmd_present(*src_pmd)) {
 					struct folio *folio = pmd_folio(*src_pmd);
 
-					if (!folio || (!is_huge_zero_folio(folio) &&
-						       !PageAnonExclusive(&folio->page))) {
+					if (!is_huge_zero_folio(folio) &&
+					    !PageAnonExclusive(&folio->page)) {
 						spin_unlock(ptl);
 						err = -EBUSY;
 						break;
_

Patches currently in -mm which might be from surenb@google.com are

userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry.patch
mm-limit-the-scope-of-vma_start_read.patch
mm-change-vma_start_read-to-drop-rcu-lock-on-failure.patch
selftests-proc-test-procmap_query-ioctl-while-vma-is-concurrently-modified.patch
fs-proc-task_mmu-factor-out-proc_maps_private-fields-used-by-procmap_query.patch
fs-proc-task_mmu-execute-procmap_query-ioctl-under-per-vma-locks.patch

