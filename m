Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24FD2192E9
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 23:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741302302; cv=none; b=FgQxClWD+ySMFf7GXnTQQ7+HF8SDcxlqAR4oXXGt5i2Lu70kKwQY85gaKIIA6EX+QqsHvfX5397teoDcD3BJE3XhhI749J4N3fc8mNgqxJQEN+XGl72Wpt5YvUxeqiocVyiVrfIg1xvl0XtfRxzbQnJoKgwWEYnygwdhKewYAf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741302302; c=relaxed/simple;
	bh=wmozdat+RwIkr5Sy4eI2zm9rFixJ09pVsr1C8soHKHo=;
	h=Date:To:From:Subject:Message-Id; b=pasvp9BnJDAlnwz7BrJYaUc3vNl6OLrhcevogm3mxPsgQCLWd18dBC72moiqoYHf6uN8vckUgRif4dMTdscrb6nV07aO6/m2WcwnsfhgC3T6TcLo5Lwy+c45Lhg1ucpdOOitnaeh4LIjy2JZfh2gObnOLyqp3qosW7NWc5Ta1sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AXYtMa99; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AXYtMa99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363E2C4CEE0;
	Thu,  6 Mar 2025 23:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741302301;
	bh=wmozdat+RwIkr5Sy4eI2zm9rFixJ09pVsr1C8soHKHo=;
	h=Date:To:From:Subject:From;
	b=AXYtMa99CipDxgROK8WsINkwgzvNfdMTTtof3pJlMkLg04VJQtk4xdyBWvrIFygcz
	 kpQmNEbRROA6pq8FzUBHluz1e+L8nVtJB/In5Jqw6fRMXO7ZrFcEXwi+TFJn2/dZT6
	 sIwOgS9zxNw8x7B3xt4ZjT9dnTDFeo1E87CGySEM=
Date: Thu, 06 Mar 2025 15:05:00 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yang@os.amperecomputing.com,willy@infradead.org,vbabka@suse.cz,ryan.roberts@arm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,anshuman.khandual@arm.com,aneesh.kumar@kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-do-not-register-private-anon-mappings-with-khugepaged-during-mmap.patch added to mm-hotfixes-unstable branch
Message-Id: <20250306230501.363E2C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: do not register private-anon mappings with khugepaged during mmap
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vma-do-not-register-private-anon-mappings-with-khugepaged-during-mmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-do-not-register-private-anon-mappings-with-khugepaged-during-mmap.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Dev Jain <dev.jain@arm.com>
Subject: mm/vma: do not register private-anon mappings with khugepaged during mmap
Date: Thu, 6 Mar 2025 12:00:37 +0530

We already are registering private-anon VMAs with khugepaged during fault
time, in do_huge_pmd_anonymous_page().  Commit "register suitable readonly
file vmas for khugepaged" moved the khugepaged registration logic from
shmem_mmap to the generic mmap path.

The userspace-visible effect should be this: khugepaged will unnecessarily
scan mm's which haven't yet faulted in.  Note that it won't actually
collapse because all PTEs are none.

Now that I think about it, the mm is going to have a file VMA anyways
during fork+exec, so the mm already gets registered during mmap due to the
non-anon case (I *think*), so at least one of either the mmap registration
or fault-time registration is redundant.

Make this logic specific for non-anon mappings.

Link: https://lkml.kernel.org/r/20250306063037.16299-1-dev.jain@arm.com
Fixes: 613bec092fe7 ("mm: mmap: register suitable readonly file vmas for khugepaged")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vma.c~mm-vma-do-not-register-private-anon-mappings-with-khugepaged-during-mmap
+++ a/mm/vma.c
@@ -2381,7 +2381,8 @@ static int __mmap_new_vma(struct mmap_st
 	 * vma_merge_new_range() calls khugepaged_enter_vma() too, the below
 	 * call covers the non-merge case.
 	 */
-	khugepaged_enter_vma(vma, map->flags);
+	if (!vma_is_anonymous(vma))
+		khugepaged_enter_vma(vma, map->flags);
 	ksm_add_vma(vma);
 	*vmap = vma;
 	return 0;
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-vma-do-not-register-private-anon-mappings-with-khugepaged-during-mmap.patch
mm-remove-redundant-return-in-set_huge_zero_folio.patch

