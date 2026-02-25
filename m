Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCE729BD90
	for <mm-commits@vger.kernel.org>; Wed, 25 Feb 2026 04:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771993514; cv=none; b=RWIN8teOScf7dTVZbsLGCjQRninHL7SHGuEHEFXrkBW1j4sf2fcczEGkQeotXN5Q4x8omJzaJZljYVl7jqwJcrfeGZpPNaTxTIZOKlqx5tCmNfQwhmLfFd1q/7YPQFXGPkWvqqo/IJBxVjYeB+LaWWrwahkxG7uPXa3/jrOsGFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771993514; c=relaxed/simple;
	bh=4lEYWzl0TU9qwsxlLrd9cf8mnRscmosxzVGfzTEfqvI=;
	h=Date:To:From:Subject:Message-Id; b=mxYzfpARmZ1vmSxylUyH+tEB4aLMXC2QlrDzLVnrZ7ccIk7fawxvi9l7oMAg9G7NiJT/Fxr1kZoZbon+8PU7cD+ao1WcLTzgKiauLP7g+O6ZIPJcy+M9CA6tXFD+W1zCbMMZPl3iCRURs+15/XqWePiOhDFnvajUi9xV82eltEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q/+zROhy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q/+zROhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A788FC116D0;
	Wed, 25 Feb 2026 04:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771993513;
	bh=4lEYWzl0TU9qwsxlLrd9cf8mnRscmosxzVGfzTEfqvI=;
	h=Date:To:From:Subject:From;
	b=q/+zROhymoIbtAZ8jnVaaPhKhjeKg0ltpVp1MAvE34FWmcVu3WVVZlyG8eeuYWcxN
	 cmdsytZtQDPVnI9kCJGixD3c/sfAoaEvExLTexTH+bJD/5iD+pylZ31ahWUT0D58KO
	 02rq9qe60hO7q9clg+oS0Furxos/qPt5mbMdc0dg=
Date: Tue, 24 Feb 2026 20:25:13 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,re@w6rz.net,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-move-put_page_testzero-out-of-vm_warn_on-in-cma_release.patch added to mm-hotfixes-unstable branch
Message-Id: <20260225042513.A788FC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: move put_page_testzero() out of VM_WARN_ON in cma_release()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-cma-move-put_page_testzero-out-of-vm_warn_on-in-cma_release.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-move-put_page_testzero-out-of-vm_warn_on-in-cma_release.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/cma: move put_page_testzero() out of VM_WARN_ON in cma_release()
Date: Tue, 24 Feb 2026 22:12:31 -0500

When CONFIG_DEBUG_VM is not set, VM_WARN_ON is a NOP.  Putting any
statement with side effect inside it is incorrect.  Collect all
!put_page_testzero() results and check the sum using WARN instead after
the loop.  It restores the same check in free_contig_range() before commit
e0c1326779cc ("mm: page_alloc: add alloc_contig_frozen_{range,pages}()"),
the commit prior to the Fixes one.

Link: https://lkml.kernel.org/r/20260225031231.2352011-1-ziy@nvidia.com
Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Ron Economos <re@w6rz.net>
Closes: https://lore.kernel.org/all/1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net/
Suggested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc:
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-move-put_page_testzero-out-of-vm_warn_on-in-cma_release
+++ a/mm/cma.c
@@ -1013,6 +1013,7 @@ bool cma_release(struct cma *cma, const
 		 unsigned long count)
 {
 	struct cma_memrange *cmr;
+	unsigned long ret = 0;
 	unsigned long i, pfn;
 
 	cmr = find_cma_memrange(cma, pages, count);
@@ -1021,7 +1022,9 @@ bool cma_release(struct cma *cma, const
 
 	pfn = page_to_pfn(pages);
 	for (i = 0; i < count; i++, pfn++)
-		VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
+		ret += !put_page_testzero(pfn_to_page(pfn));
+
+	WARN(ret, "%lu pages are still in use!\n", ret);
 
 	__cma_release_frozen(cma, cmr, pages, count);
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-cma-move-put_page_testzero-out-of-vm_warn_on-in-cma_release.patch

