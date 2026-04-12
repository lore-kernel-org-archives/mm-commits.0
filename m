Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4E2302149
	for <mm-commits@vger.kernel.org>; Sun, 12 Apr 2026 18:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776018240; cv=none; b=Rcr3toQsUmCd8csCpXiIA0UF+cLxCE/QLH7DFtJmWGH+jt0+H7itspZ1SmwJCD6mJffC9JZzT/QqESggo67JF9y3cp+Yd7XytL5ZmqmCz3brOGm6Q2dbGLy8LI51ZmN1i/0NNrWyJqir2tlm/TQ2/S5M0UWGbkoOalr4BP9fbdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776018240; c=relaxed/simple;
	bh=jITB7PqTJre4BQE25FKa2C/uI2ak4/cNP2NIDnO5mek=;
	h=Date:To:From:Subject:Message-Id; b=Tq4MioQhrBGt3KCiqlGQXIwr9MofmZ8oOwsNE226Qh2nTP6gIe8b/z8CobNjaPj5UF762654d13atm4I3o0JfDK02gfnY6C6iOVOjDvQqiUJoQAO/xDNRojfzihuL9BJai/tO5HGrUtWoNUZkGV3c0DQ9O27EtNWt5853zXtpls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zygkt2X4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zygkt2X4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AD1C19424;
	Sun, 12 Apr 2026 18:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776018239;
	bh=jITB7PqTJre4BQE25FKa2C/uI2ak4/cNP2NIDnO5mek=;
	h=Date:To:From:Subject:From;
	b=zygkt2X46f76SjBf6X/9ubHSTy2ufgwlPB9fVYNS+6/fsOBVXUbq4sP6INv71phoc
	 dYybIGrBk7PqYsVjxBuDNYVV6WFIEcWsm3GoJD+NGfuxIfuDGpTGxVe9Jl7pSlh5fR
	 gv0z/liy6BiwBz4F5eZ29jk1fURBxjQqFOcEL8UI=
Date: Sun, 12 Apr 2026 11:23:56 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,seanjc@google.com,rppt@kernel.org,peterx@redhat.com,pbonzini@redhat.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,kalyazin@amazon.com,jthoughton@google.com,hughd@google.com,harry.yoo@oracle.com,harry@kernel.org,david@kernel.org,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,avagin@google.com,aarcange@redhat.com,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] userfaultfd-mfill_atomic-remove-retry-logic-fix.patch removed from -mm tree
Message-Id: <20260412182359.50AD1C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()
has been removed from the -mm tree.  Its filename was
     userfaultfd-mfill_atomic-remove-retry-logic-fix.patch

This patch was dropped because an updated version will be issued

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
mm-page_io-use-sio-len-for-pswpin-accounting-in-sio_read_complete.patch
ocfs2-use-get_random_u32-where-appropriate.patch

