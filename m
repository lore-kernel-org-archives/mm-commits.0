Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0AB36C0CB
	for <mm-commits@vger.kernel.org>; Thu,  2 Apr 2026 18:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775154082; cv=none; b=ECFEhP7bN5FdtuzZiumn6oC4Ik4/b0c7Fxti9dwdnuPdfwQ51uGFYDtj8oU+7XyMK+8i/oSOzP032gwQ1RtA8sOZ3RfWxoKO1VIJ9uKZ863GimKLjTyOcN6/g9eGPl6wsVHTRwV6zanmVoaG/cHMe/b+0nPKwG//1Ke6jwDbWvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775154082; c=relaxed/simple;
	bh=uG2Sgg2uTCc7sEW1FoAWw1kvuyvC2EJgqY8yv4v5TP8=;
	h=Date:To:From:Subject:Message-Id; b=FnhenXl8OcVwV58Dlt1t5/Yf2Flsyq2oB3kCJQiCg2euOYaH4s727phpBXFbOqSqtuc8yQ7QHOiZBFeyQIRxigXIKl4wCUlcSG30Rzkl3Z/qTuoe/xs7/WN8W5S5dOB3pXNkMIoWLi9j9Vwx3l8ox/s/D2DWeAkA6iJ//vMOSuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K0bvw18x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K0bvw18x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EAE2C116C6;
	Thu,  2 Apr 2026 18:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775154082;
	bh=uG2Sgg2uTCc7sEW1FoAWw1kvuyvC2EJgqY8yv4v5TP8=;
	h=Date:To:From:Subject:From;
	b=K0bvw18xA+Uq72oFhfomNwrCJNJaGIOSAf99KIpaeIYLk+F09mLRoQSlQyx4O51EQ
	 HqsSDpzjNnvlzBhMQvxuD0l+ypl/OSXZJ44/j7BIGZAF0GVIEOdQUUiAoMS60PbxpP
	 5k97T+c3Gi5Pt290sMBshkbfbHwcbDFBA4TiDlW0=
Date: Thu, 02 Apr 2026 11:21:21 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,seanjc@google.com,peterx@redhat.com,pbonzini@redhat.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,kalyazin@amazon.com,jthoughton@google.com,hughd@google.com,harry.yoo@oracle.com,harry@kernel.org,david@kernel.org,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,avagin@google.com,aarcange@redhat.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-mfill_atomic-remove-retry-logic-fix.patch added to mm-unstable branch
Message-Id: <20260402182122.0EAE2C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: remove safety measure of not returning ENOENT from _copy
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
From: Mike Rapoport (Microsoft) <rppt@kernel.org>
Subject: userfaultfd: remove safety measure of not returning ENOENT from _copy
Date: Thu Apr 2 16:38:39 2026 +0300

Link: https://lkml.kernel.org/r/ac5zcDUY8CFHr6Lw@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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

 mm/userfaultfd.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-mfill_atomic-remove-retry-logic-fix
+++ a/mm/userfaultfd.c
@@ -530,9 +530,6 @@ err_filemap_remove:
 		ops->filemap_remove(folio, state->vma);
 err_folio_put:
 	folio_put(folio);
-	/* Don't return -ENOENT so that our caller won't retry */
-	if (ret == -ENOENT)
-		ret = -EFAULT;
 	return ret;
 }
 
_

Patches currently in -mm which might be from rppt@kernel.org are

userfaultfd-introduce-mfill_copy_folio_locked-helper.patch
userfaultfd-introduce-struct-mfill_state.patch
userfaultfd-introduce-mfill_establish_pmd-helper.patch
userfaultfd-introduce-mfill_get_vma-and-mfill_put_vma.patch
userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy.patch
userfaultfd-move-vma_can_userfault-out-of-line.patch
userfaultfd-introduce-vm_uffd_ops.patch
shmem-userfaultfd-use-a-vma-callback-to-handle-uffdio_continue.patch
userfaultfd-introduce-vm_uffd_ops-alloc_folio.patch
shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops.patch
userfaultfd-mfill_atomic-remove-retry-logic.patch
userfaultfd-mfill_atomic-remove-retry-logic-fix.patch

