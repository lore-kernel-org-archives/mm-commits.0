Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9912E1F02
	for <mm-commits@vger.kernel.org>; Thu,  9 Apr 2026 15:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775749219; cv=none; b=HKhlACmtflCnD6s2GeUCr5v24YF1KaMQatRyN68fcvQ+wj0jMbNrHouxt8njikUpKRVcr93vWRWkjsYwdChMeb/NvKFA3dgtXChJru3nUQW1lCrC8JNGFrTND5YtUcjNzK9WgujRZiYYxVDb9QRood3Dwx5TunKVwC6aqKMpiKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775749219; c=relaxed/simple;
	bh=zFZJE+gvH10P77a65rj9Uh5tBPzDCxcU5LAMpMl9K7g=;
	h=Date:To:From:Subject:Message-Id; b=E5uWUcYxYno3NtE10NTubeuRgikf70SvKeX5hHSwQfSCEjMtOnGLyVHP3LNU4B/aA793647tNubqD8jP/2qjWfSjGlITwFr7wBh6b2VfwzjHXequwG/h6HYdwZKxkVVQcCwwD34n5jOoBEOJ5tg724oesnIWMacu6e8pD+OH8Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uaP99Olv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uaP99Olv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF48C4CEF7;
	Thu,  9 Apr 2026 15:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775749219;
	bh=zFZJE+gvH10P77a65rj9Uh5tBPzDCxcU5LAMpMl9K7g=;
	h=Date:To:From:Subject:From;
	b=uaP99OlvyrOKTRBZAIu6yFkEk2UJIJPLmby+pVqTWsBw63wxQqwHIwlRiCDyd1yn3
	 r2DB/gvZfao/SDUjSrFzq1NPinHIq13d8kzOyMr3tFcLZlzJzL6MfKjKorQUXPMiry
	 bUJhrDQubs0KYiIlQeD/w2w/+/n1oGsa3MmV17Y8=
Date: Thu, 09 Apr 2026 08:40:18 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,seanjc@google.com,rppt@kernel.org,peterx@redhat.com,pbonzini@redhat.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,kalyazin@amazon.com,jthoughton@google.com,hughd@google.com,harry.yoo@oracle.com,harry@kernel.org,david@kernel.org,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,avagin@google.com,aarcange@redhat.com,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-mfill_atomic-remove-retry-logic-fix.patch added to mm-unstable branch
Message-Id: <20260409154019.3CF48C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-mfill_atomic-remove-retry-logic-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-mfill_atomic-remove-retry-logic-fix.patch

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
From: David Carlier <devnexen@gmail.com>
Subject: mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()
Date: Thu, 9 Apr 2026 13:06:53 +0100

mfill_copy_folio_retry() drops mmap_lock for the copy_from_user() call. 
During this window, the VMA can be replaced with a different type (e.g. 
hugetlb), making the caller's ops pointer stale.  Subsequent use of the
stale ops can lead to incorrect folio handling or a kernel crash.

Pass the caller's ops into mfill_copy_folio_retry() and compare against
the current vma_uffd_ops() after re-acquiring the lock.  Return -EAGAIN if
they differ so the operation can be retried.

Link: https://lkml.kernel.org/r/20260409120653.290386-1-devnexen@gmail.com
Fixes: 59da5c32ffa3 ("userfaultfd: mfill_atomic(): remove retry logic")
Signed-off-by: David Carlier <devnexen@gmail.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrei Vagin <avagin@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Harry Yoo (Oracle) <harry@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nikita Kalyazin <kalyazin@amazon.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-mfill_atomic-remove-retry-logic-fix
+++ a/mm/userfaultfd.c
@@ -443,7 +443,9 @@ static int mfill_copy_folio_locked(struc
 	return ret;
 }
 
-static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio)
+static int mfill_copy_folio_retry(struct mfill_state *state,
+				  const struct vm_uffd_ops *ops,
+				  struct folio *folio)
 {
 	unsigned long src_addr = state->src_addr;
 	void *kaddr;
@@ -465,6 +467,14 @@ static int mfill_copy_folio_retry(struct
 	if (err)
 		return err;
 
+	/*
+	 * The VMA type may have changed while the lock was dropped
+	 * (e.g. replaced with a hugetlb mapping), making the caller's
+	 * ops pointer stale.
+	 */
+	if (vma_uffd_ops(state->vma) != ops)
+		return -EAGAIN;
+
 	err = mfill_establish_pmd(state);
 	if (err)
 		return err;
@@ -495,7 +505,7 @@ static int __mfill_atomic_pte(struct mfi
 		 * will take care of unlocking if needed.
 		 */
 		if (unlikely(ret)) {
-			ret = mfill_copy_folio_retry(state, folio);
+			ret = mfill_copy_folio_retry(state, ops, folio);
 			if (ret)
 				goto err_folio_put;
 		}
_

Patches currently in -mm which might be from devnexen@gmail.com are

mm-hugetlb-restore-reservation-on-error-in-hugetlb_mfill_atomic_pte-resubmission-path.patch
userfaultfd-mfill_atomic-remove-retry-logic-fix.patch
mm-page_io-use-sio-len-for-pswpin-accounting-in-sio_read_complete.patch
ocfs2-use-get_random_u32-where-appropriate.patch

