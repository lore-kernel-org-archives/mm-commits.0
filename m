Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2134377A87;
	Sat,  5 Sep 2026 23:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788650558; cv=none; b=E8MuPeZaAq4N57C0Pnhqq/YJtt9VszdiF9WWvvxRyRu3dxWi4lub8qpdjRmi+dT7MAISke/Rp5bvKg9fBWV5P11b4SrSMVZ4bAFZajdnIY5L5NeCsUhMzOFu5R02LkjcVbwAQEftmN8FPMfl9H1qAxgT/TA2pAcvlGcZYDXaIpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788650558; c=relaxed/simple;
	bh=kuJpAhXwPbkkyAPa421LQue//K0JX/7OSb0rEMOcJj0=;
	h=Date:To:From:Subject:Message-Id; b=lp+eVeHO918I3IPcdF/0oalrMrHbbHQtBG3ZjE2ZiEGU5Z8K2+XkuusCWUFzJFEjtG8IkQIE2zSpKIzSucsg401z4qbSX97cO7/QyPG5dVpmHHO5dX+N81KMBdPW6W3j0G9st5XsI3LjUvCpXzqR45pDRVQ65XlEHQHhJCRMRG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=abkfo0wF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="abkfo0wF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEEB1F00A3A;
	Sat,  5 Sep 2026 23:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788650554;
	bh=lmTAv05iwf3h/dZMJFoHs2fvhmlYBUWxoLzmFqTT5bc=;
	h=Date:To:From:Subject;
	b=abkfo0wFr9j4ZSRIBj70wrJSJNSGNlYK4DnBZVNo1r9A/Ec6pUBJDXGzAq9RkEmg5
	 KAFP57LwnmdvVLqhog5ABdxr1e0LxiTi6yLpMBaKmOJ2JNUTdDkE/3OlMzd0wXMzLc
	 CBMq++zhUdyD4nJL/dnoHyXsgKlhN+oqUbcMJNyU=
Date: Sat, 05 Sep 2026 16:22:33 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,vbabka@kernel.org,sunnanyong@huawei.com,stable@vger.kernel.org,riel@surriel.com,mel@csn.ul.ie,lwoodman@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kamezawa.hiroyu@jp.fujitsu.com,jannh@google.com,harry@kernel.org,david@kernel.org,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-fix-missing-barrier-between-anon_vma-init-and-vma-anon_vma-publish.patch added to mm-hotfixes-unstable branch
Message-Id: <20260905232234.0CEEB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: fix missing barrier between anon_vma init and vma->anon_vma publish
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-rmap-fix-missing-barrier-between-anon_vma-init-and-vma-anon_vma-publish.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-fix-missing-barrier-between-anon_vma-init-and-vma-anon_vma-publish.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/rmap: fix missing barrier between anon_vma init and vma->anon_vma publish
Date: Sat, 5 Sep 2026 14:18:19 +0800

On arm64 server, we found __anon_vma_prepare() reuses anon_vma and
anon_vma->root is stale due to missing memory barrier, leading to lock and
unlock two different anon_vma->root, thus leading to a anon_vma will never
be unlocked, and another anon_vma couldn't be locked anymore.

The race is as follows:

    THREAD A                             THREAD B
__anon_vma_prepare                __anon_vma_prepare
 anon_vma = anon_vma_alloc();
 // writes may out of order here
 vma->anon_vma = anon_vma;
                                   anon_vma = find_mergeable_anon_vma(vma);
                                   anon_vma_lock_write(anon_vma);
                                     // may still see the old root
                                     down_write(&anon_vma->root->rwsem);
                                   anon_vma_unlock_write(anon_vma);
                                     // see the new root, never unlock old
                                     up_write(&anon_vma->root->rwsem);

thread A triggers page fault and calls __anon_vma_prepare() to prepare
anon_vma for the faulting vma.  __anon_vma_prepare() allocates and
initializes a new anon_vma, and then publishes it to the vma with a plain
store.  anon_vma_prepare() only requires the mmap_lock to be held for
reading, so two threads can fault on adjacent VMAs at the same time. 
While thread A publishes a new anon_vma, thread B could finds the anon_vma
via find_mergeable_anon_vma() and then locks anon_vma->root->rwsem.

However, due to missing barrier, thread B can observe the published
pointer but a stale anon_vma->root because the stores from
anon_vma_alloc() aren't yet visible.  What's the value of the stale
anon_vma->root?  __put_anon_vma() doesn't clear anon_vma->root, so the
root of the new allocated anon_vma may point to a valid anon_vma.

As a result, thread B can call anon_vma_lock_write() with the old root,
and call anon_vma_unlock_write() with the new root, leading to a anon_vma
will never be unlocked, and another anon_vma couldn't be locked anymore
(it's count is dropped from 0 to -1 due to wrong unlock).

To fix it, change the plain store `vma->anon_vma = anon_vma` to store
release, so that the fields of anon_vma are visible before anon_vma is
published to vma->anon_vma.

We don't need a read barrier at read side for thread B.  The load of
anon_vma and anon_vma->root have address-dependency.  According to
Documentation/memory-barriers.txt and some investigations, only Alpha
needs address-dependency barriers and it has been handled by READ_ONCE().

This issue needs two adjacent VMAs aren't merged but are compatible for
anon_vma.  We reproduced this issue in v5.10 with KSM enabled.  The kernel
doesn't merge commit cf7e7a3503df ("mm: prevent KSM from breaking VMA
merging for new VMAs"), so there are many adjacent VMAs that aren't merged
but are compatible for anon_vma.

Without this fix, our production environment could reproduce this issue
about 2-5 times each month.  After adding a smp_mb() before
anon_vma_lock_write(anon_vma) in __anon_vma_prepare(), which is different
to this patch, this issue hasn't be reproduced for one month.

Link: https://lore.kernel.org/20260905061820.642437-1-tujinjiang@huawei.com
Fixes: 5c341ee1dfc8 ("mm: track the root (oldest) anon_vma")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-fix-missing-barrier-between-anon_vma-init-and-vma-anon_vma-publish
+++ a/mm/rmap.c
@@ -209,7 +209,11 @@ int __anon_vma_prepare(struct vm_area_st
 	/* page_table_lock to protect against threads */
 	spin_lock(&mm->page_table_lock);
 	if (likely(!vma->anon_vma)) {
-		vma->anon_vma = anon_vma;
+		/*
+		 * The fields of anon_vma must be visible before anon_vma
+		 * is published to vma->anon_vma.
+		 */
+		smp_store_release(&vma->anon_vma, anon_vma);
 		anon_vma_chain_assign(vma, avc, anon_vma);
 		anon_rmap_tree_insert(avc, anon_vma);
 		anon_vma->num_active_vmas++;
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-rmap-fix-missing-barrier-between-anon_vma-init-and-vma-anon_vma-publish.patch
docs-ksm-fix-typos-in-sysfs-knob-names.patch
mm-ksm-fix-advisor_min_pages_to_scan-description.patch

