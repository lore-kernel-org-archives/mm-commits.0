Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F63143888
	for <mm-commits@vger.kernel.org>; Thu,  9 Jan 2025 05:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736401487; cv=none; b=PGDMz6f42qLH9xqEjXFjU2qJXlH58RVbqXuVekN+shrHxOPkFTeEHRijLkRjbYCNtke0F/+2jbZzxWIRxw8SJC/uo9oAVtnfXO7E815bU86ii3ZK8+8LbK8XO7RkIKM5HPPVIoty+Ur3d75HMTwODv6oHONxFGDnHK/BUlIn588=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736401487; c=relaxed/simple;
	bh=y07tGh14uoVhWUYbfP3FUPl87mSgh1QEzx2BnFkUZD8=;
	h=Date:To:From:Subject:Message-Id; b=OC+Ki+Qmp/ElvtGgjfXSCfL2gdBhIS9Chb2K7aRmLS9RFoVDXIbJb9QIN86BFGdJ3NxhIxbYe3RHDuvzeA6KXOobdUiHxbsuPosZm08yeaXo3OMxWgJhuVw0kyXZNfUlePimVxI7Knp4ub6R2RQYSGh1l03xWDM77S0KVP5g0tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z6P5pNuu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z6P5pNuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877FCC4CED2;
	Thu,  9 Jan 2025 05:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736401486;
	bh=y07tGh14uoVhWUYbfP3FUPl87mSgh1QEzx2BnFkUZD8=;
	h=Date:To:From:Subject:From;
	b=z6P5pNuuVd9wxFC3cHRwQCb2TaB7V3lvag7l39lmHdxAKPQHNAe48sKajH6MM5oGF
	 1XrDHW2x0oh6Chae6YDo6M9wP5kGsx33ThorRi78SI//eT+ioRGscHOO0+LcCCX+nT
	 flpJdiM2ZlDkZWqOueApJ3rIajFYXBmZZmSJOUOw=
Date: Wed, 08 Jan 2025 21:44:46 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch added to mm-unstable branch
Message-Id: <20250109054446.877FCC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/debug: print vm_refcnt state when dumping the vma
has been added to the -mm mm-unstable branch.  Its filename is
     mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch

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
Subject: mm/debug: print vm_refcnt state when dumping the vma
Date: Wed, 8 Jan 2025 18:30:21 -0800

vm_refcnt encodes a number of useful states:

- whether vma is attached or detached
- the number of current vma readers
- presence of a vma writer

Let's include it in the vma dump.

Link: https://lkml.kernel.org/r/20250109023025.2242447-13-surenb@google.com
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
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/debug.c~mm-debug-print-vm_refcnt-state-when-dumping-the-vma
+++ a/mm/debug.c
@@ -178,6 +178,17 @@ EXPORT_SYMBOL(dump_page);
 
 void dump_vma(const struct vm_area_struct *vma)
 {
+#ifdef CONFIG_PER_VMA_LOCK
+	pr_emerg("vma %px start %px end %px mm %px\n"
+		"prot %lx anon_vma %px vm_ops %px\n"
+		"pgoff %lx file %px private_data %px\n"
+		"flags: %#lx(%pGv) refcnt %x\n",
+		vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_mm,
+		(unsigned long)pgprot_val(vma->vm_page_prot),
+		vma->anon_vma, vma->vm_ops, vma->vm_pgoff,
+		vma->vm_file, vma->vm_private_data,
+		vma->vm_flags, &vma->vm_flags, refcount_read(&vma->vm_refcnt));
+#else
 	pr_emerg("vma %px start %px end %px mm %px\n"
 		"prot %lx anon_vma %px vm_ops %px\n"
 		"pgoff %lx file %px private_data %px\n"
@@ -187,6 +198,7 @@ void dump_vma(const struct vm_area_struc
 		vma->anon_vma, vma->vm_ops, vma->vm_pgoff,
 		vma->vm_file, vma->vm_private_data,
 		vma->vm_flags, &vma->vm_flags);
+#endif
 }
 EXPORT_SYMBOL(dump_vma);
 
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

