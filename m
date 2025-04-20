Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19824184
	for <mm-commits@vger.kernel.org>; Sun, 20 Apr 2025 23:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745191936; cv=none; b=qs7FpEfMpKsSpXd27XaLoWSau3I2N4InUZDMvBUSRixNXZw2qjc3HF4DSBxI2K5Cq3e1jgN5rLyCsq4dhOU+9YXPbSzd1hHQiXAW2cs90CiT8LM85PpjNMzMUGzJWQxEKH2iimjdWMa3VEdG4GKc/U2UCaWuN78VurqHneMp8qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745191936; c=relaxed/simple;
	bh=rrtdhDZ8TIPe7qsV77Uky7xS85wejic8yHht25N/Wzg=;
	h=Date:To:From:Subject:Message-Id; b=OYSowxazxaLXj+TI80/CuWmIcGcRfPJ2SiCxf0eF6cmV8W0FIti9A3YXLnieJmSnQfTTbxiBMIFfuH3YIJgX1sd7m9Xhj5tIUtmlzMR6NhgNTz1aaYTvzq5MjieMeN5ngPGy2XyuPbTHGy1Yb3EkoNbqiOpjtq+n8FGsoHgxEN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nIdk2XSz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nIdk2XSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A518C4CEE2;
	Sun, 20 Apr 2025 23:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745191935;
	bh=rrtdhDZ8TIPe7qsV77Uky7xS85wejic8yHht25N/Wzg=;
	h=Date:To:From:Subject:From;
	b=nIdk2XSzi45rtMLaPoh4u1BVN47I6GVDYakscYSMSUPQCRGmVKkOEUtz/FeCKgJzv
	 1Vq7EeAesF/g0/pUoISv5jlKDpkrbPrNpFL74s+MHo/cnnso5ZG7bDMx3qkI0SQz7z
	 EHwZI3GOeq/Wg1uv7geevdJRTaAY9tJv/KPGJVKs=
Date: Sun, 20 Apr 2025 16:32:14 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@oracle.com,harry.yoo@oracle.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-reverse-mapping-section.patch added to mm-hotfixes-unstable branch
Message-Id: <20250420233215.6A518C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add reverse mapping section
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-reverse-mapping-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-reverse-mapping-section.patch

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
Subject: MAINTAINERS: add reverse mapping section
Date: Fri, 18 Apr 2025 16:00:52 +0100

Separate out the reverse mapping part of memory management and assign
appropriate maintainers and reviewers.

David has long been invovled in work with the reverse mapping and
continues to do so, so is well suited to maintain this area of the kernel.

I have a lot of experience working with the anonymous reverse mapping and
continue to work in this area, and also have good knowledge of the walking
code and code related to VMAs.

This helps people identify who to ask for help, and also additionally makes
life easier in review.

Link: https://lkml.kernel.org/r/20250418150052.299220-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-add-reverse-mapping-section
+++ a/MAINTAINERS
@@ -15491,7 +15491,6 @@ F:	include/linux/mm_*.h
 F:	include/linux/mmzone.h
 F:	include/linux/mmu_notifier.h
 F:	include/linux/pagewalk.h
-F:	include/linux/rmap.h
 F:	include/trace/events/ksm.h
 F:	mm/
 F:	tools/mm/
@@ -15531,6 +15530,19 @@ F:	mm/page_alloc.c
 F:	include/linux/gfp.h
 F:	include/linux/compaction.h
 
+MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@redhat.com>
+M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+R:	Rik van Riel <riel@surriel.com>
+R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Harry Yoo <harry.yoo@oracle.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	include/linux/rmap.h
+F:	mm/rmap.c
+
 MEMORY MANAGEMENT - SECRETMEM
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-reverse-mapping-section.patch
mm-vma-fix-incorrectly-disallowed-anonymous-vma-merges.patch
tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch
tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch
mm-move-mmap-vma-locking-logic-into-specific-files.patch

