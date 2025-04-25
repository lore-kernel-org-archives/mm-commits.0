Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EF049641
	for <mm-commits@vger.kernel.org>; Fri, 25 Apr 2025 00:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745540459; cv=none; b=kkH8TaNkZZ8Jbc8qo2DnOZDgcLk9BxORzI66JYBuxH7VR2OyTJ6U9vlUpnTPhxxGUjo8j/r0L+JSfeMcOZ+6SeMBQkwtVF4vggwUwxmgZVWZa4WsWg0Qk5UqIHiPJgkfWgPH45IUnWGaA8XiZsdDhBA45wUVsFEjaTo4z76xeC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745540459; c=relaxed/simple;
	bh=I1SJ7QM03gu+IPp/bgVKiYuSlBhzN5tF2Wwbs0WBu28=;
	h=Date:To:From:Subject:Message-Id; b=DYNZBznMQWvMjqbvRFR7cKWiCDYDZDyFQGgynKfpc/tgkMPobC/ts5Ad7TQNc2+GvswlJ7KS9BLZDRaG2OGZ3H0i8Dl08pbHYWOIygnYZyd6ISmNCJCmmkX+v3HnzjRknPXTyx599tMZ4YpNO9QuMCpT5t/K7kiVAKC34tFUe4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=letQC5p+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="letQC5p+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62143C4CEE3;
	Fri, 25 Apr 2025 00:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745540458;
	bh=I1SJ7QM03gu+IPp/bgVKiYuSlBhzN5tF2Wwbs0WBu28=;
	h=Date:To:From:Subject:From;
	b=letQC5p+JjCBU9amPLfV6JCNsIgAqEHVwBcM8eQnO7u3PS9HxcEvL8yVOsCMlHNHK
	 5u7nMhx7tKgrBcBc5fhqy+iopj8p/pjnuPTKHpHrNj6t31qvaSwb7eq6hX6qygWvqF
	 Rv4XufKT+XhW1OhxELK/6zOZRQT311LPUReWor/Y=
Date: Thu, 24 Apr 2025 17:20:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,ryan.roberts@arm.com,npache@redhat.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-mm-thp-section.patch added to mm-hotfixes-unstable branch
Message-Id: <20250425002058.62143C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add mm THP section
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-mm-thp-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-mm-thp-section.patch

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
Subject: MAINTAINERS: add mm THP section
Date: Thu, 24 Apr 2025 12:16:32 +0100

As part of the ongoing efforts to sub-divide memory management
maintainership and reviewership, establish a section for Transparent Huge
Page support and add appropriate maintainers and reviewers.

Link: https://lkml.kernel.org/r/20250424111632.103637-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/MAINTAINERS~maintainers-add-mm-thp-section
+++ a/MAINTAINERS
@@ -15573,6 +15573,29 @@ S:	Maintained
 F:	include/linux/secretmem.h
 F:	mm/secretmem.c
 
+MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@redhat.com>
+R:	Zi Yan <ziy@nvidia.com>
+R:	Baolin Wang <baolin.wang@linux.alibaba.com>
+R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Nico Pache <npache@redhat.com>
+R:	Ryan Roberts <ryan.roberts@arm.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/admin-guide/mm/transhuge.rst
+F:	include/linux/huge_mm.h
+F:	include/linux/khugepaged.h
+F:	include/trace/events/huge_memory.h
+F:	mm/huge_memory.c
+F:	mm/khugepaged.c
+F:	tools/testing/selftests/mm/khugepaged.c
+F:	tools/testing/selftests/mm/split_huge_page_test.c
+F:	tools/testing/selftests/mm/transhuge-stress.c
+
 MEMORY MANAGEMENT - USERFAULTFD
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Peter Xu <peterx@redhat.com>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-reverse-mapping-section.patch
maintainers-add-core-mm-section.patch
maintainers-add-mm-thp-section.patch
maintainers-add-mm-thp-section-fix.patch
mm-vma-fix-incorrectly-disallowed-anonymous-vma-merges.patch
tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch
tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch
mm-move-mmap-vma-locking-logic-into-specific-files.patch

