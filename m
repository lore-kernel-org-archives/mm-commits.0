Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29EE16F265
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735247758; cv=none; b=erfxCQn/IYPRzVXXvYG8lPKHW+WH55VQreL76oOWSOf5KqpfvRVmEW1dEeliI6cnGSFA7kd8qWNYT7ozhpQd0OURjFzZOLaFlVoXJ6BXpJdjxi3QToFwEWY4aJc+q1FBNEWrnX6w47o1FRDUJv/4BfIiUjcLY+Yzd/hF29BPsNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735247758; c=relaxed/simple;
	bh=EX9oKIWZp/KKas4/9JWMzBBlpJtNNJSwjdbSPOLeL0w=;
	h=Date:To:From:Subject:Message-Id; b=RWFLy5aFVG/1ssL/WDBTgwS5YNX7NEcqo3rP/5eS2qS9+iy5487y//vLR3EKYCGzrHJmWDpIjRpKtv4ia/03qOjCesDLFGRFp15h5dD8lF/AuIqEs10klXqRATIxsVIsuYeoEGKPzrkxeUiYGmJuIEGlyqaY5APTZ3FZGOv0Ox4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HSh5dv2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HSh5dv2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17C9C4CED1;
	Thu, 26 Dec 2024 21:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735247757;
	bh=EX9oKIWZp/KKas4/9JWMzBBlpJtNNJSwjdbSPOLeL0w=;
	h=Date:To:From:Subject:From;
	b=HSh5dv2+QSxWQr5YmSkShRcCobY5PuNdTQf10uiUe/bCmeGomQJeK4vw4u17XNzuY
	 nIi0xKzAmYzlnND95GOZQ17rzVA2/0xzodTSytTciGVC7DogtlBc9OLIHEIEBkmmvw
	 U5GjYQ4IMg+zgSc08k61eXCevBKHeKLErN0VeXJY=
Date: Thu, 26 Dec 2024 13:15:57 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oliver.sang@intel.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-nommu-fix-the-last-places-where-vma-is-not-locked-before-being-attached.patch added to mm-unstable branch
Message-Id: <20241226211557.A17C9C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/nommu: fix the last places where vma is not locked before being attached
has been added to the -mm mm-unstable branch.  Its filename is
     mm-nommu-fix-the-last-places-where-vma-is-not-locked-before-being-attached.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-nommu-fix-the-last-places-where-vma-is-not-locked-before-being-attached.patch

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
Subject: mm/nommu: fix the last places where vma is not locked before being attached
Date: Thu, 26 Dec 2024 09:06:58 -0800

nommu configuration has two places where vma gets attached to the vma tree
without write-locking it.  Add the missing locks to ensure vma is always
locked before it's attached.

Link: https://lkml.kernel.org/r/20241226170710.1159679-7-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: kernel test robot <oliver.sang@intel.com>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/nommu.c~mm-nommu-fix-the-last-places-where-vma-is-not-locked-before-being-attached
+++ a/mm/nommu.c
@@ -1189,6 +1189,7 @@ share:
 		goto error_just_free;
 
 	setup_vma_to_mm(vma, current->mm);
+	vma_start_write(vma);
 	current->mm->map_count++;
 	/* add the VMA to the tree */
 	vma_iter_store(&vmi, vma, true);
@@ -1356,6 +1357,7 @@ static int split_vma(struct vma_iterator
 
 	setup_vma_to_mm(vma, mm);
 	setup_vma_to_mm(new, mm);
+	vma_start_write(new);
 	vma_iter_store(vmi, new, true);
 	mm->map_count++;
 	return 0;
_

Patches currently in -mm which might be from surenb@google.com are

seqlock-add-raw_seqcount_try_begin.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculate_try_beginretry.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-modify-vma_iter_store_gfp-to-indicate-if-its-storing-a-new-vma.patch
mm-mark-vmas-detached-upon-exit.patch
mm-nommu-fix-the-last-places-where-vma-is-not-locked-before-being-attached.patch
types-move-struct-rcuwait-into-typesh.patch
mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch
mm-move-mmap_init_lock-out-of-the-header-file.patch
mm-uninline-the-main-body-of-vma_start_write.patch
refcount-introduce-__refcount_addinc_not_zero_limited.patch
mm-replace-vm_lock-and-detached-flag-with-a-reference-count.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma-fix.patch
mm-remove-extra-vma_numab_state_init-call.patch
mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
docs-mm-document-latest-changes-to-vm_lock.patch

