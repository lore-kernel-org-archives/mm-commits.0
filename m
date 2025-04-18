Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9717D158545
	for <mm-commits@vger.kernel.org>; Fri, 18 Apr 2025 03:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945873; cv=none; b=K02VdgEDZn39cS8YVWLWUc3zQjkdHjDr60Kx0yX+oOVf++gKEZ5xBVj7L5DhdAG7u3OERx0GVUD90pbGlCREk2ZVQ6OKxP429sejH4t2JuBzNJgU7BCmbl54pI9AZxqQWp5b4jEhuXPVEtqgZh8VrgtcT3MzBUPIXwAt1Zx1h+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945873; c=relaxed/simple;
	bh=NQIJGJsdB8xrmiMPjXh3Bld4H7qSCQktae4bWHocLT4=;
	h=Date:To:From:Subject:Message-Id; b=AGN05udfO/US9uRueGWuI4XkJgPW+ewgeVnZSYO2e2oYDmldTkZlP2km6eY8bZEATXKlp89i530yjX+/8kY/YnjoJy6ATJvyxY+QE7RZ9RTnQGcSXNxBM+bHzdoccNZ98KfA+z9uQgJoG4jeif23lBBca+9K7oac7V4gsvOAP20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jlP9sNEq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jlP9sNEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A523C4CEE4;
	Fri, 18 Apr 2025 03:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744945873;
	bh=NQIJGJsdB8xrmiMPjXh3Bld4H7qSCQktae4bWHocLT4=;
	h=Date:To:From:Subject:From;
	b=jlP9sNEqm8DtK0IbIDQt0jV2TY58qWuNUYsiNDV6XW52X5N1bRNxAfeHHvMZley3a
	 wAhXDXol12pqiATtIAfuEbeOpKIj7WRBYjpjw0zQrH2YdUu+xhOkbJaL3ZSWsw3OGA
	 w64y3MrCWevvR+P63ADVPz7IHczPO56vqDQDHOdk=
Date: Thu, 17 Apr 2025 20:11:12 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@oracle.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-memory-advice-section.patch removed from -mm tree
Message-Id: <20250418031113.0A523C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add memory advice section
has been removed from the -mm tree.  Its filename was
     maintainers-add-memory-advice-section.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add memory advice section
Date: Fri, 11 Apr 2025 08:27:24 +0100

The madvise code straddles both VMA and page table manipulation.  As a
result, separate it out into its own section and add maintainers/reviewers
as appropriate.

We additionally include the mman-common.h file as this contains the shared
madvise flags and it is important we maintain this alongside madvise.c.

Link: https://lkml.kernel.org/r/20250411072724.10841-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Jann Horn <jannh@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/MAINTAINERS~maintainers-add-memory-advice-section
+++ a/MAINTAINERS
@@ -15573,6 +15573,20 @@ F:	mm/vma.h
 F:	mm/vma_internal.h
 F:	tools/testing/vma/
 
+MEMORY MAPPING - MADVISE (MEMORY ADVICE)
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+M:	David Hildenbrand <david@redhat.com>
+R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Jann Horn <jannh@google.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	include/uapi/asm-generic/mman-common.h
+F:	mm/madvise.c
+
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	Miquel Raynal <miquel.raynal@bootlin.com>
 M:	Richard Weinberger <richard@nod.at>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-fix-incorrectly-disallowed-anonymous-vma-merges.patch
tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch
tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch
mm-move-mmap-vma-locking-logic-into-specific-files.patch

