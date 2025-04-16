Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DEC243378
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 22:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744843714; cv=none; b=CitrOWwNFimDqNYqFiZlfg4B3O2kOvgBZRVQybIJSlh/0q6VI6lRcKtH6o7HXYTa5q1kJIrQBiaFcgpTnJ244V8+Lr4CdHkl8iGoCUEi495n2wd+6i8ri6zKjvt7rtdwPPpF7Ed6RjDAA8RJzDC0g1qKG7Q30SLVKAO/LE2l/Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744843714; c=relaxed/simple;
	bh=zQCQ1mcoHtP+zc5u3CBYW2UdQE9IsHdjkr18yFCu290=;
	h=Date:To:From:Subject:Message-Id; b=gl8Lz4B2hNjbl37jn4uewaIyEXB9cdO3Hgv+Y1+HDDgyt6sbKA/HwyehBDppoHRpQPSwNjoTG+XreQ9w42ioLytzLnLT9/opDx1LY2IExOHQxe2MLen2C+0qupQsIvJxfgEg/fXIxCegJsMaANTEU/5kuSsDe4Mwc0oMeLbZZA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AClNP9uv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AClNP9uv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861C1C4CEE2;
	Wed, 16 Apr 2025 22:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744843713;
	bh=zQCQ1mcoHtP+zc5u3CBYW2UdQE9IsHdjkr18yFCu290=;
	h=Date:To:From:Subject:From;
	b=AClNP9uvZRxHhDxZuXca4gLbGR/k4d45gtHOzSkhL/801UQmiePMIMFoef5qKl+NJ
	 /MKs7ERaq6Q8qVFQ3oJxQ/P5wCQugLlu9KzJoHjZTM7Nsww3WY4rKpODyjEWkVwvLC
	 BWhdkruTq/U21qo+hsUF6Nv0SPk/h7c0ZANqPtco=
Date: Wed, 16 Apr 2025 15:48:32 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,paulmck@kernel.org,Liam.Howlett@oracle.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-section-for-locking-of-mms-and-vmas.patch added to mm-hotfixes-unstable branch
Message-Id: <20250416224833.861C1C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add section for locking of mm's and VMAs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-section-for-locking-of-mms-and-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-section-for-locking-of-mms-and-vmas.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add section for locking of mm's and VMAs
Date: Wed, 16 Apr 2025 11:38:37 +0100

We place this under memory mapping as related to memory mapping
abstractions in the form of mm_struct and vm_area_struct (VMA).  Now we
have separated out mmap/vma locking logic into the mmap_lock.c and
mmap_lock.h files, so this should encapsulate the majority of the mm
locking logic in the kernel.

Suren is best placed to maintain this logic as the core architect of VMA
locking as a whole.

Link: https://lkml.kernel.org/r/e6ed679a184ca444b20dfa77af96913fd8b5efa0.1744799282.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/MAINTAINERS~maintainers-add-section-for-locking-of-mms-and-vmas
+++ a/MAINTAINERS
@@ -15570,6 +15570,22 @@ F:	mm/vma.h
 F:	mm/vma_internal.h
 F:	tools/testing/vma/
 
+MEMORY MAPPING - LOCKING
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Suren Baghdasaryan <surenb@google.com>
+M:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Shakeel Butt <shakeel.butt@linux.dev>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/mm/process_addrs.rst
+F:	include/linux/mmap_lock.h
+F:	include/trace/events/mmap_lock.h
+F:	mm/mmap_lock.c
+
 MEMORY MAPPING - MADVISE (MEMORY ADVICE)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-memory-advice-section.patch
maintainers-add-pedro-as-reviewer-to-the-memory-mapping-section.patch
maintainers-add-section-for-locking-of-mms-and-vmas.patch
mm-vma-fix-incorrectly-disallowed-anonymous-vma-merges.patch
tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch
tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch
mm-move-mmap-vma-locking-logic-into-specific-files.patch

