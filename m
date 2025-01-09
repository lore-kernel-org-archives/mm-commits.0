Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2C4143888
	for <mm-commits@vger.kernel.org>; Thu,  9 Jan 2025 05:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736401489; cv=none; b=sfeXY48KVNawjOuiz22haiVmCVhKWxyk3sIu2jzmAVLC+yeV+miCeN/kg7Q7ZpnhI0prg9031rIBAhGzImFfdA/U5ImIJflFvUHZ1NUej3hsdxa3dqZJk5RJExjEZ0H1xhBelVpG4WrJrZgQxO8S7JWQZOOzibwftS1PJSqCecA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736401489; c=relaxed/simple;
	bh=heVR0dioSFW7eO1WAbPg7HPyY6p59/+ZB2m/alySRjg=;
	h=Date:To:From:Subject:Message-Id; b=uipI6+7LdL2Gm1v/O7qcqqzBDkRyn2T/90A4QdWcy+Bw8XHzVLm4JuYOpFZxt+pd4uk7/DqtS19trb4fZb9NcIe5O9PlvILymAn+rsE8iQQDfBpK0T/FqZAIF85Fy5RY+yv6qW2Z0TsWkr3LNgLigPDJXgSgfBpaJuYtHEivBa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HBgPsGSN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HBgPsGSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C007EC4CED2;
	Thu,  9 Jan 2025 05:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736401488;
	bh=heVR0dioSFW7eO1WAbPg7HPyY6p59/+ZB2m/alySRjg=;
	h=Date:To:From:Subject:From;
	b=HBgPsGSNAlO2CP/M2YV10qteHJR6SI9tX5LxHQq7O5AY4p7SZ9qCYx6sgDJEe+56O
	 ihREZph4ZGyAYaTNzqa96+ODDmTwsbRvhWD4znfs44tdx4ULJA4Le0uT63JhUq/sha
	 C796u0BxB6zJKlgrPRt+e+lscsC6xrX99U1kAnmM=
Date: Wed, 08 Jan 2025 21:44:48 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-extra-vma_numab_state_init-call.patch added to mm-unstable branch
Message-Id: <20250109054448.C007EC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove extra vma_numab_state_init() call
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-extra-vma_numab_state_init-call.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-extra-vma_numab_state_init-call.patch

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
Subject: mm: remove extra vma_numab_state_init() call
Date: Wed, 8 Jan 2025 18:30:22 -0800

vma_init() already memset's the whole vm_area_struct to 0, so there is no
need to an additional vma_numab_state_init().

Link: https://lkml.kernel.org/r/20250109023025.2242447-14-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/mm.h~mm-remove-extra-vma_numab_state_init-call
+++ a/include/linux/mm.h
@@ -948,7 +948,6 @@ static inline void vma_init(struct vm_ar
 	vma->vm_mm = mm;
 	vma->vm_ops = &vma_dummy_vm_ops;
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
-	vma_numab_state_init(vma);
 	vma_lock_init(vma, false);
 }
 
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-skip-pgalloc_tag_swap-if-profiling-is-disabled.patch
tools-fix-atomic_set-definition-to-set-the-value-correctly.patch
seqlock-add-raw_seqcount_try_begin.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculate_try_beginretry.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas.patch
mm-mark-vmas-detached-upon-exit.patch
types-move-struct-rcuwait-into-typesh.patch
mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch
mm-move-mmap_init_lock-out-of-the-header-file.patch
mm-uninline-the-main-body-of-vma_start_write.patch
refcount-introduce-__refcount_addinc_not_zero_limited.patch
mm-replace-vm_lock-and-detached-flag-with-a-reference-count.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch
mm-remove-extra-vma_numab_state_init-call.patch
mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
docs-mm-document-latest-changes-to-vm_lock.patch
alloc_tag-avoid-current-alloc_tag-manipulations-when-profiling-is-disabled.patch

