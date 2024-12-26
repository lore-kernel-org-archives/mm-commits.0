Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B0F16F265
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735247756; cv=none; b=t1dUv1vRevCUQSLAeqaxnzOOfEKGjh7mOXCVLmrJTdC4/8A1oYpHxH6SA9ORx8oJOEIKYJMcKiePIYOfGIvvvXo6xxHpxaXuhYHnBXz3XrMfF+LQvntLI8uB920kgEfnFibr2Kre4/IESm7E4CMv4pmL6DeZ24hX9oiQGtGSZIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735247756; c=relaxed/simple;
	bh=/fGd2mNeCAwq9JzdI+sqxRMhOnhHkS5bTtF+urDoP54=;
	h=Date:To:From:Subject:Message-Id; b=MleALq5BVAjym+ObPLiJJnyfXvxowPNn8rEZHYZdB49BifQTxt3PmdxIRXQQrXiGGsUW4hFjBK8whJuoloRHKfyUP6Ei5hsXGS10sXJVVprkvDwYIkNO+FyGMJTH4YzofmwlSfhzYhvFpzKHsi+fer1RA8iPRjY+vw4DrMxCFXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X2Sd2B1d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X2Sd2B1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52591C4CED1;
	Thu, 26 Dec 2024 21:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735247755;
	bh=/fGd2mNeCAwq9JzdI+sqxRMhOnhHkS5bTtF+urDoP54=;
	h=Date:To:From:Subject:From;
	b=X2Sd2B1dQ1hn5KtLlR1h7vHdL2KaojajLbBhjGppoCMTojQT/bhqNZU+M/X84SzEC
	 +yUGT2TEK286fcUIAzgx3gpd1eLb5R6LLtUxg+QuueaTNLndCvojuN8wWRt+BbCP/R
	 jZ4IO8sQGaAkJn6lx0wvpnGSvB5P6LuZbi7DZ6YE=
Date: Thu, 26 Dec 2024 13:15:54 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oliver.sang@intel.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mark-vmas-detached-upon-exit.patch added to mm-unstable branch
Message-Id: <20241226211555.52591C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mark vmas detached upon exit
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mark-vmas-detached-upon-exit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mark-vmas-detached-upon-exit.patch

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
Subject: mm: mark vmas detached upon exit
Date: Thu, 26 Dec 2024 09:06:57 -0800

When exit_mmap() removes vmas belonging to an exiting task, it does not
mark them as detached since they can't be reached by other tasks and they
will be freed shortly.  Once we introduce vma reuse, all vmas will have to
be in detached state before they are freed to ensure vma when reused is in
a consistent state.  Add missing vma_mark_detached() before freeing the
vma.

Link: https://lkml.kernel.org/r/20241226170710.1159679-6-surenb@google.com
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

 mm/vma.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/vma.c~mm-mark-vmas-detached-upon-exit
+++ a/mm/vma.c
@@ -413,9 +413,10 @@ void remove_vma(struct vm_area_struct *v
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	mpol_put(vma_policy(vma));
-	if (unreachable)
+	if (unreachable) {
+		vma_mark_detached(vma);
 		__vm_area_free(vma);
-	else
+	} else
 		vm_area_free(vma);
 }
 
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

