Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3F2374187
	for <mm-commits@vger.kernel.org>; Thu,  2 Apr 2026 18:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775154218; cv=none; b=ba6Z/7qP0mQ0UGTzS/E91NmzGVgwcWssdobUWqeOt7GZElXPvcAcGpF6mwU5rkOjGiOi1sTMk5z1uunm1TtANrpTPNp1sYEMJg+6SO3smcncYr1ixTyHXL2byzYfBiBlnJTdQokW89QWcD2a/r6ns9rhOLIOk6auC+LZcmi991M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775154218; c=relaxed/simple;
	bh=Lyfdb/qLJJFSjyCcDf6AB8gmqvIVR59/4AwT0i6S6JM=;
	h=Date:To:From:Subject:Message-Id; b=sDYtIYvG30Br+A7yBr7H+u9fpZ2EISdgV0pYyLaQLzkmGOy/BhFIywN3F0DPl2BxYpUh16EOJwviQ4iSigPTbiR8lPmEh2ikQNdS72GESDP2A3oG2erRaJeZsHsPmKQ7TTq0/XxmxEIWEyy7t7A4b482Nda0CPlzp6+Kqb6G2oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BrtIiOhO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BrtIiOhO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2646C116C6;
	Thu,  2 Apr 2026 18:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775154217;
	bh=Lyfdb/qLJJFSjyCcDf6AB8gmqvIVR59/4AwT0i6S6JM=;
	h=Date:To:From:Subject:From;
	b=BrtIiOhONf0+yTIMJ4aaC8jjZlBSZmndD9wI327sbx4z+whKAaBh8rGZ+QvmSPOnW
	 DrUs/UNe87hxwNYUNeI7JnUcghIodzJY4Y0UWT5t03BvUHaf9/K2trTF4J9KwG0VOe
	 xtZeI2QscCPUaN31NtlXcJh/5K7jZFpYjXj0U6qI=
Date: Thu, 02 Apr 2026 11:23:37 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,seanjc@google.com,peterx@redhat.com,pbonzini@redhat.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,kalyazin@amazon.com,jthoughton@google.com,hughd@google.com,harry.yoo@oracle.com,harry@kernel.org,david@kernel.org,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,avagin@google.com,aarcange@redhat.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] userfaultfd-mfill_atomic-remove-retry-logic-fix.patch removed from -mm tree
Message-Id: <20260402182337.D2646C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: remove safety measure of not returning ENOENT from _copy
has been removed from the -mm tree.  Its filename was
     userfaultfd-mfill_atomic-remove-retry-logic-fix.patch

This patch was dropped because it was folded into userfaultfd-mfill_atomic-remove-retry-logic.patch

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

