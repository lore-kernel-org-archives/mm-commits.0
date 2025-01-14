Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0D823D3EB
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837068; cv=none; b=MF6tRGgAr0HI7R78hHGMiXasI9AN4wiMbPfb2XQBE7Te01XGrd+WuWHsiEUm5q90SjQ5U5YSlmqltRDSpx9Q1gIDN2kT2jo27rLtrm43zE1HlX3LIfkDn/VaJB9lXj0nIl7LVrH0an3BSu97quKixp4xbunCNdDtWPWEia3zPyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837068; c=relaxed/simple;
	bh=jeGEWsz0E5oiJnn3hSFaAjRX83A3AfsITA5XgG+/uhM=;
	h=Date:To:From:Subject:Message-Id; b=IP4WSLntrwM0kWeQq74pJWyph8bcpU8t2KnXY+XHFd0hN8ikyqYP3XS5L2xI6jpH8Fs0I5tbH2iXn0kXz3YlbS48LjG9yFdDmOh7AVSCn2ab3EhRBFiwFOkUqcHtx/dSf+uc9FVdehjd9VhPcCBLyd1cMwHTRb0V9fNFcWSxOB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Txi+iWPb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Txi+iWPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6CDC4CEDD;
	Tue, 14 Jan 2025 06:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837068;
	bh=jeGEWsz0E5oiJnn3hSFaAjRX83A3AfsITA5XgG+/uhM=;
	h=Date:To:From:Subject:From;
	b=Txi+iWPb8lG7bNtMbvKMJS0rgA8Ku9wQn6CRggdnTOdQabVvebLlp52RrnkVqvC3X
	 3UKy0fxM8i0xmiopyjp1KMaz3hfCJ0bf/W7tA9eguOLoCthPOJp+VF8pr+Typ7UJW5
	 XwWgMRQrdYlVU6ghe9VvoZ0s2GvxNsrkPOpN64wk=
Date: Mon, 13 Jan 2025 22:44:27 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@Oracle.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-update-memory-mapping-section.patch removed from -mm tree
Message-Id: <20250114064428.7D6CDC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update MEMORY MAPPING section
has been removed from the -mm tree.  Its filename was
     maintainers-update-memory-mapping-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: update MEMORY MAPPING section
Date: Wed, 11 Dec 2024 10:53:15 +0000

Update the MEMORY MAPPING section to contain VMA logic as it makes no
sense to have these two sections separate.

Additionally, add files which permit changes to the attributes and/or
ranges spanned by memory mappings, in essence anything which might alter
the output of /proc/$pid/[s]maps.

This is necessarily fuzzy, as there is not quite as good separation of
concerns as we would ideally like in the kernel.  However each of these
files interacts with the VMA and memory mapping logic in such a way as to
be inseparatable from it, and it is important that they are maintained in
conjunction with it.

Link: https://lkml.kernel.org/r/20241211105315.21756-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

--- a/MAINTAINERS~maintainers-update-memory-mapping-section
+++ a/MAINTAINERS
@@ -15073,7 +15073,15 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	mm/mlock.c
 F:	mm/mmap.c
+F:	mm/mprotect.c
+F:	mm/mremap.c
+F:	mm/mseal.c
+F:	mm/vma.c
+F:	mm/vma.h
+F:	mm/vma_internal.h
+F:	tools/testing/vma/
 
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	Miquel Raynal <miquel.raynal@bootlin.com>
@@ -25026,21 +25034,6 @@ F:	include/uapi/linux/vsockmon.h
 F:	net/vmw_vsock/
 F:	tools/testing/vsock/
 
-VMA
-M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Liam R. Howlett <Liam.Howlett@oracle.com>
-M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
-R:	Vlastimil Babka <vbabka@suse.cz>
-R:	Jann Horn <jannh@google.com>
-L:	linux-mm@kvack.org
-S:	Maintained
-W:	https://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
-F:	mm/vma.c
-F:	mm/vma.h
-F:	mm/vma_internal.h
-F:	tools/testing/vma/
-
 VMALLOC
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Uladzislau Rezki <urezki@gmail.com>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mips-vdso-prefer-do_mmap-to-mmap_region.patch
mm-make-mmap_region-internal.patch

