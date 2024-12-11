Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EF217838C
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 23:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733960982; cv=none; b=J1es3uewnDj5jjIUff6b71QLllfmiSc7BwZh/obZP/6bHribtmVLIruUQu7kWjwe0tG4r6E/PH9O7/XzaKEssqEr7De/v6dM0LOlQ+ctwWMV/m+tbVlrGpk2Vg3KxlOagrXublnA2tq8lhtfMdb8oNxI22kkOk01MMJf3YYEeaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733960982; c=relaxed/simple;
	bh=jBaMisbjU3RbikVgnMSJRNFFmfQOH/qhOpGlRDy7T8M=;
	h=Date:To:From:Subject:Message-Id; b=uz+V9fWRIPBeH9LAz2kdgXAmpk82AUctvUztqLknQRgicCFLp5hvpHEV1v7ozdZvkcLHZtgSFIlrvTo96gypvmr+PlIpfrfLltuQMT3qHBo7b6bfWlOS0bdRIWCRc6U5zPitU4gco52rj2sT+12pLgknPatzyozWq/mwE1jTun0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ch8Ih2Jw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ch8Ih2Jw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D9FC4CED2;
	Wed, 11 Dec 2024 23:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733960981;
	bh=jBaMisbjU3RbikVgnMSJRNFFmfQOH/qhOpGlRDy7T8M=;
	h=Date:To:From:Subject:From;
	b=Ch8Ih2JwWb/0fAXTgBnRl3guUytPDAPwpRZqfLe4KkUBysBVKexrqqsDJ9+Ra7Q43
	 Eo+gcnHrobwtEw9ZU9GuZrtkexmSAFZqpKsFFAhRBxF85O8Czk8L6ZaWUUoPZxhyCk
	 0KQXZMeGhIX/9VNASDTCFI19FN7E7FMUR+b1J0Iw=
Date: Wed, 11 Dec 2024 15:49:40 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@Oracle.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-memory-mapping-section.patch added to mm-unstable branch
Message-Id: <20241211234940.E4D9FC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update MEMORY MAPPING section
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-update-memory-mapping-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-memory-mapping-section.patch

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
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

--- a/MAINTAINERS~maintainers-update-memory-mapping-section
+++ a/MAINTAINERS
@@ -15071,7 +15071,15 @@ L:	linux-mm@kvack.org
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
@@ -25019,21 +25027,6 @@ F:	include/uapi/linux/vsockmon.h
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

docs-mm-add-vma-locks-documentation.patch
mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
mm-correctly-reference-merged-vma.patch
fork-avoid-inappropriate-uprobe-access-to-invalid-mm.patch
mm-vma-move-brk-internals-to-mm-vmac.patch
mm-vma-move-brk-internals-to-mm-vmac-fix.patch
mm-vma-move-unmapped_area-internals-to-mm-vmac.patch
mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch
mm-vma-move-stack-expansion-logic-to-mm-vmac.patch
mm-vma-move-__vm_munmap-to-mm-vmac.patch
selftests-mm-add-fork-cow-guard-page-test.patch
mm-enforce-__must_check-on-vma-merge-and-split.patch
mm-perform-all-memfd-seal-checks-in-a-single-place.patch
mm-perform-all-memfd-seal-checks-in-a-single-place-fix.patch
maintainers-update-memory-mapping-section.patch

