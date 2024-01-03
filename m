Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6607EB
	for <mm-commits@vger.kernel.org>; Wed,  3 Jan 2024 00:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bJUhxHc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72188C433C8;
	Wed,  3 Jan 2024 00:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704243015;
	bh=FU0FdfI0g3XTKvnUt9+5KuGpAhcC8iXuMK/zdez3H6U=;
	h=Date:To:From:Subject:From;
	b=bJUhxHc+5oTlQgRQoRZOUlt2C9aj2ZejBywAvU0lSIBkP0yYp1vrpdOKZpK7VneRD
	 aHBHATOdg3ADYY9n2CtToABjNKbPPGR7K0Yo1BmxJNm8VrjLqsDVaxyOpVEAdHcFrS
	 G/xi8dMBuHhRpslEFHKDQAi5PTDGIWF7X5Z+oKHc=
Date: Tue, 02 Jan 2024 16:50:14 -0800
To: mm-commits@vger.kernel.org,zhangpeng362@huawei.com,willy@infradead.org,viro@zeniv.linux.org.uk,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,ngeoffray@google.com,mhocko@suse.com,lokeshgidra@google.com,Liam.Howlett@oracle.com,kaleshsingh@google.com,jannh@google.com,hughd@google.com,david@redhat.com,brauner@kernel.org,bgeffon@google.com,axelrasmussen@google.com,aarcange@redhat.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-fix-move_pages_pte-splitting-folio-under-rcu-read-lock.patch added to mm-unstable branch
Message-Id: <20240103005015.72188C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: fix move_pages_pte() splitting folio under RCU read lock
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-fix-move_pages_pte-splitting-folio-under-rcu-read-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-fix-move_pages_pte-splitting-folio-under-rcu-read-lock.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: userfaultfd: fix move_pages_pte() splitting folio under RCU read lock
Date: Tue, 2 Jan 2024 15:32:56 -0800

While testing the split PMD path with lockdep enabled I've got an "Invalid
wait context" error caused by split_huge_page_to_list() trying to lock
anon_vma->rwsem while inside RCU read section.  The issues is due to
move_pages_pte() calling split_folio() under RCU read lock.  Fix this by
unmapping the PTEs and exiting RCU read section before splitting the folio
and then retrying.  The same retry pattern is used when locking the folio
or anon_vma in this function.  After splitting the large folio we unlock
and release it because after the split the old folio might not be the one
that contains the src_addr.

Link: https://lkml.kernel.org/r/20240102233256.1077959-1-surenb@google.com
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Nicolas Geoffray <ngeoffray@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: ZhangPeng <zhangpeng362@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/userfaultfd.c~userfaultfd-fix-move_pages_pte-splitting-folio-under-rcu-read-lock
+++ a/mm/userfaultfd.c
@@ -1078,9 +1078,18 @@ retry:
 
 		/* at this point we have src_folio locked */
 		if (folio_test_large(src_folio)) {
+			/* split_folio() can block */
+			pte_unmap(&orig_src_pte);
+			pte_unmap(&orig_dst_pte);
+			src_pte = dst_pte = NULL;
 			err = split_folio(src_folio);
 			if (err)
 				goto out;
+			/* have to reacquire the folio after it got split */
+			folio_unlock(src_folio);
+			folio_put(src_folio);
+			src_folio = NULL;
+			goto retry;
 		}
 
 		if (!src_anon_vma) {
_

Patches currently in -mm which might be from surenb@google.com are

userfaultfd-fix-move_pages_pte-splitting-folio-under-rcu-read-lock.patch
selftests-mm-add-separate-uffdio_move-test-for-pmd-splitting.patch

