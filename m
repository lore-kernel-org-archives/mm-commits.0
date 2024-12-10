Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1C34A04
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 01:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733794438; cv=none; b=IFIPZfH/VA9yNPCcsZe2uvUuApqqZh+IKNLTu7eJedT0sNUl1AKIQokp+Bdz8OwPQgbLU1VC1Cw5Qz0gI6Wtuw/BPUIjgeLL5gNpstjrUMB8K7+7lWEre2Hjn0XiIn52oaRQp6tWBrv/6doRsl8Evg8YejesKVp1bkkQ/pc9EpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733794438; c=relaxed/simple;
	bh=mVWXOUL/Fe0q4gKMb/bio9ThFYlg6tiNq7vY7gLYAJ0=;
	h=Date:To:From:Subject:Message-Id; b=SsFxedrAEF98e/mXYby2hpcFJHTVQWjIcKyAJuhShOqHWFesdEg9wR6J86L5Fu5Ml876rU1M6BQCvtv8FaLIfmM21urIwVJ2BcSELsINwuxv6A0Wolendon2L+fmx4vQRCM6sYSfTo5mYH1heuGfH6ENOKyyf+lpmYc/im4saD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y+sPy76k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y+sPy76k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50396C4CED1;
	Tue, 10 Dec 2024 01:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733794437;
	bh=mVWXOUL/Fe0q4gKMb/bio9ThFYlg6tiNq7vY7gLYAJ0=;
	h=Date:To:From:Subject:From;
	b=Y+sPy76k6l2MlsbN7Vb8ONyD9x7F27H9ZIUniyFSJF4ymuCdIds8lp++9TsJstQ6a
	 QLbQPEOaHt5cv0OEMJHOudR90Wtal00ckhPYzq2AhEFRW+5Ttwhz3RFxicoFn8sx18
	 AGiFGgZGeiPsf9S3lV8cad64PDbyx3yg/EToAB/A=
Date: Mon, 09 Dec 2024 17:33:56 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oliver.sang@intel.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-vma-cache-slab_typesafe_by_rcu-fix.patch added to mm-unstable branch
Message-Id: <20241210013357.50396C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix vma_copy for !CONFIG_PER_VMA_LOCK
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-vma-cache-slab_typesafe_by_rcu-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-vma-cache-slab_typesafe_by_rcu-fix.patch

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
Subject: mm: fix vma_copy for !CONFIG_PER_VMA_LOCK
Date: Mon, 9 Dec 2024 14:10:28 -0800

vma_copy() function for !CONFIG_PER_VMA_LOCK configuration copies all
fields using memcpy() as opposed to CONFIG_PER_VMA_LOCK version which
copies only required fields.  anon_vma_chain field should not be copied
and new vma should instead initialize it to an empty list.  Fix this by
initializing anon_vma_chain inside vma_copy() function.  The version of
vma_copy() for CONFIG_PER_VMA_LOCK is fine since it does not change that
field and anon_vma_chain of any new vma is already initialized and empty.

Link: https://lkml.kernel.org/r/20241209221028.1644210-1-surenb@google.com
Fixes: 85ad413389ae ("mm: make vma cache SLAB_TYPESAFE_BY_RCU")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202412082208.db1fb2c9-lkp@intel.com
Reported-by: Klara Modin <klarasmodin@gmail.com>
Closes: https://lore.kernel.org/all/d0ae7609-aca4-4497-9188-bb09e96e7768@gmail.com/
Tested-by: Klara Modin <klarasmodin@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/fork.c~mm-make-vma-cache-slab_typesafe_by_rcu-fix
+++ a/kernel/fork.c
@@ -524,6 +524,7 @@ static void vma_copy(const struct vm_are
 	 * will be reinitialized.
 	 */
 	data_race(memcpy(dest, src, sizeof(*dest)));
+	INIT_LIST_HEAD(&dest->anon_vma_chain);
 }
 
 #endif /* CONFIG_PER_VMA_LOCK */
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-fix-module-allocation-tags-populated-area-calculation.patch
alloc_tag-fix-set_codetag_empty-when-config_mem_alloc_profiling_debug.patch
seqlock-add-raw_seqcount_try_begin.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculate_try_beginretry.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
mm-make-vma-cache-slab_typesafe_by_rcu-fix.patch
mm-slab-allow-freeptr_offset-to-be-used-with-ctor.patch
docs-mm-document-latest-changes-to-vm_lock.patch

