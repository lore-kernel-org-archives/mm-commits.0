Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB462BCF5
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747009615; cv=none; b=H+tKDorGIOR9qdmNJtix0iwua3iUV0imNUh7dF55lAeuqMq72eTtOQle3HgRbqNw0K2voRANgHqPXJ501MXUF/YbyW+Sk3UCaEOWz0Xapi5YPYI/34rn+iqQ/uD3GfW2AdoZyTcehqTeuuNiz9NUdM7WYY5zwKuIAdR/EllvYH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747009615; c=relaxed/simple;
	bh=fqHi1Az/mNynidEvMQF/6C24NrjObcM1iaam7rhiueg=;
	h=Date:To:From:Subject:Message-Id; b=MunjNj/sSLITvegFaqim6yjoF6974/ST6OAGF+u8o22aE5qEWGcqEz99n7P5zpLB8qRduddliMujMR+9RXK/MHxnpR0g+pbnAZipgmUZwID9I2sTVxb7DNBNJNWo/nqBT36SRG8AkX4Sx9HuUrIAHliDx5dt0wIYpOcHMw5NGAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g9ZvuGFf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g9ZvuGFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89695C4CEE4;
	Mon, 12 May 2025 00:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747009614;
	bh=fqHi1Az/mNynidEvMQF/6C24NrjObcM1iaam7rhiueg=;
	h=Date:To:From:Subject:From;
	b=g9ZvuGFfrmwrlUWjoherHcYRCtqrIPWkJeoMO/qFmKvc23USgvtqIzJ9CDDH7D1pE
	 UQMdGtrWZfXhqaqRmvH5cjtqwGiSgQXJ3PKJpevhXhYB0tp22azLvy8Dfw3ikN2yIY
	 422cqAqSC+iNakUkg4EreEwz0x/BCjEMFDYfeBNE=
Date: Sun, 11 May 2025 17:26:53 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,jhubbard@nvidia.com,jgg@nvidia.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-mm-gup-section.patch removed from -mm tree
Message-Id: <20250512002654.89695C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add mm GUP section
has been removed from the -mm tree.  Its filename was
     maintainers-add-mm-gup-section.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add mm GUP section
Date: Tue, 6 May 2025 18:36:01 +0100

As part of the ongoing efforts to sub-divide memory management
maintainership and reviewership, establish a section for GUP (Get User
Pages) support and add appropriate maintainers and reviewers.

Link: https://lkml.kernel.org/r/20250506173601.97562-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/MAINTAINERS~maintainers-add-mm-gup-section
+++ a/MAINTAINERS
@@ -15542,6 +15542,18 @@ S:	Maintained
 F:	include/linux/execmem.h
 F:	mm/execmem.c
 
+MEMORY MANAGEMENT - GUP (GET USER PAGES)
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@redhat.com>
+R:	Jason Gunthorpe <jgg@nvidia.com>
+R:	John Hubbard <jhubbard@nvidia.com>
+R:	Peter Xu <peterx@redhat.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	mm/gup.c
+
 MEMORY MANAGEMENT - NUMA MEMBLOCKS AND NUMA EMULATION
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-fix-incorrectly-disallowed-anonymous-vma-merges.patch
tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch
tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch
mm-move-mmap-vma-locking-logic-into-specific-files.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality.patch
mm-abstract-initial-stack-setup-to-mm-subsystem.patch
mm-move-dup_mmap-to-mm.patch
mm-perform-vma-allocation-freeing-duplication-in-mm.patch
mm-introduce-new-mmap_prepare-file-callback.patch
mm-secretmem-convert-to-mmap_prepare-hook.patch
mm-vma-remove-mmap-retry-merge.patch

