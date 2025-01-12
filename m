Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E64219FF
	for <mm-commits@vger.kernel.org>; Sun, 12 Jan 2025 05:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736660812; cv=none; b=rFV0zKZsjrsZz3qtmka1Bl1IhY3fAMKHKWtqBzmqZ313M+uBudsuRBQT9VR5rFEki3C2e4xmZJjs7WCq50dafeyDwV7J6S08tWOcKpmIFsi1ITbV7i/4bOfeUKuqCgEE2lCsXOku0SXxoWKQUmruOPH8gQD6IpOI5CLmQ+qulZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736660812; c=relaxed/simple;
	bh=Epkiw66SD4dvh1BPRekWVeXs/sXyR3nJW1M+9mvggYw=;
	h=Date:To:From:Subject:Message-Id; b=BUL0enu5cDsZLgcU6fr2C4aCH50vZh4CCCkIP28kEZ+yugO+ZM5AiSyd3qMYkFlaDBpCCs4ffkQ3QEUHC+EBEMsUxlOGdk1U/rZEVWXyFdwfBNyN/6IkdZb8y7JwbocsuO3Jk7+NA6H8XjQBtWbnYC1K28eDAwfXgNJNCt1/F1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UnoGlWGw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UnoGlWGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96AEC4CEE0;
	Sun, 12 Jan 2025 05:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736660811;
	bh=Epkiw66SD4dvh1BPRekWVeXs/sXyR3nJW1M+9mvggYw=;
	h=Date:To:From:Subject:From;
	b=UnoGlWGw+nU0a08aearZcCp48r3ISxKasv8p3We1PCINtXYCm+8sjyFnVv2JQwZwe
	 yWfq7LclRfOkWhnF2Ao8wVAqPUh31yJE7HIDG8hUna0RDFqVf8Ac8aSORfY2Y4ercV
	 8aB7dOA0UZ8nh+bb+1X++5ct9YY/kEOAx1cZ+EQ0=
Date: Sat, 11 Jan 2025 21:46:51 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oliver.sang@intel.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch added to mm-unstable branch
Message-Id: <20250112054651.A96AEC4CEE0@smtp.kernel.org>
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
Date: Fri, 10 Jan 2025 20:26:00 -0800

vm_refcnt encodes a number of useful states:
- whether vma is attached or detached
- the number of current vma readers
- presence of a vma writer
Let's include it in the vma dump.

Link: https://lkml.kernel.org/r/20250111042604.3230628-14-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Mattew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
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
mm-move-lesser-used-vma_area_struct-members-into-the-last-cacheline.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch
mm-remove-extra-vma_numab_state_init-call.patch
mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
docs-mm-document-latest-changes-to-vm_lock.patch
alloc_tag-avoid-current-alloc_tag-manipulations-when-profiling-is-disabled.patch

